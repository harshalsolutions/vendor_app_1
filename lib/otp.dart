import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:vendor_app/404.dart';
import 'package:vendor_app/hello_vendor.dart';
import 'package:vendor_app/signsignup.dart';

//import 'package:url_launcher/url_launcher.dart';
//import 'package:otp_text_field/otp_field_style.dart';
import 'termsandcond.dart';
import 'package:otp_text_field/style.dart';

class OtpVerify extends StatefulWidget {
  final phone;
  final verificationId;
  final name;
  final companyname;
  final email;
  final address;

  const OtpVerify(
      {Key? key,
      required this.phone,
      required this.verificationId,
      this.name,
      this.companyname,
      this.email,
      this.address})
      : super(key: key);

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  var otpPin;
  OtpFieldController otpController = OtpFieldController();

/*  void verifyOTP(BuildContext context, String otp,
      String verificationId) async {
    //String otp = pin.toString().trim();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        log("${FirebaseAuth.instance.currentUser?.providerData.toString()}");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HelloVendor(phone: widget.phone,)));
      }
    } on FirebaseAuthException catch (ex) {
      log(ex.code.toString());
    }
  }*/

  Future<void> sendOtp(BuildContext context, String number) async {
    String phone = number.trim();

    await FirebaseAuth.instance
        .verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async {},
          verificationFailed: (FirebaseAuthException e) {},
          codeSent: (String verificationId, int? resendToken) async {
            Navigator.pushNamed(context, '/third',
                arguments: {'verificationId': verificationId, 'phone': phone});
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        )
        .then((value) => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("OTP sent"))));
  }

  Future<void> verifyUser1(
      BuildContext context, String otp, String verificationId) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        /* log("${FirebaseAuth.instance.currentUser?.providerData.toString()}");*/
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HelloVendor(
                      phone: widget.phone,
                    )));
      }
    } on FirebaseAuthException catch (ex) {
      log(ex.code.toString());
    }
  }

  Future<void> verifySignUpUser(
    BuildContext context,
    String otpCode,
    String verificationId,
    String name,
    String companyName,
    String address,
    String phone,
    String email,
  ) async {
    String otp = otpCode.trim();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    try {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
        if (value.user != null) {
          Map<String, dynamic> userDetails = {
            "name": name,
            "address": address,
            "companyName": companyName,
            "phone": phone,
            "email": email,
            'vid': FirebaseAuth.instance.currentUser?.uid ?? "",
            "image":
                "https://images.unsplash.com/photo-1621972750749-0fbb1abb7736?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8Y291cmllciUyMHNlcnZpY2VzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
          };
          FirebaseFirestore.instance
              .collection("Vendors")
              .where("phone", isEqualTo: phone.substring(3))
              .get()
              .then((values) {
            if (values.docs.isEmpty) {
              FirebaseFirestore.instance
                  .collection("Vendors")
                  .doc(value.user!.uid.substring(0, 20))
                  .set(userDetails)
                  .then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignIn()));
                //Change Screen
                //  Navigator.pushNamed(context, '/fifth', arguments: {});
              });
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HelloVendor(
                          phone:
                              FirebaseAuth.instance.currentUser?.phoneNumber)));
              // Navigator.pushNamed(context, '/fifth', arguments: {});
            }
          });
        }
      });
    } on FirebaseAuthException catch (ex) {
      log(ex.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: (MediaQuery.of(context).size.height) * 0.4,
        margin:
            EdgeInsets.only(top: (MediaQuery.of(context).size.height) * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.height) * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Center(
                child: Text(
              'Verify Your Number',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )),
            Container(
              width: (MediaQuery.of(context).size.width) * 0.9,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
              child: const Center(
                  child: Text(
                'Enter 6-Digit code sent at your number',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              )),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              width: (MediaQuery.of(context).size.width) * 0.9,
              height: (MediaQuery.of(context).size.height) * 0.07,
              child: OTPTextField(
                controller: otpController,
                length: 6,
                otpFieldStyle:
                    OtpFieldStyle(backgroundColor: Colors.grey.shade100),
                width: (MediaQuery.of(context).size.width) * 0.7,
                fieldWidth: 30,

                //fieldWidth: 80,

                // textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                onCompleted: (pin) {
                  setState(() {
                    otpPin = pin;
                  });
                  /*var currentVendor = FirebaseFirestore.instance
                      .collection('vendors')
                      .where('mobile', isEqualTo: widget.phone);
                  print(
                      'Current vendor is ${currentVendor.get().then((value) => print('vendordata ${value.docs[0]}'))}');
*/
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("OTP sent")));
                  if (widget.verificationId.isEmpty && widget.phone.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Wrong OTP")));
                  } else {
                    verifySignUpUser(
                        context,
                        pin,
                        widget.verificationId,
                        widget.name,
                        widget.companyname,
                        widget.address,
                        widget.phone,
                        widget.email);
                    // verifyUser(context, pin, widget.verificationId);
                    // verifyOTP(
                    //     context, pin, widget.verificationId);
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Center(
                child: InkWell(
                  onTap: () {
                    verifySignUpUser(
                        context,
                        otpPin,
                        widget.verificationId,
                        widget.name,
                        widget.companyname,
                        widget.address,
                        widget.phone,
                        widget.email);
                    //Navigator.push(context, MaterialPageRoute(builder:  (context) => const HelloVendor()));
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width) * 0.9,
                    height: (MediaQuery.of(context).size.height) * 0.07,
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                        child: Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )),
                  ),
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Didn\'t receive OTP? ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Resend',
                    style: const TextStyle(color: Colors.orange),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Otp2(
                                      phone: widget.phone,
                                    )));
                      },
                  ),
                ],
              ),
            )
            // Container(
            //   child: ,
            // )
          ],
        ),
      ),
    );
  }
}

