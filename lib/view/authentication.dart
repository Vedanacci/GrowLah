import 'dart:async';
import 'dart:io' show Platform;
import 'dart:io';
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
import 'package:grow_lah/view/introduction.dart';
import 'package:grow_lah/view/on_boarding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grow_lah/model/user_model.dart';
import 'package:sms_autofill/sms_autofill.dart';

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
  bool isUserSignedIn = false;
  FocusNode _focusNode = FocusNode();
  final SmsAutoFill _autoFill = SmsAutoFill();
  int resendToken;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    if (Platform.isAndroid) {
      getCurrentNumber();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getCurrentNumber() async {
    String number = await _autoFill.hint;
    AuthenticationController.phonenumberTextController.text = number;
  }

  void hideKeyBoard() {
    AppConfig.hideKeyBoard();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () => hideKeyBoard(),
      child: Container(
          child: Stack(children: <Widget>[
        AppConfig.bgWave(context),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, bottom: 10.0, top: 120.0),
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
                              autofocus: false,
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
                        obscureText: true,
                        autocorrect: false,
                        controller: AuthenticationController.passwordController,
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
                        onTap: () async {
                          hideKeyBoard();
                          try {
                            final result =
                                await InternetAddress.lookup('google.com');
                            if (result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {
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
                                if (password.length > 6) {
                                  if (RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(email)) {
                                    firebaseAuth
                                        .fetchSignInMethodsForEmail(email)
                                        .catchError((error) {
                                      AppConfig.showToast(
                                          "Email Already in Use");
                                    }).then((value) {
                                      print(value);
                                      if (value.isNotEmpty) {
                                        AppConfig.showToast(
                                            "Email Already in Use");
                                        swichToLogin();
                                      } else {
                                        loginUser(
                                            phone, context, email, password);
                                      }
                                    });
                                  } else {
                                    AppConfig.showToast(
                                        "Invalid Email Address");
                                  }
                                } else {
                                  AppConfig.showToast(
                                      "Password needs to be greater than 6 characters");
                                }
                              }
                            }
                          } on SocketException catch (_) {
                            print('not connected');
                            AppConfig.showToast(
                                "This App requires the Internet");
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
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            signUpClicked
                                ? "Don't have an Account yet? "
                                : "Already have an account? ",
                            style: TextStyle(
                                color: Colors.green,
                                fontFamily: AppConfig.roboto,
                                fontSize: 16.0),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                FocusScope.of(context).requestFocus(_focusNode);
                                signUpClicked = !signUpClicked;
                              });
                            },
                            child: Text(
                              signUpClicked ? "Sign up" : CommonStrings.login1,
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
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: Text(
                        "Continue as Guest",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: AppConfig.roboto,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ])),
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
              addCrediantials(completer, email, password);

              //This callback would gets called when verification is done auto maticlly
            },
            verificationFailed: (FirebaseAuthException exception) {
              print(exception);
              AppConfig.showToast("Error, Please try again");
            },
            codeSent: (String verificationId, [int forceResendingToken]) async {
              print("UserPass" + email + password);
              await _auth
                  .createUserWithEmailAndPassword(
                      email: email, password: password.toString())
                  .catchError((e) {
                print(e.code);
                AppConfig.showToast("Email Already exists");
              }).then((value) {
                codeSent(email, password, verificationId, completer, phone,
                    _auth, forceResendingToken);
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

  void addCrediantials(Completer completer, String email, String password) {
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
          .whenComplete(() async {
        print("Email linked");
        UserCredential result =
            await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }).catchError((error) {
        print("Unable to link email" + error);
      });
    } else {
      print("Error");
    }
  }

  void codeSent(
      String email,
      String password,
      String verificationId,
      Completer completer,
      String phone,
      FirebaseAuth _auth,
      int forceResendingToken) {
    resendToken = forceResendingToken;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              title: Text("Verification Code"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _codeController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    child: Text("Confirm"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () async {
                      final code = _codeController.text.trim();
                      AuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: verificationId, smsCode: code);
                      User user = FirebaseAuth.instance.currentUser;
                      print(user.uid);

                      if (user != null) {
                        print("try");
                        try {
                          user.linkWithCredential(credential).catchError((e) {
                            print("error with link");
                            AppConfig.showToast(
                                "Incorrect Code, Please try again");
                            hideKeyBoard();
                            print(e.code);
                          }).then((value) {
                            print(value.user);
                            if (value.user != null) {
                              print("phone linked");
                              CollectionReference users = FirebaseFirestore
                                  .instance
                                  .collection('Users');
                              UserModel userModel =
                                  UserModel(user.uid, "name", email, phone);
                              users.doc(user.uid).set(userModel.toJson());
                              userModel.createProfilePhoto();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          IntroductionScreen()));
                            } else {
                              hideKeyBoard();
                            }
                          });
                        } on PlatformException catch (e) {
                          print(e.code);
                          AppConfig.showToast(
                              "Incorrect Code, Please try again");
                        } on FirebaseAuthException catch (e) {
                          print(e.code);
                          AppConfig.showToast(
                              "Incorrect Code, Please try again");
                        } catch (exception) {
                          print(exception);
                          AppConfig.showToast(
                              "Incorrect Code, Please try again");
                        }
                        completer.complete(true);
                      } else {
                        print("Error");
                      }
                    },
                  ),
                  GestureDetector(
                    child: Text(
                      "Resend Code",
                      style: TextStyle(color: Colors.green),
                    ),
                    onTap: () {
                      FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: phone,
                          verificationCompleted:
                              (AuthCredential credential) async {
                            addCrediantials(completer, email, password);

                            //This callback would gets called when verification is done auto maticlly
                          },
                          verificationFailed:
                              (FirebaseAuthException exception) {
                            AppConfig.showToast(
                                "Incorrect Code, Please try again");
                          },
                          codeSent: (String verificationId,
                              [int forceResendingToken]) {
                            Navigator.pop(context);
                            codeSent(email, password, verificationId, completer,
                                phone, _auth, forceResendingToken);
                          },
                          forceResendingToken: resendToken,
                          codeAutoRetrievalTimeout: (String verificationId) {
                            verificationId = verificationId;
                            print(verificationId);
                            print("Timout");
                          });
                    },
                  )
                ],
              ));
        });
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
      print(userCredential.user);
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
