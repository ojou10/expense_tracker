import 'package:flutter/material.dart';
import '../models/expense.dart'; // Your data blueprint
import '../widgets/category_badge.dart'; // Your custom internet component!

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Dummy data to simulate our database
  final List<Expense> _recentExpenses = [
    Expense(id: '1', title: 'Groceries', amount: 45.50, date: DateTime.now().subtract(const Duration(days: 1)), category: 'Food'),
    Expense(id: '2', title: 'Uber to University', amount: 12.00, date: DateTime.now().subtract(const Duration(days: 2)), category: 'Transport'),
    Expense(id: '3', title: 'Netflix Subscription', amount: 15.99, date: DateTime.now().subtract(const Duration(days: 3)), category: 'Bills'),
    Expense(id: '4', title: 'Coffee', amount: 4.50, date: DateTime.now().subtract(const Duration(days: 3)), category: 'Food'),
    Expense(id: '5', title: 'New Mouse', amount: 25.00, date: DateTime.now().subtract(const Duration(days: 5)), category: 'Other'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Expanded allows the ListView to take up the remaining screen space
            Expanded(
              // HERE IS THE LISTVIEW.BUILDER!
              child: ListView.builder(
                itemCount: _recentExpenses.length,
                itemBuilder: (context, index) {
                  final expense = _recentExpenses[index];
                  
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.attach_money, color: Colors.white),
                      ),
                      title: Text(
                        expense.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // HERE IS YOUR CUSTOM COMPONENT INTEGRATED!
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('${expense.date.day}/${expense.date.month}/${expense.date.year}'),
                          const SizedBox(height: 4),
                          CategoryBadge(category: expense.category), // Custom Widget
                        ],
                      ),
                      trailing: Text(
                        '\$${expense.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}