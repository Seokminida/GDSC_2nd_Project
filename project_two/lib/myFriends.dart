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
  final _user = FirebaseFirestore.instance.collection('user').doc('${FirebaseAuth.instance.currentUser!.uid}');

  String userN = "";
  String userE = "";//
  String userA = "";

  void findfriend() async {
    var result = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: _filter.text)
        .get();

    result.docs.forEach((element) {
      userN = element['name'];
      userE = element['email'];//
      userA = element['address'];
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
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         showDialog(
        //             context: context,
        //             barrierDismissible: false,
        //             builder: (BuildContext context) {
        //               return AlertDialog(
        //                 title: Text('친구 추가'),
        //                 content: SingleChildScrollView(
        //                   child: Row(
        //                     children: <Widget>[
        //                       Container(
        //                         width: 250,
        //                         height: 50,
        //                         child: TextField(
        //                           focusNode: focusNode,
        //                           style: TextStyle(
        //                             fontSize: 18,
        //                           ),
        //                           autofocus: false,
        //                           controller: _filter,
        //                           decoration: InputDecoration(
        //                             hintText: '찾고 있는 친구 이메일',
        //                             labelStyle: TextStyle(
        //                                 color: Colors.white,
        //                                 letterSpacing: 2.0,
        //                                 fontSize: 20.0,
        //                                 fontWeight: FontWeight.bold),
        //                             filled: true,
        //                             fillColor: Colors.white,
        //                             prefixIcon: Icon(
        //                               Icons.mail,
        //                               color: Colors.blue[200],
        //                               size: 25,
        //                             ),
        //                           ),
        //                         ),
        //                       ),
        //                       IconButton(
        //                           icon: Icon(
        //                             Icons.search,
        //                             color: Colors.blue[200],
        //                             size: 30,
        //                           ),
        //                           onPressed: () {}),
        //                     ],
        //                   ),
        //                 ),
        //                 actions: <Widget>[
        //                   TextButton(
        //                     child: Text('추가'),
        //                     onPressed: () {
        //                       //친구 추가하기
        //                       Navigator.of(context).pop();
        //                     },
        //                   ),
        //                   TextButton(
        //                     child: Text('취소'),
        //                     onPressed: () {
        //                       Navigator.of(context).pop();
        //                     },
        //                   )
        //                 ],
        //               );
        //             });
        //       },
        //       icon: Icon(Icons.person_add))
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 364,
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
                          fontSize: 20.0,
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
                      findfriend();
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
                                    _user.update({'friends':FieldValue.arrayUnion([_filter.text])});
                                    Fluttertoast.showToast(msg: userN + '님이 추가되었습니다.');
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