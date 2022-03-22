import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_two/myPage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<String> getUser() async {
    final _user = FirebaseFirestore.instance
        .collection('user')
        .doc('${FirebaseAuth.instance.currentUser!.uid}');

    var _docSnapshot = await _user.get();
    _user.get().then((value) => {print(value.data())});
    ;
    return "userE";
  }

  @override
  Widget build(BuildContext context) {
    getUser();
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
        body: Scaffold(),
      ),
    );
  }
}
