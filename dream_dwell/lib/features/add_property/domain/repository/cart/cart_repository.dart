import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';

abstract class ICartRepository {
  Future<Either<Failure, void>> addToCart(String propertyId);
  Future<Either<Failure, List<String>>> getCart();
  Future<Either<Failure, void>> removeFromCart(String propertyId);
  Future<Either<Failure, void>> clearCart();
} 