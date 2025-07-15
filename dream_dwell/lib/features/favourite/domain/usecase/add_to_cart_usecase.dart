import 'package:dream_dwell/features/favourite/domain/entity/cart/cart_entity.dart';
import 'package:dream_dwell/features/favourite/domain/repository/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository _cartRepository;

  AddToCartUseCase(this._cartRepository);

  Future<CartEntity> call(String propertyId) async {
    return await _cartRepository.addToCart(propertyId);
  }
} 