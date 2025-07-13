import 'package:dartz/dartz.dart';
import 'package:dream_dwell/app/use_case/usecase.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/add_property/domain/repository/cart/cart_repository.dart';

class ClearCartUsecase implements UsecaseWithoutParams<void> {
  final ICartRepository _cartRepository;

  ClearCartUsecase({required ICartRepository cartRepository}) 
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, void>> call() async {
    try {
      final result = await _cartRepository.clearCart();
      return result;
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
} 