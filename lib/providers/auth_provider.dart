import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  // Mock login for demo purposes (will be replaced with Firebase Auth)
  Future<bool> login(String email, String password, UserRole role) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock user creation
      _currentUser = UserModel(
        id: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: _getNameFromEmail(email),
        role: role,
        createdAt: DateTime.now(),
        isActive: true,
      );

      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? phoneNumber,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = UserModel(
        id: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        role: role,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        isActive: true,
      );

      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  String _getNameFromEmail(String email) {
    return email.split('@')[0].replaceAll('.', ' ').split(' ')
        .map((word) => word.isNotEmpty 
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  void setUser(UserModel user) {
    _currentUser = user;
    _isAuthenticated = true;
    notifyListeners();
  }
}
