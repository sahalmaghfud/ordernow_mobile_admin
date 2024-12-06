import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ordernow/models/pesanan_model.dart';

class PesananService {
  final CollectionReference _pesananCollection =
      FirebaseFirestore.instance.collection('pesanan');

  Stream<List<Pesanan>> getPesanans() {
    return _pesananCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Pesanan.fromJson(data, id: doc.id);
          })
          .where((pesanan) => pesanan.statusPesanan != 'Selesai')
          .toList();
    });
  }

  Stream<List<Pesanan>> getHistories() {
    return _pesananCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Pesanan.fromJson(data, id: doc.id);
          })
          .where((pesanan) => pesanan.statusPesanan == 'Selesai')
          .toList();
    });
  }

  Future<void> updatePesananStatus(String id, String newStatus) async {
    try {
      await _pesananCollection.doc(id).update({'statusPesanan': newStatus});
    } catch (e) {
      throw Exception('Error updating pesanan: $e');
    }
  }

  Future<void> updatePembayaranStatus(String id, String newStatus) async {
    try {
      await _pesananCollection.doc(id).update({'statusPembayaran': newStatus});
    } catch (e) {
      throw Exception('Error updating pesanan: $e');
    }
  }

  // Update Pesanan
  Future<void> updatePesanan(
      String docId, Map<String, dynamic> updateData) async {
    try {
      // Menambahkan timestamp terbaru
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      // Update data pada dokumen berdasarkan ID
      await _pesananCollection.doc(docId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update pesanan: $e');
    }
  }

  // Delete Pesanan
  Future<void> deletePesanan(String pesananId) async {
    try {
      await _pesananCollection.doc(pesananId).delete();
    } catch (e) {
      throw Exception('Failed to delete pesanan: $e');
    }
  }
}
