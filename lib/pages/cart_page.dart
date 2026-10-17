import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartData _cart = CartData.instance;
  final _noteController = TextEditingController();
  bool _withEcoware = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _increment(CartItem item) {
    setState(() => item.qty++);
    HapticFeedback.lightImpact();
  }

  void _decrement(CartItem item) {
    if (item.qty <= 1) {
      _confirmRemove(item);
      return;
    }
    setState(() => item.qty--);
    HapticFeedback.lightImpact();
  }

  void _confirmRemove(CartItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _RemoveConfirmSheet(
        itemName: item.menuItem.name,
        onConfirm: () {
          setState(() => _cart.items.remove(item));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _clearCart() {
    setState(() => _cart.items.clear());
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = _cart.items.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (isEmpty)
              const Expanded(child: _EmptyCart())
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPickupCard(),
                      const SizedBox(height: 8),
                      ..._cart.items.map((item) => _CartItemCard(
                            item: item,
                            onIncrement: () => _increment(item),
                            onDecrement: () => _decrement(item),
                            onDelete: () => _confirmRemove(item),
                          )),
                      const SizedBox(height: 8),
                      _buildEcowareSection(),
                      const SizedBox(height: 8),
                      _buildPaymentSummary(),
                      _buildPointsInfo(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: isEmpty ? null : _buildBottomBar(),
    );
  }

  // ──────────────────────────────────────────────────
  // HEADER
  // ──────────────────────────────────────────────────
  Widget _buildHeader() {
    final count = _cart.items.fold(0, (sum, e) => sum + e.qty);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          // Brand icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.storefront, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kantin Bu Sari',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Keranjang',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Spacer(),
          _IconBtn(icon: Icons.notifications_outlined),
          const SizedBox(width: 8),
          const UserAvatar(),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────
  // SUB-HEADER  (Keranjang Saya  · N Item · Kosongkan)
  // ──────────────────────────────────────────────────
  Widget _buildSubHeader() {
    final count = _cart.items.fold(0, (sum, e) => sum + e.qty);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          const Text(
            'Keranjang Saya',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count Item',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _clearCart,
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 3),
                const Text(
                  'Kosongkan',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────
  // PICKUP CARD
  // ──────────────────────────────────────────────────
  Widget _buildPickupCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubHeader(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [AppShadows.black()],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.storefront_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOKASI PENGAMBILAN',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Kantin Bu Sari (Gedung Utama Lt. 1)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Meja Pengambilan Khusus Pesanan Online',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 13,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 4),
                          Text.rich(
                            TextSpan(
                              text: 'Estimasi siap: ',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                              children: [
                                TextSpan(
                                  text: '10 - 15 Menit',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────
  // ECOWARE + CATATAN
  // ──────────────────────────────────────────────────
  Widget _buildEcowareSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [AppShadows.black()],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle row
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.eco_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alat Makan Ramah Lingkungan',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Tambah sendok & garpu kayu?',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _withEcoware = !_withEcoware),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _withEcoware
                          ? AppColors.primary
                          : AppColors.divider,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _withEcoware ? Icons.check : Icons.add,
                      color: _withEcoware
                          ? Colors.white
                          : AppColors.textSecondary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Catatan Tambahan untuk Penjual',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.divider),
              ),
              child: TextField(
                controller: _noteController,
                maxLines: 2,
                style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Contoh: Sambal dipisah, kuah agak banyak ya Bu...',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────
  // PAYMENT SUMMARY
  // ──────────────────────────────────────────────────
  Widget _buildPaymentSummary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [AppShadows.black()],
        ),
        child: Column(
          children: [
            // Title row
            Row(
              children: [
                const Text(
                  'Ringkasan Pembayaran',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.school_outlined, size: 12, color: AppColors.primary),
                      SizedBox(width: 3),
                      Text(
                        'Mahasiswa Aktif',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SummaryRow(
              label: 'Subtotal Menu',
              value: _cart.formattedSubtotal,
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              label: '❤ Diskon Mahasiswa',
              value: '-Rp${MenuItem.formatNumber(CartData.diskonMahasiswa)}',
              labelColor: AppColors.primary,
              valueColor: AppColors.red,
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              label: 'Biaya Kemasan Ramah Lingkungan',
              value: 'Rp${MenuItem.formatNumber(CartData.biayaKemasan)}',
              labelStyle: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Tagihan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      _cart.formattedTotal,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  'Termasuk PPN',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────
  // POIN INFO
  // ──────────────────────────────────────────────────
  Widget _buildPointsInfo() {
    final points = (_cart.total / 1000).floor();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            const Icon(Icons.stars_rounded, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: 'Kamu akan mendapatkan ',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: '+$points Poin Kantin',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const TextSpan(text: ' setelah transaksi selesai!'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────
  // BOTTOM BAR
  // ──────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [AppShadows.black(alpha: 0.08, blur: 16, dy: -4)],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TOTAL PESANAN',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                _cart.formattedTotal,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/pesan'),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [AppShadows.primary()],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Lanjutkan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// CART ITEM CARD
// ════════════════════════════════════════════════════
class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [AppShadows.black()],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: item.menuItem.imagePath != null
                  ? Image.asset(
                      item.menuItem.imagePath!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imageFallback(),
                    )
                  : _imageFallback(),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.menuItem.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onDelete,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (item.note != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.note!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        item.formattedSubtotal,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      _QtyControl(
                        qty: item.qty,
                        onDecrement: onDecrement,
                        onIncrement: onIncrement,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback() => Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.restaurant, color: AppColors.textMuted),
      );
}

// ════════════════════════════════════════════════════
// QTY CONTROL  (– · N · +)
// ════════════════════════════════════════════════════
class _QtyControl extends StatelessWidget {
  const _QtyControl({
    required this.qty,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int qty;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _qtyBtn(Icons.remove, onDecrement, filled: false),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '$qty',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        _qtyBtn(Icons.add, onIncrement, filled: true),
      ],
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, {required bool filled}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
          border: filled
              ? null
              : Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Icon(icon, size: 14, color: filled ? Colors.white : AppColors.primary),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// SUMMARY ROW
// ════════════════════════════════════════════════════
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.labelColor,
    this.valueColor,
    this.labelStyle,
  });

  final String label;
  final String value;
  final Color? labelColor;
  final Color? valueColor;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: labelStyle ??
                TextStyle(
                  fontSize: 13,
                  color: labelColor ?? AppColors.textSecondary,
                  fontWeight:
                      labelColor != null ? FontWeight.w600 : FontWeight.w400,
                ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════
// EMPTY CART STATE
// ════════════════════════════════════════════════════
class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Keranjang Kosong',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Yuk tambahkan menu favoritmu!',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Lihat Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// REMOVE CONFIRM BOTTOM SHEET
// ════════════════════════════════════════════════════
class _RemoveConfirmSheet extends StatelessWidget {
  const _RemoveConfirmSheet({required this.itemName, required this.onConfirm});

  final String itemName;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Icon(
            Icons.delete_outline_rounded,
            size: 36,
            color: AppColors.red,
          ),
          const SizedBox(height: 10),
          Text(
            'Hapus "$itemName"?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Item ini akan dihapus dari keranjangmu.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Hapus',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// ICON BUTTON HELPER
// ════════════════════════════════════════════════════
class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [AppShadows.black()],
      ),
      child: Icon(icon, size: 20, color: AppColors.textPrimary),
    );
  }
}
