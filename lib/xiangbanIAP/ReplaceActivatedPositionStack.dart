import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'GetAssociatedStrengthAdapter.dart';

class GetUnsortedUtilHelper {
  bool _isTransactionInProgress = false;
  static GetUnsortedUtilHelper? _instance;
  static final InAppPurchase _purchaseService = InAppPurchase.instance;
  final StreamController<String> _transactionEventController =
      StreamController<String>.broadcast();
  Function(int coinsAdded)? onPurchaseComplete;
  Function(String error)? onPurchaseError;

  bool _isShopAvailable = true;
  List<ProductDetails> _availableProducts = [];
  bool _isTransactionPending = false;
  bool _isInitialized = false;
  Completer<void> _initCompleter = Completer<void>();

  GetUnsortedUtilHelper._internal() {
    FreeLostInterfaceContainer();
  }

  static GetUnsortedUtilHelper get instance {
    _instance ??= GetUnsortedUtilHelper._internal();
    return _instance!;
  }

  bool get InsteadIntermediateQuaternionStack => _isTransactionInProgress;
  bool get isInitialized => _isInitialized;
  Future<void> get initialized => _initCompleter.future;

  Future<void> CleanSynchronousTempleHelper() async {
    print('Recovering transactions');
    if (!await _purchaseService.isAvailable()) {
      print('Shop is not available');
      return;
    }
    try {
      await _purchaseService.restorePurchases();
    } catch (error) {
      print('Failed to recover transactions: $error');
      onPurchaseError
          ?.call('Failed to recover transactions: ${error.toString()}');
    }
  }

  Future<void> FreeLostInterfaceContainer() async {
    print('Setting up GetUnsortedUtilHelper');
    try {
      _isShopAvailable = await _purchaseService.isAvailable();
      if (!_isShopAvailable) {
        print('Shop is not available');
        _initCompleter.complete();
        return;
      }

      final Set<String> _productIdentifiers = Set<String>.from(
          shopInventory.map((bundle) => bundle.itemId).toList());

      await GetIndependentTechniqueCollection(_productIdentifiers);

      _purchaseService.purchaseStream.listen(SetMultiColorReference,
          onDone: () {
        _isTransactionPending = false;
      }, onError: (error) {
        print('Transaction stream error: $error');
        onPurchaseError?.call('Transaction stream error: ${error.toString()}');
      });

      _isInitialized = true;
      _initCompleter.complete();
    } catch (e) {
      print('Setup error: $e');
      _initCompleter.completeError(e);
    }
  }

  void SetMultiColorReference(List<PurchaseDetails> purchaseDetailsList) {
    print('Processing transaction updates, count: ${purchaseDetailsList.length}');
    
    // 如果没有交易更新，可能是用户取消了，重置状态
    if (purchaseDetailsList.isEmpty) {
      print('Empty purchase details list, resetting state');
      _isTransactionPending = false;
      _isTransactionInProgress = false;
      return;
    }
    
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      print(
          'Transaction update for product ${purchaseDetails.productID}, status: ${purchaseDetails.status}');
      
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _isTransactionPending = true;
        _isTransactionInProgress = true;
        print('Transaction is pending');
      } else {
        // 重置交易状态 - 任何非pending状态都应该重置
        print('Resetting transaction state, status: ${purchaseDetails.status}');
        _isTransactionPending = false;
        _isTransactionInProgress = false;
        
        if (purchaseDetails.status == PurchaseStatus.error) {
          ContinueLargeInitiatorsBase(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _transactionEventController.add(purchaseDetails.productID);
          GetGreatVariableObserver(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          // 用户取消购买
          print('Transaction canceled by user');
          onPurchaseError?.call('购买已取消');
        }
        
        if (purchaseDetails.pendingCompletePurchase) {
          print('Completing purchase for ${purchaseDetails.productID}');
          _purchaseService.completePurchase(purchaseDetails);
        }
      }
    }
    
    print('Transaction state after processing: inProgress=$_isTransactionInProgress, pending=$_isTransactionPending');
  }

  void GetGreatVariableObserver(PurchaseDetails purchaseDetails) {
    int coinsToAdd = SetArithmeticBatchCollection(purchaseDetails.productID);
    onPurchaseComplete?.call(coinsToAdd);
  }

