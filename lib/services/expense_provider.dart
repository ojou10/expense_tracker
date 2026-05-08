import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added Firebase Auth
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  ExpenseProvider() {
    loadExpenses(); // Load automatically when created
  }

  // Magic Key: Appends the unique Firebase User ID to the storage file!
  String get _storageKey {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    return 'saved_expenses_$userId';
  }

  // Load from LocalStorage (Now User-Specific)
  Future<void> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? expensesJson = prefs.getString(_storageKey);
    
    if (expensesJson != null) {
      final List<dynamic> decodedData = json.decode(expensesJson);
      _expenses = decodedData.map((item) => Expense.fromJson(item)).toList();
    } else {
      _expenses = []; // If new user, start with empty list
    }
    notifyListeners();
  }

  // Add and Save to LocalStorage (Now User-Specific)
  Future<void> addExpense(Expense expense) async {
    _expenses.insert(0, expense); 
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(_expenses.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encodedData);
  }

  // Wipe the screen when logging out
  void clearExpenses() {
    _expenses = [];
    notifyListeners();
  }
}