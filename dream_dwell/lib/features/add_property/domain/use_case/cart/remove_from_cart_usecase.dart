import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:dream_dwell/app/use_case/usecase.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/add_property/domain/entity/cart/cart_entity.dart';
import 'package:dream_dwell/features/add_property/domain/repository/cart/cart_repository.dart';

class RemoveFromCartParams extends Equatable {
  final String propertyId;

  const RemoveFromCartParams({required this.propertyId});

  @override
  List<Object?> get props => [propertyId];
}

class RemoveFromCartUsecase implements UsecaseWithParams<CartEntity, RemoveFromCartParams> {
  final ICartRepository _cartRepository;

  RemoveFromCartUsecase({required ICartRepository cartRepository}) 
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, CartEntity>> call(RemoveFromCartParams params) async {
    try {
      final result = await _cartRepository.removeFromCart(params.propertyId);
      return result.fold(
        (failure) => Left(failure),
        (_) => Right(CartEntity(items: [])), // Return empty cart on success
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
} 