import 'package:flutter/foundation.dart';

class SecurityService extends ChangeNotifier {
  bool _isScreenCapturePrevented = true;
  bool _isPrivacyMasked = true;

  bool get isScreenCapturePrevented => _isScreenCapturePrevented;
  bool get isPrivacyMasked => _isPrivacyMasked;

  Future<void> setScreenCapturePrevention(bool enabled) async {
    _isScreenCapturePrevented = enabled;
    // Simulate setting FLAG_SECURE on Window/Android surface
    notifyListeners();
  }

  Future<void> setPrivacyMasking(bool enabled) async {
    _isPrivacyMasked = enabled;
    notifyListeners();
  }

  String maskName(String name) {
    if (name.length <= 1) return name;
    if (name.length == 2) {
      return '${name[0]}*';
    }
    final firstChar = name[0];
    final lastChar = name[name.length - 1];
    final middleMask = '*' * (name.length - 2);
    return '$firstChar$middleMask$lastChar';
  }

  String maskPhoneNumber(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11) {
      return '${digits.substring(0, 3)}-****-${digits.substring(7)}';
    }
    if (digits.length == 10) {
      return '${digits.substring(0, 3)}-***-${digits.substring(6)}';
    }
    return phone;
  }

  String maskUnitNumber(String unit) {
    if (unit.contains('호')) {
      final parts = unit.split(' ');
      if (parts.length > 1) {
        return '${parts.sublist(0, parts.length - 1).join(' ')} ****호';
      }
      return '****호';
    }
    if (RegExp(r'^\d+$').hasMatch(unit)) {
      return '****';
    }
    return unit;
  }
}
