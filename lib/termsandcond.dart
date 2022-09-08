//import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
//import 'package:vendor_app/loader.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'scheduledorders.dart';
import 'completedorders.dart';
//import '404.dart';
import 'hello_vendor.dart';
class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Text('Terms and Conditions',textAlign: TextAlign.start,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            /*ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Loader()));

            }, child: Text('loader')),*/


            Expanded(
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child:Container(
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
                                //Navigator.push(context, MaterialPageRoute(builder:  (context) => const HelloVendor()));
                              },
                              icon: const Icon(Icons.home_filled,),
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
                                color: Colors.orange,
                                borderRadius: BorderRadius.all(Radius.circular(22))
                            ),
                            child: IconButton(
                              onPressed: (){
                                //Navigator.push(context, MaterialPageRoute(builder:  (context) => const HelloVendor()));
                              },
                              icon: const Icon(Icons.menu_rounded),
                            ),
                          ),


                        ],
                      ),
                  ),
                )
            )


          ],
        ),
      ) ,
    );
  }
}
