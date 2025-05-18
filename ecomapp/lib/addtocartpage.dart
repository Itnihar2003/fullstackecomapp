// lib/cart_page.dart

import 'dart:convert';
import 'package:ecomapp/individualpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'eachproductclass.dart'; // <- make sure this import path matches your project structure

class CartPage extends StatefulWidget {
  final String accessToken;

  const CartPage({Key? key, required this.accessToken}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<eachProduct>> _futureCartProducts;

  @override
  void initState() {
    super.initState();
    _futureCartProducts = _fetchCartProducts();
  }

  double _cartTotal = 0.0;
  Future<List<eachProduct>> _fetchCartProducts() async {
    final url = Uri.parse('http://10.0.2.2:8000/product/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;

      // Parse everything into eachProduct
      final allProducts = data
          .map((item) => eachProduct.fromJson(item as Map<String, dynamic>))
          .toList();

      // Filter only those where addedToCart == true
      final cartProducts =
          allProducts.where((p) => p.addedToCart == true).toList();
      // Compute sum of prices
      double total = 0.0;
      for (final prod in cartProducts) {
        if (prod.productDetail != null && prod.productDetail!.isNotEmpty) {
          final firstDetail = prod.productDetail![0];
          final priceString = firstDetail.price ?? '0';
          total += double.tryParse(priceString) ?? 0.0;
        }
      }

      // Update the local _cartTotal
      setState(() {
        _cartTotal = total;
      });

      return cartProducts;
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<eachProduct>>(
        future: _futureCartProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Still loading
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Error fetching
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final cartItems = snapshot.data ?? [];

          if (cartItems.isEmpty) {
            // Cart is empty
            return const Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            );
          }

          // Otherwise, show all in‐cart products
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cartItems.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 16);
            },
            itemBuilder: (context, index) {
              final eachProduct product = cartItems[index];
            
              final detail = product.productDetail!.first;

              return InkWell(
                onTap: () {
                  final detail = product.productDetail!.first;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                        image: product.image ?? '',
                        productname: product.name ?? '',
                        describtion: product.describtion ?? '',
                        brandName: product.brandName ?? '',
                        price: detail.price ?? '0',
                        stock: detail.stockQuantity?.toString() ?? '0',
                        acesstoken: widget.accessToken,
                        id: detail.product ?? 0,
                        addtocart: product.addedToCart ?? false,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.network(
                            product.image ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.broken_image, size: 40),
                              );
                            },
                          ),
                        ),
                      ),

                      // Spacer
                      const SizedBox(width: 12),

                      // Name, Brand, Price, Stock
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Brand: ${product.brandName ?? '-'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Price: ₹${detail.price}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'In stock: ${detail.stockQuantity}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // // “Remove” button
                      // IconButton(
                      //   icon: const Icon(Icons.delete_outline, color: Colors.red),
                      //   onPressed: () async {
                      //     // When pressed, immediately optimistically remove from UI
                      //     setState(() {
                      //       cartItems.removeAt(index);
                      //     });

                      //     // Then fire a PATCH request to set added_to_cart = false
                      //     try {
                      //       final patchUrl = Uri.parse(
                      //         'http://10.0.2.2:8000/product/${detail.product}/',
                      //       );
                      //       final patchResp = await http.patch(
                      //         patchUrl,
                      //         headers: {
                      //           'Authorization':
                      //               'Bearer ${widget.accessToken}',
                      //           'Content-Type': 'application/json',
                      //         },
                      //         body: jsonEncode({'added_to_cart': false}),
                      //       );
                      //       if (patchResp.statusCode != 200 &&
                      //           patchResp.statusCode != 204) {
                      //         throw Exception('Failed to update');
                      //       }
                      //     } catch (error) {
                      //       // If the PATCH failed, show a SnackBar and re‐insert item
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         SnackBar(
                      //           content: Text(
                      //               'Could not remove from cart: $error'),
                      //         ),
                      //       );
                      //       // Re‐insert the item back into the list
                      //       setState(() {
                      //         cartItems.insert(
                      //           index,
                      //           eachProduct.fromJson({
                      //             'name': product.name,
                      //             'describtion': product.describtion,
                      //             'is_digital': product.isDigital,
                      //             'brand_name': product.brandName,
                      //             'category_name': product.categoryName,
                      //             'base_category_name':
                      //                 product.baseCategoryName,
                      //             'image': product.image,
                      //             'added_to_cart': product.addedToCart,
                      //             'product_detail': product.productDetail!
                      //                 .map((d) => d.toJson())
                      //                 .toList(),
                      //           }),
                      //         );
                      //       });
                      //     }
                      //   },
                      // ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Total Price= " + _cartTotal.toString(),
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        height: 60,
        width: 100,
        color: Colors.black,
      ),
      backgroundColor: const Color(0xFF1A1A1A),
    );
  }
}
