import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../widgets/menu_card.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  static const List<String> _tabs = ['Semua', 'Makanan', 'Minuman', 'Camilan'];
  static const List<String> _categories = ['', 'makanan', 'minuman', 'camilan'];
  static const List<IconData> _tabIcons = [
    Icons.restaurant,
    Icons.lunch_dining,
    Icons.local_drink,
    Icons.bakery_dining,
  ];

  int _selectedTab = 0;
  int _selectedNav = 0;

  List<MenuItem> get _filteredMenu {
    if (_selectedTab == 0) return MenuData.all;
    return MenuData.all
        .where((m) => m.category == _categories[_selectedTab])
        .toList();
  }

  void _openDetail(MenuItem item) =>
      Navigator.pushNamed(context, '/detail', arguments: item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildGreeting()),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildPromoBanner()),
            SliverToBoxAdapter(child: _buildCategoryTabs()),
            SliverToBoxAdapter(child: _buildSectionHeader()),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.78,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = _filteredMenu[index];
                  return MenuCard(item: item, onTap: () => _openDetail(item));
                }, childCount: _filteredMenu.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ────────────────────────────────────────────────
  // HEADER
  // ────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
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
                'Beranda',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Spacer(),
          _headerIconButton(Icons.notifications_outlined),
          const SizedBox(width: 8),
          const UserAvatar(),
        ],
      ),
    );
  }

  Widget _headerIconButton(IconData icon) {
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

  // ────────────────────────────────────────────────
  // GREETING
  // ────────────────────────────────────────────────
  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, Dimas! 👋',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Mau makan sedap apa siang ini?',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _statusPill(),
        ],
      ),
    );
  }

  Widget _statusPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
        boxShadow: [AppShadows.black(alpha: 0.05, blur: 4, dy: 1)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.green.withValues(alpha: 0.4),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          const Text(
            'Buka (Ramai)',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.green,
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // SEARCH BAR
  // ────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(child: _searchField()),
          const SizedBox(width: 10),
          _filterButton(),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [AppShadows.black(blur: 8)],
      ),
      child: const Row(
        children: [
          SizedBox(width: 12),
          Icon(Icons.search, color: AppColors.textMuted, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari ayam sambal, es teh, tahu...',
                hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [AppShadows.black(blur: 8)],
      ),
      child: const Icon(Icons.tune, color: AppColors.textPrimary, size: 20),
    );
  }

  // ────────────────────────────────────────────────
  // BANNER PROMO
  // ────────────────────────────────────────────────
  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFFD4500A), Color(0xFFE8703A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [AppShadows.primary(alpha: 0.35, blur: 16, dy: 6)],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            _promoCircle(right: -20, top: -20, size: 100, alpha: 0.08),
            _promoCircle(right: 20, bottom: -30, size: 80, alpha: 0.06),
            Positioned(
              right: 12,
              top: 10,
              bottom: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'lib/images/Nasi Ayam Goreng.png',
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 120, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _discountChip(),
                  const SizedBox(height: 6),
                  const Text(
                    'Paket Komplit Sambal\nBawang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Nasi gurih, ayam suwir pedas, tempe...',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rp15.000',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 10,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.white60,
                            ),
                          ),
                          Text(
                            'Rp12.000',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Pesan',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(
                              Icons.arrow_forward,
                              size: 12,
                              color: AppColors.primary,
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
    );
  }

  Widget _promoCircle({
    double? right,
    double? top,
    double? bottom,
    required double size,
    required double alpha,
  }) {
    return Positioned(
      right: right,
      top: top,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: alpha),
        ),
      ),
    );
  }

  Widget _discountChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_offer, color: Colors.white, size: 10),
          SizedBox(width: 4),
          Text(
            'Diskon Mahasiswa 15%',
            style: TextStyle(
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
  // CATEGORY TABS
  // ────────────────────────────────────────────────
  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _tabs.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, index) => _categoryTab(index),
        ),
      ),
    );
  }

  Widget _categoryTab(int index) {
    final selected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            selected
                ? AppShadows.primary(blur: 8, dy: 3)
                : AppShadows.black(alpha: 0.05, blur: 4, dy: 1),
          ],
        ),
        child: Row(
          children: [
            Icon(
              _tabIcons[index],
              size: 14,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 5),
            Text(
              _tabs[index],
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  // SECTION HEADER
  // ────────────────────────────────────────────────
  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          const Text(
            'Paling Laris',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          const PillTag('Favorit', color: AppColors.primary),
          const Spacer(),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Lihat Semua›',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // BOTTOM NAV
  // ────────────────────────────────────────────────
  Widget _buildBottomNav() {
    const items = [
      (icon: Icons.home_rounded, label: 'Beranda'),
      (icon: Icons.restaurant_menu_rounded, label: 'Menu'),
      (icon: Icons.shopping_bag_rounded, label: 'Keranjang'),
      (icon: Icons.receipt_long_rounded, label: 'Pesanan'),
      (icon: Icons.person_rounded, label: 'Profil'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [AppShadows.black(alpha: 0.08, blur: 16, dy: -4)],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < items.length; i++)
                _navItem(index: i, icon: items[i].icon, label: items[i].label),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final selected = _selectedNav == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedNav = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? AppColors.primary : AppColors.textMuted,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
