import 'package:flutter/material.dart';

class Error429Page extends StatefulWidget {
  const Error429Page({Key? key}) : super(key: key);

  @override
  State<Error429Page> createState() => _Error429PageState();
}

class _Error429PageState extends State<Error429Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.3,
                width: MediaQuery.of(context).size.width*0.8,
                color: Colors.orange,
                child: Image.asset('assets/error429.png'),
              ),
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder:  (context) => const ));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width*0.8,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),

                  decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child:  Center(child: Text('Go Home',style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold))),
                ),
              ),
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
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.all(Radius.circular(22))
                            ),
                            child: IconButton(
                              onPressed: (){

                              },
                              icon: const Icon(Icons.home_filled,color: Colors.white,),
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

                              },
                              icon: const Icon(Icons.access_time_rounded),
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
        ),
      ),
    );
  }
}
