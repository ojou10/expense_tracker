import 'package:flutter/material.dart';
import 'camera_screen.dart'; // Import our new camera screen

// This must be Stateful to manage form input and the captured image (Lab 3)
class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String? receiptImagePath; // Variable to hold the photo path

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TextFields for input (Lab 3)
          const TextField(
            decoration: InputDecoration(
              labelText: 'Expense Title (e.g. Lunch)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount (\$)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          
          // Button to open the Native Camera (Lab 3 & 5)
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('Capture Receipt'),
            onPressed: () async {
              // Navigate to Camera Screen and wait for the result (Lab 4)
              final imagePath = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CameraScreen()),
              );

              // Update the UI if a photo was taken
              if (imagePath != null) {
                setState(() {
                  receiptImagePath = imagePath;
                });
              }
            },
          ),
          const SizedBox(height: 16),

          // Show confirmation if image was captured
          if (receiptImagePath != null)
            const Text(
              'Receipt photo attached!',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}