import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_two/myPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login.dart';

class MyPageChange extends StatefulWidget {
  const MyPageChange({Key? key}) : super(key: key);

  @override
  State<MyPageChange> createState() => _MyPageChangeState();
}

class _MyPageChangeState extends State<MyPageChange> {
  final _auth = FirebaseAuth.instance;
  final _user = FirebaseFirestore.instance
        .collection('user')
        .doc('${FirebaseAuth.instance.currentUser!.uid}');
  var nowUser = FirebaseAuth.instance.currentUser;

  void deleteUser() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      _user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  void updateUser() {
    if (nameController.text != "") {
      _user.update({'name': nameController.text});
    }
    if (addressController.text != "") {
      _user.update({'address': addressController.text});
    }
  }

  void updatePassword() {
    if (password1Controller.text != "" && password2Controller.text != "") {
      final cred = EmailAuthProvider.credential(
          email: userE, password: passwordController.text);

      nowUser!.reauthenticateWithCredential(cred).then((value) {
        nowUser!
            .updatePassword(password1Controller.text)
            .then((_) {})
            .catchError((error) {});
      }).catchError((err) {});
    }
  }

  String userE = "";
  String userN = "";
  String userA = "";

  Future<String> getUser() async {
    var _docSnapshot = await _user.get();
    userE = _docSnapshot['email'];
    print(userE);
    userN = _docSnapshot['name'];
    print(userN);
    userA = _docSnapshot['address'];
    print(userA);

    return userE;
  }

  final nameController = new TextEditingController();
  final passwordController = new TextEditingController();
  final password1Controller = new TextEditingController();
  final password2Controller = new TextEditingController();
  final addressController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: getUser(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
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
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '회원정보관리',
                            style: TextStyle(
                              color: Color.fromARGB(255, 116, 111, 111),
                              letterSpacing: 2.0,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            child: TextFormField(
                              autofocus:
                                  false,
                              controller: nameController,
                              obscureText: false,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r'[a-zA-Z0-9]').hasMatch(value)) {
                                  return ("사용할 수 없는 이름입니다.");
                                }
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: userN,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            child: TextFormField(
                              autofocus:
                                  false,
                              controller: addressController,
                              obscureText: false,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    value.length != 11 ||
                                    !RegExp(r'[0-9]').hasMatch(value)) {
                                  return ("잘못된 번호 형식입니다.");
                                }
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.house),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: userA,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue[200],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                minimumSize: Size(500, 50)),
                            onPressed: () {
                              if (nameController.text == "" &&
                                  addressController.text == "") {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false, // 창 밖 선택시 창 닫기
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('회원정보관리'),
                                        content: SingleChildScrollView(
                                          child: Text('회원정보를 입력해주세요.'),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('확인'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              } else {
                                updateUser();
                                showDialog(
                                    context: context,
                                    barrierDismissible: false, // 창 밖 선택시 창 닫기
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('회원정보관리'),
                                        content: SingleChildScrollView(
                                          child: Text('회원정보가 수정되었습니다.'),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('확인'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              }
                            },
                            child: Text('수정',
                                style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 2.0,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            '비밀번호변경',
                            style: TextStyle(
                              color: Color.fromARGB(255, 116, 111, 111),
                              letterSpacing: 2.0,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.mail),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 15, 20, 15),
                                    hintText: userE,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            child: TextFormField(
                              autofocus:
                                  false,
                              controller: passwordController,
                              obscureText: true,
                              validator: (value) {
                                RegExp regex = new RegExp(r'^.{6,}$');
                                if (!regex.hasMatch(value!)) {
                                  return ("최소 6자리 이상의 비밀번호가 필요합니다.");
                                }
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.vpn_key),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: "현재 비밀번호",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            child: TextFormField(
                              autofocus:
                                  false,
                              controller: password1Controller,
                              obscureText: true,
                              validator: (value) {
                                RegExp regex = new RegExp(r'^.{6,}$');
                                if (!regex.hasMatch(value!)) {
                                  return ("최소 6자리 이상의 비밀번호가 필요합니다.");
                                }
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.vpn_key),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: "새 비밀번호",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            child: TextFormField(
                              autofocus:
                                  false,
                              controller: password2Controller,
                              obscureText: true,
                              validator: (value) {
                                RegExp regex = new RegExp(r'^.{6,}$');
                                if (!regex.hasMatch(value!)) {
                                  return ("최소 6자리 이상의 비밀번호가 필요합니다.");
                                }
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.vpn_key),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: "새 비밀번호 확인",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue[200],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                minimumSize: Size(500, 50)),
                            onPressed: () async {
                              if (passwordController.text != "") {
                                try {
                                  UserCredential userCredential =
                                      await _auth.signInWithEmailAndPassword(
                                    email: userE,
                                    password: passwordController.text,
                                  );
                                  if (password1Controller.text == "" ||
                                      password2Controller.text == "") {
                                    showDialog(
                                        context: context,
                                        barrierDismissible:
                                            false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('비밀번호변경'),
                                            content: SingleChildScrollView(
                                              child: Text('새 비밀번호를 입력해주세요.'),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('확인'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  } else if (password1Controller.text !=
                                      password2Controller.text) {
                                    showDialog(
                                        context: context,
                                        barrierDismissible:
                                            false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('비밀번호변경'),
                                            content: SingleChildScrollView(
                                              child: Text('새 비밀번호가 일치하지 않습니다.'),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('확인'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  } else {
                                    updatePassword();
                                    showDialog(
                                        context: context,
                                        barrierDismissible:
                                            false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('비밀번호변경'),
                                            content: SingleChildScrollView(
                                              child: Text('비밀번호가 변경되었습니다.'),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('확인'),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyPage()));
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  }
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'wrong-password') {
                                    showDialog(
                                        context: context,
                                        barrierDismissible:
                                            false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('비밀번호변경'),
                                            content: SingleChildScrollView(
                                              child:
                                                  Text('현재 비밀번호가 일치하지 않습니다.'),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('확인'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  }
                                }
                              } else {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('비밀번호변경'),
                                        content: SingleChildScrollView(
                                          child: Text('현재 비밀번호를 입력해주세요.'),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('확인'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              }
                            },
                            child: Text('변경',
                                style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 2.0,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Divider(
                            height: 20.0,
                            color: Colors.blue[200],
                            thickness: 1.5,
                            endIndent: 1.0,
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('회원탈퇴'),
                                        content: SingleChildScrollView(
                                          child: Text('회원을 탈퇴하시겠습니까?'),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('탈퇴'),
                                            onPressed: () {
                                              deleteUser();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Login()));
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
                              child: Text('회원탈퇴',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 116, 111, 111),
                                    letterSpacing: 2.0,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            }));
  }
}
