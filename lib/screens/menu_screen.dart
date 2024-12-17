import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ordernow/services/menu_service.dart';
import 'package:ordernow/models/menu_model.dart';
import 'dart:io';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final MenuService _menuService = MenuService();
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  String _selectedTipe = 'makanan';
  String _selectedStatus = 'tersedia';

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  void _clearForm() {
    _namaController.clear();
    _hargaController.clear();
    _deskripsiController.clear();
    setState(() {
      _selectedTipe = 'makanan';
      _selectedStatus = 'tersedia';
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/pesanan');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Menu>>(
                stream: _menuService.getMenus(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final menus = snapshot.data!;
                  return ListView.builder(
                    itemCount: menus.length,
                    itemBuilder: (context, index) {
                      final menu = menus[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading: menu.gambar.isNotEmpty
                              ? Image.network(menu.gambar,
                                  width: 50, height: 50)
                              : const Icon(Icons.restaurant, size: 40),
                          title: Text(menu.nama),
                          subtitle: Text('${menu.tipe} - Rp ${menu.harga}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showEditDialog(menu),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _showDeleteDialog(menu),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showEditDialog(Menu menu) async {
    _namaController.text = menu.nama;
    _hargaController.text = menu.harga.toString();
    _deskripsiController.text = menu.deskripsi;
    _selectedTipe = menu.tipe;
    _selectedStatus = menu.status;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Menu'),
        content: _buildForm(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final updatedMenu = Menu(
                  id: menu.id,
                  nama: _namaController.text,
                  harga: int.parse(_hargaController.text),
                  tipe: _selectedTipe,
                  deskripsi: _deskripsiController.text,
                  status: _selectedStatus,
                  gambar: menu.gambar,
                  createdAt: menu.createdAt,
                  updatedAt: DateTime.now(),
                );
                Navigator.pop(context);
                await _menuService.updateMenu(updatedMenu, _imageFile);
                _clearForm();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddDialog() async {
    _clearForm();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambahkan Menu'),
        content: _buildForm(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final menu = Menu(
                  id: DateTime.now().toString(),
                  nama: _namaController.text,
                  harga: int.parse(_hargaController.text),
                  tipe: _selectedTipe,
                  deskripsi: _deskripsiController.text,
                  status: _selectedStatus,
                  gambar: '',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                Navigator.pop(context);
                await _menuService.createMenu(menu, _imageFile);
                _clearForm();
              }
            },
            child: const Text('Tambahkan'),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Menu'),
              validator: (value) => value!.isEmpty ? 'Masukan Nama Menu' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _hargaController,
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Masukan Harga' : null,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedTipe,
              decoration: const InputDecoration(labelText: 'Tipe'),
              items: ['makanan', 'minuman'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTipe = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _deskripsiController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(labelText: 'Status'),
              items: ['tersedia', 'tidak tersedia'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pilih Gambar'),
            ),
            if (_imageFile != null) Image.file(_imageFile!, height: 100),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(Menu menu) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Menu'),
        content: Text('Apakah anda yakin ingin menghapus ${menu.nama}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await _menuService.deleteMenu(menu.id);
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
