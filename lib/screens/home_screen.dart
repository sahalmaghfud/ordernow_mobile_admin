import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Menampilkan dialog konfirmasi
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Konfirmasi"),
                    content: const Text("Apakah Anda yakin ingin logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Menutup dialog
                        },
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text("Logout"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // 2 kolom
          crossAxisSpacing: 16, // jarak antar kolom
          mainAxisSpacing: 16, // jarak antar baris
          childAspectRatio: 1.0, // rasio tinggi dan lebar card
          children: [
            _buildCard(
              context,
              icon: Icons.restaurant_menu,
              title: "Menu",
              onTap: () {
                Navigator.pushNamed(context, '/menu');
              },
            ),
            _buildCard(
              context,
              icon: Icons.shopping_cart,
              title: "Pesanan",
              onTap: () {
                Navigator.pushNamed(context, '/pesanan');
              },
            ),
            _buildCard(
              context,
              icon: Icons.history,
              title: "Histories",
              onTap: () {
                Navigator.pushNamed(context, '/histories');
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget Card yang Reusable
  Widget _buildCard(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.green),
              const SizedBox(height: 8),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
