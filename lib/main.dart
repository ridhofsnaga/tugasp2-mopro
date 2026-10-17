import 'package:flutter/material.dart';

import 'pages/beranda_page.dart';
import 'pages/menu_detail_page.dart';
import 'pages/menu_list_page.dart';
import 'pages/order_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Bu Sari',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,

      // Route utama ke BerandaPage
      initialRoute: '/',
      routes: {
        '/': (context) => const BerandaPage(),
        '/detail': (context) => const MenuDetailPage(),
        '/menu': (context) => const MenuListPage(),
        '/pesan': (context) => const OrderPage(),
      },
    );
  }
}
