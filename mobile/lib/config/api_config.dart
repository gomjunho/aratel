import 'dart:io';

class ApiConfig {
  static String get defaultBaseUrl {
    // Allows overriding via --dart-define=BASE_URL=https://...
    const envUrl = String.fromEnvironment('BASE_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000'; // Android Emulator host loopback
    } else if (Platform.isIOS || Platform.isMacOS) {
      return 'http://127.0.0.1:3000'; // iOS Simulator & macOS desktop
    }
    return 'http://localhost:3000';
  }
}
