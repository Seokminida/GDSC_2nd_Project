import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_two/signup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'mapScreen.dart'; //
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_two/signup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final emailController = new TextEditingController();
  final pwController = new TextEditingController();

  final googleSign = GoogleSignIn();

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MapSample())); //
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //WillPopScope는 페이지 뒤로가기를 방지한다
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Form위젯으로 텍스트 컨트롤러들을 감싸서
            //컨트롤러들을 한번에 관리할 수 있도록 한다.
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/images/map3.png',
                        height: 200,
                        width: 400,
                      ),
                    ),
                    //이메일 텍스트필드
                    Container(
                      margin: EdgeInsets.fromLTRB(25, 75, 25, 0),
                      child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            //이메일 입력 형식
                            if (value!.isEmpty ||
                                !RegExp(r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                              return ("잘못된 이메일 형식입니다.");
                            }
                          },
                          textInputAction:
                              TextInputAction.next, //엔터 치면 다음 위젯으로 이동
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: "Email",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                    ),
                    SizedBox(height: 40),
                    //비밀번호 텍스트필드
                    Container(
                      margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextFormField(
                        autofocus:
                            false, //자동으로 텍스트 필드가 선택되는 것을 막는다. 기본값이 false이다.
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
                            hintText: "PassWord",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    )
                  ],
                )),
            //회원가입 페이지 이동 버튼
            Container(
              margin: EdgeInsets.only(top: 40),
              child: TextButton(
                child: Text('회원가입'),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => SignUp()));
                },
              ),
            ),
            //로그인 버튼
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  signIn(emailController.text, pwController.text);
                },
                child: Icon(Icons.forward),
                style: ElevatedButton.styleFrom(primary: Colors.grey),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: googleSignIn,
                child: Text('SignIn with Google'),
                style: ElevatedButton.styleFrom(primary: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void googleSignIn() async {
    final googleSign = GoogleSignIn();
    final googleUser = await googleSign.signIn(); //구글 계정 로그인 다이얼로그가 뜸
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MapSample()));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
