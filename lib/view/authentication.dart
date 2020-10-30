import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/controller/authentiction_controller.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/utils/common_strings.dart';
import 'package:grow_lah/view/home_screen.dart';
import 'package:grow_lah/view/on_boarding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grow_lah/model/user_model.dart';

class AuthenticationScreen extends StatefulWidget {
  AuthenticationScreen({Key key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() {
    return _AuthenticationScreenState();
  }
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool signUpClicked = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseAuth _auth;
  bool isUserSignedIn = false;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        AppConfig.bgWave(context),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding:
                          EdgeInsets.only(left: 20.0, bottom: 10.0, top: 150.0),
                      child: Text(
                        (signUpClicked
                            ? CommonStrings.welcomeBack
                            : CommonStrings.hello),
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppConfig.roboto,
                            color: Colors.green),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
                      child: Text(
                        (signUpClicked
                            ? CommonStrings.login
                            : CommonStrings.signUp),
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppConfig.roboto,
                            color: Colors.green),
                      )),
                  !signUpClicked
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Neumorphic(
                            style: NeumorphicStyle(
                                depth: -8,
                                intensity: 0.86,
                                surfaceIntensity: 0.3,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.all(Radius.circular(10.0)))),
                            child: Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TextField(
                                controller: AuthenticationController
                                    .phonenumberTextController,
                                textAlign: TextAlign.start,
                                autofocus: true,
                                maxLength: null,
                                buildCounter: (BuildContext context,
                                        {int currentLength,
                                        int maxLength,
                                        bool isFocused}) =>
                                    null,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(10.0),
                                    hintText: "Phone number (+65...)",
                                    hintStyle: TextStyle(color: Colors.green),
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                          depth: -8,
                          intensity: 0.86,
                          surfaceIntensity: 0.3,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.all(Radius.circular(10.0)))),
                      child: Container(
                        height: 50.0,
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller:
                              AuthenticationController.emailTextController,
                          textAlign: TextAlign.start,
                          focusNode: _focusNode,
                          maxLength: null,
                          buildCounter: (BuildContext context,
                                  {int currentLength,
                                  int maxLength,
                                  bool isFocused}) =>
                              null,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: CommonStrings.emailId,
                              hintStyle: TextStyle(color: Colors.green),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: -8,
                        intensity: 0.86,
                        surfaceIntensity: 0.3,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.all(Radius.circular(10.0))),
                      ),
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.visiblePassword,
                          controller:
                              AuthenticationController.passwordController,
                          textAlign: TextAlign.start,
                          maxLength: null,
                          buildCounter: (BuildContext context,
                                  {int currentLength,
                                  int maxLength,
                                  bool isFocused}) =>
                              null,
                          decoration: InputDecoration(
                              hintText: CommonStrings.password,
                              hintStyle: TextStyle(color: Colors.green),
                              contentPadding: EdgeInsets.all(10.0),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Neumorphic(
                        style: NeumorphicStyle(
                          depth: 10,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.all(Radius.circular(25.0))),
                        ),
                        child: InkWell(
                          onTap: () {
                            AppConfig.hideKeyBoard();
                            if (signUpClicked && checkEmailAndPassword()) {
                              authenticate();
                            }
                            if (!signUpClicked) {
                              if (AuthenticationController
                                          .phonenumberTextController.text ==
                                      null ||
                                  AuthenticationController
                                          .phonenumberTextController.text
                                          .trim() ==
                                      '') {
                                return AppConfig.showToast(
                                    CommonStrings.enterUserName);
                              }
                              checkEmailAndPassword();
                              var input = AuthenticationController
                                  .phonenumberTextController.text
                                  .trim();
                              bool edit = input.startsWith("+65");
                              final phone = edit ? input : ("+65" + input);
                              print("Edited Phone no " + phone);
                              final email = AuthenticationController
                                  .emailTextController.text
                                  .trim();
                              final password = AuthenticationController
                                  .passwordController.text
                                  .trim();
                              loginUser(phone, context, email, password);
                            }
                          },
                          child: Container(
                            color: Colors.green,
                            height: 50.0,
                            width: 100.0,
                            child: Center(
                              child: Text(
                                (signUpClicked
                                    ? CommonStrings.login
                                    : CommonStrings.signUp),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              signUpClicked
                                  ? "Don't have an Account yet? "
                                  : CommonStrings.alreadyHaveAcc,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontFamily: AppConfig.roboto,
                                  fontSize: 16.0),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(_focusNode);
                                  signUpClicked = !signUpClicked;
                                });
                              },
                              child: Text(
                                signUpClicked
                                    ? "Sign up"
                                    : CommonStrings.login1,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: AppConfig.roboto,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  final _codeController = TextEditingController();

  Future<bool> loginUser(
      String phone, BuildContext context, String email, String password) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    print("loginuser" + phone);
    var completer = Completer<bool>();

    _auth
        .verifyPhoneNumber(
            phoneNumber: phone,
            timeout: Duration(seconds: 60),
            verificationCompleted: (AuthCredential credential) async {
              print("Complete" + password);
              completer.complete(true);
              Navigator.of(context).pop();

              //UserCredential result =
              //await _auth.signInWithCredential(credential);

              //User user = result.user;
              User user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                AuthCredential credential = EmailAuthProvider.credential(
                    email: email, password: password.toString());
                FirebaseAuth.instance.currentUser
                    .linkWithCredential(credential)
                    .whenComplete(() {
                  print("Email linked");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                }).catchError((error) {
                  print("Unable to link email" + error);
                });
              } else {
                print("Error");
              }

              //This callback would gets called when verification is done auto maticlly
            },
            verificationFailed: (FirebaseAuthException exception) {
              print(exception);
            },
            codeSent: (String verificationId, [int forceResendingToken]) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Verification Code"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            controller: _codeController,
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Confirm"),
                          textColor: Colors.white,
                          color: Colors.green,
                          onPressed: () async {
                            final code = _codeController.text.trim();
                            AuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: code);

                            completer.complete(true);

                            print("UserPass" + email + password);
                            AuthCredential emailcredential =
                                EmailAuthProvider.credential(
                                    email: email,
                                    password: password.toString());
                            UserCredential result =
                                await _auth.createUserWithEmailAndPassword(
                                    email: email,
                                    password: password.toString());

                            User user = FirebaseAuth.instance.currentUser;

                            if (user != null) {
                              user
                                  .linkWithCredential(credential)
                                  .whenComplete(() {
                                print("Email linked");
                                CollectionReference users = FirebaseFirestore
                                    .instance
                                    .collection('Users');
                                users.add(usermodel(user.uid, "", email, phone)
                                    .toJson());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OnBoardingScreen()));
                              }).catchError((error) {
                                print("Unable to link email" + error);
                              });
                            } else {
                              print("Error");
                            }
                          },
                        )
                      ],
                    );
                  });
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              verificationId = verificationId;
              print(verificationId);
              print("Timout");
            })
        .then((value) {
      print("DOne");
    }).whenComplete(() {
      print("Done");
    });
    return completer.future;
  }

  swichToLogin() {
    setState(() {
      AuthenticationController.phonenumberTextController.clear();
      AuthenticationController.emailTextController.clear();
      AuthenticationController.passwordController.clear();
      FocusScope.of(context).requestFocus(_focusNode);
      signUpClicked = true;
    });
  }

  bool checkEmailAndPassword() {
    if (AuthenticationController.emailTextController.text == null ||
        AuthenticationController.emailTextController.text.trim() == '') {
      AppConfig.showToast(CommonStrings.enterEmail);
      return false;
    } else if (AuthenticationController.passwordController.text == null ||
        AuthenticationController.passwordController.text.trim() == '') {
      AppConfig.showToast(CommonStrings.enterPassword);
      return false;
    } else
      return true;
  }

  void authenticate() async {
    print("Authenticating User");
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: AuthenticationController.emailTextController.text
                  .trim()
                  .toLowerCase(),
              password: AuthenticationController.passwordController.text.trim())
          .whenComplete(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    } on PlatformException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        AppConfig.showToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        AppConfig.showToast('Wrong password provided for that user.');
      } else {
        AppConfig.showToast(e.message);
        print(e.message);
      }
    }
  }
}
