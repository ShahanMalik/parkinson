import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parkinson/services/notification_services/notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                fillColor: Color.fromARGB(255, 210, 209, 209),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 210, 209, 209),
                filled: true,
                hintText: 'description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // TimePickerDialog(
            //   initialTime: TimeOfDay.now(),
            // ),

            SizedBox(height: 10),
            TextButton(
                onPressed: () {
                  // send notification from one device to another
                  if (titleController.text.isEmpty ||
                      descriptionController.text.isEmpty) {
                    return;
                  }
                  notificationServices.getDeviceToken().then((value) async {
                    var data = {
                      'to': value.toString(),
                      'notification': {
                        'title': titleController.text.toString(),
                        'body': descriptionController.text.toString(),
                        "sound": "jetsons_doorbell.mp3",
                        "android_channel_id": "App",
                      },
                      'data': {
                        'type': 'msj',
                        'id': 'Shahan Malik',
                        'title': titleController.text.toString(),
                        'body': descriptionController.text.toString(),
                      }
                    };

                    await http.post(
                        Uri.parse('https://fcm.googleapis.com/fcm/send'),
                        body: jsonEncode(data),
                        headers: {
                          'Content-Type': 'application/json; charset=UTF-8',
                          'Authorization':
                              'key=AAAAP2FPohY:APA91bH58H_X2xjGHLE8VkSZx3t0QGPRLxJL0cTkcAeY02ph-E1uqGrWL1EnBrm1GCiZgN8TPG_vWlbjg_2sUs4gSkFlilRosJaN7y-HhdRFfxDJsFYYwJrazDHjeXbQaFpZ5HE8Gfd2'
                        }).then((value) {
                      if (kDebugMode) {
                        print(value.body.toString());
                      }
                    }).onError((error, stackTrace) {
                      if (kDebugMode) {
                        print(error);
                      }
                    });
                  });
                },
                child: Text(
                  'Send Notifications',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