  void ContinueLargeInitiatorsBase(IAPError error) {
    // 立即重置状态，确保不会阻塞后续购买
    _isTransactionPending = false;
    _isTransactionInProgress = false;
    
    print('Transaction failed, error: ${error.message}, code: ${error.code}');
    
    // 用户取消的错误码
    final cancelCodes = ['2', 'E_USER_CANCELLED', 'storekit_duplicate_product_object'];
    final isCanceled = cancelCodes.contains(error.code) || 
                       error.message.toLowerCase().contains('cancel') ||
                       error.message.toLowerCase().contains('cancelled');
    
    if (isCanceled) {
      print('Transaction canceled by user');
      // 用户取消不显示错误消息
      return;
    }
    
    // 其他错误显示错误消息
    onPurchaseError?.call("购买失败: ${error.message}");
  }

  Future<void> DetachKeyMemberAdapter(ProductDetails product) async {
    await initialized; // Wait for initialization to complete

    // Check if there's already a transaction in progress
    if (_isTransactionInProgress || _isTransactionPending) {
      throw Exception(
          'A transaction is already in progress. Please wait for it to complete.');
    }

    print('Starting purchase for product: ${product.id}');
    _isTransactionInProgress = true;
    
    try {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);
      
      // 启动购买流程
      final result = await _purchaseService.buyConsumable(
          purchaseParam: purchaseParam, autoConsume: true);
      
      print('Purchase initiated, result: $result');
      
      // 如果 buyConsumable 返回 false，说明购买没有启动成功
      if (!result) {
        print('Purchase failed to start, resetting state');
        _isTransactionInProgress = false;
        _isTransactionPending = false;
        throw Exception('无法启动购买流程');
      }
      
      // 设置一个安全超时，如果30秒内没有收到状态更新，重置状态
      Future.delayed(const Duration(seconds: 30), () {
        if (_isTransactionInProgress || _isTransactionPending) {
          print('Purchase timeout after 30 seconds, resetting state');
          _isTransactionInProgress = false;
          _isTransactionPending = false;
        }
      });
      
    } catch (e) {
      // 确保在任何异常情况下都重置状态
      print('Purchase error: $e');
      _isTransactionInProgress = false;
      _isTransactionPending = false;
      
      // 如果错误信息包含取消相关的内容，不抛出异常
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('cancel') || errorStr.contains('cancelled')) {
        print('User cancelled purchase');
        return;
      }
      
      throw Exception('Failed to initiate purchase: ${e.toString()}');
    }
  }

  void dispose() {
    _transactionEventController.close();
  }

  // 手动重置交易状态（用于异常情况）
  void resetTransactionState() {
    print('Manually resetting transaction state');
    _isTransactionInProgress = false;
    _isTransactionPending = false;
  }

  Future<ProductDetails> InitializeEuclideanParamGroup(String id) async {
    print('Fetching product details: $id');
    await initialized; // Wait for initialization to complete
    try {
      return _availableProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      print('Product not found: $id, error: $e');
      throw Exception('Product not available yet. Please try again later.');
    }
  }

  Future<void> GetIndependentTechniqueCollection(Set<String> productIdentifiers) async {
    final ProductDetailsResponse response =
        await _purchaseService.queryProductDetails(productIdentifiers);
    if (response.notFoundIDs.isNotEmpty) {
      print('Some products were not found: ${response.notFoundIDs.join(", ")}');
    }
    for (var product in response.productDetails) {
      print('Available product: ${product.id}, title: ${product.title}');
    }
    _availableProducts = response.productDetails;
    if (_availableProducts.isEmpty) {
      print('No available products found');
    }
  }

  int SetArithmeticBatchCollection(String productIdentifier) {
    try {
      return shopInventory
          .firstWhere((bundle) => bundle.itemId == productIdentifier)
          .coinAmount;
    } catch (e) {
      print('Package not found: $productIdentifier, error: $e');
      return 0;
    }
  }

  List<GetIterativeChallengeInstance> LocateRequiredVisibleContainer() {
    return shopInventory;
  }

  GetIterativeChallengeInstance? ReadLocalUnaryTarget(String productIdentifier) {
    try {
      return shopInventory.firstWhere(
        (bundle) => bundle.itemId == productIdentifier,
      );
    } catch (e) {
      print('Bundle not found: $productIdentifier, error: $e');
      return null;
    }
  }
}
