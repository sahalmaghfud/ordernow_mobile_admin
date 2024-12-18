import 'package:ordernow/services/pesanan_service.dart';
import 'package:ordernow/models/pesanan_model.dart';
import 'package:flutter/material.dart';

class HistoriesScreen extends StatelessWidget {
  final PesananService _pesananService = PesananService();

  HistoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pesanan'),
      ),
      body: StreamBuilder<List<Pesanan>>(
        stream: _pesananService.getHistories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada pesanan'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Pesanan pesanan = snapshot.data![index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pesanan #${"aaa"}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text('Nama: ${pesanan.namaPel}'),
                      Text('No Meja: ${pesanan.noMeja}'),
                      Text('Total: Rp ${pesanan.total}'),
                      Text('Status Pesanan: ${pesanan.statusPesanan}'),
                      Text('Status Pembayaran: ${pesanan.statusPembayaran}'),

                      // Detail Pesanan
                      ExpansionTile(
                        title: const Text('Detail Pesanan'),
                        children: pesanan.detail
                            .map((detail) => ListTile(
                                  title: Text(detail.namaMenu),
                                  subtitle: Text(
                                      'Qty: ${detail.quantity} x Rp ${detail.harga}'),
                                  trailing: Text('Rp ${detail.jumlah}'),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
