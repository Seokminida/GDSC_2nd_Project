import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyRecord extends StatefulWidget {
  const MyRecord({Key? key}) : super(key: key);

  @override
  State<MyRecord> createState() => _MyRecordState();
}

class _MyRecordState extends State<MyRecord> {
  final _user = FirebaseFirestore.instance
      .collection('user')
      .doc('${FirebaseAuth.instance.currentUser!.uid}')
      .collection('route');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내 기록',
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 2.0,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(200, 50, 180, 150), // 앱바의 배경 색
        elevation: 0.0, //떠서 보이는 그임자
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _user.snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                      leading: Icon(Icons.zoom_in),
                      title: Text(documentSnapshot['place']),
                      subtitle: Text('위도: ' +
                          documentSnapshot['lat'] +
                          ', 경도: ' +
                          documentSnapshot['lng']),
                      trailing: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('삭제'),
                                    content: SingleChildScrollView(
                                      child: Text('해당 기록을 삭제하시겠습니까?'),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('삭제'),
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('user')
                                              .doc(
                                                  '${FirebaseAuth.instance.currentUser!.uid}')
                                              .collection('route')
                                              .doc(documentSnapshot.id)
                                              .delete();
                                          //기록 삭제
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('취소'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                          icon: Icon(Icons.delete))),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
