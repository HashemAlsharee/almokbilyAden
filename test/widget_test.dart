import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:almokbily_aden/catalog_data.dart';
import 'package:almokbily_aden/core/theme/app_theme.dart';
import 'package:almokbily_aden/main.dart';
import 'package:almokbily_aden/pages/company_products_page.dart';
import 'package:almokbily_aden/pages/home_page.dart';
import 'package:almokbily_aden/pages/product_details_page.dart';

void main() {
  testWidgets('يعرض الصفحة الرئيسية', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('مرحباً بك'), findsOneWidget);
  });

  for (final size in <Size>[const Size(360, 640), const Size(1200, 1920)]) {
    testWidgets('صفحة المنتجات بدون overflow عند $size', (tester) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      for (final catalog in companyCatalogs) {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: CompanyProductsPage(catalog: catalog),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(CompanyProductsPage), findsOneWidget);
        expect(
          tester.takeException(),
          isNull,
          reason: 'ظهر خطأ في صفحة ${catalog.displayName} عند $size',
        );
      }
    });

    testWidgets('صفحة التفاصيل بدون overflow عند $size', (tester) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final catalog = companyCatalogs.first;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ProductDetailsPage(
            product: catalog.products.first,
            catalog: catalog,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ProductDetailsPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
