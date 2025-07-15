import 'package:flutter/material.dart';

class ExploreFilterDialog extends StatefulWidget {
  final double? initialMaxPrice;
  final String? initialCategory;

  const ExploreFilterDialog({
    super.key,
    this.initialMaxPrice,
    this.initialCategory,
  });

  @override
  State<ExploreFilterDialog> createState() => _ExploreFilterDialogState();
}

class _ExploreFilterDialogState extends State<ExploreFilterDialog> {
  late TextEditingController _priceController;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.initialMaxPrice?.toString() ?? '',
    );
    _selectedCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Properties'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Price Filter
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Max Price',
              hintText: 'Enter maximum price',
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
          ),
          
          const SizedBox(height: 16),
          
          // Category Filter (you can expand this with actual categories)
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              prefixIcon: Icon(Icons.category),
            ),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('All Categories'),
              ),
              const DropdownMenuItem<String>(
                value: 'apartment',
                child: Text('Apartment'),
              ),
              const DropdownMenuItem<String>(
                value: 'house',
                child: Text('House'),
              ),
              const DropdownMenuItem<String>(
                value: 'villa',
                child: Text('Villa'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final maxPrice = double.tryParse(_priceController.text);
            Navigator.of(context).pop({
              'maxPrice': maxPrice,
              'category': _selectedCategory,
            });
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
} 