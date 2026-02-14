import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_with_firebase/ui/cart_page.dart';
import 'package:ecommerce_with_firebase/utils/cart_and_favourite.dart';
import 'package:ecommerce_with_firebase/widgets/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _exclusiveStream =
      FirebaseFirestore.instance.collection('exclusive').snapshots();

  final Stream<QuerySnapshot> _bestSellingStream =
      FirebaseFirestore.instance.collection('bestselling').snapshots();

  final Stream<QuerySnapshot> _groceriesStream =
      FirebaseFirestore.instance.collection('groceries').snapshots();
  final List<String> bannerImages = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
  ];
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Pulses',
      'image':
          'https://static.vecteezy.com/system/resources/previews/054/774/118/non_2x/a-bowl-of-mix-pulses-transparent-background-png.png',
      'color': const Color(0xFFFFC36A),
    },
    {
      'name': 'Rice',
      'image':
          'https://static.vecteezy.com/system/resources/previews/047/827/455/non_2x/rice-in-sack-bag-on-transparent-background-free-png.png',
      'color': const Color(0xFFB4E197),
    },
    {
      'name': 'Cooking Oil',
      'image':
          'https://png.pngtree.com/png-vector/20231023/ourmid/pngtree-cooking-oils-isolated-on-white-with-png-image_10297524.png',
      'color': const Color(0xFFFFE29A),
    },
    {
      'name': 'Spices',
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/054/299/186/small/colorful-assortment-of-spices-in-wooden-bowl-with-transparent-background-png.png',
      'color': const Color(0xFFFF9A76), // orange-red
    },
    {
      'name': 'Flour',
      'image':
          'https://static.vecteezy.com/system/resources/previews/051/674/509/non_2x/wooden-bowl-of-flour-with-wheat-branch-on-transparent-background-free-png.png',
      'color': const Color(0xFFE0C097), // beige
    },
    {
      'name': 'Sugar',
      'image':
          'https://png.pngtree.com/png-clipart/20250105/original/pngtree-white-sugar-crystals-and-cubes-on-a-plain-background-perfect-for-png-image_18753423.png',
      'color': const Color(0xFFF5EEDC), // ivory
    },
    {
      'name': 'Coffee',
      'image':
          'https://static.vecteezy.com/system/resources/previews/055/183/321/non_2x/roasted-coffee-beans-and-ground-coffee-powder-png.png',
      'color': const Color(0xFFB5DEFF), // pastel blue
    },
    {
      'name': 'Salt',
      'image':
          'https://static.vecteezy.com/system/resources/previews/047/087/042/non_2x/salt-in-a-bowl-on-transparent-background-free-png.png',
      'color': const Color(0xFFCBC3E3), // lavender
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------- Logo ----------
              Center(
                  child: Image.asset('assets/images/carrot.png', height: 50.h)),
              SizedBox(height: 10.h),

              /// ---------- Location ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on,
                      color: Colors.blueGrey, size: 20),
                  const SizedBox(width: 5),
                  Text("Dhaka, Banasree",
                      style: TextStyle(color: Colors.black87, fontSize: 14.sp)),
                ],
              ),
              SizedBox(height: 10.h),

              /// ---------- Search Bar ----------
              _buildSearchBar(),
              SizedBox(height: 20.h),

              /// ---------- Carousel ----------
              _buildCarousel(),
              SizedBox(height: 25.h),

              /// ---------- Sections ----------
              const SectionHeader(title: "Exclusive Offer"),
              _buildFirestoreSection(_exclusiveStream),

              /// 🔹 Best Selling Section
              const SectionHeader(title: "Best Selling"),
              _buildFirestoreSection(_bestSellingStream),

              const SectionHeader(title: "Groceries"),

              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final c = categories[index];
                    return Container(
                      width: 300,
                      margin: const EdgeInsets.only(right: 14),
                      decoration: BoxDecoration(
                        color: c['color'],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 15.w),
                          Image.network(
                            c['image'],
                            alignment: Alignment.center,
                            height: 100,
                            width: 100,
                            fit: BoxFit.contain,
                          ),
                          Text(
                            c['name'],
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 30.h),
              _buildFirestoreSection(_bestSellingStream),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F2),
        borderRadius: BorderRadius.circular(17),
      ),
      child: const TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.black54, size: 26),
          hintText: 'Search Store',
          hintStyle: TextStyle(color: Colors.black45, fontSize: 16),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: bannerImages.length,
          itemBuilder: (context, index, _) => Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(bannerImages[index]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          options: CarouselOptions(
            height: 180.h,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, reason) =>
                setState(() => _currentIndex = index),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            bannerImages.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentIndex == index ? 20 : 8,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? Colors.black
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildFirestoreSection(Stream<QuerySnapshot> stream) {
  return StreamBuilder<QuerySnapshot>(
    stream: stream,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text("No products found"));
      }

      final products = snapshot.data!.docs;
      return ProductListView(products: products);
    },
  );
}

/// ---------- REUSABLE WIDGETS ----------

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          TextButton(
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
            ),
            onPressed: () {},
            child: Text("See all",
                style: TextStyle(fontSize: 13.sp, color: Colors.green)),
          ),
        ],
      ),
    );
  }
}

class ProductListView extends StatelessWidget {
  final List<QueryDocumentSnapshot> products;
  const ProductListView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: products.length,
        itemBuilder: (context, index) {
          // Get the Firestore document snapshot
          final doc = products[index];

          // Convert it to your Product model
          final product = Product.fromFirestore(doc);

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
              width: 170,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.network(
                      // ✅ Handles both 'image' (single) and 'images' (list)
                      doc['image'] ??
                          (doc['images'] != null && doc['images'] is List
                              ? doc['images'][0]
                              : 'https://via.placeholder.com/150'),
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      doc['name'] ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF181725),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Text(
                      doc['quantity'] ?? '',
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
                          "\$${doc['price'] ?? 0}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF181725),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${doc['name'] ?? 'Product'} added to basket'),
                                backgroundColor: const Color(0xFF53B175),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CartPage(),
                              ),
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
      ),
    );
  }
}
