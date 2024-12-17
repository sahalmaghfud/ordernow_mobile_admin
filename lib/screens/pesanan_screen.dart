import 'package:ordernow/services/pesanan_service.dart';
import 'package:ordernow/models/pesanan_model.dart';
import 'package:flutter/material.dart';

class PesananScreen extends StatelessWidget {
  final PesananService _pesananService = PesananService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pesanan'),
      ),
      body: StreamBuilder<List<Pesanan>>(
        stream: _pesananService.getPesanans(),
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
                      //Dropdown Status Pesanan
                      Row(
                        children: [
                          const Text('Status Pesanan: '),
                          DropdownButton<String>(
                            value: pesanan.statusPesanan,
                            items: [
                              'Menunggu',
                              'Diproses',
                              'Selesai',
                              'Dibatalkan',
                            ]
                                .map((status) => DropdownMenuItem(
                                      value: status,
                                      child: Text(status),
                                    ))
                                .toList(),
                            onChanged: (newStatus) async {
                              if (newStatus != null) {
                                try {
                                  // Panggil service untuk memperbarui status
                                  await _pesananService.updatePesananStatus(
                                      pesanan.id, newStatus);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Status pesanan berhasil diperbarui!'),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Gagal memperbarui status: $e'),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          const Text('Status Pesanan: '),
                          DropdownButton<String>(
                            value: pesanan.statusPembayaran,
                            items: ['Sudah Bayar', 'Belum Dibayar']
                                .map((status) => DropdownMenuItem(
                                      value: status,
                                      child: Text(status),
                                    ))
                                .toList(),
                            onChanged: (newStatus) async {
                              if (newStatus != null) {
                                try {
                                  await _pesananService.updatePembayaranStatus(
                                      pesanan.id, newStatus);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Status pesanan berhasil diperbarui!'),
                                    ),
                                  );
                                } catch (e) {
                                  // Tampilkan error ke pengguna jika gagal
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Gagal memperbarui status: $e'),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
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
