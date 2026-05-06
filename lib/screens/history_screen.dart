import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/category_badge.dart';
import '../services/expense_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to the ExpenseProvider
    final expenses = Provider.of<ExpenseProvider>(context).expenses;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: expenses.isEmpty 
                ? const Center(child: Text("No expenses added yet!"))
                : ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.attach_money, color: Colors.white),
                      ),
                      title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('${expense.date.day}/${expense.date.month}/${expense.date.year}'),
                          const SizedBox(height: 4),
                          CategoryBadge(category: expense.category),
                        ],
                      ),
                      trailing: Text(
                        '\$${expense.amount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent),
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