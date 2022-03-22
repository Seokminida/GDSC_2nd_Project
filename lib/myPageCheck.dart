import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'myPageChange.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyPageCheck extends StatefulWidget {
  const MyPageCheck({Key? key}) : super(key: key);

  @override
  State<MyPageCheck> createState() => _MyPageCheckState();
}

class _MyPageCheckState extends State<MyPageCheck> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyPageChange()));
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  String userE = "";

  Future<String> getUser() async {
    final _user = FirebaseFirestore.instance
        .collection('user')
        .doc('${FirebaseAuth.instance.currentUser!.uid}');

    var _docSnapshot = await _user.get();
    userE = _docSnapshot['email'];
    print(userE);

    return userE;
  }

  final pwController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
      future: getUser(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '내 정보 수정',
            style: TextStyle(
                color: Colors.white,
                letterSpacing: 2.0,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue[200], // 앱바의 배경 색
          elevation: 0.0, //떠서 보이는 그임자
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '회원정보확인',
                  style: TextStyle(
                    color: Color.fromARGB(255, 116, 111, 111),
                    letterSpacing: 2.0,
                    fontSize: 15.0, // 넘는거 어켕할거임
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),

                ///*
                Container(
                  child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: userE,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)))),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  //비밀번호 체크하는 사항 추가
                  child: TextFormField(
                    autofocus: false, //자동으로 텍스트 필드가 선택되는 것을 막는다. 기본값이 false이다.
                    controller: pwController,
                    obscureText: true, //비밀번호가 ....으로 표시되도록 한다
                    validator: (value) {
                      RegExp regex = new RegExp(r'^.{6,}$');
                      if (!regex.hasMatch(value!)) {
                        return ("최소 6자리 이상의 비밀번호가 필요합니다.");
                      }
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "비밀번호",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Divider(
                  height: 35.0,
                  color: Colors.blue[200],
                  thickness: 1.0,
                  endIndent: 5.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue[200],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: Size(500, 50)),
                  onPressed: () {
                    signIn(userE, pwController.text);
                  },
                  child: Text('확인',
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2.0,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ));
      }));
  }
}
