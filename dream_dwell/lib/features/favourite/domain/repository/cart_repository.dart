<<<<<<< HEAD
import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/add_property/domain/entity/cart/cart_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, CartEntity>> getCart();
  Future<Either<Failure, CartEntity>> addToCart(String propertyId);
  Future<Either<Failure, CartEntity>> removeFromCart(String propertyId);
  Future<Either<Failure, void>> clearCart();
=======
import 'package:dream_dwell/features/favourite/domain/entity/cart/cart_entity.dart';

abstract class CartRepository {
  Future<CartEntity> getCart();
  Future<CartEntity> addToCart(String propertyId);
  Future<CartEntity> removeFromCart(String propertyId);
  Future<void> clearCart();
>>>>>>> sprint5
} 