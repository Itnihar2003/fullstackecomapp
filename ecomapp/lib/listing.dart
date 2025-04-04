import 'dart:convert';

import 'package:ecomapp/api.dart';
import 'package:ecomapp/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class Listing extends StatefulWidget {
  const Listing({super.key});

  @override
  State<Listing> createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  void senddata(String brandname) async {
    try {
      http.Response response = await http.post(
        Uri.parse(api2),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{"name": brandname}),
      );
      if (response.statusCode == 201) {
        print("successful");
      } else {
        print("something went wrong");
      }
    } catch (e) {
      print("$e");
    }
  }

  void sendcategorydata(String catename, int? parent) async {
    try {
      print(catename);
      print(parent);
      http.Response response = await http.post(
        Uri.parse(api3),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, dynamic>{"name": catename, " parent": parent}),
      );
      if (response.statusCode == 201) {
        print("successful");
      } else {
        print("something went wrong in category");
      }
    } catch (e) {
      print("$e");
    }
  }

  String? selectedBrand;
  String? selectedcategory;
  String? selectedsubcategory;
  String? selectedcolour;
  List<Brand> brandlist = [];
  List<Category> categorylist = [];
  bool isValueInList = false;
  int cateid = 0;
  int subcateid = 0;
  int treeid = 0;
  int treeid2 = 0;
  TextEditingController contol2 = TextEditingController();
  void getbrands() async {
    try {
      http.Response response = await http.get(Uri.parse(api2));
      var jsondata = response.body;
      var data = json.decode(jsondata);
      setState(() {
        data.forEach((brand1) {
          Brand b = Brand(id: brand1['id'], name: brand1['name']);
          brandlist.add(b);
        });
      });
    } catch (e) {
      print("$e");
    }
  }

  void getcategory() async {
    try {
      http.Response response = await http.get(Uri.parse(api3));
      var jsondata = response.body;
      var data = json.decode(jsondata);

      setState(() {
        data.forEach((cate1) {
          Category c = Category(
              id: cate1['id'],
              name: cate1['name'],
              lft: cate1['lft'],
              rght: cate1['rght'],
              tree_id: cate1['tree_id'],
              level: cate1['level'],
              parent: cate1['parent']);
          categorylist.add(c);
        });
      });
    } catch (e) {
      print("error$e");
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getbrands();
      getcategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> uniquebrand =
        brandlist.map((brand) => brand.name).toSet().toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add data",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 16, 2, 56),
      ),
      body: SafeArea(
        child: Container(
          color: Color.fromARGB(255, 31, 15, 75),
          child: ListView(
            children: [
              ElevatedButton(onPressed: getcategory, child: Text("rferesh")),
              Deco(
                brandlist: brandlist,
                getbrands: getbrands,
                selectedBrand: selectedBrand,
                onChanged: (value) {
                  setState(() {
                    selectedBrand = value;
                  });
                },
                addBrand: (newBrand) {
                  setState(() {
                    brandlist
                        .add(Brand(id: brandlist.length + 1, name: newBrand));
                    selectedBrand = newBrand;
                  });
                },
                contro2: contol2,
              ),
              ctegodeco(
                categorylist: categorylist,
                onchange: (value) {
                  setState(() {
                    var selectedCategory1 =
                        categorylist.firstWhere((cate) => cate.name == value);
                    selectedcategory = selectedCategory1.name;
                    cateid = selectedCategory1.id;
                    treeid2 = selectedCategory1.tree_id;
                    selectedsubcategory = null;
                    selectedcolour = null;
                  });
                },
                selectedcategory: selectedcategory,
                onchangesubcate: (value) {
                  setState(() {
                    var selectedCategory2 = categorylist
                        .firstWhere((subcate) => subcate.name == value);
                    selectedsubcategory = selectedCategory2.name;
                    subcateid = selectedCategory2.id;
                    treeid = selectedCategory2.tree_id;
                    selectedcolour = null;
                  });
                },
                selectedsubcategory: selectedsubcategory,
                cateid: cateid,
                subcateid: subcateid,
                selectedcolour: selectedcolour,
                onchangecolour: (value) {
                  setState(() {
                    selectedcolour = value;
                  });
                },
                treeid: treeid,
                treeid2: treeid2,
                sendcatedata: sendcategorydata,
                getcategory: getcategory,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          setState(() {
            for (var brand in uniquebrand) {
              if (selectedBrand == null || brand == selectedBrand) {
                isValueInList = true;
              }
            }

            if (!isValueInList) {
              senddata(selectedBrand!);
            } else {
              senddata(contol2.text);
              setState(() {
                contol2.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please select a brand before saving.")),
              );
            }
          });
        },
        child: Text("Save"),
      ),
    );
  }
}

class Deco extends StatefulWidget {
  const Deco({
    super.key,
    required this.brandlist,
    required this.getbrands,
    required this.selectedBrand,
    required this.onChanged,
    required this.addBrand,
    required this.contro2,
  });

  final List<Brand> brandlist;
  final Function getbrands;
  final String? selectedBrand;
  final TextEditingController contro2;
  final ValueChanged<String?> onChanged;
  final ValueChanged<String> addBrand;

  @override
  State<Deco> createState() => _DecoState();
}

class _DecoState extends State<Deco> {
  @override
  Widget build(BuildContext context) {
    List<String> uniqueBrandNames =
        widget.brandlist.map((brand) => brand.name).toSet().toList();
    TextEditingController controller2 = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Enter a Brand",
              style:
                  TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 229, 227, 221),
            ),
            width: MediaQuery.of(context).size.width * 1.0,
            child: DropdownButton<String>(
              menuMaxHeight: 200,
              value: widget.selectedBrand,
              hint: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Select a Brand",
                    style: TextStyle(color: Colors.cyan)),
              ),
              isExpanded: true,
              items: uniqueBrandNames.map((brandName) {
                return DropdownMenuItem<String>(
                  value: brandName,
                  child: Text(brandName, style: TextStyle(color: Colors.cyan)),
                );
              }).toList()
                ..add(DropdownMenuItem<String>(
                    value: "add_new",
                    child: TextButton(
                      child: Text("Add New Brand"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Enter new brand"),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextField(
                                        controller: controller2,
                                        decoration: InputDecoration(
                                            hintText: "Enter brand",
                                            border: OutlineInputBorder()),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel")),
                                          SizedBox(width: 8),
                                          ElevatedButton(
                                              onPressed: () {
                                                widget.contro2.text =
                                                    controller2.text;

                                                widget
                                                    .addBrand(controller2.text);
                                                Navigator.pop(context);
                                              },
                                              child: Text("Save")),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ))),
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class ctegodeco extends StatefulWidget {
  final List<Category> categorylist;
  final String? selectedcategory;
  final ValueChanged<String?> onchange;
  final ValueChanged<String?> onchangesubcate;
  final ValueChanged<String?> onchangecolour;
  final String? selectedsubcategory;
  final String? selectedcolour;
  final int cateid;
  final int subcateid;
  final int treeid;
  final int treeid2;
  final Function sendcatedata;
  final Function getcategory;
  const ctegodeco({
    super.key,
    required this.categorylist,
    required this.selectedcategory,
    required this.onchange,
    this.selectedsubcategory,
    required this.onchangesubcate,
    required this.cateid,
    required this.subcateid,
    this.selectedcolour,
    required this.onchangecolour,
    required this.treeid,
    required this.treeid2,
    required this.sendcatedata,
    required this.getcategory,
  });

  @override
  State<ctegodeco> createState() => _ctegodecoState();
}

TextEditingController concategory = TextEditingController();

class _ctegodecoState extends State<ctegodeco> {
  @override
  Widget build(BuildContext context) {
    List<uniqueinfo> uniquecategory = widget.categorylist
        .where((category1) => category1.level == 0)
        .map((category) => uniqueinfo(
            name: category.name, id: category.id, treeid2: category.tree_id))
        .toSet()
        .toList();
    List<uniquecol> uniquesubcategory = widget.categorylist
        .where((category1) =>
            category1.parent == widget.cateid &&
            category1.level == 1 &&
            category1.tree_id == widget.treeid2)
        .map((categorys) => uniquecol(
            id: categorys.id, name: categorys.name, treeid: categorys.tree_id))
        .toSet()
        .toList();
    List<String> uniquecolour = widget.categorylist
        .where((category2) =>
            category2.parent == widget.subcateid &&
            category2.level == 2 &&
            category2.tree_id == widget.treeid2)
        .map((categoryc) => categoryc.name)
        .toSet()
        .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: () {
                print(widget.selectedcategory);
                print(widget.cateid);
                print(uniquecolour);
                print(uniquesubcategory);
              },
              child: Text("check")),
          Text("Enter Category",
              style:
                  TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 229, 227, 221),
            ),
            width: MediaQuery.of(context).size.width * 1.0,
            child: DropdownButton<String>(
              menuMaxHeight: 200,
              hint: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Select a category",
                    style: TextStyle(color: Colors.cyan)),
              ),
              value: widget.selectedcategory,
              isExpanded: true,
              items: uniquecategory.map((cate) {
                return DropdownMenuItem<String>(
                  value: cate.name,
                  child: Text(cate.name, style: TextStyle(color: Colors.cyan)),
                );
              }).toList()
                ..add(DropdownMenuItem<String>(
                    value: "add_new",
                    child: TextButton(
                      child: Text("Add New Category"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Enter new Category"),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextField(
                                        controller: concategory,
                                        decoration: InputDecoration(
                                            hintText: "Enter category",
                                            border: OutlineInputBorder()),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel")),
                                          SizedBox(width: 8),
                                          ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  widget.sendcatedata(
                                                      concategory.text, null);
                                                  widget.getcategory();
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              child: Text("Save")),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ))),
              onChanged: widget.onchange,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Enter SubCategory",
              style:
                  TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 229, 227, 221),
            ),
            width: MediaQuery.of(context).size.width * 1.0,
            child: DropdownButton<String>(
              menuMaxHeight: 200,
              hint: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Select a Subcategory",
                    style: TextStyle(color: Colors.cyan)),
              ),
              value: widget.selectedsubcategory,
              isExpanded: true,
              items: uniquesubcategory.map((subcate) {
                return DropdownMenuItem<String>(
                  value: subcate.name,
                  child:
                      Text(subcate.name, style: TextStyle(color: Colors.cyan)),
                );
              }).toList(),
              onChanged: widget.onchangesubcate,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Enter Colour",
              style:
                  TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 229, 227, 221),
            ),
            width: MediaQuery.of(context).size.width * 1.0,
            child: DropdownButton<String>(
              menuMaxHeight: 200,
              hint: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text("Select Colour", style: TextStyle(color: Colors.cyan)),
              ),
              value: widget.selectedcolour,
              isExpanded: true,
              items: uniquecolour.map((subcatecolor) {
                return DropdownMenuItem<String>(
                  value: subcatecolor,
                  child:
                      Text(subcatecolor, style: TextStyle(color: Colors.cyan)),
                );
              }).toList(),
              onChanged: widget.onchangecolour,
            ),
          )
        ],
      ),
    );
  }
}

class uniqueinfo {
  int id;
  String name;
  int treeid2;
  uniqueinfo({required this.name, required this.id, required this.treeid2});
}

class uniquecol {
  int id;
  int treeid;
  String name;
  uniquecol({required this.id, required this.name, required this.treeid});
}
