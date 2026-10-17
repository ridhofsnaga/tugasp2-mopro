class MenuItem {
  final String id;
  final String name;
  final String description;
  final String shortDesc;
  final int price;
  final double rating;
  final int reviewCount;
  final String estimasiMenit;
  final String? imagePath;
  final String? badge;
  final String category;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDesc,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.estimasiMenit,
    this.imagePath,
    this.badge,
    required this.category,
  });

  String get formattedPrice => 'Rp${formatNumber(price)}';

  static String formatNumber(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class MenuData {
  static const List<MenuItem> all = [
    MenuItem(
      id: '1',
      name: 'Nasi Ayam Goreng',
      description:
          'Paket nasi pulen hangat dengan ayam goreng bumbu kuning lengkuas khas Bu Sari yang gurih renyah, disajikan dengan sambal terasi pedas manis, tahu/tempe, dan lalapan segar timun kemangi.',
      shortDesc: 'Ayam renyah + sambal',
      price: 12000,
      rating: 4.9,
      reviewCount: 120,
      estimasiMenit: '5-10 menit',
      imagePath: 'lib/images/Nasi Ayam Goreng.png',
      badge: 'Terlaris',
      category: 'makanan',
    ),
    MenuItem(
      id: '2',
      name: 'Nasi Telur Dadar',
      description:
          'Nasi pulen dengan telur dadar kribo renyah khas Bu Sari, digoreng dengan bumbu bawang yang harum. Disajikan dengan sambal dan lalapan segar.',
      shortDesc: 'Dadar kribo renyah',
      price: 10000,
      rating: 4.7,
      reviewCount: 98,
      estimasiMenit: '5-8 menit',
      imagePath: 'lib/images/Nasi Telur Goreng.png',
      badge: 'Hemat',
      category: 'makanan',
    ),
    MenuItem(
      id: '3',
      name: 'Mi Goreng Spesial',
      description:
          'Mi goreng spesial dengan telur, sawi, dan kerupuk renyah. Bumbu rahasia Bu Sari yang kaya rasa, cocok untuk makan siang.',
      shortDesc: 'Telur, sawi & kerupuk',
      price: 10000,
      rating: 4.8,
      reviewCount: 85,
      estimasiMenit: '7-12 menit',
      imagePath: 'lib/images/Mie Goreng Spesial.png',
      badge: null,
      category: 'makanan',
    ),
    MenuItem(
      id: '4',
      name: 'Es Teh Manis',
      description:
          'Es teh manis dengan aroma melati asli yang menyegarkan. Dibuat dari teh pilihan yang diseduh langsung, disajikan dingin dengan es batu.',
      shortDesc: 'Wangi melati asli dingin',
      price: 5000,
      rating: 4.6,
      reviewCount: 210,
      estimasiMenit: '2-3 menit',
      imagePath: 'lib/images/Es Teh Manis.jpg',
      badge: 'Segar',
      category: 'minuman',
    ),
  ];
}

class SpicyOption {
  final String label;
  final String subLabel;
  final int extraPrice;

  const SpicyOption({
    required this.label,
    required this.subLabel,
    required this.extraPrice,
  });

  String get formattedExtra =>
      extraPrice == 0 ? 'Gratis' : '+Rp${MenuItem.formatNumber(extraPrice)}';
}

class ExtraTopping {
  final String label;
  final String subLabel;
  final int extraPrice;

  const ExtraTopping({
    required this.label,
    required this.subLabel,
    required this.extraPrice,
  });

  String get formattedExtra => '+Rp${MenuItem.formatNumber(extraPrice)}';
}
