import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/workout.dart';

class RunningTrainingSessionScreen extends StatefulWidget {
  final Workout workout;

  const RunningTrainingSessionScreen({super.key, required this.workout});

  @override
  State<RunningTrainingSessionScreen> createState() => _RunningTrainingSessionScreenState();
}

class _RunningTrainingSessionScreenState extends State<RunningTrainingSessionScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isPaused = false;
  int _currentExerciseIndex = 0;
  List<Map<String, dynamic>> _exercises = [];
  double _distance = 0.0; // 模拟距离（公里）
  int _heartRate = 0; // 模拟心率
  double _pace = 0.0; // 配速（分钟/公里）
  int _calories = 0; // 卡路里
  
  @override
  void initState() {
    super.initState();
    _exercises = _getExerciseList();
    _startTimer();
    _initializeStats();
  }

  void _initializeStats() {
    _heartRate = 75 + (10 - 10 * 0.5).toInt(); // 初始心率
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _elapsedSeconds++;
          _updateStats();
          _checkExerciseProgress();
        });
      }
    });
  }

  void _updateStats() {
    // 模拟距离增长（根据配速）
    final currentExercise = _exercises[_currentExerciseIndex];
    final exerciseName = currentExercise['name'] as String;
    
    if (exerciseName.contains('冲刺')) {
      _distance += 0.005; // 快速跑
      _heartRate = 150 + (10 - 10 * 0.5).toInt();
      _pace = 4.0;
    } else if (exerciseName.contains('匀速') || exerciseName.contains('稳定')) {
      _distance += 0.0028; // 中等配速
      _heartRate = 130 + (10 - 10 * 0.5).toInt();
      _pace = 5.5;
    } else if (exerciseName.contains('热身') || exerciseName.contains('放松') || exerciseName.contains('恢复')) {
      _distance += 0.0015; // 慢跑
      _heartRate = 110 + (10 - 10 * 0.5).toInt();
      _pace = 7.0;
    } else {
      _distance += 0.002;
      _heartRate = 120 + (10 - 10 * 0.5).toInt();
      _pace = 6.0;
    }
    
    // 计算卡路里（简化公式）
    _calories = (_elapsedSeconds * 0.15).toInt();
  }

  void _checkExerciseProgress() {
    int totalSeconds = 0;
    for (int i = 0; i <= _currentExerciseIndex && i < _exercises.length; i++) {
      totalSeconds += _exercises[i]['totalSeconds'] as int;
    }
    
    if (_elapsedSeconds >= totalSeconds && _currentExerciseIndex < _exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
      });
      HapticFeedback.mediumImpact();
    }
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    HapticFeedback.lightImpact();
    
    if (_isPaused) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('训练已暂停'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.grey[800],
        ),
      );
    }
  }

  void _finishWorkout() {
    _timer?.cancel();
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '训练完成！',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '干得漂亮！继续保持！',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow('总时长', _formatTime(_elapsedSeconds), Icons.schedule),
                    const SizedBox(height: 16),
                    _buildSummaryRow('距离', '${_distance.toStringAsFixed(2)} km', Icons.straighten),
                    const SizedBox(height: 16),
                    _buildSummaryRow('卡路里', '$_calories kcal', Icons.local_fire_department),
                    const SizedBox(height: 16),
                    _buildSummaryRow('平均心率', '$_heartRate bpm', Icons.favorite),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        '返回',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('训练数据已保存'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppTheme.vitalOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        '保存',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.vitalOrange, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 15,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double _getProgress() {
    final totalDuration = widget.workout.duration * 60;
    return (_elapsedSeconds / totalDuration).clamp(0.0, 1.0);
  }

  int _getCurrentExerciseElapsed() {
    int totalPreviousSeconds = 0;
    for (int i = 0; i < _currentExerciseIndex && i < _exercises.length; i++) {
      totalPreviousSeconds += _exercises[i]['totalSeconds'] as int;
    }
    return _elapsedSeconds - totalPreviousSeconds;
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = _exercises.isNotEmpty ? _exercises[_currentExerciseIndex] : null;
    final currentElapsed = _getCurrentExerciseElapsed();
    final currentTotal = currentExercise?['totalSeconds'] as int? ?? 1;
    final exerciseProgress = (currentElapsed / currentTotal).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21), // 深蓝黑色背景
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 22),
                      onPressed: () {
                        _showExitDialog();
                      },
                    ),
                  ),
                  Text(
                    widget.workout.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 48), // 占位保持标题居中
                ],
              ),
            ),

            // 总进度条
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '总进度',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${(_getProgress() * 100).toInt()}%',
                        style: const TextStyle(
                          color: AppTheme.vitalOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _getProgress(),
                      minHeight: 6,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.vitalOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 实时数据卡片
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1D1E33),
                      const Color(0xFF1A1B2E),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLiveStatCard(
                      '距离',
                      '${_distance.toStringAsFixed(2)}',
                      'km',
                      Icons.straighten,
                      const Color(0xFF4FC3F7),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white.withValues(alpha: 0.1),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                    _buildLiveStatCard(
                      '心率',
                      '$_heartRate',
                      'bpm',
                      Icons.favorite,
                      const Color(0xFFFF5252),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white.withValues(alpha: 0.1),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                    _buildLiveStatCard(
                      '配速',
                      _pace.toStringAsFixed(1),
                      'min/km',
                      Icons.speed,
                      const Color(0xFF66BB6A),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 主要内容区域
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1D1E33),
                          const Color(0xFF1A1B2E),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: currentExercise != null
                        ? Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // 当前动作编号
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppTheme.vitalOrange.withValues(alpha: 0.3),
                                          AppTheme.vitalOrange.withValues(alpha: 0.15),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppTheme.vitalOrange.withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '动作 ${_currentExerciseIndex + 1}/${_exercises.length}',
                                      style: const TextStyle(
                                        color: AppTheme.vitalOrange,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                          // 动作名称
                          Text(
                            currentExercise['name'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),

                          // 动作描述
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              currentExercise['description'] as String,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 13,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 32),

                                  // 圆形进度和计时器
                                  SizedBox(
                                    width: 160,
                                    height: 160,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // 背景圆环
                                        SizedBox(
                                          width: 160,
                                          height: 160,
                                          child: CircularProgressIndicator(
                                            value: 1.0,
                                            strokeWidth: 10,
                                            backgroundColor: Colors.transparent,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              Colors.white.withValues(alpha: 0.08),
                                            ),
                                          ),
                                        ),
                                        // 进度圆环
                                        SizedBox(
                                          width: 160,
                                          height: 160,
                                          child: CircularProgressIndicator(
                                            value: exerciseProgress,
                                            strokeWidth: 10,
                                            strokeCap: StrokeCap.round,
                                            backgroundColor: Colors.transparent,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              AppTheme.vitalOrange,
                                            ),
                                          ),
                                        ),
                                        // 时间显示
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _formatTime(currentElapsed),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 38,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: -1,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '/ ${_formatTime(currentTotal)}',
                                              style: TextStyle(
                                                color: Colors.white.withValues(alpha: 0.4),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                          const SizedBox(height: 28),

                          // 动作详情
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildStatBadge(
                                Icons.repeat,
                                currentExercise['sets'] as String,
                              ),
                              const SizedBox(width: 16),
                              _buildStatBadge(
                                Icons.local_fire_department,
                                '$_calories kcal',
                              ),
                            ],
                          ),

                          // 下一个动作预览
                          if (_currentExerciseIndex < _exercises.length - 1) ...[
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_forward,
                                    color: AppTheme.vitalOrange.withValues(alpha: 0.6),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '下一个',
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.4),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _exercises[_currentExerciseIndex + 1]['name'] as String,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    _exercises[_currentExerciseIndex + 1]['duration'] as String,
                                    style: TextStyle(
                                      color: AppTheme.vitalOrange.withValues(alpha: 0.8),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                                  ],
                                ],
                              ),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.vitalOrange,
                            ),
                          ),
                  ),
                  
                  // 暂停遮罩
                  if (_isPaused)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0E21).withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: AppTheme.vitalOrange.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.vitalOrange.withValues(alpha: 0.2),
                                    AppTheme.vitalOrange.withValues(alpha: 0.1),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.vitalOrange.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.pause,
                                color: AppTheme.vitalOrange,
                                size: 36,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              '训练已暂停',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '点击继续按钮恢复训练',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // 底部控制按钮
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // 上一个动作
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1D1E33),
                            const Color(0xFF1A1B2E),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _currentExerciseIndex > 0
                              ? () {
                                  setState(() {
                                    _currentExerciseIndex--;
                                    int totalSeconds = 0;
                                    for (int i = 0; i < _currentExerciseIndex; i++) {
                                      totalSeconds += _exercises[i]['totalSeconds'] as int;
                                    }
                                    _elapsedSeconds = totalSeconds;
                                  });
                                  HapticFeedback.lightImpact();
                                }
                              : null,
                          borderRadius: BorderRadius.circular(28),
                          child: Center(
                            child: Icon(
                              Icons.skip_previous,
                              color: _currentExerciseIndex > 0 
                                  ? Colors.white 
                                  : Colors.white.withValues(alpha: 0.2),
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // 暂停/继续
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.vitalOrange.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _togglePause,
                          borderRadius: BorderRadius.circular(28),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isPaused ? Icons.play_arrow : Icons.pause,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isPaused ? '继续' : '暂停',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // 下一个动作
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1D1E33),
                            const Color(0xFF1A1B2E),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _currentExerciseIndex < _exercises.length - 1
                              ? () {
                                  setState(() {
                                    _currentExerciseIndex++;
                                    int totalSeconds = 0;
                                    for (int i = 0; i < _currentExerciseIndex; i++) {
                                      totalSeconds += _exercises[i]['totalSeconds'] as int;
                                    }
                                    _elapsedSeconds = totalSeconds;
                                  });
                                  HapticFeedback.lightImpact();
                                }
                              : _finishWorkout,
                          borderRadius: BorderRadius.circular(28),
                          child: Center(
                            child: Icon(
                              _currentExerciseIndex < _exercises.length - 1
                                  ? Icons.skip_next
                                  : Icons.check,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.vitalOrange, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveStatCard(String label, String value, String unit, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: ' $unit',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '结束训练？',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '确定要结束当前训练吗？进度将不会被保存。',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '取消',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              '结束',
              style: TextStyle(color: AppTheme.vitalOrange),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getExerciseList() {
    final title = widget.workout.title;
    
    if (title.contains('5公里')) {
      return [
        {
          'name': '热身慢跑',
          'description': '以轻松的配速开始，逐渐提升心率，激活腿部肌肉',
          'sets': '1组',
          'duration': '5分钟',
          'totalSeconds': 300,
        },
        {
          'name': '匀速跑',
          'description': '保持稳定配速，控制呼吸节奏，专注于跑步姿态',
          'sets': '1组',
          'duration': '20分钟',
          'totalSeconds': 1200,
        },
        {
          'name': '放松慢跑',
          'description': '降低配速，让心率逐渐恢复，放松腿部肌肉',
          'sets': '1组',
          'duration': '5分钟',
          'totalSeconds': 300,
        },
      ];
    } else if (title.contains('间歇')) {
      return [
        {
          'name': '热身跑',
          'description': '轻松慢跑，逐步提升体温和心率',
          'sets': '1组',
          'duration': '5分钟',
          'totalSeconds': 300,
        },
        {
          'name': '快速冲刺',
          'description': '以80-90%的最大速度冲刺，全力以赴',
          'sets': '6组',
          'duration': '1分钟',
          'totalSeconds': 60,
        },
        {
          'name': '恢复慢跑',
          'description': '慢跑恢复，让心率下降',
          'sets': '6组',
          'duration': '2分钟',
          'totalSeconds': 120,
        },
        {
          'name': '整理放松',
          'description': '轻松慢跑结束训练',
          'sets': '1组',
          'duration': '5分钟',
          'totalSeconds': 300,
        },
      ];
    } else if (title.contains('长距离')) {
      return [
        {
          'name': '热身准备',
          'description': '从慢跑开始，逐步提升配速',
          'sets': '1组',
          'duration': '10分钟',
          'totalSeconds': 600,
        },
        {
          'name': '稳定配速跑',
          'description': '保持舒适的配速，专注于呼吸和步频',
          'sets': '1组',
          'duration': '45分钟',
          'totalSeconds': 2700,
        },
        {
          'name': '冷却放松',
          'description': '逐渐降低速度，让心率平稳下降',
          'sets': '1组',
          'duration': '5分钟',
          'totalSeconds': 300,
        },
      ];
    } else if (title.contains('瑜伽')) {
      return [
        {
          'name': '山式站立',
          'description': '双脚并拢站立，身体挺直，感受身体的平衡',
          'sets': '3组',
          'duration': '30秒',
          'totalSeconds': 30,
        },
        {
          'name': '下犬式',
          'description': '双手双脚着地，臀部向上抬起，拉伸背部',
          'sets': '3组',
          'duration': '45秒',
          'totalSeconds': 45,
        },
        {
          'name': '战士式',
          'description': '前腿弯曲，后腿伸直，双臂向两侧伸展',
          'sets': '3组',
          'duration': '30秒',
          'totalSeconds': 30,
        },
        {
          'name': '婴儿式',
          'description': '跪坐在地上，上身前倾，放松全身',
          'sets': '1组',
          'duration': '60秒',
          'totalSeconds': 60,
        },
      ];
    } else if (title.contains('普拉提')) {
      return [
        {
          'name': '百式呼吸',
          'description': '仰卧，双腿抬起，双臂上下摆动',
          'sets': '3组',
          'duration': '100秒',
          'totalSeconds': 100,
        },
        {
          'name': '卷腹',
          'description': '仰卧，上身缓慢卷起，感受腹部收缩',
          'sets': '4组',
          'duration': '60秒',
          'totalSeconds': 60,
        },
        {
          'name': '平板支撑',
          'description': '用前臂支撑身体，保持身体呈一条直线',
          'sets': '3组',
          'duration': '45秒',
          'totalSeconds': 45,
        },
      ];
    } else if (title.contains('拉伸')) {
      return [
        {
          'name': '颈部拉伸',
          'description': '缓慢转动头部，放松颈部肌肉',
          'sets': '2组',
          'duration': '40秒',
          'totalSeconds': 40,
        },
        {
          'name': '肩部拉伸',
          'description': '双臂交叉胸前，拉伸肩部和上背部',
          'sets': '2组',
          'duration': '60秒',
          'totalSeconds': 60,
        },
        {
          'name': '腿部拉伸',
          'description': '坐姿前屈，拉伸腿后侧肌肉',
          'sets': '2组',
          'duration': '40秒',
          'totalSeconds': 40,
        },
      ];
    } else if (title.contains('上肢')) {
      return [
        {
          'name': '哑铃推举',
          'description': '双手持哑铃，从肩部向上推举',
          'sets': '4组',
          'duration': '90秒',
          'totalSeconds': 90,
        },
        {
          'name': '俯卧撑',
          'description': '双手撑地，屈臂下降后推起',
          'sets': '4组',
          'duration': '60秒',
          'totalSeconds': 60,
        },
        {
          'name': '哑铃弯举',
          'description': '屈肘将哑铃举至肩部，锻炼肱二头肌',
          'sets': '4组',
          'duration': '75秒',
          'totalSeconds': 75,
        },
      ];
    } else if (title.contains('下肢')) {
      return [
        {
          'name': '深蹲',
          'description': '屈膝下蹲至大腿与地面平行',
          'sets': '4组',
          'duration': '90秒',
          'totalSeconds': 90,
        },
        {
          'name': '弓步蹲',
          'description': '一腿向前迈出，屈膝下蹲',
          'sets': '4组',
          'duration': '80秒',
          'totalSeconds': 80,
        },
        {
          'name': '提踵',
          'description': '脚跟抬起，用脚尖支撑身体',
          'sets': '4组',
          'duration': '60秒',
          'totalSeconds': 60,
        },
      ];
    } else if (title.contains('核心')) {
      return [
        {
          'name': '平板支撑',
          'description': '用前臂支撑身体，保持身体呈一条直线',
          'sets': '4组',
          'duration': '60秒',
          'totalSeconds': 60,
        },
        {
          'name': '俄罗斯转体',
          'description': '坐姿，转动上身左右触地',
          'sets': '4组',
          'duration': '80秒',
          'totalSeconds': 80,
        },
        {
          'name': '登山者',
          'description': '交替将膝盖向胸部提拉',
          'sets': '4组',
          'duration': '30秒',
          'totalSeconds': 30,
        },
      ];
    } else if (title.contains('燃脂')) {
      return [
        {
          'name': '热身跳跃',
          'description': '开合跳，激活全身肌肉',
          'sets': '1组',
          'duration': '3分钟',
          'totalSeconds': 180,
        },
        {
          'name': '高抬腿',
          'description': '快速高抬腿，提升心率',
          'sets': '3组',
          'duration': '1分钟',
          'totalSeconds': 60,
        },
        {
          'name': '波比跳',
          'description': '全身爆发力训练，快速燃脂',
          'sets': '3组',
          'duration': '45秒',
          'totalSeconds': 45,
        },
        {
          'name': '登山跑',
          'description': '快速交替提膝，核心发力',
          'sets': '3组',
          'duration': '1分钟',
          'totalSeconds': 60,
        },
        {
          'name': '放松拉伸',
          'description': '全身拉伸，帮助恢复',
          'sets': '1组',
          'duration': '3分钟',
          'totalSeconds': 180,
        },
      ];
    }
    
    // 默认通用训练
    return [
      {
        'name': '热身准备',
        'description': '轻松活动，逐步提升体温',
        'sets': '1组',
        'duration': '5分钟',
        'totalSeconds': 300,
      },
      {
        'name': '主要训练',
        'description': '按照计划完成训练动作',
        'sets': '3组',
        'duration': '${widget.workout.duration - 10}分钟',
        'totalSeconds': (widget.workout.duration - 10) * 60,
      },
      {
        'name': '放松整理',
        'description': '拉伸放松，帮助身体恢复',
        'sets': '1组',
        'duration': '5分钟',
        'totalSeconds': 300,
      },
    ];
  }
}
