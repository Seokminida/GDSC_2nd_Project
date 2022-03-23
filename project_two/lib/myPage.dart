import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_two/myRecord.dart';
import 'myPageCheck.dart';
import 'myFriends.dart';
import 'login.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List? _output;
  File? _image;

  String userE = "";
  String userN = "";

  Future<String> getUser() async {
    final _user = FirebaseFirestore.instance
        .collection('user')
        .doc('${FirebaseAuth.instance.currentUser!.uid}');
        // .collection('userinfo')
        // .doc('userinfo');

    var _docSnapshot = await _user.get();
    userE = _docSnapshot['email'];
    print(userE);
    userN = _docSnapshot['name'];
    print(userN);

    return userE;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
      future: getUser(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '내 정보',
              style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color.fromARGB(200, 50, 180, 150), // 앱바의 배경 색
            elevation: 0.0, // 앱바 입체감
          ),
          body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    InkWell(
                      child: Image(
                        image: AssetImage('images/루피.jpg'),
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.fill,
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            barrierDismissible: true, // 창 밖 선택시 창 닫기
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: AlertDialog(
                                  title: Text('프로필 이미지 설정',
                                      textAlign: TextAlign.center),
                                  actions: <Widget>[
                                    Divider(
                                      height: 0.0,
                                      color: Color.fromARGB(200, 50, 180, 150),
                                      thickness: 1.5,
                                      endIndent: 0.0,
                                    ),
                                    ListTile(
                                      title: Text('카메라',
                                          textAlign: TextAlign.center),
                                      onTap: () {
                                        getImage(ImageSource.camera);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    Divider(
                                      height: 0.0,
                                      color: Color.fromARGB(200, 50, 180, 150),
                                      thickness: 0.0,
                                      endIndent: 0.0,
                                    ),
                                    ListTile(
                                      title: Text('갤러리',
                                          textAlign: TextAlign.center),
                                      onTap: () {
                                        getImage(ImageSource.gallery);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    Divider(
                                      height: 0.0,
                                      color: Color.fromARGB(200, 50, 180, 150),
                                      thickness: 0.0,
                                      endIndent: 0.0,
                                    ),
                                    ListTile(
                                      title: Text('취소',
                                          textAlign: TextAlign.center),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyPageCheck()));
                              },
                              child: Text(userN + '님 >',
                                  style: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: 2.0,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                },
                                child: Text(
                                  '로그아웃',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 116, 111, 111),
                                    letterSpacing: 2.0,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          '  ' + userE,
                          style: TextStyle(
                            color: Color.fromARGB(255, 116, 111, 111),
                            letterSpacing: 2.0,
                            fontSize: 15.0, // 넘는거 어켕할거임
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: 60.0,
                  color: Color.fromARGB(200, 50, 180, 150),
                  thickness: 1.5,
                  endIndent: 5.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.replay,
                    color: Colors.black,
                  ),
                  title: Text(
                    '기록',
                    style: TextStyle(
                      letterSpacing: 2.0,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyRecord()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  title: Text(
                    '친구',
                    style: TextStyle(
                      letterSpacing: 2.0,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyFriends()));
                  },
                ),
              ],
            ),
          ),
        );
      },
    ));
  }

  Future getImage(ImageSource imageSource) async {
    XFile? ximage = await ImagePicker().pickImage(source: imageSource);
    File image = File(ximage!.path);
    if (image == null) return;
    setState(() {
      _image = image;
    });
  } // 프로필 이미지 설정 (카메라, 갤러리)
}
