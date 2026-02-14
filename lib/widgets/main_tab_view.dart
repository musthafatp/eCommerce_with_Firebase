import 'package:ecommerce_with_firebase/ui/account.dart';
import 'package:ecommerce_with_firebase/ui/cart_page.dart';
import 'package:ecommerce_with_firebase/ui/explore/explore_page.dart';
import 'package:ecommerce_with_firebase/ui/favourite_page.dart';
import 'package:ecommerce_with_firebase/ui/home_screen.dart';
import 'package:ecommerce_with_firebase/widgets/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  int selectTab = 0;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 5, vsync: this);
    controller?.addListener(() {
      selectTab = controller?.index ?? 0;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: TabBarView(controller: controller, children: [
        const HomeScreen(),
        ExplorePage(),
        FavouritePage(),
        CartPage(),
        AccountPage(),
      ]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 3, offset: Offset(0, -2))
            ]),
        child: BottomAppBar(
          color: Colors.white,
          elevation: 0,
          child: TabBar(
              controller: controller,
              indicatorColor: Colors.transparent,
              indicatorWeight: 1,
              labelColor: Colors.green,
              labelStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.w600),
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
              tabs: [
                Tab(
                    text: "Shop",
                    icon: Icon(
                      Icons.shopify_sharp,
                      color: selectTab == 0 ? Colors.green : Colors.black54,
                    )),
                Tab(
                    text: "Explore",
                    icon: Icon(
                      Icons.manage_search_sharp,
                      color: selectTab == 1 ? Colors.green : Colors.black54,
                    )),
                Tab(
                    text: "Favorite",
                    icon: Icon(
                      Icons.favorite_outline_sharp,
                      color: selectTab == 2 ? Colors.green : Colors.black54,
                    )),
                Tab(
                    text: "Cart",
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: selectTab == 3 ? Colors.green : Colors.black54,
                    )),
                Tab(
                    text: "Account",
                    icon: Icon(
                      Icons.account_circle_sharp,
                      color: selectTab == 4 ? Colors.green : Colors.black54,
                    ))
              ]),
        ),
      ),
    );
  }
}
