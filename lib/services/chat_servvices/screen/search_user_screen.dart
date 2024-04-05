// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:parkinson/services/chat_servvices/model/user_model.dart';

// import 'chat_screen.dart';

// class MainScreen extends StatefulWidget {
//   UserModel user;
//   MainScreen(this.user, {super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   String name = "";
//   List<Map> searchResult = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             title: Card(
//           child: TextField(
//             decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.search), hintText: 'Search...'),
//             onChanged: (val) {
//               setState(() {
//                 name = val;
//               });
//             },
//           ),
//         )),
//         body: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('user')
//               .where('name', isNotEqualTo: widget.user.name)
//               .snapshots(),
//           builder: (context, snapshots) {
//             return (snapshots.connectionState == ConnectionState.waiting)
//                 ? Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : ListView.builder(
//                     itemCount: snapshots.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       var data = snapshots.data!.docs[index].data()
//                           as Map<String, dynamic>;

//                       if (name.isEmpty) {
//                         return ListTile(
//                           title: Text(
//                             data['name'],
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                                 color: Colors.black54,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           leading: CircleAvatar(
//                             backgroundImage: NetworkImage(data['image']),
//                           ),
//                           trailing: IconButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => ChatScreen(
//                                             currentUserUid: FirebaseAuth
//                                                 .instance.currentUser!.uid,
//                                             friendId: data['uid'],
//                                             friendName: data['name'],
//                                             friendImage: data['image'])));
//                               },
//                               icon: const Icon(Icons.message)),
//                         );
//                       }
//                       if (data['name']
//                           .toString()
//                           .toLowerCase()
//                           .startsWith(name.toLowerCase())) {
//                         return ListTile(
//                           title: Text(
//                             data['name'],
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                                 color: Colors.black54,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           leading: CircleAvatar(
//                             backgroundImage: NetworkImage(data['image']),
//                           ),
//                           trailing: IconButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => ChatScreen(
//                                             currentUserUid: FirebaseAuth
//                                                 .instance.currentUser!.uid,
//                                             friendId: data[index]['uid'],
//                                             friendName: data[index]['name'],
//                                             friendImage: data[index]
//                                                 ['image'])));
//                               },
//                               icon: const Icon(Icons.message)),
//                         );
//                       }
//                       return Container();
//                     });
//           },
//         ));
//   }
// }
