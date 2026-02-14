// ==================== Imports ====================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_with_firebase/utils/cart_and_favourite.dart';
import 'package:ecommerce_with_firebase/ui/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ==================== Product Model ====================

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final double rating;
  final int reviewCount;
  final String image; // single image URL
  final String quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.quantity,
  });

  // Convert Firestore document → Product object
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: (data['price'] is num)
          ? data['price'].toDouble()
          : double.tryParse(data['price'].toString()) ?? 0.0,
      description: data['description'] ?? 'No description available.',
      image: data['image'] ?? '',
      rating: (data['rating'] is num)
          ? data['rating'].toDouble()
          : double.tryParse(data['rating'].toString()) ?? 0.0,
      reviewCount: data['reviewCount'] ?? 0,
      quantity: data['quantity'] ?? '',
    );
  }

  // Convert Product object → Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'rating': rating,
      'reviewCount': reviewCount,
      'image': image,
      'quantity': quantity,
    };
  }
}

// ==================== Firestore Service ====================

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of all products
  Stream<List<Product>> getProducts() {
    return _firestore.collection('products').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList(),
        );
  }

  // Get single product by ID
  Future<Product?> getProductById(String id) async {
    final doc = await _firestore.collection('products').doc(id).get();
    if (doc.exists) return Product.fromFirestore(doc);
    return null;
  }

  // Add a new product with auto ID
  Future<void> addProduct(Product product) async {
    await _firestore.collection('products').add(product.toFirestore());
  }
}

// ==================== Product Detail Page ====================

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
  bool _isFavorite = false;
  bool _isProductDetailExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        actions: [
          IconButton(
            padding: EdgeInsets.all(16.w),
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSection(),
                    _buildProductInfoSection(),
                    _buildQuantitySection(),
                    SizedBox(height: 16.h),
                    _buildProductDetailSection(),
                    _buildNutritionsSection(),
                    _buildReviewSection(),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
            _buildAddToBasketButton(),
          ],
        ),
      ),
    );
  }

  // ==================== UI Sections ====================

  Widget _buildImageSection() {
    final image = widget.product.image;
    return Container(
      height: 350.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Image.network(
          image,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 100, color: Colors.grey),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductInfoSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF181725),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.product.quantity,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.product.name} added to Favourite'),
                  backgroundColor: const Color(0xFF53B175),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              setState(() {
                toggleFavourite(widget.product);
                _isFavorite = isFavourite(widget.product);
              });
            },
            child: Icon(
              isFavourite(widget.product)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color:
                  isFavourite(widget.product) ? Colors.red : Colors.grey[400],
              size: 22.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (_quantity > 1) {
                    setState(() => _quantity--);
                  }
                },
                child: Container(
                  width: 45.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.remove, color: Colors.grey, size: 15.sp),
                ),
              ),
              Container(
                width: 60.w,
                alignment: Alignment.center,
                child: Text(
                  '$_quantity',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF181725),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _quantity++),
                child: Container(
                  width: 45.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.add,
                      color: const Color(0xFF53B175), size: 15.sp),
                ),
              ),
            ],
          ),
          Text(
            '\$${(widget.product.price * _quantity).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF181725),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetailSection() {
    return Container(
      margin: EdgeInsets.only(top: 1.h),
      color: Colors.white,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(
                () => _isProductDetailExpanded = !_isProductDetailExpanded),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Product Detail',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF181725),
                    ),
                  ),
                  Icon(
                    _isProductDetailExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.chevron_right,
                    color: Colors.black,
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ),
          if (_isProductDetailExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
              child: Text(
                widget.product.description,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNutritionsSection() {
    return Container(
      margin: EdgeInsets.only(top: 1.h),
      color: Colors.white,
      child: ListTile(
        title: Text(
          'Nutritions',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF181725),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '100gr',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Icon(Icons.chevron_right, color: Colors.black, size: 18.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewSection() {
    return Container(
      margin: EdgeInsets.only(top: 1.h),
      color: Colors.white,
      child: ListTile(
        title: Text(
          'Review',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF181725),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(
              5,
              (index) => Icon(
                Icons.star,
                size: 18.sp,
                color: index < widget.product.rating
                    ? const Color(0xFFF3603F)
                    : Colors.grey[300],
              ),
            ),
            SizedBox(width: 12.w),
            Icon(Icons.chevron_right, color: Colors.black, size: 18.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToBasketButton() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: () {
            addToCart(widget.product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${widget.product.name} added to cart'),
                backgroundColor: const Color(0xFF53B175),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF53B175),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Text(
            'Add To Basket',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
