import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class MenuDetailPage extends StatefulWidget {
  const MenuDetailPage({super.key});

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  static const List<SpicyOption> _spicyOptions = [
    SpicyOption(
      label: 'Sedang',
      subLabel: 'Racikan pas standar Bu Sari',
      extraPrice: 0,
    ),
    SpicyOption(
      label: 'Pedas Nampol 🌶',
      subLabel: 'Ekstra cabai rawit merah geprek',
      extraPrice: 1000,
    ),
    SpicyOption(
      label: 'Pisah Sambal',
      subLabel: 'Sambal dibungkus plastik terpisah',
      extraPrice: 0,
    ),
  ];

  static const List<ExtraTopping> _toppings = [
    ExtraTopping(
      label: 'Tambah Telur Dadar',
      subLabel: 'Dadar daun bawang crispy tepi',
      extraPrice: 4000,
    ),
    ExtraTopping(
      label: 'Tambah Tempe Goreng (2 pcs)',
      subLabel: 'Tempe bumbu ketumbar renyah',
      extraPrice: 2000,
    ),
  ];

  int _selectedSpicy = 0;
  final Set<int> _selectedToppings = {};
  int _quantity = 1;
  bool _isFavorite = false;
  final TextEditingController _noteController = TextEditingController();

  MenuItem _menuItem = MenuData.all.first;
  late int _basePrice = _menuItem.price;

  int get _totalExtra =>
      _spicyOptions[_selectedSpicy].extraPrice +
      _selectedToppings.fold(0, (sum, i) => sum + _toppings[i].extraPrice);

  int get _totalPrice => (_basePrice + _totalExtra) * _quantity;

  String get _formattedTotal => 'Rp${MenuItem.formatNumber(_totalPrice)}';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is MenuItem) {
      _menuItem = args;
      _basePrice = args.price;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.background,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNameSection(),
                      _gap(),
                      _buildSpicySection(),
                      _gap(),
                      _buildToppingSection(),
                      _gap(),
                      _buildNoteSection(),
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomBar()),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // SLIVER APP BAR WITH HERO IMAGE
  // ────────────────────────────────────────────────
  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [AppShadows.black(alpha: 0.1, blur: 6, dy: 0)],
          ),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
      ),
      title: const Text(
        'Detail Menu',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.help_outline,
            color: AppColors.textSecondary,
            size: 22,
          ),
          onPressed: () {},
        ),
        const Padding(
          padding: EdgeInsets.only(right: 12),
          child: UserAvatar(size: 36, iconSize: 18),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (_menuItem.imagePath != null)
              Image.asset(
                _menuItem.imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _heroPlaceholder(),
              )
            else
              _heroPlaceholder(),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Color(0x40000000),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Row(
                children: [
                  _heroBadge(
                    Icons.local_fire_department,
                    'Paling Laris Kampus',
                    AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  _heroBadge(
                    Icons.verified,
                    '100% Halal',
                    const Color(0xFF555555),
                  ),
                ],
              ),
            ),
            Positioned(bottom: 16, right: 16, child: _favoriteButton()),
          ],
        ),
      ),
    );
  }

  Widget _favoriteButton() {
    return GestureDetector(
      onTap: () => setState(() => _isFavorite = !_isFavorite),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [AppShadows.black(alpha: 0.15, blur: 8, dy: 0)],
        ),
        child: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite ? Colors.red : AppColors.textSecondary,
          size: 20,
        ),
      ),
    );
  }

  Widget _heroPlaceholder() {
    return Container(
      color: const Color(0xFFFDEBD0),
      child: const Center(
        child: Icon(Icons.restaurant, size: 80, color: AppColors.primaryLight),
      ),
    );
  }

  Widget _heroBadge(IconData icon, String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // NAME SECTION
  // ────────────────────────────────────────────────
  Widget _buildNameSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _menuItem.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _menuItem.formattedPrice,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: AppColors.star, size: 16),
              const SizedBox(width: 3),
              Text(
                '${_menuItem.rating} (${_menuItem.reviewCount}+ rating)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.access_time_rounded,
                size: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 3),
              Text(
                _menuItem.estimasiMenit,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _menuItem.description,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // SECTION WRAPPER (judul + badge + hint)
  // ────────────────────────────────────────────────
  Widget _sectionCard({
    required String title,
    required Widget badge,
    required String hint,
    required Widget child,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              badge,
            ],
          ),
          const SizedBox(height: 2),
          Text(
            hint,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // SPICY SECTION — menggunakan RadioGroup (Flutter 3.32+)
  // ────────────────────────────────────────────────
  Widget _buildSpicySection() {
    return _sectionCard(
      title: 'Tingkat Kepedasan',
      badge: const PillTag('Wajib', color: AppColors.primary),
      hint: 'Pilih salah satu sesuai seleramu',
      child: RadioGroup<int>(
        groupValue: _selectedSpicy,
        onChanged: (value) {
          if (value != null) setState(() => _selectedSpicy = value);
        },
        child: Column(
          children: [
            for (var i = 0; i < _spicyOptions.length; i++)
              _OptionTile(
                control: Radio<int>(
                  value: i,
                  activeColor: AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                title: _spicyOptions[i].label,
                subtitle: _spicyOptions[i].subLabel,
                trailing: _spicyOptions[i].formattedExtra,
                selected: _selectedSpicy == i,
                onTap: () => setState(() => _selectedSpicy = i),
                trailingColor: _spicyOptions[i].extraPrice > 0
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  // TOPPING SECTION
  // ────────────────────────────────────────────────
  Widget _buildToppingSection() {
    return _sectionCard(
      title: 'Tambahan Lauk',
      badge: const PillTag('Opsional', color: AppColors.badgeHemat),
      hint: 'Bisa pilih lebih dari satu',
      child: Column(
        children: [
          for (var i = 0; i < _toppings.length; i++)
            _OptionTile(
              control: Checkbox(
                value: _selectedToppings.contains(i),
                onChanged: (value) => _toggleTopping(i, value == true),
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              title: _toppings[i].label,
              subtitle: _toppings[i].subLabel,
              trailing: _toppings[i].formattedExtra,
              selected: _selectedToppings.contains(i),
              onTap: () => _toggleTopping(i, !_selectedToppings.contains(i)),
              trailingColor: AppColors.primary,
            ),
        ],
      ),
    );
  }

  void _toggleTopping(int index, bool selected) {
    setState(() {
      if (selected) {
        _selectedToppings.add(index);
      } else {
        _selectedToppings.remove(index);
      }
    });
  }

  // ────────────────────────────────────────────────
  // NOTE SECTION
  // ────────────────────────────────────────────────
  Widget _buildNoteSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Catatan Khusus Bu Sari',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Spacer(),
              Text(
                'Maks. 100 karakter',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _noteController,
            maxLength: 100,
            maxLines: 3,
            decoration: InputDecoration(
              hintText:
                  'Cth: Jangan pakai daun kemangi ya bu, tolong banyakin kuah sambalnya...',
              hintStyle: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
              filled: true,
              fillColor: AppColors.background,
              border: _noteBorder(AppColors.divider, 1),
              enabledBorder: _noteBorder(AppColors.divider, 1),
              focusedBorder: _noteBorder(AppColors.primary, 1.5),
              counterStyle: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _noteBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget _gap() => const SizedBox(height: 8);

  // ────────────────────────────────────────────────
  // BOTTOM BAR
  // ────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [AppShadows.black(alpha: 0.1, blur: 16, dy: -4)],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _quantitySelector(),
              const SizedBox(width: 12),
              Expanded(child: _addToCartButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quantitySelector() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _quantityButton(
            icon: Icons.remove,
            filled: false,
            onTap: () {
              if (_quantity > 1) setState(() => _quantity--);
            },
          ),
          SizedBox(
            width: 32,
            child: Center(
              child: Text(
                '$_quantity',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          _quantityButton(
            icon: Icons.add,
            filled: true,
            onTap: () => setState(() => _quantity++),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 44,
        alignment: Alignment.center,
        decoration: filled
            ? const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(11),
                ),
              )
            : null,
        child: Icon(
          icon,
          size: 18,
          color: filled ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _addToCartButton() {
    return GestureDetector(
      onTap: _showAddedToCart,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [AppShadows.primary(alpha: 0.35, blur: 10, dy: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 6),
            const Text(
              'Tambah',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 1,
              height: 20,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(width: 10),
            Text(
              _formattedTotal,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddedToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Berhasil ditambahkan ke keranjang! $_formattedTotal',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

/// Satu baris pilihan (radio/checkbox) dengan judul, subjudul, dan harga.
class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.control,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.selected,
    required this.onTap,
    required this.trailingColor,
  });

  final Widget control;
  final String title;
  final String subtitle;
  final String trailing;
  final bool selected;
  final VoidCallback onTap;
  final Color trailingColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            control,
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              trailing,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: trailingColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
