import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _changeEmail(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('E-posta Değiştir'),
            content: const Text(
              'Bu özellik MongoDB bağlantısıyla aktif olacaktır.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tamam'),
              ),
            ],
          ),
    );
  }

  void _changePassword(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Şifre Değiştir'),
            content: const Text(
              'Bu özellik MongoDB bağlantısıyla aktif olacaktır.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tamam'),
              ),
            ],
          ),
    );
  }

  void _changeTheme(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Tema Değiştir'),
            content: const Text(
              'Tema değiştirme özelliği daha sonra entegre edilecek.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tamam'),
              ),
            ],
          ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Çıkış Yap'),
            content: const Text('Gerçek çıkış işlemi MongoDB ile çalışacak.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tamam'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text("E-posta Değiştir"),
            onTap: () => _changeEmail(context),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Şifre Değiştir"),
            onTap: () => _changePassword(context),
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text("Tema Değiştir"),
            onTap: () => _changeTheme(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Çıkış Yap"),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
