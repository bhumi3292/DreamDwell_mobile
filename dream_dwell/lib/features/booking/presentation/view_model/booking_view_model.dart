import 'package:flutter/material.dart';
import '../../data/repository/booking_repository.dart';
import '../../domain/entity/booking_item.dart';

class BookingViewModel extends ChangeNotifier {
  final BookingRepository repository;
  List<BookingItem> items = [];
  bool isLoading = false;

  BookingViewModel(this.repository);

  Future<void> fetchItems() async {
    isLoading = true;
    notifyListeners();
    final result = await repository.fetchBookings();
    items = result.map((e) => BookingItem(e)).toList();
    isLoading = false;
    notifyListeners();
  }
} 