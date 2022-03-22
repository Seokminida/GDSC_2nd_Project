import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_two/myPage.dart';

import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userE = "";
  String userN = "";
  String userP = "";

  Future<String> getUser() async {
    final _user = FirebaseFirestore.instance
        .collection('user')
        .doc('${FirebaseAuth.instance.currentUser!.uid}');

    var _docSnapshot = await _user.get();

    userE = "로그인이 완료되었습니다.";

    _user.get().then((value) => {print(value.data())});
    userP = _docSnapshot['email'];
    print(userP);

    return userE;
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    print(userE);
    //뒤로가기 방지를 위한 위젯
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            //로그아웃 버튼
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyPage()));
                },
                icon: Icon(Icons.person))
          ],
        ),
        body: FutureBuilder(
          future: getUser(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 300,
                    ),
                    Text(userE),
                    Text(userN),
                    Text(userP),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 15),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}