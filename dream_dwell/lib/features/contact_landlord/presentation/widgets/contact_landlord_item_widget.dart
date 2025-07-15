import 'package:flutter/material.dart';
import '../../domain/entity/contact_landlord_item.dart';

class ContactLandlordItemWidget extends StatelessWidget {
  final ContactLandlordItem item;
  const ContactLandlordItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
    );
  }
} 