import 'package:flutter/material.dart';

class MenuListPage extends StatelessWidget {
  const MenuListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kantin Bu Sari - Daftar Menu'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Selamat Datang di Kantin Bu Sari!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Pilih menu favoritmu di bawah ini:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/detail');
                },
                icon: const Icon(Icons.restaurant_menu),
                label: const Text('Lihat Detail Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
