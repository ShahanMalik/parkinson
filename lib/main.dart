import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:parkinson/routes/app_routes.dart';
import 'package:parkinson/theme/theme_helper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'App Notification Channel',
    id: 'App',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'App',
  );
  print(result);
  //
  ThemeHelper().changeTheme('primary');
  runApp(MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message fbm : ${message.messageId.toString()}");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      title: 'Parkinson',
      debugShowCheckedModeBanner: false,
      // initialRoute: AppRoutes.splashScreen,
      initialRoute: AppRoutes.authenticationScreen,
      routes: AppRoutes.routes,
    );
  }
}
