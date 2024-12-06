import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ordernow/models/menu_model.dart';
import 'dart:io';

class MenuService {
  final CollectionReference _menuCollection =
      FirebaseFirestore.instance.collection('menu');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Validasi file gambar
  bool _validateImageFile(File imageFile) {
    final bytes = imageFile.readAsBytesSync();
    final allowedExtensions = ['.jpg', '.jpeg', '.png'];
    final maxSizeInBytes = 5 * 1024 * 1024; // 5 MB

    if (!allowedExtensions
        .any((ext) => imageFile.path.toLowerCase().endsWith(ext))) {
      throw Exception(
          'File type not valid. Only jpg, jpeg, and png are allowed.');
    }

    if (bytes.length > maxSizeInBytes) {
      throw Exception('File size too large. Maximum 5 MB.');
    }

    return true;
  }

  // Unggah gambar ke Storage
  Future<String> _uploadImage(File imageFile) async {
    _validateImageFile(imageFile);

    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference ref = _storage.ref().child('menu_images/$fileName');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  // Create
  Future<void> createMenu(Menu menu, File? imageFile) async {
    try {
      String imageUrl = '';
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile);
      }

      await _menuCollection.doc(menu.id).set({
        ...menu.toJson(),
        'gambar': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create menu: $e');
    }
  }

  // Read
  Stream<List<Menu>> getMenus() {
    return _menuCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Menu.fromJson({...data, 'id': doc.id});
      }).toList();
    });
  }

  // Update
  Future<void> updateMenu(Menu menu, File? imageFile) async {
    try {
      Map<String, dynamic> updateData = {...menu.toJson()};

      if (imageFile != null) {
        // Hapus gambar lama jika ada
        if (menu.gambar.isNotEmpty) {
          try {
            await _storage.refFromURL(menu.gambar).delete();
          } catch (e) {
            print('Failed to delete old image: $e');
          }
        }

        // Unggah gambar baru
        String imageUrl = await _uploadImage(imageFile);
        updateData['gambar'] = imageUrl;
      }

      updateData['updatedAt'] = FieldValue.serverTimestamp();
      await _menuCollection.doc(menu.id).update(updateData);
    } catch (e) {
      throw Exception('Failed to update menu: $e');
    }
  }

  // Delete
  Future<void> deleteMenu(String menuId) async {
    try {
      // Dapatkan data menu untuk mendapatkan URL gambar
      DocumentSnapshot menuDoc = await _menuCollection.doc(menuId).get();
      Map<String, dynamic> menuData = menuDoc.data() as Map<String, dynamic>;

      // Hapus file gambar dari Storage jika ada
      if (menuData['gambar'] != null && menuData['gambar'] != '') {
        try {
          await _storage.refFromURL(menuData['gambar']).delete();
        } catch (e) {
          print('Failed to delete image: $e');
        }
      }

      // Hapus dokumen dari Firestore
      await _menuCollection.doc(menuId).delete();
    } catch (e) {
      throw Exception('Failed to delete menu: $e');
    }
  }
}
