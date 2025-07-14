import 'package:dio/dio.dart';
import 'package:dream_dwell/app/constant/api_endpoints.dart';
import 'package:dream_dwell/cores/network/api_service.dart';
import 'package:dream_dwell/features/add_property/domain/entity/cart/cart_entity.dart';

abstract class CartRemoteDataSource {
  Future<CartEntity> getCart();
  Future<CartEntity> addToCart(String propertyId);
  Future<CartEntity> removeFromCart(String propertyId);
  Future<void> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiService apiService;

  CartRemoteDataSourceImpl(this.apiService);

  @override
  Future<CartEntity> getCart() async {
    try {
      final response = await apiService.dio.get(ApiEndpoints.getCart);
      if (response.data['success'] == true) {
        if (response.data['data'] == null || response.data['data']['items'] == null) {
          return const CartEntity(
            id: '',
            userId: '',
            items: [],
            createdAt: null,
            updatedAt: null,
          );
        }
        return CartEntity.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get cart');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('Failed to get cart: $e');
    }
  }

  @override
  Future<CartEntity> addToCart(String propertyId) async {
    try {
      final response = await apiService.dio.post(
        ApiEndpoints.addToCart,
        data: {'propertyId': propertyId},
      );
      if (response.data['success'] == true) {
        return CartEntity.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to add to cart');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  @override
  Future<CartEntity> removeFromCart(String propertyId) async {
    try {
      final response = await apiService.dio.delete(
        '${ApiEndpoints.removeFromCart}$propertyId',
      );
      if (response.data['success'] == true) {
        return CartEntity.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to remove from cart');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      final response = await apiService.dio.delete(ApiEndpoints.clearCart);
      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Failed to clear cart');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }
} 