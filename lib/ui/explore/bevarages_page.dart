import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_with_firebase/ui/cart_page.dart';
import 'package:ecommerce_with_firebase/widgets/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BeveragesPage extends StatefulWidget {
  final String? query; // optional search query passed from other page

  const BeveragesPage({
    super.key,
    this.query,
    required List<Map<String, dynamic>> filteredBeverages,
  });

  @override
  State<BeveragesPage> createState() => _BeveragesPageState();
}

class _BeveragesPageState extends State<BeveragesPage> {
  final TextEditingController _searchController = TextEditingController();

  // ✅ Fetch products from Firestore (collection path)
  final Stream<QuerySnapshot> _beveragesStream = FirebaseFirestore.instance
      .collection('groceries')
      .doc('beverages')
      .collection('items')
      .snapshots();

  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    // if coming from another page with a search query
    if (widget.query != null && widget.query!.isNotEmpty) {
      _searchController.text = widget.query!;
      searchQuery = widget.query!;
    }
  }

  void filterSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                // Top row with back button and title
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Beverages",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(Icons.tune, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // 🔸 Grid of beverages (filtered)
      body: StreamBuilder<QuerySnapshot>(
        stream: _beveragesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text('Error loading beverages',
                    style: TextStyle(color: Colors.red)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No beverages found.'));
          }

          // ✅ Get all products
          final products = snapshot.data!.docs
              .map((doc) => Product.fromFirestore(doc))
              .where((p) => p.name.toLowerCase().contains(searchQuery))
              .toList();

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 19),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final product = products[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(product: product),
                    ),
                  );
                },
                child: Container(
                  width: 190,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🖼 Product image
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: Image.network(
                          product.image,
                          height: 230,
                          width: 230,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF181725),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        child: Text(
                          product.quantity.toString(),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${product.price}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF181725),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CartPage()),
                                );
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF53B175),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 22,
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
            },
          );
        },
      ),
    );
  }
}
