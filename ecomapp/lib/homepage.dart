import 'dart:convert';

import 'package:ecomapp/api.dart';
import 'package:ecomapp/todo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<Todo> todo = [];
  void fetchdata() async {
    try {
      http.Response response = await http.get(Uri.parse(api));
      var jsondata = response.body;
      var data = json.decode(jsondata);
      data.forEach((todo1) {
        Todo t = Todo(
            id: todo1['id'],
            price: todo1['price'],
            stock_quantity: todo1['stock_quantity'],
            sku: todo1['sku'],
            is_active: todo1['is_active'],
            product: todo1['product']);
        todo.add(t);
      });

      print(todo.length);
    } catch (e) {
      print("error found $e");
    }
  }

  void senddata(String val) async {
    try {
      http.Response response = await http.post(
        Uri.parse(api2),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{"name": val}),
      );
    } catch (e) {
      print("erroe$e");
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        
         fetchdata();
        // Change state after 5 seconds
      }
      );
    });
    
  }

  TextEditingController contro = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ecom App",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 16, 2, 56),
      ),
      body: SafeArea(
        child: Container(
          // child: TextField(
          //   controller: contro,
          // ),
          child: ListView.builder(
            itemCount: todo.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 300,
                  color: Color.fromARGB(255, 31, 15, 75),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo[index].id.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          todo[index].is_active.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          todo[index].price.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          todo[index].product.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          todo[index].sku.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          todo[index].stock_quantity.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          color: Color.fromARGB(255, 54, 43, 94),
        ),
      ),
      bottomNavigationBar: TextButton(
        onPressed: () {
          // senddata(contro.text);
          // fetchdata();
        },
        child: Text('add'),
      ),
    );
  }
}
