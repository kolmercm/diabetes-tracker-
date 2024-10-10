import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  String? _authToken; // Added: To store the authorization token

  ApiService({required this.baseUrl});

  // Modified: Return bool to indicate success
  bool setAuthToken(String token) {
    if (token.isNotEmpty) {
      _authToken = token;
      return true;
    }
    return false;
  }

  // Added: Method to check if token is set
  bool get isAuthTokenSet => _authToken != null && _authToken!.isNotEmpty;

  // Example: POST request to log blood sugar
  Future<Map<String, dynamic>> logBloodSugar(int bloodSugar) async {
    final url = Uri.parse('$baseUrl/process-data');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (_authToken != null)
            'Authorization':
                'Bearer $_authToken', // Modified: Added Authorization header
        },
        body: jsonEncode({
          'blood_sugar': bloodSugar,
          'timestamp': DateTime.now().toIso8601String()
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to log blood sugar');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Example: GET request to retrieve app info
  Future<Map<String, dynamic>> getAppInfo() async {
    final url = Uri.parse('$baseUrl/protected-route');
    try {
      // Check if the auth token is set
      if (!isAuthTokenSet) {
        throw Exception(
            'Auth token is not set. Please log in or set the token.');
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Content-Type': 'application/json',
        },
      );

      // Handle different status codes
      switch (response.statusCode) {
        case 200:
          return jsonDecode(response.body);
        case 401:
          throw Exception('Unauthorized: Please log in again.');
        case 403:
          throw Exception(
              'Forbidden: You do not have permission to access this resource.');
        case 404:
          throw Exception('Not Found: The requested resource does not exist.');
        default:
          throw Exception(
              'Failed to get app info. Status code: ${response.statusCode}');
      }
    } on FormatException {
      throw Exception('Error: Invalid response format');
    } catch (e) {
      throw Exception('Error getting app info: $e');
    }
  }

  // Add more methods as needed for other endpoints
}
