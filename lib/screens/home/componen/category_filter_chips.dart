import 'package:flutter/material.dart'; 
import 'package:login/screens/home/home_page.dart';

class CategoryFilterChips extends StatelessWidget {
  final FilterType selectedFilter;
  final Function(FilterType) onFilterSelected;

  const CategoryFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: FilterType.values.map((filter) {
          final String label = filter.name[0].toUpperCase() + filter.name.substring(1);
          return ChoiceChip(
            label: Text(label),
            selected: selectedFilter == filter,
            onSelected: (isSelected) {
              if (isSelected) onFilterSelected(filter);
            },
            backgroundColor: Colors.black.withOpacity(0.3),
            selectedColor: Colors.amber,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: selectedFilter == filter ? Colors.black : Colors.white70,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(color: Colors.transparent),
            ),
          );
        }).toList(),
      ),
    );
  }
}