import 'package:flutter/material.dart';
import '../../data/repository/contact_landlord_repository.dart';
import '../../domain/entity/contact_landlord_item.dart';

class ContactLandlordViewModel extends ChangeNotifier {
  final ContactLandlordRepository repository;
  List<ContactLandlordItem> items = [];
  bool isLoading = false;

  ContactLandlordViewModel(this.repository);

  Future<void> fetchItems() async {
    isLoading = true;
    notifyListeners();
    final result = await repository.fetchContacts();
    items = result.map((e) => ContactLandlordItem(e)).toList();
    isLoading = false;
    notifyListeners();
  }
} 