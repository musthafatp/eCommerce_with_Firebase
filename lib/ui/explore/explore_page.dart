import 'package:ecommerce_with_firebase/ui/explore/bevarages_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Fruits & Vegetable',
      'image': 'assets/images/5.png',
      'color': const Color(0xFFE8F5E9),
      'borderColor': const Color(0xFF81C784),
      'route': '/fruits',
    },
    {
      'name': 'Cooking Oil & Ghee',
      'image': 'assets/images/1.png',
      'color': const Color(0xFFFFF8E1),
      'borderColor': const Color(0xFFFFD54F),
      'route': '/oil',
    },
    {
      'name': 'Meat & Fish',
      'image': 'assets/images/6.png',
      'color': const Color(0xFFFCE4EC),
      'borderColor': const Color(0xFFF48FB1),
      'route': '/meat',
    },
    {
      'name': 'Bakery & Snacks',
      'image':
          'https://png.pngtree.com/png-clipart/20230928/original/pngtree-cute-breads-bakery-stationary-sticker-oil-painting-png-image_13165667.png',
      'color': const Color(0xFFEDE7F6),
      'borderColor': const Color(0xFFB39DDB),
      'route': '/bakery',
    },
    {
      'name': 'Dairy & Eggs',
      'image':
          'https://png.pngtree.com/png-vector/20240902/ourmid/pngtree-dairy-and-eggs-clipart-illustration-milk-cottage-cheese-on-tablecloth-png-image_13726916.png',
      'color': const Color(0xFFFFFDE7),
      'borderColor': const Color(0xFFFFEB3B),
      'route': '/dairy',
    },
    {
      'name': 'Beverages',
      'image': 'assets/images/4.png',
      'color': const Color(0xFFE1F5FE),
      'borderColor': const Color(0xFF4FC3F7),
      'route': '/beverages',
    },
  ];

  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(categories);
  }

  void onSearchSubmit(String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BeveragesPage(filteredBeverages: [],
            
          ),
        ),
      );
    }
  }

  void filterSearch(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      if (lowerQuery.isEmpty) {
        filteredItems = List.from(categories);
      } else {
        filteredItems = categories
            .where((item) =>
                item['name'].toString().toLowerCase().contains(lowerQuery))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Text(
            'Find Products',
            style: TextStyle(
              fontSize: 17.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: const Color(0xFF000000),
            ),
          ),
          SizedBox(height: 10.h),

          // 🔍 Search Bar
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
            child: _buildSearchBar(),
          ),
          SizedBox(height: 10.h),

          // 🧺 Category Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 15.w,
                mainAxisSpacing: 15.h,
              ),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(filteredItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Search Bar Widget
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F2),
        borderRadius: BorderRadius.circular(17),
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: onSearchSubmit, // <-- added this line

        onChanged: filterSearch,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.black54, size: 26),
          hintText: 'Search Store',
          hintStyle: TextStyle(
              color: Colors.black45, fontSize: 16, fontFamily: 'poppins'),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        ),
      ),
    );
  }

  // 🔹 Category Card Widget
  Widget _buildCategoryCard(Map<String, dynamic> category) {
    final imagePath = category['image'];

    // Check if imagePath is a network URL
    final isNetworkImage =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');
    return GestureDetector(
      onTap: () {
        final route = category['route'];

        if (route == '/fruits') {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const FruitsPage()));
        } else if (route == '/oil') {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const OilPage()));
        } else if (route == '/meat') {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const MeatPage()));
        } else if (route == '/bakery') {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const BakeryPage()));
        } else if (route == '/dairy') {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const DairyPage()));
        } else if (route == '/beverages') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const BeveragesPage(filteredBeverages: [],
                      )));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: category['color'],
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: category['borderColor'],
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(18.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: isNetworkImage
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.contain,
                        height: 150.h,
                        width: 150.h,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image,
                              size: 40, color: Colors.grey);
                        },
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        height: 150.h,
                        width: 150.h,
                      ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 20.h),
              child: Text(
                category['name'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF181725),
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FruitsPage extends StatelessWidget {
  const FruitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _simplePage(context, 'Fresh Fruits & Vegetable');
  }
}

class OilPage extends StatelessWidget {
  const OilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _simplePage(context, 'Cooking Oil & Ghee');
  }
}

class MeatPage extends StatelessWidget {
  const MeatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _simplePage(context, 'Meat & Fish');
  }
}

class BakeryPage extends StatelessWidget {
  const BakeryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _simplePage(context, 'Bakery & Snacks');
  }
}

class DairyPage extends StatelessWidget {
  const DairyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _simplePage(context, 'Dairy & Eggs');
  }
}

//
// 🔹 Common function to simplify dummy page UI
//
Widget _simplePage(BuildContext context, String title) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      backgroundColor: const Color(0xFF53B175),
    ),
    body: Center(
      child: Text(
        'Welcome to $title Page',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
