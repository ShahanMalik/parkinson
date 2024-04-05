import 'package:flutter/material.dart';
import 'package:parkinson/main_Activity.dart';
import 'package:parkinson/presentation/authentication_screen/authentication_screen.dart';
import 'package:parkinson/presentation/forgot_password_screen/forgot_password_screen.dart';
import 'package:parkinson/presentation/splash_screen/splash_screen.dart';
import 'package:parkinson/presentation/login_screen/login_screen.dart';
import 'package:parkinson/presentation/signup_screen/signup_screen.dart';
import 'package:parkinson/presentation/dashboard_screen/dashboard_screen.dart';
import 'package:parkinson/presentation/article_screen/article_screen.dart';
import 'package:parkinson/presentation/ambulance_screen/ambulance_screen.dart';

class AppRoutes {
  static const String authenticationScreen = '/authentication_screen';

  static const String splashScreen = '/splash_screen';

  static const String loginScreen = '/login_screen';

  static const String forgetPasswordScreen = '/forget_password_screen';

  static const String signupScreen = '/signup_screen';

  static const String dashboardScreen = '/dashboard_screen';

  static const String drDetailsScreen = '/dr_details_screen';

  static const String bookAnAppointmentScreen = '/book_an_appointment_screen';

  static const String drugDetailsScreen = '/drug_details_screen';

  static const String articleScreen = '/article_screen';

  static const String ambulanceScreen = '/ambulance_screen';

  static const String schedulePage = '/schedule_page';

  static const String scheduleTabContainerScreen =
      '/schedule_tab_container_screen';

  static const String messagePage = '/message_page';

  static const String messageTabContainerScreen =
      '/message_tab_container_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String mainActivity = '/mainActivity';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => SplashScreen(),
    mainActivity: (context) => MainActivity(),
    authenticationScreen: (context) => AuthenticationScreen(),
    loginScreen: (context) => LoginScreen(),
    forgetPasswordScreen: (context) => ForgetPasswordScreen(),
    signupScreen: (context) => SignupScreen(),
    dashboardScreen: (context) => DashboardScreen(),
    articleScreen: (context) => ArticleScreen(),
    ambulanceScreen: (context) => AmbulanceScreen(),
  };
}
