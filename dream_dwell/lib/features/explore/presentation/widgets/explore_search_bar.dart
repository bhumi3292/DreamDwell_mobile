import 'package:flutter/material.dart';

class ExploreSearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onFilterPressed;

  const ExploreSearchBar({
    super.key,
    required this.onSearchChanged,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: theme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search properties...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: onSearchChanged,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.tune,
              color: theme.primaryColor,
            ),
            onPressed: onFilterPressed,
          ),
        ],
      ),
    );
  }
} 