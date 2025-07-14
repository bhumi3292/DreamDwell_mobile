import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/add_property/domain/entity/cart/cart_entity.dart';
import 'package:dream_dwell/features/favourite/domain/repository/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;
  RemoveFromCartUseCase(this.repository);
  Future<Either<Failure, CartEntity>> call(String propertyId) => repository.removeFromCart(propertyId);
} 