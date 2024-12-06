import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  final String id;
  final String nama;
  final int harga;
  final String tipe;
  final String deskripsi;
  final String status;
  final String gambar;
  final DateTime createdAt;
  final DateTime updatedAt;

  Menu({
    required this.id,
    required this.nama,
    required this.harga,
    required this.tipe,
    required this.deskripsi,
    required this.status,
    required this.gambar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      harga: json['harga'] ?? 0,
      tipe: json['tipe'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      status: json['status'] ?? '',
      gambar: json['gambar'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'harga': harga,
      'tipe': tipe,
      'deskripsi': deskripsi,
      'status': status,
      'gambar': gambar,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
