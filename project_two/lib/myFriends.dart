import 'package:cloud_firestore/cloud_firestore.dart'; //
import 'package:firebase_auth/firebase_auth.dart'; //
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class MyFriends extends StatefulWidget {
  const MyFriends({Key? key}) : super(key: key);

  @override
  State<MyFriends> createState() => _MyFriendsState();
}

class _MyFriendsState extends State<MyFriends> {
  String nowE = "";
  Future<String> getUser() async {
    final _user = FirebaseFirestore.instance
        .collection('user')
        .doc('${FirebaseAuth.instance.currentUser!.uid}');
        // .collection('userinfo')
        // .doc('userinfo');

    var _docSnapshot = await _user.get();
    nowE = _docSnapshot['email'];

    return userE;
  }
  final _friend = FirebaseFirestore.instance
      .collection('user');
    

  final _user = FirebaseFirestore.instance
      .collection('user')
      .doc('${FirebaseAuth.instance.currentUser!.uid}');

  String userN = "";
  String userE = "";
  String userA = "";
  late List<String> userF;//

  void findfriend(String wonder) async {
    var result = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: wonder)
        .get();

    result.docs.forEach((element) {
      userN = element['name'];
      userE = element['email'];
      userA = element['address'];
      userF = List.from(element['friends']);//
    });
  }
  //
  String userNN = "";
  String userEE = "";
  String userAA = "";
  void friendinfo(String wonder) async {
    var result = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: wonder)
        .get();

    result.docs.forEach((element) {
      userNN = element['name'];
      userEE = element['email'];
      userAA = element['address'];
    });
  }

  TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '친구 관리',
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 2.0,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(200, 50, 180, 150), // 앱바의 배경색
        elevation: 0.0, //떠서 보이는 그임자
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 343,
                  height: 50,
                  child: TextField(
                    focusNode: focusNode,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    autofocus: false,
                    controller: _filter,
                    decoration: InputDecoration(
                      hintText: '찾고 있는 친구 이메일',
                      labelStyle: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2.0,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.mail,
                        color: Color.fromARGB(200, 50, 180, 150),
                        size: 25,
                      ),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Color.fromARGB(200, 50, 180, 150),
                      size: 30,
                    ),
                    onPressed: () async {
                      findfriend(_filter.text);
                      if (userE != "") {
                        showDialog(
                            context: context,
                            barrierDismissible: false, // 창 밖 선택시 창 닫기
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('친구 추가'),
                                content: SingleChildScrollView(
                                  child: Text(userN + "님을 추가하시겠습니까?"),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('추가'),
                                    onPressed: () {
                                      _user.update({
                                        'friends': FieldValue.arrayUnion(
                                            [_filter.text])
                                      });
                                      Fluttertoast.showToast(
                                          msg: userN + '님이 추가되었습니다.');
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
                        userE = "";
                      } else {
                        Fluttertoast.showToast(msg: '해당 이메일이 검색되지 않습니다.');
                      }
                    })
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
              stream: _friend.snapshots(),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  getUser();
                  findfriend(nowE);//현재 나의 아이디
                  return ListView.builder(
                    itemCount: userF.length,//
                    itemBuilder: (context, index) {
                      //final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index]; //
                      friendinfo(userF[index]);//
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text(userNN +
                              "님 " +
                              userEE), //
                          subtitle: Text(userAA), //
                          trailing: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('삭제'),
                                        content: SingleChildScrollView(
                                          child: Text('친구를 삭제하시겠습니까?'),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('삭제'),
                                            onPressed: () {
                                              _user.update({
                                        'friends': FieldValue.delete()
                                      });
                                              //deleteUser();
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
                              icon: Icon(Icons.delete)),
                        ),
                      );
                      //  } return Card();//
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),),
          ],
        ),
      ),
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: _user.snapshots(),
      //   builder: (context, streamSnapshot) {
      //     if (streamSnapshot.hasData) {
      //       return ListView.builder(
      //         itemCount: streamSnapshot.data!.docs.length, //
      //         itemBuilder: (context, index) {
      //           final DocumentSnapshot documentSnapshot =
      //               streamSnapshot.data!.docs[index]; //
      //           return Card(
      //             margin: const EdgeInsets.all(10),
      //             child: ListTile(
      //               leading: Icon(Icons.person),
      //               title: Text(documentSnapshot['name'] +
      //                   "님 " +
      //                   documentSnapshot['email']), //
      //               subtitle: Text(documentSnapshot['address']), //
      //               trailing: IconButton(
      //                   onPressed: () {
      //                     showDialog(
      //                         context: context,
      //                         barrierDismissible: false,
      //                         builder: (BuildContext context) {
      //                           return AlertDialog(
      //                             title: Text('삭제'),
      //                             content: SingleChildScrollView(
      //                               child: Text('친구를 삭제하시겠습니까?'),
      //                             ),
      //                             actions: <Widget>[
      //                               TextButton(
      //                                 child: Text('삭제'),
      //                                 onPressed: () {
      //                                   //deleteUser();
      //                                   Navigator.of(context).pop();
      //                                 },
      //                               ),
      //                               TextButton(
      //                                 child: Text('취소'),
      //                                 onPressed: () {
      //                                   Navigator.of(context).pop();
      //                                 },
      //                               )
      //                             ],
      //                           );
      //                         });
      //                   },
      //                   icon: Icon(Icons.delete)),
      //             ),
      //           );
      //         },
      //       );
      //     }
      //     return const Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   },
      // ),
    );
  }
}
