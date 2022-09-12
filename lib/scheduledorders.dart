import 'dart:developer';
import 'package:vendor_app/profile.dart';

import 'user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '404.dart';
import 'completedorders.dart';
import 'hello_vendor.dart';
import 'ordersmodel.dart';
import 'scheduledorderdetail.dart';

class ScheduledOrders extends StatefulWidget {
  const ScheduledOrders({Key? key}) : super(key: key);

  @override
  State<ScheduledOrders> createState() => _ScheduledOrdersState();
}

class _ScheduledOrdersState extends State<ScheduledOrders> {
  TextEditingController weightcontroller = TextEditingController();
  bool isagreed = false;
  String vendorid = '';
  String userid = '';
  User? currentUser = FirebaseAuth.instance.currentUser;
  getVendor() async {
    await FirebaseFirestore.instance
        .collection('Vendors')
        .where('phone', isEqualTo: currentUser?.phoneNumber?.substring(3))
        .get()
        .then((value) {
      for (var data1 in value.docs) {
        log(data1['name']);
        setState(() {
          data = data1;
          vendorid = data1['vid'];
        });
      }
    });
  }

  late OrderModel scheduledordermodel;
  List<OrderModel> scheduledorderList = [];
  getScheduledOrders() async {
    await FirebaseFirestore.instance
        .collection('Orders')
        .where('vid', isEqualTo: vendorid)
        .where('orderStatus', whereIn: ["picked", "dispatched"])
        .get()
        .then((value) {
          scheduledorderList.clear();
          for (var data1 in value.docs) {
            //log(' the of orders is this ${data1.data().toString()}');
            scheduledordermodel = OrderModel.fromMap(data1.data());

            setState(() {
              scheduledorderList.add(scheduledordermodel);
              data = data1;
            });
          }
        });
  }

  late UserModel userModel;
  List<UserModel> usersList = [];

