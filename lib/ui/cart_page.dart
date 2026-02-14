import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_with_firebase/utils/cart_and_favourite.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Map<int, int> quantities = {}; // product index -> quantity

  Future<void> _checkout() async {
    if (cartItems.isEmpty) return;

    double total = 0;
    final List<Map<String, dynamic>> orderItems = [];

    for (int i = 0; i < cartItems.length; i++) {
      int qty = quantities[i] ?? 1;
      final product = cartItems[i];
      total += product.price * qty;

      orderItems.add({
        'name': product.name,
        'price': product.price,
        'quantity': qty,
        'total': product.price * qty,
        'image': product.image,
      });
    }

    try {
      // ✅ Save to Firestore under "orders" collection
      await FirebaseFirestore.instance.collection('orders').add({
        'items': orderItems,
        'totalAmount': total,
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        cartItems.clear();
        quantities.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Checkout successful! Order saved to Firestore."),
          backgroundColor: Color(0xFF53B175),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save order: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = 0;
    for (int i = 0; i < cartItems.length; i++) {
      int qty = quantities[i] ?? 1;
      total += cartItems[i].price * qty;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Cart",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: cartItems.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final product = cartItems[index];
                final qty = quantities[index] ?? 1;

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        product.image,
                        height: 70,
                        width: 70,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "1kg, Price",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.grey.shade300),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.remove, size: 20),
                              onPressed: () {
                                setState(() {
                                  if (qty > 1) {
                                    quantities[index] = qty - 1;
                                  }
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              qty.toString(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.grey.shade300),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              onPressed: () {
                                setState(() {
                                  quantities[index] = qty + 1;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "\$${(product.price * qty).toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            cartItems.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -3),
                )
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF53B175),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _checkout,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Go to Checkout",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "\$${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
