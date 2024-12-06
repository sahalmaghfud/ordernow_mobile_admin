import 'package:cloud_firestore/cloud_firestore.dart';

class Pesanan {
  final String id;
  final String namaPel;
  final int noMeja;
  final int total;
  final String statusPembayaran;
  final String statusPesanan;
  final List<Detail> detail;
  final String? catatan;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pesanan({
    required this.id,
    required this.namaPel,
    required this.noMeja,
    required this.total,
    required this.statusPembayaran,
    required this.statusPesanan,
    required this.detail,
    this.catatan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pesanan.fromJson(Map<String, dynamic> json, {required String id}) {
    return Pesanan(
      id: id,
      namaPel: json['namaPel'] ?? '',
      noMeja: json['noMeja'] ?? 0,
      total: json['total'] ?? 0,
      statusPembayaran: json['statusPembayaran'] ?? '',
      statusPesanan: json['statusPesanan'] ?? '',
      detail: (json['detail'] as List<dynamic>)
          .map((item) => Detail.fromJson(item as Map<String, dynamic>))
          .toList(),
      catatan: json['catatan'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'namaPel': namaPel,
      'noMeja': noMeja,
      'total': total,
      'statusPembayaran': statusPembayaran,
      'statusPesanan': statusPesanan,
      'detail': detail.map((item) => item.toJson()).toList(),
      'catatan': catatan,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class Detail {
  final String namaMenu;
  final int quantity;
  final int harga;
  final int jumlah;

  Detail({
    required this.namaMenu,
    required this.quantity,
    required this.harga,
    required this.jumlah,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      namaMenu: json['namaMenu'] ?? '',
      quantity: json['quantity'] ?? 0,
      harga: json['harga'] ?? 0,
      jumlah: json['jumlah'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'namaMenu': namaMenu,
      'quantity': quantity,
      'harga': harga,
      'jumlah': jumlah,
    };
  }
}

extension PesananExtension on Pesanan {
  Pesanan copyWith({
    String? id, // Tambahkan id ke dalam copyWith
    String? namaPel,
    int? noMeja,
    int? total,
    String? statusPembayaran,
    String? statusPesanan,
    List<Detail>? detail,
    String? catatan,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Pesanan(
      id: id ?? this.id, // Tambahkan id
      namaPel: namaPel ?? this.namaPel,
      noMeja: noMeja ?? this.noMeja,
      total: total ?? this.total,
      statusPembayaran: statusPembayaran ?? this.statusPembayaran,
      statusPesanan: statusPesanan ?? this.statusPesanan,
      detail: detail ?? this.detail,
      catatan: catatan ?? this.catatan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
