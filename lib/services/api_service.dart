import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://responsi.webwizards.my.id/api';

  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Login response body: ${response.body}'); // For debugging

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        if (responseData['data'] != null && responseData['data']['token'] != null) {
          return 'Login successful!'; // Success message
        } else {
          return 'Login successful, but no token received. Please try again.';
        }
      } else {
        print('Login failed. Status code: ${response.statusCode}');
        return responseData['data'] ?? 'Failed to login. Please check your credentials and try again.';
      }
    } catch (e) {
      print('Exception during login: $e');
      return 'Failed to login: $e';
    }
  }


  Future<void> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/registrasi'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nama': name, 'email': email, 'password': password}),
      );

      print('Register response body: ${response.body}'); // For debugging

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        print('Registration successful');
      } else {
        print('Registration failed. Status code: ${response.statusCode}');
        throw Exception(responseData['data'] ?? 'Failed to register');
      }
    } catch (e) {
      print('Exception during registration: $e');
      throw Exception('Failed to register: $e');
    }
  }

  // Fetch all records from the API
  Future<List<dynamic>> getAll() async {
    final response = await http.get(Uri.parse('$baseUrl/kesehatan/rekam_medis_pasien'));
    
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      return decodedResponse['data']; // Adjust this line according to your API response structure
    } else {
      throw Exception('Failed to load records');
    }
  }

  // Create a new record
  Future<void> createRecord(Map<String, dynamic> data) async {
    await http.post(
      Uri.parse('$baseUrl/kesehatan/rekam_medis_pasien'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(data),
    );
  }

  Future<bool> updateRecord(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/kesehatan/rekam_medis_pasien/$id/update'), // Adjusted the URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(data),
    );

    // Log the response for debugging
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }


  // Delete a record
  Future<bool> deleteRecord(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/kesehatan/rekam_medis_pasien/$id/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response.statusCode == 200; // Return true if the deletion was successful
  }
}