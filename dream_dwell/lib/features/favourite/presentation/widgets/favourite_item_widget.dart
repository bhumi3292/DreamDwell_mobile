import 'package:flutter/material.dart';
import '../../domain/entity/favourite_item.dart';
import 'package:dream_dwell/features/add_property/presentation/view/property_detail_page.dart';

class FavouriteItemWidget extends StatelessWidget {
  final FavouriteItem item;
  const FavouriteItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailPage(propertyId: item.id),
          ),
        );
      },
    );
  }
} 