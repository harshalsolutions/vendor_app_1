import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vendor_app/hello_vendor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_app/signsignup.dart';
import 'package:vendor_app/vendor_model.dart';

import 'completedorders.dart';
import 'scheduledorders.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance
      .ref('UserProfiles/${FirebaseAuth.instance.currentUser!.uid}');

  String imageUrl = 'https://www.kindpng.com/picc/m/24-248253_user-profile-default-image-png-clipart-png-download.png';

  File? imageFile;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => imageFile = imageTemporary);

      if (imageFile != null) {
        log(imageFile!.path.toString());
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> _uploadData() async {
    UploadTask uploadTask = storageRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .putFile(imageFile!);


    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    _addImageInFirebase(imageUrl);
  }

  _addImageInFirebase(String url) async {
    await FirebaseFirestore.instance
        .collection('Vendors')
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .set({
      'image': url,
    }, SetOptions(merge: true)).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Updated")));

    });
    if (mounted) {
      setState(() {
        imageUrl = url;
      });
    }
  }

  showMenu() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        constraints: const BoxConstraints(
          //minHeight: MediaQuery.of(context).size.height*0.7,
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.orange,
            ),
            padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.04),
            //height: 0.75,
            height:  MediaQuery.of(context).size.height*0.33,



            child: Column(

              children: <Widget>[

                Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),

                    ),
                    child: Column(
                      children: <Widget>[

                        Container(
                          //padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
                            decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(width: 1,color: Colors.white30))
                            ),
                            child:  ListTile(
                              leading:  Icon(Icons.photo_library_rounded),
                              //Icon(Icons.phone_locked),
                              title: InkWell(onTap: (){
                                pickImage(ImageSource.gallery);
                              },child:  Text('Gallery',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),)),)


                        ),
                        Container(
                          //padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
                            decoration: const BoxDecoration(
                              //border: Border(bottom: BorderSide(width: 1,color: Colors.white))
                            ),
                            child:   ListTile(
                              leading: const Icon(Icons.camera_alt),
                              //Icon(Icons.phone_locked),
                              title: InkWell(onTap: (){

                                pickImage(ImageSource.camera);
                              },child: const Text('Camera',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),)),)


                        ),
                        ElevatedButton(onPressed: (){
                          print('clicked');
                          _uploadData();
                        }
                            , child: Text('1'))
                        /*OutlinedButton(
                          style: OutlinedButton.styleFrom(

                            primary: Colors.white,
                            side: const BorderSide(color: Colors.white, width: 2), //<-- SEE HERE
                          ),
                          onPressed: () {
                            _uploadData();
                          },
                          child: const Text(
                            'Update Profile',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),*/



                      ],
                    )),

              ],
            ),
          );
        });
  }
  String userImage = '';
  var name = '';
  var company = '';
  var phone= '';
  var mail = '';
  User? currentUser = FirebaseAuth.instance.currentUser;
  late VendorModel vendormodel;
  List<VendorModel> vendorList = [];
  _getVendor()async{
    await FirebaseFirestore.instance.collection('Vendors')
        .where('phone',isEqualTo: currentUser?.phoneNumber?.substring(3))
        .get()
        .then((value) {
      for(var data1 in value.docs){
        print('Data ka data TTTTTTTTTTTTt${data1.data().toString()}');
        log(data1['name']);

        setState((){

          data = data1;
          userImage = data['image'];
          //vendorid = data1['vid'];

          //print('data of vid is ${data.toString()}');
        });


      }
      print("FFFFFFFFFFFFF$userImage");
      // /data = value.data();
      //print(data1['name']);
      //log(data['address']);

    });

    //print(data[0][0]['name']);
  }

  TextEditingController namecontroller = TextEditingController(text: data['name']);
  TextEditingController companyname = TextEditingController(text: data['companyName']);
  TextEditingController phonenumber = TextEditingController(text: data['phone']);
  TextEditingController email = TextEditingController(text: data['email']);
  @override
  void initState() {
    _getVendor();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  //margin: EdgeInsets.only(left: (MediaQuery.of(context).size.height)*0.02),
                  height: (MediaQuery.of(context).size.height)*0.2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular((MediaQuery.of(context).size.height)*0.08),bottomRight: Radius.circular((MediaQuery.of(context).size.height)*0.08)),
                    color: Colors.orange,

                  ),
                  child: Container(
                    margin: EdgeInsets.only(left: (MediaQuery.of(context).size.width)*0.02,top:(MediaQuery.of(context).size.height)*0.05 ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(onPressed: (){
                              Navigator.pop(context);
                            }, icon: const Icon(Icons.arrow_back))
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(left: (MediaQuery.of(context).size.width)*0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Profile',textAlign: TextAlign.start,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700),),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.08),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height*0.15,
                        width: MediaQuery.of(context).size.height*0.15,
                        decoration:   BoxDecoration(
                          border: Border.all(width: 7,color: Colors.orange) ,
                          borderRadius: const BorderRadius.all(Radius.circular(30)),

                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: imageFile!=null ?
                            Image.file(imageFile!) :Image.network(userImage ),
                          ),
                        ),

                      ),
                      InkWell(
                        onTap: showMenu,
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],

                          ),
                          child: const Icon(Icons.camera_alt,color: Colors.orange,),
                        ),
                      )

                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.85,
                        decoration: const BoxDecoration(
                          //border: Border(bottom: BorderSide(width: 1,color: Colors.black))
                        ),
                        child:   TextField(
                              controller: namecontroller,
                            decoration: const InputDecoration(
                              labelText: "Name",
                              hintText:'Name',
                              labelStyle: const TextStyle(
                                color: Colors.black54
                              ),
                              //border: InputBorder.none,
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            )
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.85,
                        decoration: const BoxDecoration(
                          //border: Border(bottom: BorderSide(width: 1,color: Colors.black))
                        ),
                        child:   TextField(
                          controller: companyname,
                            decoration: const InputDecoration(
                              labelText: "Company Name",
                              hintText:'Company Name',
                              labelStyle: const TextStyle(
                                color: Colors.black54
                              ),
                              //border: InputBorder.none,
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            )
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.85,
                        decoration: const BoxDecoration(
                          //border: Border(bottom: BorderSide(width: 1,color: Colors.black))
                        ),
                        child:   TextField(
                          controller: phonenumber,

                            decoration: const InputDecoration(
                              labelText: "Phone Number",
                              hintText:'Phone Number',

                              labelStyle: const TextStyle(
                                color: Colors.black54
                              ),
                              //border: InputBorder.none,
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            )
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.85,
                        decoration: const BoxDecoration(
                          //border: Border(bottom: BorderSide(width: 1,color: Colors.black))
                        ),
                        child:  TextField(
                          controller: email,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              hintText:'Email',
                              labelStyle: const TextStyle(
                                color: Colors.black54
                              ),
                              //border: InputBorder.none,
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            )
                        ),
                      ),
                      ElevatedButton(onPressed: (){
                        _signOut(context);
                        print('logging out');
                      },
                          child: const Text('LogOut'))
                    ],

                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: (MediaQuery.of(context).size.height)*0.02),
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(Radius.circular((MediaQuery.of(context).size.height)*0.04))
              ),
              height: (MediaQuery.of(context).size.height)*0.1,
              width: (MediaQuery.of(context).size.width)*0.9,
              child: Row(
                crossAxisAlignment:CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(22))
                    ),
                    child: IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder:  (context) => const HelloVendor()));
                      },
                      icon: const Icon(Icons.home_filled),
                    ),
                  ),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(22))
                    ),
                    child: IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder:  (context) => const ScheduledOrders()));
                      },
                      icon: const Icon(Icons.access_time_rounded),
                    ),
                  ),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(22))
                    ),
                    child: IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder:  (context) => const CompletedOrders()));
                      },
                      icon: const Icon(Icons.shopping_cart_outlined),
                    ),
                  ),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.all(Radius.circular(22))
                    ),
                    child: IconButton(
                      onPressed: (){
                        //Navigator.push(context, MaterialPageRoute(builder:  (context) => const HelloVendor()));
                      },
                      icon: const Icon(Icons.menu_rounded,color: Colors.white,),
                    ),
                  ),


                ],
              ),
            )


          ],
        ),
      ),
    );


  }
}

Future<void> _signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignIn()));
}
