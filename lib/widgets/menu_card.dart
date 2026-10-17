import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../theme/app_theme.dart';
import 'app_widgets.dart';

/// Kartu satu item menu yang ditampilkan pada grid beranda.
class MenuCard extends StatelessWidget {
  const MenuCard({super.key, required this.item, required this.onTap});

  final MenuItem item;
  final VoidCallback onTap;

  Color get _badgeColor => switch (item.badge) {
    'Hemat' => AppColors.badgeHemat,
    'Segar' => AppColors.badgeSegar,
    _ => AppColors.badgeTerlaris,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [AppShadows.black(alpha: 0.07, blur: 12, dy: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: item.imagePath != null
                        ? Image.asset(
                            item.imagePath!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _imagePlaceholder(),
                          )
                        : _imagePlaceholder(isMinuman: true),
                  ),
                  if (item.badge != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: PillTag(
                        item.badge!,
                        color: _badgeColor,
                        solid: true,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.shortDesc,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        item.formattedPrice,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onTap,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
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

  Widget _imagePlaceholder({bool isMinuman = false}) {
    return Container(
      width: double.infinity,
      color: isMinuman ? const Color(0xFFD6EAF8) : const Color(0xFFFDEBD0),
      child: Icon(
        isMinuman ? Icons.local_drink : Icons.restaurant,
        color: isMinuman
            ? AppColors.badgeSegar.withValues(alpha: 0.5)
            : AppColors.primary.withValues(alpha: 0.3),
        size: 48,
      ),
    );
  }
}