class OtpVerify1 extends StatefulWidget {
  final phone;
  final verificationId;

  const OtpVerify1({
    Key? key,
    required this.phone,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<OtpVerify1> createState() => _OtpVerify1State();
}

class _OtpVerify1State extends State<OtpVerify1> {
  var otpPin;
  OtpFieldController otpController = OtpFieldController();

/*  void verifyOTP(BuildContext context, String otp,
      String verificationId) async {
    //String otp = pin.toString().trim();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        log("${FirebaseAuth.instance.currentUser?.providerData.toString()}");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HelloVendor(phone: widget.phone,)));
      }
    } on FirebaseAuthException catch (ex) {
      log(ex.code.toString());
    }
  }*/

  Future<void> sendOtp(BuildContext context, String number) async {
    String phone = number.trim();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) async {
        //Navigator.pushNamed(context, '/third',
        //     arguments: {'verificationId': verificationId, 'phone': phone});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> verifyUser1(
      BuildContext context, String otp, String verificationId) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        log("${FirebaseAuth.instance.currentUser?.providerData.toString()}");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HelloVendor(
                      phone: widget.phone,
                    )));
      }
    } on FirebaseAuthException catch (ex) {
      log(ex.code.toString());
    }
  }

  /*Future<void> verifySignUpUser(
      BuildContext context,
      String otpCode,
      String verificationId,

      ) async {
    String otp = otpCode.trim();
    print('Verify user is running');

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    try {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
        if (value.user != null) {
          Map<String, dynamic> userDetails = {
            "name": name,
            "address": address,
            "companyname":companyName,
            "phone": phone,
            "email":email,
            'vid': FirebaseAuth.instance.currentUser?.uid ?? "",
            "image":
            "https://images.unsplash.com/photo-1621972750749-0fbb1abb7736?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8Y291cmllciUyMHNlcnZpY2VzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
          };
          FirebaseFirestore.instance
              .collection("Vendors")
              .where("phone", isEqualTo:phone)
              .get()
              .then((values) {
            if (values.docs.isEmpty) {
              FirebaseFirestore.instance
                  .collection("Vendors")
                  .doc(value.user!.uid.substring(0, 20))
                  .set(userDetails)
                  .then((value) {
                print('in if conditions');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HelloVendor(
                            phone: FirebaseAuth
                                .instance.currentUser?.phoneNumber)));
                //Change Screen
                //  Navigator.pushNamed(context, '/fifth', arguments: {});
              });
            } else {
              print('in if conditions');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HelloVendor(
                          phone:
                          FirebaseAuth.instance.currentUser?.phoneNumber)));
              // Navigator.pushNamed(context, '/fifth', arguments: {});
            }
          });
        }
      });
    } on FirebaseAuthException catch (ex) {
      log(ex.code.toString());
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: (MediaQuery.of(context).size.height) * 0.4,
        margin:
            EdgeInsets.only(top: (MediaQuery.of(context).size.height) * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.height) * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Center(
                child: Text(
              'Verify Your Number',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )),
            Container(
              width: (MediaQuery.of(context).size.width) * 0.9,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
              child: const Center(
                  child: Text(
                'Enter 6-Digit code sent at your number',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              )),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              width: (MediaQuery.of(context).size.width) * 0.9,
              height: (MediaQuery.of(context).size.height) * 0.07,
              child: OTPTextField(
                controller: otpController,
                length: 6,
                otpFieldStyle:
                    OtpFieldStyle(backgroundColor: Colors.grey.shade100),
                width: (MediaQuery.of(context).size.width) * 0.7,
                fieldWidth: 30,

                //fieldWidth: 80,

                // textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                onCompleted: (pin) {
                  setState(() {
                    otpPin = pin;
                  });
                  /*var currentVendor = FirebaseFirestore.instance
                      .collection('vendors')
                      .where('mobile', isEqualTo: widget.phone);
                  print(
                      'Current vendor is ${currentVendor.get().then((value) => print('vendordata ${value.docs[0]}'))}');
*/
                  if (widget.verificationId.isEmpty && widget.phone.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Wrong OTP")));
                  } else {
                    verifyUser1(context, pin, widget.verificationId);
                    // verifySignUpUser(context, pin, widget.verificationId );
                    // verifyUser(context, pin, widget.verificationId);
                    // verifyOTP(
                    //     context, pin, widget.verificationId);
                  }
                  print("Completed: $pin");
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Center(
                child: InkWell(
                  onTap: () {
                    verifyUser1(context, otpPin, widget.verificationId);
                    //verifySignUpUser(context, otpPin);
                    //Navigator.push(context, MaterialPageRoute(builder:  (context) => const HelloVendor()));
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width) * 0.9,
                    height: (MediaQuery.of(context).size.height) * 0.07,
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                        child: Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )),
                  ),
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Didn\'t receive OTP? ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Resend',
                    style: const TextStyle(color: Colors.orange),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Otp2(
                                      phone: widget.phone,
                                    )));
                        print('tapped');
                        // launchUrl((Uri.parse('http://stackoverflow.com')));
                      },
                  ),
                ],
              ),
            )
            // Container(
            //   child: ,
            // )
          ],
        ),
      ),
    );
  }
}

