import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dream_dwell/features/favourite/presentation/view_model/cart_view_model.dart';
import 'package:dream_dwell/features/favourite/presentation/widgets/cart_item_widget.dart';
import 'package:dream_dwell/features/favourite/presentation/widgets/empty_cart_widget.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Get.find<CartViewModel>();
    // Always reload cart when the page is built
    cartViewModel.loadCart();
    print('Cart items: ${cartViewModel.cart?.items}');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Favourites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF003366),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (cartViewModel.itemCount > 0)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.red),
              onPressed: () => _showClearCartDialog(context, cartViewModel),
            ),
        ],
      ),
      body: Obx(() {
        if (cartViewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF003366)),
            ),
          );
        }

        if (cartViewModel.cart == null || cartViewModel.itemCount == 0) {
          return const EmptyCartWidget();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: cartViewModel.cart?.items?.length ?? 0,
          itemBuilder: (context, index) {
            final item = cartViewModel.cart!.items![index];
            return CartItemWidget(
              cartItem: item,
              onRemove: () => cartViewModel.removeFromCart(item.property?.id ?? ''),
              baseUrl: 'http://10.0.2.2:3001/',
            );
          },
        );
      }),
    );
  }

  void _showClearCartDialog(BuildContext context, CartViewModel cartViewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cart'),
          content: const Text('Are you sure you want to remove all items from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                cartViewModel.clearCart();
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
} 