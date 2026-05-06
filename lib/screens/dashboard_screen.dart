import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
import '../services/api_service.dart'; // Import our new API Service

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final double totalExpensesUSD = 1250.50;
  double exchangeRate = 1.0;
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _getLiveExchangeRate();
  }

  // Fetch data and update UI (Lab 6: Use StatefulWidget to hold API data)
  Future<void> _getLiveExchangeRate() async {
    final rate = await ApiService.fetchExchangeRate('EGP');
    
    // Add the setState method to notify the framework (Lab 6)
    if (mounted) {
      setState(() {
        exchangeRate = rate;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate live total
    final double totalInEGP = totalExpensesUSD * exchangeRate;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Spent This Month (Live EGP)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            // Show a loading spinner while fetching from API
            isLoading 
              ? const CircularProgressIndicator()
              : Text(
                  'EGP ${totalInEGP.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 36, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.blue),
                ),
            const SizedBox(height: 30),
            const Text(
              'Spending by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                  sections: [
                    PieChartSectionData(color: Colors.redAccent, value: 40, title: 'Food', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    PieChartSectionData(color: Colors.blueAccent, value: 30, title: 'Transport', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    PieChartSectionData(color: Colors.greenAccent, value: 15, title: 'Bills', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    PieChartSectionData(color: Colors.orangeAccent, value: 15, title: 'Other', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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