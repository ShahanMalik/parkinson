import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parkinson/main_Activity.dart';

import 'package:parkinson/services/chat_servvices/screen/chat_screen.dart';
import 'package:parkinson/services/chat_servvices/widgets/message_text_field.dart';
import '../widgets/single_message.dart';

class HomeScreenChat extends StatefulWidget {
  const HomeScreenChat({Key? key});

  @override
  State<HomeScreenChat> createState() => _HomeScreenChatState();
}

class _HomeScreenChatState extends State<HomeScreenChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Chat Screen',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(
                radioValue.toString() == 'doctors' ? 'patients' : 'doctors')
            // .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final doctors = snapshot.data!.docs;
            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey[200],
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(255, 155, 153, 153),
                        backgroundImage: CachedNetworkImageProvider(
                            doctors[index]['profilePic']),
                      ),
                      title:
                          Text(doctors[index]['name'].toString().toUpperCase()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              singleDoctor: doctors[index],
                              // currentUserUid: FirebaseAuth.instance.currentUser!.uid,
                              // friendId: doctors[index]['uid'],
                              // friendName: doctors[index]['name'],
                              // friendImage: doctors[index]['profilePic'],
                            ),
                          ),
                        ).then((value) {
                          FirebaseFirestore.instance
                              .collection(radioValue.toString())
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            'online': 'offline',
                            'offlineTime': DateTime.now(),
                          });
                        });
                      },
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.amber,
            ));
          } else {
            return CircularProgressIndicator(
              color: Colors.amber,
            );
          }
        },
      ),
    );
  }
}
