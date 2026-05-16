import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'camera_screen.dart';
import '../models/expense.dart';
import '../services/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String? receiptImagePath;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Food';
  final List<String> _categories = ['Food', 'Transport', 'Bills', 'Other'];

  void _saveExpense() {
    // 1. Check if fields are empty
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // 2. Safely try to convert the text to a number (Prevents the "meow" crash!)
    final parsedAmount = double.tryParse(_amountController.text);
    
    if (parsedAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number for the amount')),
      );
      return;
    }

    // 3. Create the expense using the safely parsed amount
    final newExpense = Expense(
      id: DateTime.now().toString(),
      title: _titleController.text,
      amount: parsedAmount,
      date: DateTime.now(),
      category: _selectedCategory,
      receiptPath: receiptImagePath,
    );

    // Add to state and storage
    Provider.of<ExpenseProvider>(context, listen: false).addExpense(newExpense);

    // Clear form
    _titleController.clear();
    _amountController.clear();
    setState(() => receiptImagePath = null);  

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Expense Added!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController, 
            decoration: const InputDecoration(labelText: 'Expense Title', border: OutlineInputBorder())
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController, 
            keyboardType: TextInputType.number, 
            decoration: const InputDecoration(labelText: 'Amount (\$)', border: OutlineInputBorder())
          ),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Category'),
            items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
            onChanged: (val) => setState(() => _selectedCategory = val!),
          ),
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Receipt'),
                onPressed: () async {
                  final imagePath = await Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraScreen()));
                  if (imagePath != null) setState(() => receiptImagePath = imagePath);
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Expense'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                onPressed: _saveExpense,
              ),
            ],
          ),
          if (receiptImagePath != null) 
            const Padding(
              padding: EdgeInsets.only(top: 8.0), 
              child: Text('Receipt attached!', style: TextStyle(color: Colors.green))
            ),
        ],
      ),
    );
  }
}