import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkinson/core/app_export.dart';
import 'package:parkinson/main_Activity.dart';
import 'package:parkinson/presentation/doctors/doctor_screen/doctor_screen.dart';
import 'package:parkinson/services/chat_servvices/widgets/message_text_field.dart';
import '../widgets/single_message.dart';

// DateTime? onlineTime;
// DateTime? offlineTime;
String? online = 'offline';

class ChatScreen extends StatefulWidget {
  var singleDoctor;

  ChatScreen({
    super.key,
    required this.singleDoctor,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVisibility();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        print('inactive');
        FirebaseFirestore.instance
            .collection(radioValue.toString())
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'online': 'offline',
          'offlineTime': DateTime.now(),
        });
        break;
      case AppLifecycleState.resumed:
        print('resumed');
        FirebaseFirestore.instance
            .collection(radioValue.toString())
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'online': 'online',
          'offlineTime': DateTime.now(),
        });
        break;
      case AppLifecycleState.paused:
        print('paused');
        FirebaseFirestore.instance
            .collection(radioValue.toString())
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'online': 'offline',
          'offlineTime': DateTime.now(),
        });
        break;
      case AppLifecycleState.detached:
        print('detached');
        FirebaseFirestore.instance
            .collection(radioValue.toString())
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'online': 'offline',
          'offlineTime': DateTime.now(),
        });
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  void setVisibility() async {
    print('visibility');
    var userDoc = FirebaseFirestore.instance
        .collection(radioValue.toString())
        .doc(FirebaseAuth.instance.currentUser!.uid);

    await userDoc.update({
      'online': 'online',
      'onlineTime': DateTime.now(),
    });

    // var receiver = FirebaseFirestore.instance
    //     .collection(radioValue.toString() == 'doctors' ? 'patients' : 'doctors')
    //     .doc(widget.singleDoctor['uid']);

    // var snapshot = await receiver.get();
    // online = snapshot['online'];
    // // onlineTime = snapshot['onlineTime'] as DateTime;
    // offlineTime = snapshot['offlineTime'] as DateTime;
    // print(online);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        leading: InkWell(
          highlightColor: Color.fromARGB(255, 32, 160, 132),
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              CircleAvatar(
                radius: 17,
                backgroundImage: CachedNetworkImageProvider(
                    widget.singleDoctor['profilePic']),
              ),
            ],
          ),
        ),
        backgroundColor: PrimaryColors().teal300,
        // backgroundColor: Color.fromARGB(255, 17, 115, 94),
        title: InkWell(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  DoctorScreen(
                singleDoctor: widget.singleDoctor,
              ),
              transitionDuration: Duration(
                  seconds: 1), // Adjust transition duration as per your need
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = Offset(1.0, 0.0);
                var end = Offset.zero;
                var curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.singleDoctor['name'],
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              // Text(
              //   online.toString(),
              //   style: TextStyle(
              //     fontSize: 9,
              //     color: Colors.white,
              //     fontWeight: FontWeight.w300,
              //   ),
              // ),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(radioValue.toString() == 'doctors'
                        ? 'patients'
                        : 'doctors')
                    .doc(widget.singleDoctor['uid'])
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return SizedBox.shrink();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox.shrink();
                  }

                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  online = data['online'];
                  return Text(
                    data['online'].toString(),
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.video_camera_solid,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {},
            itemBuilder: (BuildContext context) {
              return {'Profile', 'Settings', 'Sign out'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(radioValue.toString())
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('messages')
                    .doc(widget.singleDoctor['uid'])
                    .collection('chats')
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return const Center(
                        child: Text("Say Hi"),
                      );
                    }

                    return ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var a = DateTime.parse(snapshot
                              .data.docs[index]['date']
                              .toDate()
                              .toString());
                          var time = DateFormat(' hh:mm a').format(a);
                          bool isMe = snapshot.data.docs[index]['senderId'] ==
                              FirebaseAuth.instance.currentUser!.uid;
                          return SingleMessage(
                              imageUrl: snapshot.data.docs[index]['sendPic'],
                              type: snapshot.data.docs[index]['type'],
                              message: snapshot.data.docs[index]['message'],
                              isMe: isMe,
                              time: time);
                        });
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          )),
          MessageTextField(FirebaseAuth.instance.currentUser!.uid,
              widget.singleDoctor['uid']),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color.fromARGB(255, 168, 172, 172),
        ),
        margin: const EdgeInsets.only(bottom: 48, left: 2),
        child: InkWell(
          onTap: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController
                      .position.minScrollExtent, // Change this line
                  duration: Duration(seconds: 2),
                  curve: Curves.fastOutSlowIn,
                );
              }
            });
          },
          child: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
      ),
    );
  }
}
