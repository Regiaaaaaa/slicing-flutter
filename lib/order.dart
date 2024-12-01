import 'package:flutter/material.dart';
import 'package:food_ordering_app/main.dart';
import 'package:food_ordering_app/profile.dart';
import 'package:food_ordering_app/form.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderPage extends StatefulWidget {
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _orderItems = [];
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Foto', 'Nama Produk', 'Harga', 'Aksi'];

  @override
  void initState() {
    super.initState();
    _fetchOrderItems();
  }

  Future<void> _fetchOrderItems() async {
    try {
      final List<dynamic> response = await _supabase.from('foods').select('*');

      setState(() {
        _orderItems = List<Map<String, dynamic>>.from(response);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching order items: $error')),
      );
    }
  }

  Future<void> _deleteOrderItem(int id) async {
  try {
    await _supabase
        .from('foods')
        .delete()
        .eq('id', id);

    _fetchOrderItems(); // Refresh data after deletion
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error deleting item: $error')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildAddDataSection(),
            _buildTabBar(),
            _buildOrderList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              ),
              color: Colors.black,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddDataSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductForm()),
              ).then((_) => _fetchOrderItems());
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF2D63E2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Add Data',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _tabs
                  .asMap()
                  .entries
                  .map((entry) =>
                      _buildTab(entry.value, entry.key == _selectedTabIndex))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = _tabs.indexOf(text);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _orderItems.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = _orderItems[index];
          return _buildOrderItem(
           id: item['id'] ?? 0,  // Provide a default if null
          name: item['name'] as String? ?? 'Unnamed Item',  // Cast and provide default
          price: item['price'] as int? ?? 0,
          category: item['category'] as String? ?? 'Unknown category',
          imagePath: item['image_url'] as String? ?? 'default_image.png',
          );
        },
      ),
    );
  }

  Widget _buildOrderItem({
    required int id,
    required String name,
    required int price,
    required String category,
    required String imagePath,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  category,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  price.toString(),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.delete_outline, size: 18, color: Colors.red),
              padding: EdgeInsets.zero,
              onPressed: () => _deleteOrderItem(id),
            ),
          ),
        ],
      ),
    );
  }
}
