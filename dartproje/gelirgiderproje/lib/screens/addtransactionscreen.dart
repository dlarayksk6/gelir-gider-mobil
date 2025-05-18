import 'package:flutter/material.dart';
import 'package:gelirgiderproje/screens/homescreen.dart';
import 'package:gelirgiderproje/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _kategori = TextEditingController();
  final TextEditingController _miktar = TextEditingController();
  final TextEditingController _aciklama = TextEditingController();
  final TextEditingController _tarih = TextEditingController();
  final TextEditingController _fatura = TextEditingController();
  String type = 'income';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yeni İşlem")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: type,
              items: const [
                DropdownMenuItem(value: 'income', child: Text("Gelir")),
                DropdownMenuItem(value: 'expense', child: Text("Gider")),
              ],
              onChanged: (val) => setState(() => type = val!),
            ),
            TextField(
              controller: _kategori,
              decoration: const InputDecoration(labelText: 'Kategori'),
            ),
            TextField(
              controller: _miktar,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tutar'),
            ),
            TextField(
              controller: _aciklama,
              decoration: const InputDecoration(labelText: 'Açıklama'),
            ),
            TextField(
              controller: _tarih,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Tarih Seç',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  String formattedDate = pickedDate.toIso8601String();
                  setState(() {
                    _tarih.text = formattedDate;
                  });
                }
              },
            ),
            TextField(
              controller: _fatura,
              decoration: const InputDecoration(labelText: 'Fatura'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _data();
              },
              child: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> _data() async {
    if (_kategori.text.isEmpty || _miktar.text.isEmpty) return;

    final islem = type == 'income' ? 'gelir' : 'gider';
    final miktar = double.tryParse(_miktar.text) ?? 0.0;
    final kategori = _kategori.text;
    final tarih = _tarih.text;
    final aciklama = _aciklama.text;
    final fatura = _fatura.text;

    final token = await getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Giriş yapılmamış. Lütfen tekrar giriş yapın.'),
        ),
      );
      return;
    }

    final result = await ApiService().dataSave(
      islem,
      miktar,
      kategori,
      tarih,
      aciklama,
      fatura,
      token,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result ?? 'Veri kaydedilemedi')));

    if (result == 'Kayıt başarılı') {
      Navigator.pop(context, {
        'kategori': kategori,
        'miktar': miktar,
        'islem': islem,
        'tarih': tarih,
        'aciklama': aciklama,
      });
    }
  }
}