class Otp2 extends StatefulWidget {
  final phone;

  const Otp2({Key? key, required this.phone}) : super(key: key);

  @override
  State<Otp2> createState() => _Otp2State();
}

class _Otp2State extends State<Otp2> {
  Duration myDuration = const Duration(seconds: 30);

  String strDigits(int n) => n.toString().padLeft(2, '0');

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  late Timer _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: (MediaQuery.of(context).size.height) * 0.4,
        margin:
            EdgeInsets.only(top: (MediaQuery.of(context).size.height) * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.height) * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: const Center(
                  child: Text(
                'Verify Your Number',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )),
            ),
            Container(
              width: (MediaQuery.of(context).size.width) * 0.9,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
              child: const Center(
                  child: Text(
                'Enter 4-Digit code sent at your number',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              )),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              width: (MediaQuery.of(context).size.width) * 0.9,
              height: (MediaQuery.of(context).size.height) * 0.07,
              child: OTPTextField(
                length: 6,
                width: (MediaQuery.of(context).size.width) * 0.7,

                //fieldWidth: 80,

                // textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                onCompleted: (pin) {
                  // print("Completed: $pin");
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HelloVendor(phone: widget.phone)));
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width) * 0.9,
                    height: (MediaQuery.of(context).size.height) * 0.07,
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                        child: Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )),
                  ),
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Resend OTP ',
                    style: TextStyle(color: Colors.black),
                  ),
                  _start == 0
                      ? TextSpan(
                          text: 'Resend',
                          style: const TextStyle(color: Colors.orange),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Error404Page()));
                              //print('tapped');
                              //launchUrl((Uri.parse('http://stackoverflow.com')));
                            },
                        )
                      : TextSpan(
                          text: '00:$_start',
                          style: const TextStyle(color: Colors.orange),
                        ),
                ],
              ),
            )
            // Container(
            //   child: ,
            // )
          ],
        ),
      ),
    );
  }
}
