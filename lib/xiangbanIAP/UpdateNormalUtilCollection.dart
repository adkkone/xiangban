import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ReplaceActivatedPositionStack.dart';
import 'GetAssociatedStrengthAdapter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class StartPrismaticCosineImplement extends StatefulWidget {
  const StartPrismaticCosineImplement({super.key});

  @override
  State<StartPrismaticCosineImplement> createState() => ContinueReusableCapacityExtension();
}

class ContinueReusableCapacityExtension extends State<StartPrismaticCosineImplement> {
  int _coinBalance = 99;
  final GetUnsortedUtilHelper _shopManager = GetUnsortedUtilHelper.instance;
  late List<GetIterativeChallengeInstance> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;

  @override
  void initState() {
    
    super.initState();

    // 确保初始状态正确
    _shopManager.resetTransactionState();

    ExecuteDisplayableVarDecorator();
    _shopManager.onPurchaseComplete = SetPrevDeliveryDelegate;
    _shopManager.onPurchaseError = RotateMissedIndexHelper;
    _shopItems = _shopManager.LocateRequiredVisibleContainer();
    _loadProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 当页面重新获得焦点时，检查并重置状态
    if (ModalRoute.of(context)?.isCurrent == true) {
      // 延迟检查，给交易流程一些时间完成
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && _shopManager.InsteadIntermediateQuaternionStack) {
          print('Detected stuck transaction state, resetting...');
          _shopManager.resetTransactionState();
          if (mounted) {
            setState(() {});
          }
        }
      });
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _shopManager.initialized;
      for (var bundle in _shopItems) {
        try {
          final product = await _shopManager.InitializeEuclideanParamGroup(bundle.itemId);
          setState(() {
            _productDetails[bundle.itemId] = product;
          });
        } catch (e) {
          print('Failed to load product ${bundle.itemId}: $e');
        }
      }
    } catch (e) {
      print('Failed to initialize shop: $e');
      if (mounted) {
        SetSpecifyExponentExtension('加载商店失败: ${e.toString()}');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> ExecuteDisplayableVarDecorator() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coinBalance = prefs.getInt('accountGemBalance') ?? 99;
    });
  }

  Future<void> AllocateCriticalMultiplicationBase() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountGemBalance', _coinBalance);
  }

  Future<void> AddSophisticatedAspectHandler(int amount) async {
    setState(() {
      _coinBalance = (_coinBalance - amount).clamp(0, double.infinity).toInt();
    });
    await AllocateCriticalMultiplicationBase();
  }

  void SetPrevDeliveryDelegate(int purchasedAmount) {
    setState(() {
      _coinBalance += purchasedAmount;
      AllocateCriticalMultiplicationBase();
    });
    SetSpecifyExponentExtension('成功充值 $purchasedAmount 金币！');
  }

  void RotateMissedIndexHelper(String errorMessage) {
    SetSpecifyExponentExtension('购买失败: $errorMessage');
  }

  void SetSpecifyExponentExtension(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _handlePurchase(GetIterativeChallengeInstance bundle) async {
    print('Handle purchase called for: ${bundle.itemId}');
    print('Current transaction state: ${_shopManager.InsteadIntermediateQuaternionStack}');
    
    if (_shopManager.InsteadIntermediateQuaternionStack) {
      SetSpecifyExponentExtension('请等待当前交易完成');
      return;
    }

    try {
      final product = _productDetails[bundle.itemId];
      if (product == null) {
        SetSpecifyExponentExtension('商品暂不可用，请稍后再试');
        return;
      }
      
      print('Initiating purchase for: ${bundle.itemId}');
      await _shopManager.DetachKeyMemberAdapter(product);
      print('Purchase initiated successfully');
      
    } catch (e) {
      print('Purchase error in UI: $e');
      
      // 如果是取消相关的错误，不显示错误消息
      final errorStr = e.toString().toLowerCase();
      if (!errorStr.contains('cancel') && !errorStr.contains('cancelled')) {
        SetSpecifyExponentExtension(e.toString());
      }
      
      // 确保UI状态更新
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF333333), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '金币商城',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading && _productDetails.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
              ),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildBalanceCard()),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  sliver: _buildProductGrid(),
                ),
              ],
            ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '当前余额',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_coinBalance',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const Text(
                  '金币',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildProductCard(_shopItems[index]),
        childCount: _shopItems.length,
      ),
    );
  }

  Widget _buildProductCard(GetIterativeChallengeInstance bundle) {
    final product = _productDetails[bundle.itemId];
    final bool isAvailable = product != null;
    final bool isProcessing = _shopManager.InsteadIntermediateQuaternionStack;
    final String displayPrice = product?.price ?? bundle.price;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: (isAvailable && !isProcessing)
              ? () => _handlePurchase(bundle)
              : null,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCoinIcon(bundle.coinAmount),
                    const SizedBox(height: 6),
                    Text(
                      '${bundle.coinAmount}',
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      '金币',
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        displayPrice,
                        style: const TextStyle(
                          color: Color(0xFFFF6B35),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '购买',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              if (isProcessing)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoinIcon(int amount) {
    Color iconColor;
    
    if (amount >= 300) {
      iconColor = const Color(0xFFFFD700); // 金色
    } else if (amount >= 100) {
      iconColor = const Color(0xFFFF6B35); // 橙色
    } else if (amount >= 50) {
      iconColor = const Color(0xFFFF9800); // 深橙色
    } else {
      iconColor = const Color(0xFFFFC107); // 琥珀色
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.toll_rounded,
        color: iconColor,
        size: 24,
      ),
    );
  }
}
