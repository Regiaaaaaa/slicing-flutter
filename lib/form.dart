import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String? selectedCategory;
  String? selectedFileName;
  String? selectedFilePath;

  // Fungsi untuk memilih file
  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        selectedFileName = file.name;
        selectedFilePath = file.path;
      });
      print('Nama file: ${file.name}');
      print('Path file: ${file.path}');
    } else {
      print("Tidak ada file yang dipilih.");
    }
  }

  // Fungsi untuk menambahkan data ke Supabase
  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final category = selectedCategory ?? 'Uncategorized';

    try {
      // Simpan data ke Supabase
      final response = await Supabase.instance.client.from('foods').insert({
        'name': name,
        'price': price,
        'category': category,
        'image_url': selectedFileName ?? 'No file selected',
      });

      // // Periksa error dari Supabase
      // if (response.error != null) {
      //   throw response.error!;
      // }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk berhasil ditambahkan!')),
      );

      // Reset form setelah berhasil
      _formKey.currentState!.reset();
      _nameController.clear();
      _priceController.clear();
      setState(() {
        selectedCategory = null;
        selectedFileName = null;
        selectedFilePath = null;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
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
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Produk',
                    hintText: 'Masukkan nama produk',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama produk harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga harus diisi';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Harga harus berupa angka';
                    }
                    return null;
                  },
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
                    DropdownMenuItem(value: 'Makanan', child: Text('Makanan')),
                    DropdownMenuItem(value: 'Minuman', child: Text('Minuman')),
                    DropdownMenuItem(value: 'Snack', child: Text('Snack')),
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
                        child: const Text("Pilih File"),
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
                    onPressed: _addProduct,
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