  Map dataUser = {};
  getUsers(int index) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: scheduledorderList[index].uid)
        .get()
        .then((value) {
      //(imgUrl, uid, address, phone, name, email)
      /* print('the user data is ${value.docs[index].data()['name']}');
      print(value.docs[index].data()['name']);
      name = value.docs[index].data()['name'];
      print(name);
      address = value.docs[index].data()['address'];
      print(address);
      image = value.docs[index].data()['imgUrl'];*/

      usersList.clear();
      for (var data1 in value.docs) {
        userModel = UserModel.fromMap(data1.data());
        //
        setState(() {
          dataUser = data1.data();
          // usersList.add(dataUser);
          usersList.add(userModel);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getVendor();
    getScheduledOrders();
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("Picked Up Orders",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
              ],
            ),
          ),
          scheduledorderList.isNotEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.builder(
                      itemCount: scheduledorderList.length,
                      itemBuilder: (context, index) {
                        String orderstatus =
                            scheduledorderList[index].orderStatus;
                        getUsers(index);
                        return Container(
                            margin: const EdgeInsets.only(top: 25),
                            width: (MediaQuery.of(context).size.width) * 0.9,
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // CircleAvatar(
                                    //   radius: 35.0,
                                    //   backgroundImage:
                                    //       NetworkImage(usersList[index].imgUrl),
                                    //   backgroundColor: Colors.transparent,
                                    // ),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          usersList[0].name.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 23),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          usersList[0].address.toString(),
                                          textAlign: TextAlign.start,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Pickup Address  : '),
                                      Expanded(
                                          child: Text(scheduledorderList[index]
                                              .pickupAdrs))
                                    ]),
                                Row(children: [
                                  const Text('Pickup Date  : '),
                                  Expanded(
                                      child: Text(
                                          scheduledorderList[index].pickupTime))
                                ]),
                                Row(children: [
                                  const Text('Pickup Time  : '),
                                  Row(
                                    children: const [
                                      Text('11:45 PM'),
                                      SizedBox(width: 30),
                                      // Container(
                                      //   padding: const EdgeInsets.all(5),
                                      //   decoration: const BoxDecoration(
                                      //       borderRadius: BorderRadius.all(
                                      //           Radius.circular(20)),
                                      //       color: Colors.orange),
                                      //   child: const Text('Due in 2 Hours'),
                                      // )
                                    ],
                                  )
                                ]),
                                const Divider(
                                  color: Colors.orange,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ScheduledOrderDetail(
                                                      orders:
                                                          scheduledorderList[
                                                              index],
                                                      users: usersList[0],
                                                    )));
                                      },
                                      child: const Text('View Details',
                                          style:
                                              TextStyle(color: Colors.orange)),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            if (orderstatus == "dispatched") {
                                              FirebaseFirestore.instance
                                                  .collection("Orders")
                                                  .doc(scheduledorderList[index]
                                                      .trackingId)
                                                  .update({
                                                'orderStatus': "complete"
                                              }).then((value) =>
                                                      print("dissssss"));
                                            } else if (orderstatus ==
                                                "picked") {
                                              FirebaseFirestore.instance
                                                  .collection("Orders")
                                                  .doc(scheduledorderList[index]
                                                      .trackingId)
                                                  .update({
                                                'orderStatus': "dispatched"
                                              }).then((value) =>
                                                      print("dissssss"));
                                            }
                                            //Navigator.push(context, MaterialPageRoute(builder:  (context) => const ProfilePage()));
                                            // showDialog(
                                            //     context: context,
                                            //     builder: (_) => AlertDialog(
                                            //             content: Container(
                                            //           height: (MediaQuery.of(
                                            //                       context)
                                            //                   .size
                                            //                   .height) *
                                            //               0.5,
                                            //           decoration:
                                            //               const BoxDecoration(
                                            //             //color: Colors.grey,
                                            //             borderRadius:
                                            //                 BorderRadius.all(
                                            //                     Radius.circular(
                                            //                         50)),
                                            //             //color: Colors.orange
                                            //           ),
                                            //           child: Column(
                                            //             children: [
                                            //               Row(
                                            //                 children: [
                                            //                   const CircleAvatar(
                                            //                     radius: 35.0,
                                            //                     backgroundImage:
                                            //                         NetworkImage(
                                            //                             'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                                            //                     backgroundColor:
                                            //                         Colors
                                            //                             .transparent,
                                            //                   ),
                                            //                   const SizedBox(
                                            //                       width: 20),
                                            //                   Column(
                                            //                     crossAxisAlignment:
                                            //                         CrossAxisAlignment
                                            //                             .start,
                                            //                     children: <
                                            //                         Widget>[
                                            //                       Text(
                                            //                         usersList[0]
                                            //                             .name
                                            //                             .toString(),
                                            //                         style: const TextStyle(
                                            //                             fontWeight:
                                            //                                 FontWeight
                                            //                                     .bold,
                                            //                             fontSize:
                                            //                                 23),
                                            //                         textAlign:
                                            //                             TextAlign
                                            //                                 .start,
                                            //                       ),
                                            //                       // Text(
                                            //                       //   scheduledorderList[0][""],
                                            //                       //   textAlign:
                                            //                       //       TextAlign
                                            //                       //           .start,
                                            //                       // )
                                            //                     ],
                                            //                   ),
                                            //                 ],
                                            //               ),
                                            //               Row(children: [
                                            //                 const Text(
                                            //                     'Pickup Address  : '),
                                            //                 Expanded(
                                            //                     child: Text(
                                            //                         scheduledorderList[
                                            //                                 index]
                                            //                             .pickupAdrs,
                                            //                         style: const TextStyle(
                                            //                             fontWeight:
                                            //                                 FontWeight.bold)))
                                            //               ]),
                                            //               Row(children: [
                                            //                 const Text(
                                            //                     'Pickup Date  : '),
                                            //                 Expanded(
                                            //                     child: Text(
                                            //                   scheduledorderList[
                                            //                           index]
                                            //                       .pickupTime,
                                            //                   style: const TextStyle(
                                            //                       fontWeight:
                                            //                           FontWeight
                                            //                               .bold),
                                            //                 ))
                                            //               ]),
                                            //               Row(children: [
                                            //                 const Text(
                                            //                     'Length  : '),
                                            //                 Expanded(
                                            //                     child: Text(
                                            //                   '${scheduledorderList[index].length} cm',
                                            //                   style: const TextStyle(
                                            //                       fontWeight:
                                            //                           FontWeight
                                            //                               .bold),
                                            //                 ))
                                            //               ]),
                                            //               Row(children: [
                                            //                 const Text(
                                            //                     'Breadth  : '),
                                            //                 Expanded(
                                            //                     child: Text(
                                            //                   '${scheduledorderList[index].breadth} cm',
                                            //                   style: const TextStyle(
                                            //                       fontWeight:
                                            //                           FontWeight
                                            //                               .bold),
                                            //                 ))
                                            //               ]),
                                            //               Row(children: [
                                            //                 const Text(
                                            //                     'Height  : '),
                                            //                 Expanded(
                                            //                     child: Text(
                                            //                   '${scheduledorderList[index].height} cm',
                                            //                   style: const TextStyle(
                                            //                       fontWeight:
                                            //                           FontWeight
                                            //                               .bold),
                                            //                 ))
                                            //               ]),
                                            //               Row(children: [
                                            //                 const Text(
                                            //                     'Weight of the package  : '),
                                            //                 Expanded(
                                            //                     child: Text(
                                            //                   '${scheduledorderList[index].weight} kg',
                                            //                   style: const TextStyle(
                                            //                       fontWeight:
                                            //                           FontWeight
                                            //                               .bold),
                                            //                 ))
                                            //               ]),
                                            //               Row(children: [
                                            //                 const Text(
                                            //                     'Content of the package  : '),
                                            //                 Expanded(
                                            //                     child: Text(
                                            //                   scheduledorderList[
                                            //                           index]
                                            //                       .packageContent,
                                            //                   style: const TextStyle(
                                            //                       fontWeight:
                                            //                           FontWeight
                                            //                               .bold),
                                            //                 ))
                                            //               ]),
                                            //               Row(children: const [
                                            //                 Text(
                                            //                     'Mode of Payment  : '),
                                            //                 Expanded(
                                            //                     child: Text(
                                            //                   'COD',
                                            //                   style: TextStyle(
                                            //                       fontWeight:
                                            //                           FontWeight
                                            //                               .bold),
                                            //                 ))
                                            //               ]),
                                            //               Row(children: [
                                            //                 const Text(
                                            //                     'Amount  : '),
                                            //                 Expanded(
                                            //                     child: Text(
                                            //                   '${scheduledorderList[index].packageValue}',
                                            //                   style: const TextStyle(
                                            //                       fontWeight:
                                            //                           FontWeight
                                            //                               .bold),
                                            //                 ))
                                            //               ]),
                                            //               Row(children: [
                                            //                 const Text(
                                            //                     'Type of shipment  : '),
                                            //                 Expanded(
                                            //                     child: Text(
                                            //                   scheduledorderList[
                                            //                           index]
                                            //                       .shipmentType,
                                            //                   style: const TextStyle(
                                            //                       fontWeight:
                                            //                           FontWeight
                                            //                               .bold),
                                            //                 ))
                                            //               ]),
                                            //               Row(
                                            //                 children: <Widget>[
                                            //                   InkWell(
                                            //                     onTap: () {
                                            //                       if (isagreed ==
                                            //                           true) {
                                            //                         setState(
                                            //                             () {
                                            //                           isagreed =
                                            //                               false;
                                            //                         });
                                            //                       } else {
                                            //                         setState(
                                            //                             () {
                                            //                           isagreed =
                                            //                               true;
                                            //                         });
                                            //                       }
                                            //                     },
                                            //                     child:
                                            //                         Container(
                                            //                       height: 20,
                                            //                       decoration: BoxDecoration(
                                            //                           border: Border.all(
                                            //                               width:
                                            //                                   1,
                                            //                               color:
                                            //                                   Colors.black)),
                                            //                       child: Icon(
                                            //                         Icons.check,
                                            //                         color: isagreed
                                            //                             ? Colors
                                            //                                 .orange
                                            //                             : Colors
                                            //                                 .white,
                                            //                       ),
                                            //                     ),
                                            //                   ),
                                            //                   const Text(
                                            //                       "I have received the cash")
                                            //                 ],
                                            //               ),
                                            //               InkWell(
                                            //                 onTap: () {
                                            //                   print("4");
                                            //                   var snackBar =
                                            //                       const SnackBar(
                                            //                           content: Text(
                                            //                               'Please Check the Box'));
                                            //                   isagreed
                                            //                       ? showDialog(
                                            //                           context:
                                            //                               context,
                                            //                           builder: (_) =>
                                            //                               AlertDialog(
                                            //                                   content:
                                            //                                       Container(
                                            //                                 height:
                                            //                                     (MediaQuery.of(context).size.height) * 0.21,
                                            //                                 decoration:
                                            //                                     const BoxDecoration(),
                                            //                                 child:
                                            //                                     Column(
                                            //                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            //                                   children: [
                                            //                                     Align(
                                            //                                         alignment: Alignment.centerRight,
                                            //                                         child: IconButton(
                                            //                                             onPressed: () {
                                            //                                               Navigator.pop(context);
                                            //                                             },
                                            //                                             icon: const Icon(Icons.close))),
                                            //                                     const Text(
                                            //                                       'Confirmed the weight of the parcel?',
                                            //                                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            //                                       textAlign: TextAlign.center,
                                            //                                     ),
                                            //                                     const SizedBox(
                                            //                                       height: 20,
                                            //                                     ),
                                            //                                     Row(
                                            //                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            //                                       children: [
                                            //                                         InkWell(
                                            //                                           onTap: () {
                                            //                                             print("5");
                                            //                                             showDialog(
                                            //                                                 context: context,
                                            //                                                 builder: (_) => AlertDialog(
                                            //                                                         content: Container(
                                            //                                                       height: (MediaQuery.of(context).size.height) * 0.3,
                                            //                                                       decoration: const BoxDecoration(
                                            //                                                         //color: Colors.grey,
                                            //                                                         borderRadius: BorderRadius.all(Radius.circular(50)),
                                            //                                                         //color: Colors.orange
                                            //                                                       ),
                                            //                                                       child: Column(
                                            //                                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            //                                                         children: [
                                            //                                                           Row(
                                            //                                                             mainAxisAlignment: MainAxisAlignment.end,
                                            //                                                             children: [
                                            //                                                               IconButton(
                                            //                                                                   onPressed: () {
                                            //                                                                     Navigator.pop(context);
                                            //                                                                   },
                                            //                                                                   icon: const Icon(Icons.close))
                                            //                                                             ],
                                            //                                                           ),
                                            //                                                           const Text(
                                            //                                                             'Enter the weight of the package',
                                            //                                                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            //                                                           ),
                                            //                                                           Container(
                                            //                                                             height: (MediaQuery.of(context).size.height) * 0.05,
                                            //                                                             padding: const EdgeInsets.only(left: 15, right: 15),
                                            //                                                             decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                            //                                                             child: Row(
                                            //                                                               children: <Widget>[
                                            //                                                                 Flexible(
                                            //                                                                   child: TextField(
                                            //                                                                     controller: weightcontroller,
                                            //                                                                     decoration: const InputDecoration(hintText: 'Weight', border: InputBorder.none),
                                            //                                                                   ),
                                            //                                                                 ),
                                            //                                                                 const Expanded(
                                            //                                                                     child: Align(
                                            //                                                                   alignment: Alignment.centerRight,
                                            //                                                                   child: Text(
                                            //                                                                     'Kg',
                                            //                                                                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                                            //                                                                   ),
                                            //                                                                 ))
                                            //                                                               ],
                                            //                                                             ),
                                            //                                                           ),
                                            //                                                           InkWell(
                                            //                                                             onTap: () {
                                            //                                                               FirebaseFirestore db = FirebaseFirestore.instance;

                                            //                                                               final updateStatus = db.collection("Orders").doc(scheduledorderList[index].trackingId);
                                            //                                                               updateStatus.update({
                                            //                                                                 "weight": weightcontroller.text,
                                            //                                                                 "orderStatus": "picked"
                                            //                                                               }).then((value) {
                                            //                                                                 print("done");
                                            //                                                               });
                                            //                                                               //updateData(id1, id2, n),

                                            //                                                               showDialog(
                                            //                                                                   context: context,
                                            //                                                                   builder: (_) => AlertDialog(
                                            //                                                                           content: SizedBox(
                                            //                                                                         height: (MediaQuery.of(context).size.height) * 0.21,
                                            //                                                                         child: Column(
                                            //                                                                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            //                                                                           children: [
                                            //                                                                             Align(
                                            //                                                                                 alignment: Alignment.centerRight,
                                            //                                                                                 child: IconButton(
                                            //                                                                                     onPressed: () {
                                            //                                                                                       Navigator.pop(context);
                                            //                                                                                     },
                                            //                                                                                     icon: const Icon(Icons.close))),
                                            //                                                                             const Text(
                                            //                                                                               'You have Successfully Completed your pickup',
                                            //                                                                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            //                                                                               textAlign: TextAlign.center,
                                            //                                                                             ),
                                            //                                                                             const SizedBox(
                                            //                                                                               height: 20,
                                            //                                                                             ),
                                            //                                                                             Row(
                                            //                                                                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            //                                                                               children: [
                                            //                                                                                 InkWell(
                                            //                                                                                   onTap: () {
                                            //                                                                                     Navigator.push(_, MaterialPageRoute(builder: (context) => const HelloVendor()));
                                            //                                                                                   },
                                            //                                                                                   child: Container(
                                            //                                                                                     height: (MediaQuery.of(context).size.height) * 0.07,
                                            //                                                                                     width: (MediaQuery.of(context).size.width) * 0.65,
                                            //                                                                                     decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.orange),
                                            //                                                                                     child: const Center(child: Text('Go To Home', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15))),
                                            //                                                                                   ),
                                            //                                                                                 ),
                                            //                                                                               ],
                                            //                                                                             ),
                                            //                                                                           ],
                                            //                                                                         ),
                                            //                                                                       )));
                                            //                                                             },
                                            //                                                             child: Container(
                                            //                                                               height: (MediaQuery.of(context).size.height) * 0.07,
                                            //                                                               width: (MediaQuery.of(context).size.width) * 0.8,
                                            //                                                               decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.orange),
                                            //                                                               child: const Center(child: Text('Next', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22))),
                                            //                                                             ),
                                            //                                                           )
                                            //                                                         ],
                                            //                                                       ),
                                            //                                                     )));
                                            //                                           },
                                            //                                           child: Container(
                                            //                                             height: (MediaQuery.of(context).size.height) * 0.07,
                                            //                                             width: (MediaQuery.of(context).size.width) * 0.3,
                                            //                                             decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.orange),
                                            //                                             child: const Center(child: Text('Edit Weight', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15))),
                                            //                                           ),
                                            //                                         ),
                                            //                                         InkWell(
                                            //                                           onTap: () {
                                            //                                             FirebaseFirestore db = FirebaseFirestore.instance;

                                            //                                             final updateStatus = db.collection("Orders").doc(scheduledorderList[index].trackingId);
                                            //                                             updateStatus.update({
                                            //                                               "orderStatus": "picked"
                                            //                                             }).then((value) {
                                            //                                               print("done");
                                            //                                             });
                                            //                                             //updateData(id1, id2, n),
                                            //                                             showDialog(
                                            //                                                 context: context,
                                            //                                                 builder: (_) => AlertDialog(
                                            //                                                         content: SizedBox(
                                            //                                                       height: (MediaQuery.of(context).size.height) * 0.21,
                                            //                                                       child: Column(
                                            //                                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            //                                                         children: [
                                            //                                                           Align(
                                            //                                                               alignment: Alignment.centerRight,
                                            //                                                               child: IconButton(
                                            //                                                                   onPressed: () {
                                            //                                                                     Navigator.pop(context);
                                            //                                                                   },
                                            //                                                                   icon: const Icon(Icons.close))),
                                            //                                                           const Text(
                                            //                                                             'You have Successfully Completed your pickup',
                                            //                                                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            //                                                             textAlign: TextAlign.center,
                                            //                                                           ),
                                            //                                                           const SizedBox(
                                            //                                                             height: 20,
                                            //                                                           ),
                                            //                                                           Row(
                                            //                                                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            //                                                             children: [
                                            //                                                               InkWell(
                                            //                                                                 onTap: () {
                                            //                                                                   Navigator.push(_, MaterialPageRoute(builder: (context) => const HelloVendor()));
                                            //                                                                 },
                                            //                                                                 child: Container(
                                            //                                                                   height: (MediaQuery.of(context).size.height) * 0.07,
                                            //                                                                   width: (MediaQuery.of(context).size.width) * 0.65,
                                            //                                                                   decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.orange),
                                            //                                                                   child: const Center(child: Text('Go To Home', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15))),
                                            //                                                                 ),
                                            //                                                               ),
                                            //                                                             ],
                                            //                                                           ),
                                            //                                                         ],
                                            //                                                       ),
                                            //                                                     )));
                                            //                                             // Navigator.pop(context);
                                            //                                           },
                                            //                                           child: Container(
                                            //                                             height: (MediaQuery.of(context).size.height) * 0.07,
                                            //                                             width: (MediaQuery.of(context).size.width) * 0.3,
                                            //                                             decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.orange),
                                            //                                             child: const Center(child: Text('Yes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15))),
                                            //                                           ),
                                            //                                         ),
                                            //                                       ],
                                            //                                     ),
                                            //                                   ],
                                            //                                 ),
                                            //                               )))
                                            //                       : ScaffoldMessenger.of(
                                            //                               context)
                                            //                           .showSnackBar(
                                            //                               snackBar);
                                            //                 },
                                            //                 child: Container(
                                            //                   height: (MediaQuery.of(
                                            //                               context)
                                            //                           .size
                                            //                           .height) *
                                            //                       0.07,
                                            //                   width: (MediaQuery.of(
                                            //                               context)
                                            //                           .size
                                            //                           .width) *
                                            //                       0.8,
                                            //                   decoration: const BoxDecoration(
                                            //                       borderRadius:
                                            //                           BorderRadius.all(
                                            //                               Radius.circular(
                                            //                                   10)),
                                            //                       color: Colors
                                            //                           .orange),
                                            //                   child: const Center(
                                            //                       child: Text(
                                            //                           'Proceed',
                                            //                           style: TextStyle(
                                            //                               fontWeight: FontWeight
                                            //                                   .bold,
                                            //                               color: Colors
                                            //                                   .white,
                                            //                               fontSize:
                                            //                                   22))),
                                            //                 ),
                                            //               ),
                                            //             ],
                                            //           ),
                                            //         )));
                                          },
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                orderstatus == "dispatched"
                                                    ? "Deliver"
                                                    : "Dispatched",
                                                style: const TextStyle(
                                                    color: Colors.orange)),
                                          )),
                                    )
                                  ],
                                )
                              ],
                            ));
                      }))
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: const Center(
                      child: Text('No Picked up or Dispatched Orders'))),
          Expanded(
              child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                  bottom: (MediaQuery.of(context).size.height) * 0.02),
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(
                      (MediaQuery.of(context).size.height) * 0.04))),
              height: (MediaQuery.of(context).size.height) * 0.1,
              width: (MediaQuery.of(context).size.width) * 0.9,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(22))),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HelloVendor()));
                      },
                      icon: const Icon(Icons.home_filled),
                    ),
                  ),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.all(Radius.circular(22))),
                    child: IconButton(
                      onPressed: () {
                        //Navigator.push(context, MaterialPageRoute(builder:  (context) => const ScheduledOrders()));
                      },
                      icon: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(22))),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CompletedOrders()));
                      },
                      icon: const Icon(Icons.shopping_cart_outlined),
                    ),
                  ),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(22))),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfilePage()));
                      },
                      icon: const Icon(Icons.menu_rounded),
                    ),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
