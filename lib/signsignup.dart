import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//import 'package:url_launcher/url_launcher.dart';
import 'package:vendor_app/termsandcond.dart';
import 'otp.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController mobileNumber = TextEditingController();

  void sendOTP(BuildContext context, TextEditingController controller) async {
    String phone = "+91" + controller.text.trim();

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        codeSent: (verificationId, resendToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpVerify1(
                        phone: mobileNumber.text,
                        verificationId: verificationId,
                      )));
        },
        verificationCompleted: (credential) {},
        verificationFailed: (ex) {
          log(ex.code.toString());
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: const Duration(seconds: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: (MediaQuery.of(context).size.height) * 0.9,
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
                'Sign In',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )),
            ),
            Container(
              width: (MediaQuery.of(context).size.width) * 0.9,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
              child: const Center(
                  child: Text(
                'Enter your Mobile Number so that we know who it is',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              )),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              width: (MediaQuery.of(context).size.width) * 0.9,
              height: (MediaQuery.of(context).size.height) * 0.07,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 1, color: Colors.grey.shade100)),
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 2),
              child: TextField(
                controller: mobileNumber,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  //enabledBorder: ,

                  border: InputBorder.none,

                  hintText: 'Mobile No.',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Center(
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Wrong OTP")));
                    sendOTP(context, mobileNumber);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtpVerify(
                                  verificationId: "",
                                  phone: mobileNumber,
                                )));
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width) * 0.9,
                    height: (MediaQuery.of(context).size.height) * 0.07,
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                        child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'New to  Pick My Parcel? ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Register',
                        style: const TextStyle(color: Colors.orange),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print('tapped');

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()));
                            //launchUrl((Uri.parse('http://stackoverflow.com')));
                          },
                      ),
                    ],
                  ),
                ),
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

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late bool isagreed = false;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController companynamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();

  void sendOTP(BuildContext context, TextEditingController controller,
      String name, String companyName, String email, String address) async {
    String phone = "+91${controller.text.trim()}";

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        codeSent: (verificationId, resendToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpVerify(
                        phone: mobileNumber.text,
                        verificationId: verificationId,
                        name: name,
                        companyname: companyName,
                        email: email,
                        address: address,
                      )));
        },
        verificationCompleted: (credential) {},
        verificationFailed: (ex) {
          log(ex.code.toString());
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: const Duration(seconds: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: (MediaQuery.of(context).size.height) * 0.9,
        margin:
            EdgeInsets.only(top: (MediaQuery.of(context).size.height) * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
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
                    'Sign Up',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width) * 0.9,
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: const Center(
                      child: Text(
                    'Lets get to know you better',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  )),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  width: (MediaQuery.of(context).size.width) * 0.9,
                  height: (MediaQuery.of(context).size.height) * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border:
                          Border.all(width: 1, color: Colors.grey.shade100)),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 5, bottom: 2),
                  child: TextField(
                    controller: namecontroller,
                    decoration: const InputDecoration(
                      //enabledBorder: ,
                      border: InputBorder.none,
                      hintText: 'Name',
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  width: (MediaQuery.of(context).size.width) * 0.9,
                  height: (MediaQuery.of(context).size.height) * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border:
                          Border.all(width: 1, color: Colors.grey.shade100)),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 5, bottom: 2),
                  child: TextField(
                    controller: companynamecontroller,
                    decoration: const InputDecoration(
                      //enabledBorder: ,
                      border: InputBorder.none,
                      hintText: 'Company Name.',
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  width: (MediaQuery.of(context).size.width) * 0.9,
                  height: (MediaQuery.of(context).size.height) * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border:
                          Border.all(width: 1, color: Colors.grey.shade100)),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 5, bottom: 2),
                  child: TextField(
                    controller: addresscontroller,
                    decoration: const InputDecoration(
                      //enabledBorder: ,
                      border: InputBorder.none,
                      hintText: 'Address',
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  width: (MediaQuery.of(context).size.width) * 0.9,
                  height: (MediaQuery.of(context).size.height) * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border:
                          Border.all(width: 1, color: Colors.grey.shade100)),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 5, bottom: 2),
                  child: TextField(
                    controller: mobileNumber,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      //enabledBorder: ,
                      border: InputBorder.none,
                      hintText: 'Mobile No.',
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  width: (MediaQuery.of(context).size.width) * 0.9,
                  height: (MediaQuery.of(context).size.height) * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border:
                          Border.all(width: 1, color: Colors.grey.shade100)),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 5, bottom: 2),
                  child: TextField(
                    controller: emailcontroller,
                    decoration: const InputDecoration(
                      //enabledBorder: ,
                      border: InputBorder.none,
                      hintText: 'E-mail',
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if (isagreed == true) {
                          setState(() {
                            isagreed = false;
                          });
                        } else {
                          setState(() {
                            isagreed = true;
                          });
                        }
                      },
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black)),
                        child: Icon(
                          Icons.check,
                          color: isagreed ? Colors.orange : Colors.white,
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'I Agree to',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: const TextStyle(color: Colors.orange),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TermsAndConditions()));
                              },
                          ),
                          const TextSpan(
                            text: ' of Pick My Parcel',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        var snackBar =
                            SnackBar(content: Text('Please Check the Box'));
                        isagreed
                            ? sendOTP(
                                context,
                                mobileNumber,
                                namecontroller.text,
                                companynamecontroller.text,
                                emailcontroller.text,
                                addresscontroller.text)
                            : ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                        //Navigator.push(context, MaterialPageRoute(builder:  (context) =>  OtpVerify(verificationId: null, phone:mobileNumber,)));
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width) * 0.9,
                        height: (MediaQuery.of(context).size.height) * 0.07,
                        decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: const Center(
                            child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Already a Member? ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Sign In',
                        style: const TextStyle(color: Colors.orange),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            //print('tapped');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignIn()));
                          },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
