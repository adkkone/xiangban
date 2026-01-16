import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../theme/app_theme.dart';

class CalendarDialog extends StatefulWidget {
  const CalendarDialog({super.key});

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  
  // 模拟已完成运动的日期
  final Set<DateTime> _completedDates = {
    DateTime.now().subtract(const Duration(days: 1)),
    DateTime.now().subtract(const Duration(days: 3)),
    DateTime.now().subtract(const Duration(days: 5)),
    DateTime.now().subtract(const Duration(days: 7)),
  };
  
  // 模拟计划运动的日期
  final Set<DateTime> _plannedDates = {
    DateTime.now(),
    DateTime.now().add(const Duration(days: 2)),
    DateTime.now().add(const Duration(days: 4)),
  };

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isCompleted(DateTime day) {
    return _completedDates.any((date) => _isSameDay(date, day));
  }

  bool _isPlanned(DateTime day) {
    return _plannedDates.any((date) => _isSameDay(date, day));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '运动日历',
                    style: TextStyle(
                      color: AppTheme.darkGray,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.offWhite,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: AppTheme.darkGray, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            
            // 图例
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegend(Icons.check_circle, '已完成', Colors.green),
                  const SizedBox(width: 24),
                  _buildLegend(Icons.schedule, '已计划', AppTheme.vitalOrange),
                ],
              ),
            ),
            
            // 日历 - 使用 SizedBox 明确限制高度
            Container(
              color: Colors.white,
              child: SizedBox(
                height: 320,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2026, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => _isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: AppTheme.vitalOrange.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: AppTheme.vitalOrange,
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      outsideDaysVisible: false,
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGray,
                      ),
                      leftChevronIcon: const Icon(Icons.chevron_left, color: AppTheme.darkGray, size: 20),
                      rightChevronIcon: const Icon(Icons.chevron_right, color: AppTheme.darkGray, size: 20),
                    ),
                    daysOfWeekHeight: 28,
                    rowHeight: 38,
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        return _buildDayCell(day, false, false);
                      },
                      todayBuilder: (context, day, focusedDay) {
                        return _buildDayCell(day, true, false);
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        return _buildDayCell(day, false, true);
                      },
                    ),
                  ),
                ),
              ),
            ),
            
            // 底部统计
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('本月完成', '${_completedDates.length}', '次'),
                  Container(width: 1, height: 28, color: Colors.grey[300]),
                  _buildStat('本月计划', '${_plannedDates.length}', '次'),
                  Container(width: 1, height: 28, color: Colors.grey[300]),
                  _buildStat('连续打卡', '3', '天'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildDayCell(DateTime day, bool isToday, bool isSelected) {
    final isCompleted = _isCompleted(day);
    final isPlanned = _isPlanned(day);
    
    Color? backgroundColor;
    Color textColor = AppTheme.darkGray;
    
    if (isSelected) {
      backgroundColor = AppTheme.vitalOrange;
      textColor = Colors.white;
    } else if (isToday) {
      backgroundColor = AppTheme.vitalOrange.withValues(alpha: 0.15);
    } else if (isCompleted) {
      backgroundColor = Colors.green.withValues(alpha: 0.1);
    } else if (isPlanned) {
      backgroundColor = AppTheme.vitalOrange.withValues(alpha: 0.08);
    }
    
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (isCompleted && !isSelected)
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, String unit) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.vitalOrange,
            ),
            children: [
              TextSpan(
                text: ' $unit',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
