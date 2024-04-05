import 'package:app_settings/app_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkinson/presentation/authentication_screen/authentication_screen.dart';
import 'package:parkinson/services/chat_servvices/screen/home_screen.dart';
import 'package:parkinson/services/notification_services/home_screen.dart';

import 'package:parkinson/widgets/profile_menu.dart';
import 'package:parkinson/widgets/profile_pic.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parkinson Therapy"),
        elevation: 0,
        leading: Icon(Icons.emergency_rounded),
      ),
      // body: Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 35.v),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       // CustomImageView(imagePath: ,),SizedBox(height: 8.v),

      //       SizedBox(
      //         height: 115,
      //         width: 115,
      //         child: Stack(
      //           fit: StackFit.expand,
      //           clipBehavior: Clip.none,
      //           children: [
      //             const CircleAvatar(
      //               backgroundImage:
      //                   AssetImage("assets/images/Profile Image.png"),
      //             ),
      //             Positioned(
      //               right: -16,
      //               bottom: 0,
      //               child: SizedBox(
      //                 height: 46,
      //                 width: 46,
      //                 child: TextButton(
      //                   style: TextButton.styleFrom(
      //                     foregroundColor: Colors.white,
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(50),
      //                       side: const BorderSide(color: Colors.white),
      //                     ),
      //                     backgroundColor: const Color(0xFFF5F6F9),
      //                   ),
      //                   onPressed: () {},
      //                   child:
      //                       SvgPicture.asset("assets/images/Camera Icon.svg"),
      //                 ),
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //       SizedBox(height: 8.v),
      //       CustomElevatedButton(text: 'Password'), SizedBox(height: 8.v),
      //       CustomElevatedButton(text: 'Email Address'), SizedBox(height: 8.v),
      //       // CustomElevatedButton(text: 'Fingerprint'), SizedBox(height: 8.v),
      //       CustomElevatedButton(text: 'Support'), SizedBox(height: 8.v),
      //       CustomElevatedButton(
      //         text: 'Sign Out',
      //         onPressed: () async {
      //           await FirebaseAuth.instance.signOut().then(
      //                 (value) => Navigator.of(context).pushAndRemoveUntil(
      //                   MaterialPageRoute(
      //                     builder: (context) => const AuthenticationScreen(),
      //                   ),
      //                   (route) => false,
      //                 ),
      //               );
      //         },
      //       ),
      //     ],
      //   ),
      // ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Chats",
              icon: "assets/images/User Icon.svg",
              press: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreenChat()))
              },
            ),
            ProfileMenu(
              text: "Notifications",
              icon: "assets/images/Bell.svg",
              press: () {
                AppSettings.openAppSettings(
                  asAnotherTask: true,
                  //open notification setting
                  type: AppSettingsType.notification,
                );
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
            ProfileMenu(
              text: "App info",
              icon: "assets/images/Settings.svg",
              press: () {
                AppSettings.openAppSettings(
                  asAnotherTask: true,
                  //open notification setting
                  type: AppSettingsType.settings,
                );
              },
            ),
            // ProfileMenu(
            //   text: "Help Center",
            //   icon: "assets/images/Question mark.svg",
            //   press: () {},
            // ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/images/Log out.svg",
              press: () async {
                await FirebaseAuth.instance.signOut().then(
                      (value) => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const AuthenticationScreen(),
                        ),
                        (route) => false,
                      ),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
