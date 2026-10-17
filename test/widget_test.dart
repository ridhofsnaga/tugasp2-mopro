import 'package:flutter_test/flutter_test.dart';

import 'package:app1/main.dart';

void main() {
  testWidgets('Beranda menampilkan judul dan daftar menu', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Kantin Bu Sari'), findsOneWidget);
    expect(find.text('Paling Laris'), findsOneWidget);
    expect(find.text('Nasi Ayam Goreng'), findsOneWidget);
  });
}
