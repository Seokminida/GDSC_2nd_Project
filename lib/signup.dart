import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        registerDetails();
        Fluttertoast.showToast(msg: '계정 생성이 완료되었습니다.');
        Navigator.pop(context);
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  void registerDetails() {
    final CollectionReference _user =
        FirebaseFirestore.instance.collection('user');

    _user
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .set({
      'email': emailController.text,
      'name': nameController.text,
      'address': addressController.text
    });
    //firestore database에 현재 등록 유저의 정보 올리기
    //<Users 컬렉션 -> 현재 유저의 uid 도큐먼트>에 유저 데이터 추가
    //컬렉션에 도큐먼트를 추가할 때는 add를 사용하였지만
    //도큐먼트에 데이터를 추가할 때는 set을 사용한다.
    //set 안에는 Map형식의 값을 넣어줘야 한다.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      //키보드가 올라오면 하단에 오버플로우가 발생하므로
      //SingleChildScrollView로 감싸준다.
      child: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(25, 75, 25, 0),
                    child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                            return ("잘못된 이메일 형식입니다.");
                          }
                        },
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(25, 40, 25, 0),
                    child: TextFormField(
                      controller: pwController,
                      obscureText: true,
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{6,}$');
                        if (!regex.hasMatch(value!)) {
                          return ("최소 6자리 이상의 비밀번호가 필요합니다.");
                        }
                      },
                      onSaved: (value) {
                        pwController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.vpn_key),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "PassWord",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(25, 40, 25, 0),
                    child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'[a-zA-Z0-9]').hasMatch(value)) {
                            return ("사용할 수 없는 이름입니다.");
                          }
                        },
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(25, 40, 25, 0),
                    child: TextFormField(
                        controller: addressController,
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                        textInputAction: TextInputAction.next, //엔터 치면 다음으로 넘어감
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.home),
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Address",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))),
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 40),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                    onPressed: () {
                      signUp(emailController.text, pwController.text);
                    },
                    child: Text('가입하기')))
          ],
        ),
      ),
    ));
  }
}