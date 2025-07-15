import 'package:flutter/material.dart';
import '../../domain/entity/booking_item.dart';

class BookingItemWidget extends StatelessWidget {
  final BookingItem item;
  const BookingItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
    );
  }
} 