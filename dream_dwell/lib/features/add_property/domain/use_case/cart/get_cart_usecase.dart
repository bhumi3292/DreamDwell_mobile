import 'package:dartz/dartz.dart';
import 'package:dream_dwell/app/use_case/usecase.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/add_property/domain/entity/cart/cart_entity.dart';
import 'package:dream_dwell/features/add_property/domain/repository/cart/cart_repository.dart';

class GetCartUsecase implements UsecaseWithoutParams<CartEntity> {
  final ICartRepository _cartRepository;

  GetCartUsecase({required ICartRepository cartRepository}) 
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, CartEntity>> call() async {
    try {
      final result = await _cartRepository.getCart();
      return result.fold(
        (failure) => Left(failure),
        (propertyIds) => Right(CartEntity(items: [])), // Return empty cart for now
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
} 