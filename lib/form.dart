import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:food_ordering_app/order.dart';


class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCategory;
  String? selectedFileName; 
  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        selectedFileName = file.name; 
      });
      print('Nama file: ${file.name}');
      print('Path file: ${file.path}');
      print('Ukuran file: ${file.size}');
    } else {
      print("Tidak ada file yang dipilih.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nama Produk',
                    hintText: 'Masukkan nama produk',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Harga',
                    hintText: 'Masukkan harga',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Kategori produk',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  items: const [
                    DropdownMenuItem(value: 'makanan', child: Text('Makanan')),
                    DropdownMenuItem(value: 'minuman', child: Text('Minuman')),
                    DropdownMenuItem(value: 'snack', child: Text('Snack')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: pickFile,
                        child: Text("Pilih File"),
                      ),
                      if (selectedFileName != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'File terpilih: $selectedFileName',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {}

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderPage())
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
