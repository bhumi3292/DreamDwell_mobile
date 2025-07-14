import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dream_dwell/features/favourite/presentation/view_model/cart_view_model.dart';

class CartButtonWidget extends StatelessWidget {
  final String propertyId;
  final double size;

  const CartButtonWidget({
    super.key,
    required this.propertyId,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Get.find<CartViewModel>();

    return Obx(() {
      final isInCart = cartViewModel.isInCart(propertyId);

      return IconButton(
        onPressed: () {
          if (isInCart) {
            cartViewModel.removeFromCart(propertyId);
          } else {
            cartViewModel.addToCart(propertyId);
          }
        },
        icon: Icon(
          isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
          size: size,
          color: isInCart ? const Color(0xFF003366) : Colors.grey[600],
        ),
        tooltip: isInCart ? 'Remove from cart' : 'Add to cart',
      );
    });
  }
} 