import 'package:ecomapp/admin.dart';
import 'package:ecomapp/homepage.dart';
import 'package:ecomapp/listing.dart';
import 'package:flutter/material.dart';

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "intro",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 16, 2, 56),
      ),
      body: SafeArea(
          child: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>adminpannel(),
                      ));
                },
                child: Container(
                  child: Center(child: Text("Retailer")),
                  height: 200,
                  width: 200,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                child: TextButton(
                  onPressed: () {   Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => homepage(),
                      ));},
                  child: Container(
                    child: Center(child: Text("Customer")),
                    height: 200,
                    width: 200,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        color: Color.fromARGB(255, 31, 15, 75),
      )),
    );
  }
}
