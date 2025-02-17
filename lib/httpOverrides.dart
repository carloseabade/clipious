import 'dart:io';

import 'package:invidious/database.dart';
import 'package:invidious/globals.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // if true, it will allow all certs, if false it will throw error on a bad cert
        return db.getSettings(SKIP_SSL_VERIFICATION)?.value == 'true';
      };
  }
}
