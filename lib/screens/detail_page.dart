// lib/screens/detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/paket_jasa.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final PaketJasa paket;
  final void Function(PaketJasa, {int? stars}) onPesan;

  const DetailPage({super.key, required this.paket, required this.onPesan});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _starController = TextEditingController();

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final bool isImmortalPackage = widget.paket.id == 'p5';

    return Scaffold(
      appBar: AppBar(title: Text(widget.paket.judul)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(widget.paket.rankAwalUrl, width: 80),
                    Icon(Icons.arrow_forward_rounded, size: 30, color: Colors.grey[600]),
                    Image.asset(widget.paket.rankTujuanUrl, width: 80),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Deskripsi', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(widget.paket.deskripsi, style: Theme.of(context).textTheme.bodyMedium),
            if (isImmortalPackage)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah Bintang', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _starController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        hintText: 'Masukkan jumlah bintang',
                        prefixIcon: Icon(Icons.star_border),
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Estimasi:', style: TextStyle(fontSize: 16)),
                Text(widget.paket.estimasi, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Harga Dasar:', style: TextStyle(fontSize: 16)),
                Text(
                  formatter.format(widget.paket.harga),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.shopping_cart_checkout),
            label: const Text('Pesan Sekarang'),
            onPressed: () {
              int? stars;
              if (isImmortalPackage) {
                if (_starController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Harap masukkan jumlah bintang!'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }
                stars = int.tryParse(_starController.text);
              }
              widget.onPesan(widget.paket, stars: stars);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pesanan berhasil dibuat!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}