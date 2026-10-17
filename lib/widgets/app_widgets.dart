import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Label kecil berbentuk kapsul untuk badge, status, dan tag kategori.
///
/// `solid: false` (default) menampilkan latar warna transparan dengan teks
/// berwarna, sedangkan `solid: true` menampilkan latar penuh dengan teks putih.
class PillTag extends StatelessWidget {
  const PillTag(
    this.label, {
    super.key,
    required this.color,
    this.solid = false,
    this.fontSize = 11,
    this.fontWeight = FontWeight.w600,
  });

  final String label;
  final Color color;
  final bool solid;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: solid ? color : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: solid ? Colors.white : color,
        ),
      ),
    );
  }
}

/// Avatar bulat berwarna primary yang dipakai di header beranda & detail.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.size = 38, this.iconSize = 20});

  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryLight,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Icon(Icons.person, color: Colors.white, size: iconSize),
    );
  }
}
