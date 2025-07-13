import 'package:dream_dwell/features/add_property/domain/repository/cart/cart_repository.dart';
import 'package:dream_dwell/features/add_property/data/data_source/cart/remote_datasource/cart_remote_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';

class CartRepositoryImpl implements ICartRepository {
  final CartRemoteDatasource cartDataSource;

  CartRepositoryImpl({required this.cartDataSource});

  @override
  Future<Either<Failure, void>> addToCart(String propertyId) async {
    // TODO: Implement actual logic
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<String>>> getCart() async {
    // TODO: Implement actual logic
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String propertyId) async {
    // TODO: Implement actual logic
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    // TODO: Implement actual logic
    return const Right(null);
  }
} 