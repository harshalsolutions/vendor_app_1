import 'dart:developer';
//import 'package:vendor_app/ordersmodel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/ordersmodel.dart';
import 'package:vendor_app/profile.dart';
import 'package:vendor_app/scheduledorderdetail.dart';
import 'package:vendor_app/scheduledorders.dart';
import 'package:vendor_app/user_model.dart';

import 'completedorders.dart';

class HelloVendor extends StatefulWidget {
  final phone;

  const HelloVendor({Key? key, this.phone}) : super(key: key);

  @override
  State<HelloVendor> createState() => _HelloVendorState();
}

var data;

class _HelloVendorState extends State<HelloVendor> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String vendorid = '';
  User? currentUser = FirebaseAuth.instance.currentUser;

  //final Stream<QuerySnapshot> vendors=FirebaseFirestore.instance.collection('vendors').snapshots();
  TextEditingController weightcontroller = TextEditingController();
  initState() {
    _getOrders();
    _getVendor();
    super.initState();
  }

  _getVendor() async {
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
          //print('data of vid is ${data.toString()}');
        });
      }
    });

    //print(data[0][0]['name']);
  }

  late OrderModel ordermodel;
  List<OrderModel> orderList = [];

  _getOrders() async {
    await FirebaseFirestore.instance
        .collection('Orders')
        .where('vid', isEqualTo: vendorid)
        .where('orderStatus', isEqualTo: 'waiting')
        // .where('mobile',isEqualTo: widget.phone)
        .get()
        .then((value) {
      orderList.clear();
      for (var data1 in value.docs) {
        //log(' the of orders is this ${data1.data().toString()}');
        ordermodel = OrderModel?.fromMap(data1.data());
        //print('similar data are ${data1.data().toString()}');
        setState(() {
          orderList.add(ordermodel);
          data = data1;
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
        .where('orderStatus', isEqualTo: 'accepted')
        .get()
        .then((value) {
      scheduledorderList.clear();
      for (var data1 in value.docs) {
        scheduledordermodel = OrderModel?.fromMap(data1.data());
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

  bool isagreed = false;

  @override
  Widget build(BuildContext context) {
    getScheduledOrders();

    _getVendor();
    _getOrders();

    //final Stream<QuerySnapshot> orders=FirebaseFirestore.instance.collection('orders')/*.where('vid',isEqualTo: FirebaseAuth.instance.currentUser.uid)*/.where('orderStatus',isEqualTo: 'waiting').snapshots();
    /*print(data['vid']);*/
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          //margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height)*0.3),
          //height: (MediaQuery.of(context).size.height),
          child: Center(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 50, left: 20),
                        child: const Text(
                          'Hello Vendor',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 5, left: 20),
                        child: const Text(
                          'DHL Employee',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black26),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20, left: 20),
                        child: const Text(
                          'New Orders',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                orderList.isNotEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: ListView.builder(
                            itemCount: orderList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(
                                  top: (MediaQuery.of(context).size.height) *
                                      0.03,
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      //margin: EdgeInsets.only(top:(MediaQuery.of(context).size.height)*0.03,),
                                      height:
                                          (MediaQuery.of(context).size.height) *
                                              0.32,
                                      width:
                                          (MediaQuery.of(context).size.width) *
                                              0.65,
                                      decoration: BoxDecoration(
                                          color: Colors.orangeAccent.shade100,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15))),
                                    ),
                                    Container(
                                      height:
                                          (MediaQuery.of(context).size.height) *
                                              0.26,
                                      width:
                                          (MediaQuery.of(context).size.width) *
                                              0.8,
                                      decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          top: (MediaQuery.of(context)
                                                  .size
                                                  .height) *
                                              0.02,
                                        ),
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                child: Container(
                                                  width: (MediaQuery.of(context)
                                                          .size
                                                          .width) *
                                                      0.6,
                                                  height:
                                                      (MediaQuery.of(context)
                                                              .size
                                                              .height) *
                                                          0.15,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 30),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15))),
                                                  child: FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          10),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    height: 20,
                                                                    width: 20,
                                                                    decoration: const BoxDecoration(
                                                                        color: Colors
                                                                            .orange,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))),
                                                                  ),
                                                                  Container(
                                                                    width: 3,
                                                                    height: 30,
                                                                    color: Colors
                                                                        .orangeAccent,
                                                                  ),
                                                                  Container(
                                                                    height: 20,
                                                                    width: 20,
                                                                    decoration: const BoxDecoration(
                                                                        color: Colors
                                                                            .orange,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Column(
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Text(orderList[
                                                                            index]
                                                                        .pickupAdrs),
                                                                    Text(orderList[
                                                                            index]
                                                                        .pickupPin)
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Text(orderList[
                                                                            index]
                                                                        .deliveryAdrs),
                                                                    Text(orderList[
                                                                            index]
                                                                        .deliveryPin)
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            const Text(
                                                                'Order Value',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black26)),
                                                            Text(
                                                              '₹ ${orderList[index].packageValue}',
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            const Text(
                                                                'Applicable\n Weight',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black26)),
                                                            Text(
                                                                '${orderList[index].weight} Kg',
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: SizedBox(
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width) *
                                                    0.6,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            20)),
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey)),
                                                        child: const Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            20)),
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey)),
                                                        child: const Icon(
                                                          Icons.currency_rupee,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            20)),
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey)),
                                                        child: const Icon(
                                                          Icons
                                                              .backpack_outlined,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width) *
                                                    0.6,
                                                margin: const EdgeInsets.only(
                                                    bottom: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      '1 hour ago',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            FirebaseFirestore
                                                                db =
                                                                FirebaseFirestore
                                                                    .instance;

                                                            final updateStatus = db
                                                                .collection(
                                                                    "Orders")
                                                                .doc(orderList[
                                                                        index]
                                                                    .trackingId);
                                                            updateStatus.update({
                                                              "orderStatus":
                                                                  "rejected"
                                                            }).then(
                                                                (value) =>
                                                                    log(""),
                                                                onError: (e) =>
                                                                    log("Error updating document $e"));

                                                            // FirebaseFirestore.instance.collection('orders').where('trackingId',isEqualTo: Orders.docs[index]['trackingId']).do
                                                            // Orders.docs[index]['trackingId'].update(
                                                            //     {'orderStatus': 'rejected'});
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          20)),
                                                              border: Border.all(
                                                                  width: 2,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            child: IconButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: const Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 30),
                                                        InkWell(
                                                          onTap: () {
                                                            FirebaseFirestore
                                                                db =
                                                                FirebaseFirestore
                                                                    .instance;

                                                            final updateStatus = db
                                                                .collection(
                                                                    "Orders")
                                                                .doc(orderList[
                                                                        index]
                                                                    .trackingId);
                                                            updateStatus.update({
                                                              "orderStatus":
                                                                  "accepted"
                                                            }).then(
                                                                (value) =>
                                                                    log(""),
                                                                onError: (e) =>
                                                                    log("Error updating document $e"));
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          20)),
                                                              border: Border.all(
                                                                  width: 2,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            child: const Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }))
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.37,
                        child: const Center(child: Text('No New Orders'))),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text("Scheduled Orders",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23)),
                            ],
                          ),
                        ),
                        scheduledorderList.isNotEmpty
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: ListView.builder(
                                    itemCount: scheduledorderList.length,
                                    itemBuilder: (context, index) {
                                      // print(
                                      //     'kkkkkkkkkkkkkkkkkkkkkkkk${scheduledorderList)}');
                                      getUsers(index);
                                      return InkWell(
                                        child: Container(
                                            width: (MediaQuery.of(context)
                                                    .size
                                                    .width) *
                                                0.9,
                                            padding: const EdgeInsets.all(25),
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    // CircleAvatar(
                                                    //   radius: 35.0,
                                                    //   backgroundImage:
                                                    //       NetworkImage(
                                                    //           usersList[index]
                                                    //               .imgUrl),
                                                    //   backgroundColor:
                                                    //       Colors.transparent,
                                                    // ),
                                                    const SizedBox(width: 20),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          usersList[0]
                                                              .name
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 23),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                        Text(
                                                          usersList[0]
                                                              .address
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.start,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                          'Pickup Address  : '),
                                                      Expanded(
                                                          child: Text(
                                                              scheduledorderList[
                                                                      index]
                                                                  .pickupAdrs
                                                                  .toString()))
                                                    ]),
                                                Row(children: [
                                                  const Text('Pickup Date  : '),
                                                  Expanded(
                                                      child: Text(
                                                          scheduledorderList[
                                                                  index]
                                                              .pickupTime
                                                              .toString()))
                                                ]),
                                                Row(children: [
                                                  const Text('Pickup Time  : '),
                                                  Row(
                                                    children: [
                                                      const Text('11:45 PM'),
                                                      const SizedBox(width: 30),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        decoration: const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20)),
                                                            color:
                                                                Colors.orange),
                                                        child: const Text(
                                                            'Due in 2 Hours'),
                                                      )
                                                    ],
                                                  )
                                                ]),
                                                const Divider(
                                                  color: Colors.orange,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ScheduledOrderDetail(
                                                                          orders:
                                                                              scheduledorderList[index],
                                                                          users:
                                                                              usersList[0],
                                                                        )));
                                                      },
                                                      child: const Text(
                                                          'View Details',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .orange)),
                                                    ),
                                                    Expanded(
                                                      child: InkWell(
                                                          onTap: () {
                                                            //Navigator.push(context, MaterialPageRoute(builder:  (context) => const ProfilePage()));
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  bool
                                                                      isAggreed =
                                                                      false;
                                                                  return StatefulBuilder(
                                                                      builder:
                                                                          (context,
                                                                              setState) {
                                                                    return AlertDialog(
                                                                        content:
                                                                            Container(
                                                                      height: (MediaQuery.of(context)
                                                                              .size
                                                                              .height) *
                                                                          0.5,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        //color: Colors.grey,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(50)),
                                                                        //color: Colors.orange
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              const CircleAvatar(
                                                                                radius: 35.0,
                                                                                backgroundImage: NetworkImage('https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                                                                                backgroundColor: Colors.transparent,
                                                                              ),
                                                                              const SizedBox(width: 20),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    usersList[0].name.toString(),
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
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
                                                                          Row(children: [
                                                                            const Text('Pickup Address  : '),
                                                                            Expanded(child: Text(scheduledorderList[index].pickupAdrs.toString(), style: const TextStyle(fontWeight: FontWeight.bold)))
                                                                          ]),
                                                                          Row(children: [
                                                                            const Text('Pickup Date  : '),
                                                                            Expanded(
                                                                                child: Text(
                                                                              scheduledorderList[index].pickupTime.toString(),
                                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                                            ))
                                                                          ]),
                                                                          Row(children: [
                                                                            const Text('Length  : '),
                                                                            Expanded(
                                                                                child: Text(
                                                                              '${scheduledorderList[index].length.toString()} cm',
                                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                                            ))
                                                                          ]),
                                                                          Row(children: [
                                                                            const Text('Breadth  : '),
                                                                            Expanded(
                                                                                child: Text(
                                                                              '${scheduledorderList[index].breadth.toString()} cm',
                                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                                            ))
                                                                          ]),
                                                                          Row(children: [
                                                                            const Text('Height  : '),
                                                                            Expanded(
                                                                                child: Text(
                                                                              '${scheduledorderList[index].height.toString()} cm',
                                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                                            ))
                                                                          ]),
                                                                          Row(children: [
                                                                            const Text('Weight of the package  : '),
                                                                            Expanded(
                                                                                child: Text(
                                                                              '${scheduledorderList[index].weight.toString()} kg',
                                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                                            ))
                                                                          ]),
                                                                          Row(children: [
                                                                            const Text('Content of the package  : '),
                                                                            Expanded(
                                                                                child: Text(
                                                                              scheduledorderList[index].packageContent.toString(),
                                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                                            ))
                                                                          ]),
                                                                          Row(children: const [
                                                                            Text('Mode of Payment  : '),
                                                                            Expanded(
                                                                                child: Text(
                                                                              'COD',
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ))
                                                                          ]),
                                                                          Row(children: [
                                                                            const Text('Amount  : '),
                                                                            Expanded(
                                                                                child: Text(
                                                                              '${scheduledorderList[index].packageValue}',
                                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                                            ))
                                                                          ]),
                                                                          Row(children: [
                                                                            const Text('Type of shipment  : '),
                                                                            Expanded(
                                                                                child: Text(
                                                                              scheduledorderList[index].shipmentType.toString(),
                                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                                            ))
                                                                          ]),
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
                                                                                  decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
                                                                                  child: Icon(
                                                                                    Icons.check,
                                                                                    color: isagreed ? Colors.orange : Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const Text("I have received the cash")
                                                                            ],
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              var snackBar = const SnackBar(content: Text('Please Check the Box'));
                                                                              isagreed
                                                                                  ? showDialog(
                                                                                      context: context,
                                                                                      builder: (_) => AlertDialog(
                                                                                              content: Container(
                                                                                            height: (MediaQuery.of(context).size.height) * 0.21,
                                                                                            decoration: const BoxDecoration(),
                                                                                            child: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                              children: [
                                                                                                Align(
                                                                                                    alignment: Alignment.centerRight,
                                                                                                    child: IconButton(
                                                                                                        onPressed: () {
                                                                                                          print("2");
                                                                                                          Navigator.pop(context);
                                                                                                        },
                                                                                                        icon: const Icon(Icons.close))),
                                                                                                const Text(
                                                                                                  'Confirmed the weight of the parcel?',
                                                                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                                                                  textAlign: TextAlign.center,
                                                                                                ),
                                                                                                const SizedBox(
                                                                                                  height: 20,
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                  children: [
                                                                                                    InkWell(
                                                                                                      onTap: () {
                                                                                                        showDialog(
                                                                                                            context: context,
                                                                                                            builder: (_) => AlertDialog(
                                                                                                                    content: Container(
                                                                                                                  height: (MediaQuery.of(context).size.height) * 0.3,
                                                                                                                  decoration: const BoxDecoration(
                                                                                                                    //color: Colors.grey,
                                                                                                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                                                                                                    //color: Colors.orange
                                                                                                                  ),
                                                                                                                  child: Column(
                                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                                                    children: [
                                                                                                                      Row(
                                                                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                                                                        children: [
                                                                                                                          IconButton(
                                                                                                                              onPressed: () {
                                                                                                                                print('3');
                                                                                                                                Navigator.pop(context);
                                                                                                                              },
                                                                                                                              icon: const Icon(Icons.close))
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                      const Text(
                                                                                                                        'Enter the weight of the package',
                                                                                                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                                                                                      ),
                                                                                                                      Container(
                                                                                                                        height: (MediaQuery.of(context).size.height) * 0.05,
                                                                                                                        padding: const EdgeInsets.only(left: 15, right: 15),
                                                                                                                        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                                                                                        child: Row(
                                                                                                                          children: <Widget>[
                                                                                                                            Flexible(
                                                                                                                              child: TextField(
                                                                                                                                controller: weightcontroller,
                                                                                                                                decoration: const InputDecoration(hintText: 'Weight', border: InputBorder.none),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            const Expanded(
                                                                                                                                child: Align(
                                                                                                                              alignment: Alignment.centerRight,
                                                                                                                              child: Text(
                                                                                                                                'Kg',
                                                                                                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                                                                                                                              ),
                                                                                                                            ))
                                                                                                                          ],
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      InkWell(
                                                                                                                        onTap: () async {
                                                                                                                          FirebaseFirestore db = FirebaseFirestore.instance;

                                                                                                                          final updateStatus = db.collection("Orders").doc(scheduledorderList[index].trackingId);
                                                                                                                          await updateStatus.update({
                                                                                                                            "weight": weightcontroller.text,
                                                                                                                            "orderStatus": "picked"
                                                                                                                          }).then((value) {
                                                                                                                            print("done");
                                                                                                                          });
                                                                                                                          //updateData(id1, id2, n),

                                                                                                                          showDialog(
                                                                                                                              context: context,
                                                                                                                              builder: (_) => AlertDialog(
                                                                                                                                      content: SizedBox(
                                                                                                                                    height: (MediaQuery.of(context).size.height) * 0.21,
                                                                                                                                    child: Column(
                                                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                                                                      children: [
                                                                                                                                        Align(
                                                                                                                                            alignment: Alignment.centerRight,
                                                                                                                                            child: IconButton(
                                                                                                                                                onPressed: () {
                                                                                                                                                  Navigator.pop(context);
                                                                                                                                                },
                                                                                                                                                icon: const Icon(Icons.close))),
                                                                                                                                        const Text(
                                                                                                                                          'You have Successfully Completed your pickup',
                                                                                                                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                                                                                                          textAlign: TextAlign.center,
                                                                                                                                        ),
                                                                                                                                        const SizedBox(
                                                                                                                                          height: 20,
                                                                                                                                        ),
                                                                                                                                        Row(
                                                                                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                                                          children: [
                                                                                                                                            InkWell(
                                                                                                                                              onTap: () {
                                                                                                                                                Navigator.push(_, MaterialPageRoute(builder: (context) => const HelloVendor()));
                                                                                                                                              },
                                                                                                                                              child: Container(
                                                                                                                                                height: (MediaQuery.of(context).size.height) * 0.07,
                                                                                                                                                width: (MediaQuery.of(context).size.width) * 0.65,
                                                                                                                                                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.orange),
                                                                                                                                                child: const Center(child: Text('Go To Home', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15))),
                                                                                                                                              ),
                                                                                                                                            ),
                                                                                                                                          ],
                                                                                                                                        ),
                                                                                                                                      ],
                                                                                                                                    ),
                                                                                                                                  )));
                                                                                                                        },
                                                                                                                        child: Container(
                                                                                                                          height: (MediaQuery.of(context).size.height) * 0.07,
                                                                                                                          width: (MediaQuery.of(context).size.width) * 0.8,
                                                                                                                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.orange),
                                                                                                                          child: const Center(child: Text('Next', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22))),
                                                                                                                        ),
                                                                                                                      )
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                )));
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        height: (MediaQuery.of(context).size.height) * 0.07,
                                                                                                        width: (MediaQuery.of(context).size.width) * 0.3,
                                                                                                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.orange),
                                                                                                        child: const Center(child: Text('Edit Weight', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15))),
                                                                                                      ),
                                                                                                    ),
                                                                                                    InkWell(
                                                                                                      onTap: () {
                                                                                                        FirebaseFirestore db = FirebaseFirestore.instance;

                                                                                                        final updateStatus = db.collection("Orders").doc(scheduledorderList[index].trackingId);
                                                                                                        updateStatus.update({"orderStatus": "picked"}).then((value) {
                                                                                                          print("done");
                                                                                                        });
                                                                                                        //updateData(id1, id2, n),
                                                                                                        showDialog(
                                                                                                            context: context,
                                                                                                            builder: (_) => AlertDialog(
                                                                                                                    content: SizedBox(
                                                                                                                  height: (MediaQuery.of(context).size.height) * 0.21,
                                                                                                                  child: Column(
                                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                                                    children: [
                                                                                                                      Align(
                                                                                                                          alignment: Alignment.centerRight,
                                                                                                                          child: IconButton(
                                                                                                                              onPressed: () {
                                                                                                                                Navigator.pop(context);
                                                                                                                              },
                                                                                                                              icon: const Icon(Icons.close))),
                                                                                                                      const Text(
                                                                                                                        'You have Successfully Completed your pickup',
                                                                                                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                                                                                        textAlign: TextAlign.center,
                                                                                                                      ),
                                                                                                                      const SizedBox(
                                                                                                                        height: 20,
                                                                                                                      ),
                                                                                                                      Row(
                                                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                                        children: [
                                                                                                                          InkWell(
                                                                                                                            onTap: () {
                                                                                                                              Navigator.push(_, MaterialPageRoute(builder: (context) => const HelloVendor()));
                                                                                                                            },
                                                                                                                            child: Container(
                                                                                                                              height: (MediaQuery.of(context).size.height) * 0.07,
                                                                                                                              width: (MediaQuery.of(context).size.width) * 0.65,
                                                                                                                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.orange),
                                                                                                                              child: const Center(child: Text('Go To Home', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15))),
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                )));
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        height: (MediaQuery.of(context).size.height) * 0.07,
                                                                                                        width: (MediaQuery.of(context).size.width) * 0.3,
                                                                                                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.orange),
                                                                                                        child: const Center(child: Text('Yes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15))),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          )))
                                                                                  : ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: (MediaQuery.of(context).size.height) * 0.07,
                                                                              width: (MediaQuery.of(context).size.width) * 0.8,
                                                                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.orange),
                                                                              child: const Center(child: Text('Proceed', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22))),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ));
                                                                  });
                                                                });
                                                          },
                                                          child: const Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                                'Pick Order',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .orange)),
                                                          )),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )),
                                      );
                                    }),
                              )
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: const Center(
                                    child: Text('No Scheduled Orders'))),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(
                      bottom: (MediaQuery.of(context).size.height) * 0.02,
                      top: (MediaQuery.of(context).size.height) * 0.02),
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
                                color: Colors.orangeAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22))),
                            child: IconButton(
                              onPressed: () {
                                //Navigator.push(context, MaterialPageRoute(builder:  (context) => const Error404Page()));
                              },
                              icon: const Icon(
                                Icons.home_filled,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            decoration: const BoxDecoration(
                                color: Colors.orange,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22))),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ScheduledOrders()));
                              },
                              icon: const Icon(Icons.access_time_rounded),
                            ),
                          ),
                          Container(
                            height: 40,
                            decoration: const BoxDecoration(
                                color: Colors.orange,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22))),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CompletedOrders()));
                              },
                              icon: const Icon(Icons.shopping_cart_outlined),
                            ),
                          ),
                          Container(
                            height: 40,
                            decoration: const BoxDecoration(
                                color: Colors.orange,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22))),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ProfilePage()));
                              },
                              icon: const Icon(Icons.menu_rounded),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
