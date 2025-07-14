import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dream_dwell/features/add_property/domain/entity/cart/cart_entity.dart';
import 'package:dream_dwell/features/favourite/domain/use_case/add_to_cart_usecase.dart';
import 'package:dream_dwell/features/favourite/domain/use_case/clear_cart_usecase.dart';
import 'package:dream_dwell/features/favourite/domain/use_case/get_cart_usecase.dart';
import 'package:dream_dwell/features/favourite/domain/use_case/remove_from_cart_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/property/get_property_by_id_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';

class CartViewModel extends GetxController {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartViewModel({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.clearCartUseCase,
  });

  final Rx<CartEntity?> _cart = Rx<CartEntity?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  Rx<CartEntity?> get cartRx => _cart;

  CartEntity? get cart => _cart.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  int get itemCount => _cart.value?.items?.length ?? 0;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await getCartUseCase();
    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        _isLoading.value = false;
        Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (cart) async {
        _cart.value = cart;
        _isLoading.value = false;
        await _populateCartProperties();
      },
    );
  }

  Future<void> _populateCartProperties() async {
    if (_cart.value?.items == null) return;
    final getPropertyByIdUsecase = GetIt.instance<GetPropertyByIdUsecase>();
    bool updated = false;

    for (int i = 0; i < (_cart.value!.items?.length ?? 0); i++) {
      final item = _cart.value!.items![i];
      if (item.property != null && (item.property!.title == null || item.property!.title!.isEmpty)) {
        final propertyId = item.property?.id;
        if (propertyId != null && propertyId.isNotEmpty) {
          final result = await getPropertyByIdUsecase(propertyId);
          result.fold(
            (failure) {},
            (property) {
              _cart.value!.items![i] = CartItemEntity(
                id: item.id,
                property: property,
                createdAt: item.createdAt,
              );
              updated = true;
            },
          );
        }
      }
    }
    if (updated) {
      _cart.refresh();
    }
  }

  Future<void> addToCart(String propertyId) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await addToCartUseCase(propertyId);
    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        _isLoading.value = false;
        // Show a specific message if property is already in cart
        if (failure.message.toLowerCase().contains('already in cart')) {
          Get.snackbar(
            'Already Added',
            'This property is already in your favourites.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      (cart) async {
        _cart.value = cart;
        _isLoading.value = false;
        await _populateCartProperties();
        Get.snackbar(
          'Added to Favourites',
          'Property added to your favourites.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Reload cart to update all pages
        await loadCart();
      },
    );
  }

  Future<void> removeFromCart(String propertyId) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await removeFromCartUseCase(propertyId);
    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        _isLoading.value = false;
        Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (cart) async {
        _cart.value = cart;
        _isLoading.value = false;
        await _populateCartProperties();
        Get.snackbar(
          'Removed from Favourites',
          'Property removed from your favourites.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Reload cart to update all pages
        await loadCart();
      },
    );
  }

  Future<void> clearCart() async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await clearCartUseCase();
    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        _isLoading.value = false;
        Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (_) {
        _cart.value = null;
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Cart cleared successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }

  bool isInCart(String propertyId) {
    return _cart.value?.items?.any((item) => item.property?.id == propertyId) ?? false;
  }
} 