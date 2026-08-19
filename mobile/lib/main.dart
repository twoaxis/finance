import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:twoaxis_finance/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:twoaxis_finance/core/services/notification_service_impl.dart';
import 'package:twoaxis_finance/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if(kDebugMode) {
    await FirebaseAuth.instance.useAuthEmulator("10.0.2.2", 9099);
    FirebaseFirestore.instance.useFirestoreEmulator("10.0.2.2", 8080);
  }

  var notificationService = NotificationServiceImpl(messaging: FirebaseMessaging.instance);

  await notificationService.initialize();
  var token = await notificationService.getToken();
  debugPrint("FCM Token: $token");

  runApp(const App());
}
