import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parkinson/core/app_export.dart';
import 'package:parkinson/presentation/ambulance_screen/ambulance_screen.dart';
import 'package:parkinson/presentation/dashboard_screen/dashboard_screen.dart';
import 'package:parkinson/presentation/disease_detector_screen/disease_detector_screen.dart';
import 'package:parkinson/presentation/patient_detail_screen/patient_detail_screen.dart';
import 'package:parkinson/presentation/user_profile/user_profile.dart';
import 'package:parkinson/services/chat_servvices/screen/home_screen.dart';
import 'package:parkinson/services/notification_services/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? radioValue = '';

class MainActivity extends StatefulWidget {
  const MainActivity({Key? key}) : super(key: key);

  @override
  State<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  int selectedIndex = 0;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.imgNavHome,
      activeIcon: ImageConstant.imgNavHome,
      title: "Home",
      type: BottomBarEnum.Home,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgCalculator,
      activeIcon: ImageConstant.imgCalculator,
      title: "Ambulance",
      type: BottomBarEnum.Ambulance,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavAppointment,
      activeIcon: ImageConstant.imgNavAppointment,
      title: "Check",
      type: BottomBarEnum.Check,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavProfile,
      activeIcon: ImageConstant.imgNavProfile,
      title: "Profile",
      type: BottomBarEnum.Profile,
    )
  ];

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    getSharedPref();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    NotificationServices().getDeviceToken().then((value) {
      FirebaseFirestore.instance
          .collection(radioValue!)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"deviceToken": value});
    });
    print('how many time it called');
  }

  void getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      radioValue = prefs.getString("loginPageRadioValue");
    });
  }

  @override
  Widget build(BuildContext context) {
    print('radioValue is : $radioValue');

    final screens = [
      DashboardScreen(),
      AmbulanceScreen(),
      radioValue == "patients"
          ? DiseaseDetectorScreen()
          : PatientDetailScreen(),
      UserProfileScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      // appBar: AppBar(
      //   title: Text("Parkinson Therapy"),
      //   elevation: 0,
      //   leading: Icon(Icons.emergency_rounded),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          return BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: bottomMenuList[index].icon,
                  height: 21.v,
                  width: 20.h,
                  color: appTheme.gray500,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.v),
                  child: Text(
                    bottomMenuList[index].title ?? "",
                    style: theme.textTheme.labelSmall!.copyWith(
                      color: appTheme.gray500,
                    ),
                  ),
                ),
              ],
            ),
            activeIcon: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: bottomMenuList[index].activeIcon,
                  height: 22.v,
                  width: 19.h,
                  color: appTheme.cyan300,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.v),
                  child: Text(
                    bottomMenuList[index].title ?? "",
                    style: CustomTextStyles.labelSmallCyan300.copyWith(
                      color: appTheme.cyan300,
                    ),
                  ),
                ),
              ],
            ),
            label: '',
          );
        }),
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreenChat()));
        },
        child: Container(
          height: 45,
          width: 45,
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: appTheme.teal50,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Lottie.asset(
              'assets/images/message_lottie.json',
              fit: BoxFit.scaleDown,
              height: 26,
              width: 26,
            ),
          ),
        ),
      ),
    );
  }
}

enum BottomBarEnum {
  Home,
  Ambulance,
  Check,
  Profile,
}

class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    this.title,
    required this.type,
  });

  String icon;

  String activeIcon;

  String? title;

  BottomBarEnum type;
}
