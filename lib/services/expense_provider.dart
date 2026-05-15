import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ExpenseProvider() {
    loadExpenses();
  }

  String get _userId => FirebaseAuth.instance.currentUser?.uid ?? 'guest';

  String get _storageKey => 'saved_expenses_$_userId';

  // Load from Firestore API first, fall back to local cache
  Future<void> loadExpenses() async {
    final uid = _userId;
    if (uid == 'guest') {
      // Not authenticated — load from local only
      await _loadFromLocal();
      return;
    }

    try {
      final snapshot = await _firestore
          .collection('expenses')
          .where('userId', isEqualTo: uid)
          .orderBy('date', descending: true)
          .get();

      _expenses = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Expense.fromJson(data);
      }).toList();

      // Update local cache with fresh API data
      await _saveToLocal();
    } catch (e) {
      // API unavailable — fall back to local storage
      debugPrint('Firestore load failed, using local cache: $e');
      await _loadFromLocal();
    }

    notifyListeners();
  }

  // Add expense — save to Firestore API, then update local cache
  Future<void> addExpense(Expense expense) async {
    final expenseWithUser = Expense(
      id: expense.id,
      title: expense.title,
      amount: expense.amount,
      date: expense.date,
      category: expense.category,
      userId: _userId,
    );

    _expenses.insert(0, expenseWithUser);
    notifyListeners();

    // Save to Firestore API (use expense.id as document ID for consistency)
    if (_userId != 'guest') {
      try {
        await _firestore
            .collection('expenses')
            .doc(expense.id)
            .set(expenseWithUser.toJson());
      } catch (e) {
        debugPrint('Firestore save failed: $e');
      }
    }

    // Always persist locally as cache
    await _saveToLocal();
  }

  // Delete an expense from Firestore and local state
  Future<void> deleteExpense(String firestoreDocId) async {
    _expenses.removeWhere((e) => e.id == firestoreDocId);
    notifyListeners();

    if (_userId != 'guest') {
      try {
        await _firestore.collection('expenses').doc(firestoreDocId).delete();
      } catch (e) {
        debugPrint('Firestore delete failed: $e');
      }
    }

    await _saveToLocal();
  }

  // Clear in-memory state on logout (Firestore data persists)
  void clearExpenses() {
    _expenses = [];
    notifyListeners();
  }

  // -- Private helpers --

  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final String? expensesJson = prefs.getString(_storageKey);

    if (expensesJson != null) {
      final List<dynamic> decodedData = json.decode(expensesJson);
      _expenses = decodedData.map((item) => Expense.fromJson(item)).toList();
    } else {
      _expenses = [];
    }
  }

  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        json.encode(_expenses.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encodedData);
  }
}
