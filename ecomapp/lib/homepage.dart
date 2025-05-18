// lib/homepage.dart

import 'dart:async';
import 'dart:convert';
import 'package:ecomapp/addtocartpage.dart';
import 'package:ecomapp/api.dart';
import 'package:ecomapp/demo .dart';
import 'package:ecomapp/eachproductclass.dart';
import 'package:ecomapp/individualpage.dart';
import 'package:ecomapp/todo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class homepage extends StatefulWidget {
  final String acesstoken;
  const homepage({super.key, required this.acesstoken});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  String? selectedCategory;
  String searchQuery = "";
  TextEditingController contro = TextEditingController();

  Future<List<eachProduct>> fetcheachproduct() async {
    if (widget.acesstoken.isEmpty) {
      throw Exception("Access token is null");
    }
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/product/'),
        headers: {
          'Authorization': 'Bearer ${widget.acesstoken}',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        return data
            .map((item) => eachProduct.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Failed to load product");
      }
    } catch (e) {
      print("Exception in fetch: $e");
      throw Exception("An error occurred");
    }
  }

  final PageController _controller = PageController();
  final List<String> images = [
    'https://imgs.search.brave.com/f9nC2O3Epk2RJ4R6ys8mFPOmw1Yo7yyp8EaEHO52QXU/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly90My5m/dGNkbi5uZXQvanBn/LzAzLzE0LzI4Lzk2/LzM2MF9GXzMxNDI4/OTY3Ml95RVFNZUVN/NGsyWjgwd0FlSm1y/MEJRTTAxYWpPUGhW/RC5qcGc',
    'https://imgs.search.brave.com/y5qlWY5Fd3vt5hPdF-PjtG7Tn5WDQZ7wUtUYVX_iY10/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/ZnJlZS1wc2QvaG9y/aXpvbnRhbC1iYW5u/ZXItb25saW5lLWZh/c2hpb24tc2FsZV8y/My0yMTQ4NTg1NDA0/LmpwZz9zZW10PWFp/c19oeWJyaWQmdz03/NDA',
    'https://imgs.search.brave.com/Ri_H1rWPXmP-7qOQU8Kgm-EAE3LBrAYi_fWLmJyJtSI/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAzLzA2LzY5LzQ5/LzM2MF9GXzMwNjY5/NDkzMF9TM1o4SDlR/azFNTjc5WlVlN2JF/V3FURnVvblJaZGVt/dy5qcGc',
  ];
  int currentPage = 0;
  Timer? timer;

  final List<Map<String, dynamic>> categories = [
    {"title": "All", "icon": Icons.list},
    {"title": "Mens Clothing", "icon": Icons.male},
    {"title": "Womens Clothing", "icon": Icons.female},
    {"title": "Kids Wear", "icon": Icons.child_care},
    {"title": "Footwear", "icon": Icons.directions_run},
    {"title": "Accessories", "icon": Icons.shopping_bag},
  ];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      if (currentPage < images.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      _controller.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });

    contro.addListener(() {
      setState(() {
        searchQuery = contro.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    contro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(
                        accessToken: widget.acesstoken,
                      ),
                    ));
              },
              icon: const Icon(Icons.add_shopping_cart_sharp,
                  color: Colors.white))
        ],
        title: const Text("Ecom App", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: const Color(0xFF1A1A1A),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: contro,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                // Categories
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                  child: SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected =
                            (selectedCategory == category["title"]);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (selectedCategory == category["title"]) {
                                selectedCategory = null;
                              } else {
                                selectedCategory = category["title"];
                              }
                            });
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: isSelected
                                    ? Colors.blueAccent
                                    : Colors.white,
                                child: Icon(
                                  category["icon"],
                                  size: 30,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  category["title"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.blueAccent
                                        : Colors.white,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Carousel
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            images[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Best Sale Product Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            colors: [Colors.blue, Colors.green, Colors.yellow],
                          ).createShader(bounds);
                        },
                        child: const Text(
                          "Best Sale Product",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        "See more",
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ],
                  ),
                ),

                // Product Grid
                FutureBuilder<List<eachProduct>>(
                  future: fetcheachproduct(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final allProducts = snapshot.data!;

                      final filteredProducts = allProducts.where((p) {
                        final matchesCategory = selectedCategory == null ||
                            selectedCategory == "All" ||
                            (p.baseCategoryName?.toLowerCase().contains(
                                    selectedCategory!.toLowerCase()) ??
                                false);

                        final matchesSearch = (p.name
                                    ?.toLowerCase()
                                    .contains(searchQuery) ??
                                false) ||
                            (p.describtion
                                    ?.toLowerCase()
                                    .contains(searchQuery) ??
                                false) ||
                            (p.brandName?.toLowerCase().contains(searchQuery) ??
                                false) ||
                            (p.baseCategoryName
                                    ?.toLowerCase()
                                    .contains(searchQuery) ??
                                false) ||
                            (p.categoryName
                                    ?.toLowerCase()
                                    .contains(searchQuery) ??
                                false);

                        return matchesCategory && matchesSearch;
                      }).toList();

                      final Map<int, List<Map<String, dynamic>>> groupedBySku =
                          {};
                      for (var product in filteredProducts) {
                        for (var detail in product.productDetail!) {
                          final skuInt = int.tryParse(detail.sku.toString());
                          if (skuInt != null) {
                            groupedBySku.putIfAbsent(skuInt, () => []).add({
                              "productDetail": detail,
                              "productId": detail.product,
                              "name": product.name,
                              "describtion": product.describtion,
                              "brandName": product.brandName,
                              "baseCategoryName": product.baseCategoryName,
                              "categoryName": product.categoryName,
                              "isActive": detail.isActive,
                              "addedToCart": product.addedToCart,
                              "image": product.image,
                            });
                          }
                        }
                      }

                      if (groupedBySku.isEmpty) {
                        return Center(
                          child: Text(
                            "No products match your search",
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: groupedBySku.values.length,
                        itemBuilder: (context, index) {
                          final sku = groupedBySku.keys.elementAt(index);
                          final skuDetails = groupedBySku[sku]!;
                          final entry = skuDetails[0];
                          final ProductDetail detail =
                              entry["productDetail"] as ProductDetail;
                          final int productId =
                              entry["productId"] as int; // safe now
                          final bool inCart =
                              entry["addedToCart"] as bool? ?? false;
                          final String? imageUrl = entry["image"] as String?;

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailPage(
                                    image: imageUrl ??
                                        "https://via.placeholder.com/150",
                                    productname: entry["name"] as String? ?? "",
                                    describtion:
                                        entry["describtion"] as String? ?? "",
                                    brandName:
                                        entry["brandName"] as String? ?? "",
                                    price: "₹${detail.price}",
                                    stock: "${detail.stockQuantity}",
                                    acesstoken: widget.acesstoken,
                                    id: productId,
                                    addtocart: inCart,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 110,
                                    width: double.infinity,
                                    child: Image.network(
                                      imageUrl ?? "",
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Center(
                                        child: Icon(Icons.broken_image),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${entry["name"]} (${entry["brandName"]})",
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        Text(
                                          entry["describtion"] as String? ?? "",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.star,
                                                color: Colors.amber, size: 24),
                                            const SizedBox(width: 4),
                                            const Text(
                                              "4.7",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              "|${detail.stockQuantity}",
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "₹${detail.price}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text("No results found",
                            style: TextStyle(color: Colors.white)),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
