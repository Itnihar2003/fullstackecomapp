// lib/product_detail_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ProductDetailPage extends StatefulWidget {
  final String image;
  final String productname;
  final String describtion;
  final String brandName;
  final String price; // e.g. "250.00"
  final String stock; // e.g. "12"
  final String acesstoken; // JWT token
  final bool addtocart; // initial in-cart state
  final int id; // product ID (PK)

  const ProductDetailPage({
    Key? key,
    required this.image,
    required this.productname,
    required this.describtion,
    required this.brandName,
    required this.price,
    required this.stock,
    required this.acesstoken,
    required this.id,
    required this.addtocart,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late bool _inCart;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    // Initialize in-cart flag from widget
    _inCart = widget.addtocart;

    // Initialize Razorpay instance and register listeners:
    _razorpay = Razorpay()
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // Clear Razorpay listeners
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "Payment Success (ID: ${response.paymentId})");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Failed: ${response.code} – ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "External Wallet: ${response.walletName}");
  }

  Future<void> _toggleAddToCart({
    required int productId,
    required String accessToken,
    required bool newValue,
  }) async {
    final url = Uri.parse('http://10.0.2.2:8000/product/$productId/');
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'added_to_cart': newValue}),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update cart status');
    }
  }

  void _startRazorpayCheckout() {
    final double parsedPrice = double.tryParse(widget.price) ?? 0.0;
    final int amountInPaise = (parsedPrice * 100).toInt();

    var options = {
      'key': 'rzp_test_GcZZFDPP0jHtC4',
      'amount': amountInPaise, 
      'name': widget.productname,
      'description': widget.describtion,
      'prefill': {
        'contact': '9692435630',
        'email': 'test@razorpay.com',
      },
      'external': {
        'wallets': ['paytm'],
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      if (e is MissingPluginException ||
          e.toString().contains("MissingPluginException")) {
        Fluttertoast.showToast(
            msg: "Cannot run Razorpay on emulator. Try on a real device.");
      } else {
        Fluttertoast.showToast(msg: "Error: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 1) Large Product Image
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                widget.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child:
                      Icon(Icons.broken_image, color: Colors.white30, size: 60),
                ),
              ),
            ),

            // 2) Details
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.black,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price & Stock Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹${widget.price}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "(only ${widget.stock} left)",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Product Name
                      Text(
                        widget.productname,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Brand Name
                      Text(
                        "Brand: ${widget.brandName}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Description
                      Text(
                        widget.describtion,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Ratings & Reviews (static for now)
                      const RatingsReviewsContainer(),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // 3) Bottom Buttons Row (“Add/Remove Cart” + “Buy now”)
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Favorite (placeholder)
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border,
                          color: Colors.white),
                      onPressed: () {
                        // Toggle favorite if you wish
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  // “Add to Cart” / “Remove from Cart”
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _inCart ? Colors.redAccent : Colors.white,
                        foregroundColor: _inCart ? Colors.white : Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        final newValue = !_inCart;
                        setState(() {
                          _inCart = newValue;
                        });
                        try {
                          await _toggleAddToCart(
                            productId: widget.id,
                            accessToken: widget.acesstoken,
                            newValue: newValue,
                          );
                        } catch (e) {
                          // Revert UI if patch fails
                          setState(() {
                            _inCart = !_inCart;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not update cart status'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        _inCart ? "Remove from Cart" : "Add to Cart",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // “Buy now” button → Razorpay
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _startRazorpayCheckout,
                      child: const Text(
                        "Buy now",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Static Ratings & Reviews widget (no changes made here):
class RatingsReviewsContainer extends StatelessWidget {
  const RatingsReviewsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildStarRow({
      required String starsLabel,
      required double fraction,
      required String countText,
      required Color color,
    }) {
      return Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              starsLabel,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: fraction,
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text(
              countText,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top title row: "Ratings & Reviews" + Rate Product button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Ratings & Reviews",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  side: const BorderSide(color: Colors.grey),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 0,
                ),
                onPressed: () {},
                child: const Text("Rate Product"),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Example breakdown (static values)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildStarRow(
                      starsLabel: "5 ★",
                      fraction: 0.75,
                      countText: "4,38,920",
                      color: Colors.green,
                    ),
                    const SizedBox(height: 8),
                    _buildStarRow(
                      starsLabel: "4 ★",
                      fraction: 0.25,
                      countText: "1,45,827",
                      color: Colors.green,
                    ),
                    const SizedBox(height: 8),
                    _buildStarRow(
                      starsLabel: "3 ★",
                      fraction: 0.10,
                      countText: "59,028",
                      color: Colors.green,
                    ),
                    const SizedBox(height: 8),
                    _buildStarRow(
                      starsLabel: "2 ★",
                      fraction: 0.05,
                      countText: "30,545",
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 8),
                    _buildStarRow(
                      starsLabel: "1 ★",
                      fraction: 0.12,
                      countText: "72,555",
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // (You could add circular sub‐ratings here if needed)
            ],
          ),
        ],
      ),
    );
  }
}
