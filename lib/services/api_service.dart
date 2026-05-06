import 'dart:convert'; // Lab 6: Serialization and Deserialization
import 'package:http/http.dart' as http; // Lab 6: HTTP plugin

class ApiService {
  // Free, no-key-required exchange rate API
  static const String _baseUrl = 'https://open.er-api.com/v6/latest/USD';

  // Async programming to fetch data (Lab 6)
  static Future<double> fetchExchangeRate(String targetCurrency) async {
    try {
      // Making a correct API call with a 5-second timeout (Lab 6)
      final response = await http
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        // Use json.decode to transform the JSON string into a Dart object (Lab 6)
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Extract the specific currency rate
        return data['rates'][targetCurrency] ?? 1.0;
      } else {
        // Error handling (Lab 6)
        throw Exception('Failed to load exchange rate: ${response.statusCode}');
      }
    } catch (e) {
      // Catch blocks prevent the app from crashing (Lab 6)
      print('API Error: $e');
      return 1.0; // Fallback rate if offline
    }
  }
}