import 'package:flutter/material.dart';

// This is your own custom stateless component (Lab 3 concept)
class CategoryBadge extends StatelessWidget {
  final String category;

  const CategoryBadge({super.key, required this.category});

  // Logic to determine color based on category
  Color _getCategoryColor() {
    switch (category.toLowerCase()) {
      case 'food': return Colors.redAccent;
      case 'transport': return Colors.blueAccent;
      case 'bills': return Colors.greenAccent;
      default: return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _getCategoryColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getCategoryColor()),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: _getCategoryColor(),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}