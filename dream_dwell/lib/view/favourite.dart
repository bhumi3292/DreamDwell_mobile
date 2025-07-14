import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dream_dwell/features/favourite/presentation/view/cart_view.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {

  @override
  Widget build(BuildContext context) {
    return const CartView();
  }
}