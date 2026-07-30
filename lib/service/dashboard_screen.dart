import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _totalSaldo = 0;
  List<Map<String, dynamic>> _riwayatPengeluaran = [];

  @override
  void initState() {
    super.initState();
    _muatDataLokal();
  }

  Future<void> _muatDataLokal() async {
    final prefs = await SharedPreferences.getInstance();
    final storedSaldo = prefs.getInt('totalSaldo') ?? 0;
    final riwayatString = prefs.getString('riwayatPengeluaran') ?? '[]';
    List<Map<String, dynamic>> riwayat = [];
    try {
      final decoded = jsonDecode(riwayatString) as List<dynamic>;
      riwayat = decoded.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      riwayat = [];
    }

    setState(() {
      _totalSaldo = storedSaldo;
      _riwayatPengeluaran = riwayat;
    });
  }

  Future<void> _tambahPengeluaran(String keterangan, int nominal) async {
    final prefs = await SharedPreferences.getInstance();
    final item = {
      'keterangan': keterangan,
      'nominal': nominal,
      'tanggal': DateTime.now().toIso8601String(),
    };

    setState(() {
      _totalSaldo -= nominal;
      _riwayatPengeluaran.insert(0, item);
    });

    await prefs.setInt('totalSaldo', _totalSaldo);
    await prefs.setString('riwayatPengeluaran', jsonEncode(_riwayatPengeluaran));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Saldo: Rp $_totalSaldo', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            const Text('Riwayat Pengeluaran:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: _riwayatPengeluaran.isEmpty
                  ? const Center(child: Text('Belum ada riwayat pengeluaran.'))
                  : ListView.separated(
                      itemCount: _riwayatPengeluaran.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = _riwayatPengeluaran[index];
                        final nominal = item['nominal'] ?? 0;
                        final keterangan = item['keterangan'] ?? '';
                        final tanggal = item['tanggal'] ?? '';
                        return ListTile(
                          title: Text(keterangan),
                          subtitle: Text(tanggal),
                          trailing: Text('-Rp $nominal'),
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _tambahPengeluaran('Contoh pengeluaran', 10000);
              },
              child: const Text('Tambah Contoh Pengeluaran'),
            ),
          ],
        ),
      ),
    );
  }
}