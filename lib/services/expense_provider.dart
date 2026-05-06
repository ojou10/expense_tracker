import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  ExpenseProvider() {
    _loadExpenses();
  }

  // Load from LocalStorage (Lab 7)
  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? expensesJson = prefs.getString('saved_expenses');
    if (expensesJson != null) {
      final List<dynamic> decodedData = json.decode(expensesJson);
      _expenses = decodedData.map((item) => Expense.fromJson(item)).toList();
      notifyListeners();
    }
  }

  // Add and Save to LocalStorage (Lab 7)
  Future<void> addExpense(Expense expense) async {
    _expenses.insert(0, expense); // Add to top of list
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(_expenses.map((e) => e.toJson()).toList());
    await prefs.setString('saved_expenses', encodedData);
  }
}