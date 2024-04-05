import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:parkinson/theme/theme_helper.dart';

class PatientDetailScreen extends StatefulWidget {
  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Details"),
        elevation: 0,
        leading: Icon(Icons.emergency_rounded),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('patients')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Data is available
                    final doctors = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = doctors[index];

                        return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.teal.shade50,
                                border: Border.all(
                                    color: appTheme.teal300, width: 0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        child: CachedNetworkImage(
                                          imageUrl: doctor['profilePic'],
                                          placeholder: (context, url) =>
                                              Container(
                                            height: 80,
                                            width: 80,
                                            child: LinearProgressIndicator(
                                              color: Colors.grey.shade200,
                                              backgroundColor:
                                                  Colors.grey.shade100,
                                            ),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(
                                            doctor['name'],
                                            style: TextStyle(
                                              color: appTheme.teal300,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 19,
                                            ),
                                          ),
                                          Text(
                                            doctor['disease'].join(', '),
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 44, 44, 44),
                                              fontWeight: FontWeight.w100,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },
                    );
                  } else if (snapshot.hasError) {
                    // Error occurred while fetching data
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    // Data is still loading
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
