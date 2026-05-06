import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'package:provider/provider.dart'; 
import '../services/api_service.dart';
import '../services/expense_provider.dart'; 

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double exchangeRate = 1.0;
  bool isLoading = true; 
  bool _showInEGP = false; 

  @override
  void initState() {
    super.initState();
    _getLiveExchangeRate();
  }

  Future<void> _getLiveExchangeRate() async {
    final rate = await ApiService.fetchExchangeRate('EGP');
    if (mounted) {
      setState(() {
        exchangeRate = rate;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Grab the REAL list of expenses from the Provider
    final expenses = Provider.of<ExpenseProvider>(context).expenses;

    double totalExpensesUSD = 0;
    double foodTotal = 0;
    double transportTotal = 0;
    double billsTotal = 0;
    double otherTotal = 0;

    for (var expense in expenses) {
      totalExpensesUSD += expense.amount;
      
      if (expense.category == 'Food') {
        foodTotal += expense.amount;
      } else if (expense.category == 'Transport') {
        transportTotal += expense.amount;
      } else if (expense.category == 'Bills') {
        billsTotal += expense.amount;
      } else {
        otherTotal += expense.amount;
      }
    }

    final double totalInEGP = totalExpensesUSD * exchangeRate;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Spent', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                OutlinedButton.icon(
                  icon: const Icon(Icons.currency_exchange, size: 18),
                  label: Text(_showInEGP ? 'View in USD' : 'Convert to EGP'),
                  onPressed: () => setState(() => _showInEGP = !_showInEGP),
                ),
              ],
            ),
            const SizedBox(height: 8),
            isLoading 
              ? const CircularProgressIndicator()
              : Text(
                  _showInEGP ? 'EGP ${totalInEGP.toStringAsFixed(2)}' : '\$${totalExpensesUSD.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
            const SizedBox(height: 30),
            const Text('Spending by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            
            Expanded(
              child: totalExpensesUSD == 0 
                ? const Center(child: Text("Add expenses to see your chart!"))
                : PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      sections: [
                        if (foodTotal > 0) PieChartSectionData(color: Colors.redAccent, value: foodTotal, title: 'Food', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        if (transportTotal > 0) PieChartSectionData(color: Colors.blueAccent, value: transportTotal, title: 'Transport', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        if (billsTotal > 0) PieChartSectionData(color: Colors.greenAccent, value: billsTotal, title: 'Bills', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        if (otherTotal > 0) PieChartSectionData(color: Colors.orangeAccent, value: otherTotal, title: 'Other', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}