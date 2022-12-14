import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/profile.dart';
import 'package:vendor_app/scheduledorders.dart';
import 'package:vendor_app/user_model.dart';
import '404.dart';
import 'completedorderdetail.dart';
import 'hello_vendor.dart';
import 'ordersmodel.dart';

class CompletedOrders extends StatefulWidget {
  const CompletedOrders({Key? key}) : super(key: key);

  @override
  State<CompletedOrders> createState() => _CompletedOrdersState();
}

class _CompletedOrdersState extends State<CompletedOrders> {
  bool isagreed = false;
  String vendorid = '';
  User? currentUser = FirebaseAuth.instance.currentUser;
  var userData;
  getVendor() async {
    await FirebaseFirestore.instance
        .collection('Vendors')
        .where('phone', isEqualTo: currentUser?.phoneNumber?.substring(3))
        .get()
        .then((value) {
      for (var data1 in value.docs) {
        setState(() {
          data = data1;

          vendorid = data1['vid'];
        });
      }
    });
  }

  late OrderModel completedOrderModel;
  List<OrderModel> completedOrderList = [];
  getCompletedOrders() async {
    await FirebaseFirestore.instance
        .collection('Orders')
        .where('vid', isEqualTo: vendorid)
        .where('orderStatus', isEqualTo: 'complete')
        .get()
        .then((value) {
      completedOrderList.clear();
      for (var data1 in value.docs) {
        completedOrderModel = OrderModel.fromMap(data1.data());

        setState(() {
          completedOrderList.add(completedOrderModel);

          data = data1;
        });
      }
      setState(() {
        completedOrderList = completedOrderList.reversed.toList();
      });
    });
  }

  late UserModel userModel;
  String name = '';
  String address = '';
  String image = '';
  List<UserModel> usersList = [];

  Map dataUser = {};
  Future<Map<dynamic, dynamic>> getUsers(int index) async {
    Map map = {};
    await FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: completedOrderList[index].uid)
        .get()
        .then((value) {
      usersList.clear();
      for (var data1 in value.docs) {
        userModel = UserModel.fromMap(data1.data());
        //
        setState(() {
          dataUser = data1.data();
          // usersList.add(dataUser);
          map = {
            "name": data1['name'],
            'address': data1['address'],
            'image': data1['image']
          };
          usersList.add(userModel);
        });
      }
    });
    return map;
  }

  @override
  Widget build(BuildContext context) {
    getVendor();
    getCompletedOrders();

    return Scaffold(
      body: Column(
        children: [
          InkWell(
            child: Container(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () => {Navigator.pop(context)},
                          icon: const Icon(Icons.arrow_back_rounded)),
                      const Text("Completed Orders",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 23)),
                    ],
                  ),
                ),
                completedOrderList.isNotEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ListView.builder(
                            itemCount: completedOrderList.length,
                            itemBuilder: (context, index) {
                              return FutureBuilder(
                                  future: getUsers(index),
                                  builder: (context, snapshot) {
                                    var userdata = {};
                                    if (snapshot.hasData) {
                                      userdata = snapshot.data
                                          as Map<dynamic, dynamic>;
                                    }
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CompletedOrderDetail(
                                                      user: usersList[0],
                                                      orders:
                                                          completedOrderList[
                                                              index],
                                                    )));
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(top: 25),
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width) *
                                              0.9,
                                          padding: const EdgeInsets.all(25),
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
                                                  CircleAvatar(
                                                    radius: 35.0,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            userdata['image']),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        userdata['name'],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 23),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      Text(
                                                        userdata['address'],
                                                        textAlign:
                                                            TextAlign.start,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                        'Pickup Address  : '),
                                                    Expanded(
                                                        child: Text(
                                                            completedOrderList[
                                                                    index]
                                                                .pickupAdrs))
                                                  ]),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(top: 15),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          bottom: 5,
                                                          left: 30,
                                                          right: 30),
                                                  decoration:
                                                      const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          color: Color(
                                                              0xff4BC600)),
                                                  child: const Text(
                                                    'Completed',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    );
                                  });
                            }),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: const Center(child: Text('No Completed Orders')))
              ],
            )),
          ),
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
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(22))),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ScheduledOrders()));
                      },
                      icon: const Icon(Icons.access_time_rounded),
                    ),
                  ),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.all(Radius.circular(22))),
                    child: IconButton(
                      onPressed: () {
                        //Navigator.push(context, MaterialPageRoute(builder:  (context) => const CompletedOrders()));
                      },
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
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
