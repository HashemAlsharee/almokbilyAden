import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../catalog_data.dart';
import '../core/theme/app_colors.dart';
import 'company_products_page.dart';
import 'solar_calculator_page.dart';

// Everything for the HomePage (models, data, widgets) is defined in this file

class CompanyItem {
  final String title;
  final String bannerImage;
  final String routeName;
  final bool isArabic;
  final String? catalogId;

  const CompanyItem({
    required this.title,
    required this.bannerImage,
    required this.routeName,
    required this.catalogId,
    this.isArabic = false,
  });
}

const List<CompanyItem> companies = [
  CompanyItem(
    title: 'LONGI',
    bannerImage: 'images/LONGi_banner_2170x725.webp',
    routeName: 'longi',
    catalogId: 'longi',
  ),
  CompanyItem(
    title: 'Canadian Solar',
    bannerImage: 'images/CanadianSolar_banner_2170x725.webp',
    routeName: 'canadian',
    catalogId: 'canadian',
  ),
  CompanyItem(
    title: 'Solis',
    bannerImage: 'images/Solis_banner_2170x725.webp',
    routeName: 'solis',
    catalogId: 'solis',
  ),
  CompanyItem(
    title: 'PYLONTECH',
    bannerImage: 'images/PYLONTECH_banner_2170x725.webp',
    routeName: 'pylontech',
    catalogId: 'pylontech',
  ),
  CompanyItem(
    title: 'HITHIUM',
    bannerImage: 'images/HITHIUM_banner_2170x725.webp',
    routeName: 'hithium',
    catalogId: 'hithium',
  ),
  CompanyItem(
    title: 'حاسبة الأنظمة الشمسية',
    bannerImage: 'images/solar_banner_generated.webp',
    routeName: 'calculator',
    isArabic: true,
    catalogId: '',
  ),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openCatalog(BuildContext context, String catalogId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CompanyProductsPage(catalog: catalogById(catalogId)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const _TopHeader(),
                const _WelcomeSection(),
                const SizedBox(height: 12),
                ...companies.map(
                  (c) => _CompanyCard(
                    item: c,
                    onTap: () {
                      if (c.routeName == 'calculator') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SolarCalculatorPage(),
                          ),
                        );
                      } else if (c.catalogId != null &&
                          c.catalogId!.isNotEmpty) {
                        _openCatalog(context, c.catalogId!);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: SizedBox(height: 56, child: _safeSvg('images/0.svg'))),
          const SizedBox(height: 8),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.navy.withValues(alpha: .08),
          ),
        ],
      ),
    );
  }

  Widget _safeSvg(String asset) {
    return SvgPicture.asset(
      asset,
      fit: BoxFit.contain,
      semanticsLabel: 'logo',
      placeholderBuilder: (context) => const SizedBox.shrink(),
      // onPictureError won't crash the app; fallback handled by surrounding layout
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final height = screenWidth * 0.45; // responsive base
    final clampedHeight = height.clamp(280.0, 360.0);

    return SizedBox(
      width: double.infinity,
      height: clampedHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/1.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: AppColors.blue.withValues(alpha: .22)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background,
                  AppColors.background.withValues(alpha: .10),
                ],
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'مرحباً بكم',
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اختر الشركة التي ترغب باستعراض منتجاتها',
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(color: AppColors.navy, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final CompanyItem item;
  final VoidCallback onTap;

  const _CompanyCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth > 800
            ? 800.0
            : constraints.maxWidth;
        // Calculate the previous card height solely to preserve the exact same border radius
        final double oldCardHeight = (constraints.maxWidth * 0.30).clamp(
          170.0,
          205.0,
        );
        final double borderRadius = oldCardHeight * 0.11;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Material(
                color: AppColors.background.withValues(alpha: 0),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      color: AppColors.background,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.navy.withValues(alpha: .08),
                          blurRadius: 18,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: Image.asset(
                        item.bannerImage,
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: oldCardHeight,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
