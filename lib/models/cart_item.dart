import 'menu_item.dart';

/// Satu baris item di keranjang, menyimpan referensi [MenuItem],
/// jumlah (qty), dan catatan opsional.
class CartItem {
  final MenuItem menuItem;
  final String? note; // e.g. "Pedas Nampol, +Telur Dadar"
  int qty;

  CartItem({required this.menuItem, this.note, this.qty = 1});

  int get subtotal => menuItem.price * qty;
  String get formattedSubtotal => 'Rp${MenuItem.formatNumber(subtotal)}';
}

/// Singleton sederhana untuk mengelola state keranjang.
class CartData {
  CartData._();
  static final CartData instance = CartData._();

  final List<CartItem> items = [
    CartItem(
      menuItem: MenuData.all[0], // Nasi Ayam Goreng
      note: 'Pedas Nampol, +Telur Dadar',
      qty: 1,
    ),
    CartItem(
      menuItem: MenuData.all[1], // Nasi Telur Dadar
      note: 'Sambal Sedang',
      qty: 1,
    ),
    CartItem(
      menuItem: MenuData.all[3], // Es Teh Manis
      note: 'Manis Sedang, Es Sedikit',
      qty: 2,
    ),
  ];

  /// Diskon mahasiswa tetap
  static const int diskonMahasiswa = 5000;

  /// Biaya kemasan ramah lingkungan
  static const int biayaKemasan = 1000;

  int get subtotalMenu => items.fold(0, (sum, e) => sum + e.subtotal);

  int get total => subtotalMenu - diskonMahasiswa + biayaKemasan;

  String get formattedSubtotal => 'Rp${MenuItem.formatNumber(subtotalMenu)}';
  String get formattedTotal => 'Rp${MenuItem.formatNumber(total)}';
}
