import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'bucket.dart';
import 'order.dart';
import 'profile.dart';
import 'splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://phpqmybemfecjgtrveed.supabase.co', // Ganti dengan URL Supabase Anda
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBocHFteWJlbWZlY2pndHJ2ZWVkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIzMzMyNTcsImV4cCI6MjA0NzkwOTI1N30.W-CuKneUG0g9r5ooLabGIX29Rx_Wvaq9rg3Tiqwu4FA', 
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ordering App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> menuItems = [
    {'name': 'Burger King Medium', 'price': '45500', 'image': 'assets/burger.png'},
    {'name': 'Original Kebab', 'price': '17500', 'image': 'assets/kebab.png'},
    {'name': 'Sauge', 'price': '45500', 'image': 'assets/sauge.png'},
    {'name': 'Premium Corndog', 'price': '18000', 'image': 'assets/corndog.png'},
    {'name': 'Nasi Goreng', 'price': '25000', 'image': 'assets/nasigoreng.png'},
    {'name': 'Es Kopi', 'price': '15000', 'image': 'assets/eskopi.png'},
  ];

  List<CartItem> cartItems = [];
  String selectedCategory = 'All';

 
  void _addToCart(String name, double price, String imageUrl) {
    setState(() {
      final existingItem = cartItems.firstWhere(
        (item) => item.name == name,
        orElse: () => CartItem(name: '', price: 0, imageUrl: ''),
      );
      if (existingItem.name.isNotEmpty) {
        existingItem.quantity++;
      } else {
        cartItems.add(CartItem(name: name, price: price, imageUrl: imageUrl));
      }
    });

    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$name has been added to the cart."),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
       leading: PopupMenuButton<String>(
  icon: Icon(Icons.menu, color: Colors.black),
  offset: Offset(0, 50),
  onSelected: (value) {
    if (value == 'about') {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('About Us'),
            content: Text('This is my restaurant app. Enjoy various delicious food and drinks here!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Tutup'),
              ),
            ],
          );
        },
      );
    }
  },
  itemBuilder: (context) => [
    PopupMenuItem(value: 'about', child: Text('About Us')),
  ],
),

        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryButton('All', Icons.fastfood, selectedCategory == 'All'),
                _buildCategoryButton('Food', Icons.restaurant_menu, selectedCategory == 'Food'),
                _buildCategoryButton('Drink', Icons.local_drink, selectedCategory == 'Drink'),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final menuItem = menuItems[index];
                return _buildFoodItem(
                  menuItem['name']!,
                  double.parse(menuItem['price']!),
                  menuItem['image']!,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(cartItems: cartItems),
              ),
            );
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
          }
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cartItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cartItems.fold<int>(0, (sum, item) => sum + item.quantity)}',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: isSelected ? Colors.white : Colors.black),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFoodItem(String name, double price, String imagePath) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),

          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Rp ${price.toStringAsFixed(0)}', style: TextStyle(color: Colors.grey[600])),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _addToCart(name, price, imagePath),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Add"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
