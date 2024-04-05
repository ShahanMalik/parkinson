import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parkinson/core/utils/utils.dart';
import 'package:parkinson/services/notification_services/notification_services.dart';
import 'package:parkinson/widgets/custom_elevated_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DiseaseDetectorScreen extends StatefulWidget {
  const DiseaseDetectorScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseDetectorScreen> createState() => _DiseaseDetectorScreenState();
}

class _DiseaseDetectorScreenState extends State<DiseaseDetectorScreen> {
  List<String> deviceToken = [];
  var musclesStiffnessValue = "No";
  var tremorsValue = "No";
  var slowMovementValue = "No";
  var balanceProblemValue = "No";
  var shufflingGaitValue = "No";
  var speechChangeValue = "No";
  bool isload = false;

  List<String> symptoms = [
    'Muscles Stiffness',
    'Tremors',
    'Slow Movement',
    'Balance Problem',
    'Shuffling Gait',
    'Speech Change',
  ];

  List<String> answers = ["No", "No", "No", "No", "No", "No"];
  List<String> disease = [];

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
    // deviceToken.clear();
  }

  @override
  Widget build(BuildContext context) {
    print(answers);

    return Scaffold(
      appBar: AppBar(
        title: Text("Parkinson Therapy"),
        elevation: 0,
        leading: Icon(Icons.emergency_rounded),
      ),
      body: Padding(
          padding: EdgeInsets.only(left: 20, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Give the following answers",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(''),
                  Row(
                    children: [
                      Text("Yes"),
                      SizedBox(
                        width: 35,
                      ),
                      Text("No"),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                ],
              ),
              // 1 ---------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Muscles Stiffness'),
                  Row(
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: musclesStiffnessValue,
                        onChanged: (value) {
                          setState(
                            () {
                              musclesStiffnessValue = value.toString();
                              answers[0] = value.toString();
                            },
                          );
                        },
                      ),
                      Radio(
                        value: "No",
                        groupValue: musclesStiffnessValue,
                        onChanged: (value) {
                          setState(
                            () {
                              musclesStiffnessValue = value.toString();
                              answers[0] = value.toString();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              // -------- 2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tremors'),
                  Row(
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: tremorsValue,
                        onChanged: (value) {
                          setState(() {
                            tremorsValue = value.toString();
                            answers[1] = value.toString();
                          });
                        },
                      ),
                      Radio(
                        value: "No",
                        groupValue: tremorsValue,
                        onChanged: (value) {
                          setState(() {
                            tremorsValue = value.toString();
                            answers[1] = value.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              // -------- 3
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Slow Movement'),
                  Row(
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: slowMovementValue,
                        onChanged: (value) {
                          setState(() {
                            slowMovementValue = value.toString();
                            answers[2] = value.toString();
                          });
                        },
                      ),
                      Radio(
                        value: "No",
                        groupValue: slowMovementValue,
                        onChanged: (value) {
                          setState(() {
                            slowMovementValue = value.toString();
                            answers[2] = value.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              // -------- 4
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Balance Problem'),
                  Row(
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: balanceProblemValue,
                        onChanged: (value) {
                          setState(() {
                            balanceProblemValue = value.toString();
                            answers[3] = value.toString();
                          });
                        },
                      ),
                      Radio(
                        value: "No",
                        groupValue: balanceProblemValue,
                        onChanged: (value) {
                          setState(() {
                            balanceProblemValue = value.toString();
                            answers[3] = value.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              // -------- 5
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shuffling Gait'),
                  Row(
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: shufflingGaitValue,
                        onChanged: (value) {
                          setState(() {
                            shufflingGaitValue = value.toString();
                            answers[4] = value.toString();
                          });
                        },
                      ),
                      Radio(
                        value: "No",
                        groupValue: shufflingGaitValue,
                        onChanged: (value) {
                          setState(() {
                            shufflingGaitValue = value.toString();
                            answers[4] = value.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              // -------- 6
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Speech Change'),
                  Row(
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: speechChangeValue,
                        onChanged: (value) {
                          setState(() {
                            speechChangeValue = value.toString();
                            answers[5] = value.toString();
                          });
                        },
                      ),
                      Radio(
                        value: "No",
                        groupValue: speechChangeValue,
                        onChanged: (value) {
                          setState(() {
                            speechChangeValue = value.toString();
                            answers[5] = value.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              CustomElevatedButton(
                text: "Check",
                isloading: isload,
                onPressed: () async {
                  setState(() {
                    isload = true;
                  });
                  for (int i = 0; i < answers.length; i++) {
                    if (answers[i] == "No") {
                      disease.add(symptoms[i]);
                    }
                  }
                  if (disease.isEmpty) {
                    Utils().showMessage(context, 'You are healthy!');
                    setState(() {
                      isload = false;
                    });
                    return;
                  } else {
                    print("You have $disease");
                    await FirebaseFirestore.instance
                        .collection('patients')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({
                      "disease": disease,
                      "diseaseAddTime": DateTime.now().toString(),
                    }).then((value) {
                      print("Success");
                    }).catchError((error) {
                      print("Failed");
                    });
                  }
                  //...............................................
                  //...............................................
                  //...............................................
                  //...............................................
                  //...............................................
                  print("Button pressed");
                  var collection =
                      FirebaseFirestore.instance.collection('doctors');
                  var snapshot = await collection.get();
                  // print("Got snapshot with ${snapshot.docs.length} docs");
                  snapshot.docs.forEach((doc) {
                    print("Device Token: " + doc['deviceToken']);
                    deviceToken.add(doc['deviceToken']);
                  });
                  //...............................................
                  //...............................................
                  //...............................................
                  //...............................................
                  //...............................................
                  const FCM_SERVER_KEY =
                      'key=AAAAP2FPohY:APA91bH58H_X2xjGHLE8VkSZx3t0QGPRLxJL0cTkcAeY02ph-E1uqGrWL1EnBrm1GCiZgN8TPG_vWlbjg_2sUs4gSkFlilRosJaN7y-HhdRFfxDJsFYYwJrazDHjeXbQaFpZ5HE8Gfd2';

                  Future<void> sendNotification(String deviceToken) async {
                    var data = {
                      'to': deviceToken,
                      'notification': {
                        'title': "Parkinson's Disease ",
                        'body': "New Patient Added",
                        "sound": "jetsons_doorbell.mp3",
                        "android_channel_id": "App",
                      },
                      'data': {
                        'type': 'msj',
                        'id': 'Shahan Malik',
                        'title': "Parkinson's Disease",
                        'body': "New Patient Added",
                      }
                    };

                    try {
                      var response = await http.post(
                        Uri.parse('https://fcm.googleapis.com/fcm/send'),
                        body: jsonEncode(data),
                        headers: {
                          'Content-Type': 'application/json; charset=UTF-8',
                          'Authorization': FCM_SERVER_KEY,
                        },
                      );
                      if (kDebugMode) {
                        print(response.body);
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  }

                  for (int i = 0; i < deviceToken.length; i++) {
                    print("inside this for loop");
                    await sendNotification(deviceToken[i].toString());
                  }

                  //................................................
                  //................................................
                  //................................................
                  setState(() {
                    musclesStiffnessValue = "No";
                    tremorsValue = "No";
                    slowMovementValue = "No";
                    balanceProblemValue = "No";
                    shufflingGaitValue = "No";
                    speechChangeValue = "No";
                    deviceToken.clear();
                    disease.clear();
                    answers = ["No", "No", "No", "No", "No", "No"];
                    isload = false;
                  });
                  //................................................
                  //................................................
                },
              ),
            ],
          )),
    );
  }
}


  // var musclesStiffnessValue = "No";
  // var tremorsValue = "No";
  // var slowMovementValue = "No";
  // var balanceProblemValue = "No";
  // var shufflingGaitValue = "No";
  // var speechChangeValue = "No";