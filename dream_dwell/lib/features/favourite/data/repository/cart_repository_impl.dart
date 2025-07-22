<<<<<<< HEAD
import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/favourite/data/data_source/cart/remote_datasource/cart_remote_datasource.dart';
import 'package:dream_dwell/features/add_property/domain/entity/cart/cart_entity.dart';
import 'package:dream_dwell/features/favourite/domain/repository/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    try {
      final cart = await remoteDataSource.getCart();
      return Right(cart);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
=======
import 'package:dream_dwell/features/favourite/data/datasource/cart_api_service.dart';
import 'package:dream_dwell/features/favourite/data/model/cart_model/cart_api_model.dart';
import 'package:dream_dwell/features/favourite/domain/entity/cart/cart_entity.dart';
import 'package:dream_dwell/features/favourite/domain/repository/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartApiService _cartApiService;

  CartRepositoryImpl(this._cartApiService);

  @override
  Future<CartEntity> getCart() async {
    try {
      final cartApiModel = await _cartApiService.getCart();
      return cartApiModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get cart: $e');
>>>>>>> sprint5
    }
  }

  @override
<<<<<<< HEAD
  Future<Either<Failure, CartEntity>> addToCart(String propertyId) async {
    try {
      final cart = await remoteDataSource.addToCart(propertyId);
      return Right(cart);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
=======
  Future<CartEntity> addToCart(String propertyId) async {
    try {
      final cartApiModel = await _cartApiService.addToCart(propertyId);
      return cartApiModel.toEntity();
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
>>>>>>> sprint5
    }
  }

  @override
<<<<<<< HEAD
  Future<Either<Failure, CartEntity>> removeFromCart(String propertyId) async {
    try {
      final cart = await remoteDataSource.removeFromCart(propertyId);
      return Right(cart);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
=======
  Future<CartEntity> removeFromCart(String propertyId) async {
    try {
      final cartApiModel = await _cartApiService.removeFromCart(propertyId);
      return cartApiModel.toEntity();
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
>>>>>>> sprint5
    }
  }

  @override
<<<<<<< HEAD
  Future<Either<Failure, void>> clearCart() async {
    try {
      await remoteDataSource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
=======
  Future<void> clearCart() async {
    try {
      await _cartApiService.clearCart();
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
>>>>>>> sprint5
    }
  }
} 