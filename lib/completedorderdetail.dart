import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vendor_app/scheduledorders.dart';

import '404.dart';
import 'completedorders.dart';
import 'hello_vendor.dart';

class CompletedOrderDetail extends StatefulWidget {
  final orders;
  final user;
  const CompletedOrderDetail(
      {Key? key, required this.orders, required this.user})
      : super(key: key);

  @override
  State<CompletedOrderDetail> createState() => _CompletedOrderDetailState();
}

class _CompletedOrderDetailState extends State<CompletedOrderDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            color: const Color(0xffe5e5e5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () => {Navigator.pop(context)},
                              icon: const Icon(Icons.arrow_back_rounded)),
                          Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: const Text("Completed Orders",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23))),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    showMenu();
                    //Navigator.push(context, MaterialPageRoute(builder:  (context) => const CompletedOrderDetail()));
                  },
                  child: Container(
                      width: (MediaQuery.of(context).size.width) * 0.9,
                      padding: const EdgeInsets.all(25),
                      margin: EdgeInsets.only(
                          top: (MediaQuery.of(context).size.width) * 0.05),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              //  CircleAvatar(
                              //   radius: 35.0,
                              //   backgroundImage:
                              //   NetworkImage(widget.user.imgUrl),
                              //   backgroundColor: Colors.transparent,
                              // ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.user.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    widget.user.address,
                                    textAlign: TextAlign.start,
                                  )
                                ],
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.only(top: 15),
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 30, right: 30),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Color(0xff4BC600)),
                              child: const Text(
                                'Completed',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        padding: const EdgeInsets.only(top: 25, left: 25),
                        child: const Text(
                          'Order Details',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ))),
                Container(
                    width: (MediaQuery.of(context).size.width) * 0.9,
                    padding: const EdgeInsets.all(25),
                    margin: EdgeInsets.only(
                        top: (MediaQuery.of(context).size.width) * 0.05),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Customer Contact Details',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pickup Address  : '),
                              Expanded(
                                  child: Text(widget.orders.pickupAdrs,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))
                            ]),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Delivery Address  : '),
                              Expanded(
                                  child: Text(widget.orders.deliveryAdrs,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))
                            ]),
                      ],
                    )),
                Container(
                    width: (MediaQuery.of(context).size.width) * 0.9,
                    padding: const EdgeInsets.all(25),
                    margin: EdgeInsets.only(
                        top: (MediaQuery.of(context).size.width) * 0.05),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Date & Time',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pickup Date  : '),
                              Expanded(
                                  child: Text(widget.orders.pickupTime,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))
                            ]),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Pickup Time  : '),
                              Expanded(
                                  child: Text('01:00 PM',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))
                            ]),
                      ],
                    )),
                Container(
                    width: (MediaQuery.of(context).size.width) * 0.9,
                    padding: const EdgeInsets.all(25),
                    margin: EdgeInsets.only(
                        top: (MediaQuery.of(context).size.width) * 0.05),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Package Details',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Length  : '),
                              Expanded(
                                  child: Text('${widget.orders.length} cm',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))
                            ]),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Breadth  : '),
                              Expanded(
                                  child: Text('${widget.orders.breadth} cm',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))
                            ]),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Height  : '),
                              Expanded(
                                  child: Text('${widget.orders.pickupAdrs} cm',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))
                            ]),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Weight of the Package : '),
                              Expanded(
                                  child: Text('${widget.orders.weight} kg',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))
                            ]),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Content of the Package : '),
                              Expanded(
                                  child: Text(widget.orders.packageContent,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))
                            ]),
                      ],
                    )),
                Container(
                    width: (MediaQuery.of(context).size.width) * 0.9,
                    padding: const EdgeInsets.all(25),
                    margin: EdgeInsets.only(
                        top: (MediaQuery.of(context).size.width) * 0.05),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Package Value',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Value of the Package  : '),
                              Expanded(
                                  child: Text('${widget.orders.packageValue}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))
                            ]),
                      ],
                    )),
                Container(
                    width: (MediaQuery.of(context).size.width) * 0.9,
                    padding: const EdgeInsets.all(25),
                    margin: EdgeInsets.only(
                        top: (MediaQuery.of(context).size.width) * 0.05),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Shipment Type',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pickup Date  : '),
                              Expanded(
                                  child: Text(widget.orders.pickupTime,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))
                            ]),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Type of the Shipment  : '),
                              Expanded(
                                  child: Text(widget.orders.shipmentType,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))
                            ]),
                      ],
                    )),
                Align(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(22))),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Error404Page()));
                            },
                            icon: const Icon(
                              Icons.home_filled,
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
                              color: Colors.orangeAccent,
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
                            icon: const Icon(Icons.shopping_cart_outlined,
                                color: Colors.white),
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
                              //Navigator.push(context, MaterialPageRoute(builder:  (context) => const HelloVendor()));
                            },
                            icon: const Icon(
                              Icons.menu_rounded,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
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
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.04),
            //height: 0.75,
            height: MediaQuery.of(context).size.height * 0.7,

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
                        Row(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.height * 0.1,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 5, color: Colors.white),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  image: const DecorationImage(
                                      image: NetworkImage(
                                          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                                      fit: BoxFit.fill)),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Raju Verma',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  '6358563934',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                )
                              ],
                            )
                          ],
                        ),
                        Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.05),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Colors.white30))),
                            child: ListTile(
                              leading: Icon(Icons.phone_locked),
                              //Icon(Icons.phone_locked),
                              title: Text(
                                'Contact Us',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                        Container(
                            //padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Colors.white30))),
                            child: ListTile(
                              leading: Icon(Icons.checklist),
                              //Icon(Icons.phone_locked),
                              title: Text(
                                'Terms & Conditions',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                        Container(
                            //padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
                            decoration: const BoxDecoration(
                                //border: Border(bottom: BorderSide(width: 1,color: Colors.white))
                                ),
                            child: ListTile(
                              leading: Icon(Icons.logout),
                              //Icon(Icons.phone_locked),
                              title: Text(
                                'Logout',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                      ],
                    )),
              ],
            ),
          );
        });
  }
}
