import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart'; // Added Provider
import '../services/theme_provider.dart'; // Added our new provider
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Student";
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? "Student";
    });
  }

  Future<void> _saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    setState(() {
      userName = name;
    });
    _nameController.clear(); 
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the provider to get the current switch state
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Text(
                'Hello, $userName!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 30),
          
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Update Name',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.save, color: Theme.of(context).primaryColor),
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    _saveName(_nameController.text);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          const Text(
            'App Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const Divider(),
          
          SwitchListTile(
            title: const Text('Enable Dark Mode Theme'),
            subtitle: const Text('Save preference locally'),
            // Connect the switch directly to the provider!
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
            activeColor: Theme.of(context).primaryColor,
          ),

          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/'); // Send back to Login
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}