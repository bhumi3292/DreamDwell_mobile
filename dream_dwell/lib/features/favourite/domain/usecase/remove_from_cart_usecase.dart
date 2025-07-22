import 'package:dream_dwell/features/favourite/domain/entity/cart/cart_entity.dart';
import 'package:dream_dwell/features/favourite/domain/repository/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository _cartRepository;

  RemoveFromCartUseCase(this._cartRepository);

  Future<CartEntity> call(String propertyId) async {
    return await _cartRepository.removeFromCart(propertyId);
  }
} 