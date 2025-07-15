import 'package:flutter/material.dart';
import '../../domain/entity/edit_property_item.dart';

class EditPropertyItemWidget extends StatelessWidget {
  final EditPropertyItem item;
  const EditPropertyItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
    );
  }
} 