import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/add_property/domain/entity/cart/cart_entity.dart';
import 'package:dream_dwell/features/favourite/domain/repository/cart_repository.dart';

class GetCartUseCase {
  final CartRepository repository;
  GetCartUseCase(this.repository);
  Future<Either<Failure, CartEntity>> call() => repository.getCart();
} 