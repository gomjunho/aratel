import 'dart:io';

class ApiConfig {
  static String get defaultBaseUrl {
    // Allows overriding via --dart-define=BASE_URL=http://...
    const envUrl = String.fromEnvironment('BASE_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }

    if (Platform.isAndroid) {
      // Default to 127.0.0.1 for ADB reverse port forwarding on physical devices (e.g. adb reverse tcp:3000 tcp:3000)
      // or 10.0.2.2 for Android Studio Emulator.
      return 'http://127.0.0.1:3000';
    } else if (Platform.isIOS || Platform.isMacOS) {
      return 'http://127.0.0.1:3000'; // iOS Simulator & macOS desktop
    }
    return 'http://localhost:3000';
  }
}
