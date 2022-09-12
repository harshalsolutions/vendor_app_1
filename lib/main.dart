import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/hello_vendor.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'signsignup.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: currentUser == null
          ? const MyHomePage(title: 'Flutter')
          : HelloVendor(phone: currentUser.phoneNumber),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.height) * 0.04,
                      left: (MediaQuery.of(context).size.height) * 0.02),
                  // margin: EdgeInsets.only(left: (MediaQuery.of(context).size.height)*0.02),
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
                        child: Center(
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
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                        top: (MediaQuery.of(context).size.height) * 0.15),
                    height: (MediaQuery.of(context).size.height) * 0.3,
                    width: (MediaQuery.of(context).size.width) * 0.7,
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                      //borderRadius: BorderRadius.all(Radius.circular((MediaQuery.of(context).size.height)*0.3))
                    )),
                Container(
                  margin: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.height) * 0.05),
                  child: const Text('Welcome',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.height) * 0.03),
                  child: const Text('Grow with us',
                      style: TextStyle(fontSize: 20)),
                )
              ],
            ),
          ),
          Expanded(
              child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignIn()));
                    },
                    child: Container(
                      height: (MediaQuery.of(context).size.height) * 0.1,
                      width: (MediaQuery.of(context).size.width) * 0.5,
                      decoration: const BoxDecoration(

                          //color: Colors.orange,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              bottomRight: Radius.circular(35))),
                      child: const Center(
                          child: Text(
                        'Sign In',
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )),
                    )),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
                    },
                    child: Container(
                      height: (MediaQuery.of(context).size.height) * 0.1,
                      width: (MediaQuery.of(context).size.width) * 0.5,
                      decoration: const BoxDecoration(
                          color: Colors.orange,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(35))),
                      child: const Center(
                          child: Text(
                        'Create Account',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      )),
                    ))
              ],
            ),
          ))
        ]),
      ),
    );
  }
}
