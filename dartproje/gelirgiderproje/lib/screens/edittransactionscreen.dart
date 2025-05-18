import 'package:flutter/material.dart';

class EditTransactionScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;
  final int index;
  const EditTransactionScreen({
    super.key,
    required this.transaction,
    required this.index,
  });

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late String _type;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.transaction['title']);
    _amountController = TextEditingController(
      text: widget.transaction['amount'].toString(),
    );
    _type = widget.transaction['type'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("İşlem Düzenle")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _type,
              items: const [
                DropdownMenuItem(value: 'income', child: Text("Gelir")),
                DropdownMenuItem(value: 'expense', child: Text("Gider")),
              ],
              onChanged: (val) => setState(() => _type = val!),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Başlık'),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tutar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty ||
                    _amountController.text.isEmpty)
                  return;
                final updatedTransaction = {
                  'title': _titleController.text,
                  'amount': _amountController.text,
                  'type': _type,
                };
                Navigator.pop(context, {
                  'updatedTransaction': updatedTransaction,
                  'index': widget.index,
                });
              },
              child: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}
