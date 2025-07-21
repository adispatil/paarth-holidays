import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../models/profile_model.dart';
import '../models/leads_model.dart';
import '../models/sector_model.dart';
import '../models/booking_model.dart';
import '../models/enquiry_details_model.dart';
import '../models/offer_model.dart';
import '../models/wallet_model.dart';
import 'storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://macha.tours/api';
  StorageService? _storageService;
  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      final prefs = await SharedPreferences.getInstance();
      _storageService = StorageService(prefs);
      _isInitialized = true;
    }
  }

  Map<String, String> _getHeaders() {
    if (_storageService == null) {
      throw Exception('Storage service not initialized');
    }
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': _storageService!.getToken() ?? '',
    };
  }

  /// Sends an OTP to the given mobile number for sign-in.
  ///
  /// Sends a POST request to the /otp-signin endpoint.
  /// Returns the token on success.
  /// Throws an [Exception] if the request fails or there is a network/server error.
  Future<String> otpSignIn(String mobileNumber) async {
    final url = Uri.parse('$baseUrl/otp-signin');
    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'mobile_number': mobileNumber}),
          )
          .timeout(
            const Duration(seconds: 50),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null && data['data']['token'] != null) {
          return data['data']['token'];
        } else {
          throw Exception(data['message'] ?? 'Failed to send OTP');
        }
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      }
      throw Exception('Failed to send OTP: $e');
    }
  }

  /// Fetches the user profile from the API.
  ///
  /// Sends a GET request to the /profile endpoint with required headers.
  /// Returns a [ProfileModel] on success.
  /// Throws an [Exception] if the request fails, the token is invalid, or there is a network/server error.
  Future<ProfileModel> fetchUserProfile() async {
    await _ensureInitialized();
    final url = Uri.parse('$baseUrl/profile');
    try {
      final response = await http
          .get(
            url,
            headers: {
              ..._getHeaders(),
              'user_type': '1',
            },
          )
          .timeout(
            const Duration(seconds: 50),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true && data['resultData'] != null) {
          return ProfileModel.fromJson(data['resultData']);
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch profile');
        }
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      }
      throw Exception('Failed to fetch profile: $e');
    }
  }

  /// Fetches all leads (pending, active, and closed) from the API.
  ///
  /// Sends a GET request to the /leads endpoint with required headers.
  /// Returns a [LeadsModel] on success.
  /// Throws an [Exception] if the request fails, the token is invalid, or there is a network/server error.
  Future<LeadsModel> fetchLeads() async {
    await _ensureInitialized();
    final url = Uri.parse('$baseUrl/leads');
    try {
      final response = await http
          .get(
            url,
            headers: _getHeaders(),
          )
          .timeout(
            const Duration(seconds: 50),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true) {
          return LeadsModel.fromJson(data);
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch leads');
        }
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      }
      throw Exception('Failed to fetch leads: $e');
    }
  }

  /// Fetches all sectors from the API.
  ///
  /// Sends a GET request to the /sectors endpoint with required headers.
  /// Returns a [SectorModel] on success.
  /// Throws an [Exception] if the request fails or there is a network/server error.
  Future<SectorModel> fetchSectors() async {
    await _ensureInitialized();
    final url = Uri.parse('$baseUrl/sectors');
    try {
      final response = await http
          .get(
            url,
            headers: _getHeaders(),
          )
          .timeout(
            const Duration(seconds: 50),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true) {
          return SectorModel.fromJson(data);
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch sectors');
        }
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      }
      throw Exception('Failed to fetch sectors: $e');
    }
  }

  /// Creates a new lead with the provided details.
  ///
  /// Sends a POST request to the /add-request endpoint with required headers.
  /// Returns a [Map<String, dynamic>] containing the response data on success.
  /// Throws an [Exception] if the request fails or there is a network/server error.
  Future<Map<String, dynamic>> createLead({
    required String leadName,
    required String leadContact,
    required String leadSector,
  }) async {
    await _ensureInitialized();
    final url = Uri.parse('$baseUrl/add-request');
    try {
      final response = await http
          .post(
            url,
            headers: _getHeaders(),
            body: jsonEncode({
              'lead_name': leadName,
              'lead_contact': leadContact,
              'lead_sector': leadSector,
            }),
          )
          .timeout(
            const Duration(seconds: 50),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Failed to create lead');
        }
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      }
      throw Exception('Failed to create lead: $e');
    }
  }

  /// Fetches all bookings from the API.
  ///
  /// Sends a GET request to the /enquiries endpoint with required headers.
  /// Returns a [List<BookingModel>] on success.
  /// Throws an [Exception] if the request fails or there is a network/server error.
  Future<List<BookingModel>> fetchBookings() async {
    await _ensureInitialized();
    final url = Uri.parse('$baseUrl/enquiries');
    try {
      final response = await http
          .get(
            url,
            headers: _getHeaders(),
          )
          .timeout(
            const Duration(seconds: 50),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true && data['resultData'] != null) {
          return BookingModel.listFromJson(data['resultData']);
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch bookings');
        }
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      }
      throw Exception('Failed to fetch bookings: $e');
    }
  }

  /// Fetches enquiry details from the API.
  ///
  /// Sends a GET request to the /enquiry-details endpoint with required headers.
  /// Returns a [EnquiryDetailsModel] on success.
  /// Throws an [Exception] if the request fails or there is a network/server error.
  Future<EnquiryDetailsModel> fetchEnquiryDetails(String enquiryId) async {
    await _ensureInitialized();
    final url = Uri.parse('$baseUrl/enquiry-details?enquiry_id=$enquiryId');
    try {
      final response = await http
          .get(
            url,
            headers: _getHeaders(),
          )
          .timeout(
            const Duration(seconds: 50),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true && data['resultData'] != null) {
          return EnquiryDetailsModel.fromJson(data['resultData']);
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch enquiry details');
        }
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      }
      throw Exception('Failed to fetch enquiry details: $e');
    }
  }

  /// Fetches the latest offers from the API.
  ///
  /// Sends a GET request to the /offers endpoint.
  /// Returns a [List<OfferModel>] on success.
  /// Throws an [Exception] if the request fails or there is a network/server error.
  Future<List<OfferModel>> fetchOffers() async {
    final url = Uri.parse('$baseUrl/offers');
    try {
      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 50),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true && data['resultData'] != null) {
          return OfferModel.listFromJson(data['resultData']);
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch offers');
        }
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      }
      throw Exception('Failed to fetch offers: $e');
    }
  }

  /// Changes the user's password.
  ///
  /// Sends a POST request to the /change-password endpoint with required headers.
  /// Returns a [Map<String, dynamic>] containing the response data on success.
  /// Throws an [Exception] if the request fails or there is a network/server error.
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _ensureInitialized();
    final url = Uri.parse('$baseUrl/change-password');
    try {
      final response = await http
          .post(
            url,
            headers: _getHeaders(),
            body: jsonEncode({
              'old_password': oldPassword,
              'new_password': newPassword,
            }),
          )
          .timeout(
            const Duration(seconds: 50),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Failed to change password');
        }
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      }
      throw Exception('Failed to change password: $e');
    }
  }

  /// Sends a password reset email to the provided email address.
  ///
  /// Sends a POST request to the /forgot-password endpoint.
  /// Returns a [Map<String, dynamic>] containing the response data on success.
  /// Throws an [Exception] if the request fails or there is a network/server error.
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final url = Uri.parse('$baseUrl/forgot-password');
    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'username': email,
            }),
          )
          .timeout(
            const Duration(seconds: 50),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Failed to send password reset email');
        }
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      }
      throw Exception('Failed to send password reset email: $e');
    }
  }

  /// Fetches wallet data from the API.
  ///
  /// Sends a GET request to the /wallet endpoint with required headers.
  /// Returns a [WalletModel] on success.
  /// Throws an [Exception] if the request fails or there is a network/server error.
  Future<WalletModel> fetchWallet() async {
    await _ensureInitialized();
    final response = await http.get(
      Uri.parse('https://macha.tours/api/wallet'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true) {
        return WalletModel.fromJson(jsonResponse['resultData']);
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to fetch wallet data');
      }
    } else {
      throw Exception('Failed to fetch wallet data: ${response.statusCode}');
    }
  }

  /// Uploads contacts to the server.
  ///
  /// Sends a POST request to the /contacts endpoint with required headers.
  /// Filters contacts to only include those with valid phone numbers (10 digits).
  /// Throws an [Exception] if the request fails or there is a network/server error.
  Future<void> uploadContacts(List<Contact> contacts) async {
    try {
      await _ensureInitialized();
      final List<Map<String, String>> data = contacts
          .where((c) => c.phones.isNotEmpty)
          .map((c) => {
                'name': c.displayName,
                'number': c.phones.first.number.replaceAll(RegExp(r'\D'), '').replaceFirst(RegExp(r'^.*(?=\d{10}\$)'), ''),
              })
          .where((c) => c['number'] != null && c['number']!.length == 10)
          .toList();
      if (data.isEmpty) return;
      final response = await http.post(
        Uri.parse('https://macha.tours/api/contacts'),
        headers: _getHeaders(),
        body: jsonEncode({'data': data}),
      );
      debugPrint('Contacts upload response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        debugPrint('All contacts saved to server.');
      }
    } catch (e) {
      debugPrint('Failed to upload contacts: $e');
    }
  }

  /// Validates the OTP using the provided token and otp.
  ///
  /// Sends a POST request to the /validate-otp endpoint.
  /// Returns a map with 'auth_token' and 'is_profile_completed' on success.
  /// Throws an [Exception] if the request fails or there is a network/server error.
  Future<Map<String, dynamic>> validateOtp({required String token, required String otp}) async {
    final url = Uri.parse('$baseUrl/validate-otp');
    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'token': token, 'otp': otp}),
          )
          .timeout(
            const Duration(seconds: 50),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null && data['data']['auth_token'] != null) {
          return {
            'auth_token': data['data']['auth_token'],
            'is_profile_completed': data['data']['is_profile_completed'],
          };
        } else {
          throw Exception(data['message'] ?? 'Failed to validate OTP');
        }
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      }
      throw Exception('Failed to validate OTP: $e');
    }
  }

  /// Updates the user profile with name, gender, and email.
  ///
  /// Sends a POST request to the /update-profile endpoint.
  /// Returns the message on success.
  /// Throws an [Exception] if the request fails or there is a network/server error.
  Future<String> updateProfile({required String name, required String gender, required String email}) async {
    final url = Uri.parse('$baseUrl/update-profile');
    await _ensureInitialized();
    try {
      final response = await http
          .post(
            url,
            headers: _getHeaders(),
            body: jsonEncode({
              'name': name,
              'gender': gender,
              'email': email,
            }),
          )
          .timeout(
            const Duration(seconds: 50),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true) {
          return data['message'] ?? 'Profile updated successfully!';
        } else {
          throw Exception(data['message'] ?? 'Failed to update profile');
        }
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      }
      throw Exception('Failed to update profile: $e');
    }
  }
}
