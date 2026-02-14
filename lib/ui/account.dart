import 'package:ecommerce_with_firebase/Authentication/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = FirebaseAuth.instance.currentUser;

    Future<void> logout() async {
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginPage()));
    }

    // If user is null, show a message
    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'No user logged in',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Account",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // 👤 Profile Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : const NetworkImage(
                          'https://img.freepik.com/free-photo/luxury-plain-green-gradient-abstract-studio-background-empty-room-with-space-your-text-picture_1258-82980.jpg?semt=ais_hybrid&w=740&q=80',
                        ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName ?? "user Name",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email ?? "No email",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // ✏️ Edit Icon (You can repurpose later)
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Edit profile coming soon!'),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Divider(),

          Expanded(
            child: ListView(
              children: [
                _buildTile(Icons.shopping_bag_outlined, "Orders"),
                _buildTile(Icons.badge_outlined, "My Details"),
                _buildTile(Icons.location_on_outlined, "Delivery Address"),
                _buildTile(Icons.payment_outlined, "Payment Methods"),
                _buildTile(Icons.local_offer_outlined, "Promo Code"),
                _buildTile(Icons.notifications_none_outlined, "Notifications"),
                _buildTile(Icons.help_outline, "Help"),
                _buildTile(Icons.info_outline, "About"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout, color: Color(0xFF53B175)),
              label: const Text(
                "Log Out",
                style: TextStyle(
                    color: Color(0xFF53B175),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              onPressed: () async {
                logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEBF8EE),
                elevation: 0,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black45),
      onTap: () {},
    );
  }
}
