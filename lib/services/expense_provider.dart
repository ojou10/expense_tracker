import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  ExpenseProvider() {
    loadExpenses(); 
  }

  String get _storageKey {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    return 'saved_expenses_$userId';
  }

  Future<void> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? expensesJson = prefs.getString(_storageKey);
    
    if (expensesJson != null) {
      final List<dynamic> decodedData = json.decode(expensesJson);
      _expenses = decodedData.map((item) => Expense.fromJson(item)).toList();
    } else {
      _expenses = []; 
    }
    notifyListeners();
  }

  // saves locally AND to the Cloud API 
  Future<void> addExpense(Expense expense) async {
    _expenses.insert(0, expense); 
    notifyListeners();
    
    //  Store Data Locally
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(_expenses.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encodedData);

    // Requirement 8: API Integration to Store Data (Firestore API)
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(expense.id)
          .set(expense.toJson()); // Sends the JSON to the cloud!
    } catch (e) {
      print("Failed to store to API: $e");
    }
  }

  void clearExpenses() {
    _expenses = [];
    notifyListeners();
  }
}