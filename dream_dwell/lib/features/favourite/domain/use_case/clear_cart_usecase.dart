import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/favourite/domain/repository/cart_repository.dart';

class ClearCartUseCase {
  final CartRepository repository;
  ClearCartUseCase(this.repository);
  Future<Either<Failure, void>> call() => repository.clearCart();
} 