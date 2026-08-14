// lib/features/profile/services/security_service.dart

class SecurityService {
  SecurityService._();
  static final SecurityService instance = SecurityService._();

  String _currentPin = '123456'; // Default mock PIN
  bool _isBiometricsEnabled = true;
  bool _useFaceId = true;
  bool _requirePinForTransfer = true;

  String get currentPin => _currentPin;
  bool get isBiometricsEnabled => _isBiometricsEnabled;
  bool get useFaceId => _useFaceId;
  bool get requirePinForTransfer => _requirePinForTransfer;

  void setPin(String newPin) {
    _currentPin = newPin;
  }

  void toggleBiometrics(bool value) {
    _isBiometricsEnabled = value;
  }

  void toggleFaceId(bool value) {
    _useFaceId = value;
  }

  void toggleRequirePinForTransfer(bool value) {
    _requirePinForTransfer = value;
  }

  bool verifyPin(String pin) {
    return pin == _currentPin;
  }

  Future<bool> authenticateWithBiometrics() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _isBiometricsEnabled;
  }
}
