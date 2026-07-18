import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../catalog_data.dart';
import '../core/theme/app_colors.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductItem product;
  final CompanyCatalog catalog;

  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.catalog,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _Header(
                  title: '${catalog.displayName} ${product.model}',
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 790),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
                      child: Column(
                        children: [
                          _ProductStage(product: product, catalog: catalog),
                          const SizedBox(height: 20),
                          _IdentityCard(product: product, catalog: catalog),
                          const SizedBox(height: 20),
                          _OverviewCard(product: product),
                          const SizedBox(height: 20),
                          _SpecificationsCard(product: product),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 790),
        child: SizedBox(
          height: 112,
          child: LayoutBuilder(
            builder: (context, constraints) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: AppColors.orange,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: SizedBox(
                      width: (constraints.maxWidth * .43).clamp(135.0, 260.0),
                      height: 62,
                      child: SvgPicture.asset(
                        'images/0.svg',
                        fit: BoxFit.contain,
                        colorFilter: const ColorFilter.mode(
                          AppColors.navy,
                          BlendMode.srcIn,
                        ),
                        placeholderBuilder: (_) => const _LogoFallback(),
                        errorBuilder: (_, __, ___) => const _LogoFallback(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback();
  @override
  Widget build(BuildContext context) => const FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(
      'ALMOKBILY',
      style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900),
    ),
  );
}

class _ProductStage extends StatelessWidget {
  final ProductItem product;
  final CompanyCatalog catalog;
  const _ProductStage({required this.product, required this.catalog});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.12,
      child: Container(
        decoration: _cardDecoration(radius: 18),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              right: -80,
              bottom: -90,
              child: Container(
                width: 310,
                height: 270,
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(130),
                ),
              ),
            ),
            Positioned(
              left: -50,
              bottom: -80,
              child: Transform.rotate(
                angle: -.45,
                child: Container(
                  width: 90,
                  height: 390,
                  color: AppColors.orange.withValues(alpha: .52),
                ),
              ),
            ),
            Positioned(
              left: 28,
              top: 30,
              child: SizedBox(
                width: 130,
                height: 48,
                child: Image.asset(
                  catalog.logoPath,
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
            Center(
              child: FractionallySizedBox(
                heightFactor: .82,
                widthFactor: .62,
                child: _LargeProductImage(product: product),
              ),
            ),
            Positioned(
              right: -35,
              top: 145,
              child: SizedBox(
                width: 90,
                height: 170,
                child: CustomPaint(painter: _DotsPainter()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LargeProductImage extends StatelessWidget {
  final ProductItem product;
  const _LargeProductImage({required this.product});

  @override
  Widget build(BuildContext context) {
    if (product.imagePath.isNotEmpty) {
      return Image.asset(
        product.imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const _PanelPlaceholder(),
      );
    }
    return const _PanelPlaceholder();
  }
}

class _PanelPlaceholder extends StatelessWidget {
  const _PanelPlaceholder();
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.navy,
      border: Border.all(color: AppColors.blue, width: 3),
      borderRadius: BorderRadius.circular(4),
      boxShadow: [
        BoxShadow(
          color: AppColors.navy.withValues(alpha: .22),
          blurRadius: 14,
          offset: const Offset(7, 10),
        ),
      ],
    ),
    child: const Center(
      child: Icon(Icons.solar_power_outlined, color: AppColors.blue, size: 68),
    ),
  );
}

class _IdentityCard extends StatelessWidget {
  final ProductItem product;
  final CompanyCatalog catalog;
  const _IdentityCard({required this.product, required this.catalog});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(32, 26, 32, 28),
    decoration: _decoratedCard(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${catalog.displayName} ${product.model}',
          textDirection: TextDirection.ltr,
          style: const TextStyle(
            color: AppColors.navy,
            fontSize: 29,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Text(
              catalog.displayName,
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                color: AppColors.navy,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              width: 2,
              height: 26,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: AppColors.orange,
            ),
            Flexible(
              child: Text(
                product.type,
                style: const TextStyle(
                  color: AppColors.orange,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _OverviewCard extends StatelessWidget {
  final ProductItem product;
  const _OverviewCard({required this.product});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(32, 32, 32, 42),
    decoration: _decoratedCard(blueCorner: true),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.description_outlined, color: AppColors.orange, size: 34),
            SizedBox(width: 22),
            Expanded(
              child: Text(
                'نظرة عامة على المنتج',
                maxLines: 2,
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          product.description,
          style: const TextStyle(
            color: AppColors.navy,
            fontSize: 16,
            height: 2.05,
          ),
        ),
      ],
    ),
  );
}

class _SpecificationsCard extends StatelessWidget {
  final ProductItem product;
  const _SpecificationsCard({required this.product});

  static const icons = [
    Icons.bolt_outlined,
    Icons.monitor_heart_outlined,
    Icons.trending_up,
    Icons.scale_outlined,
    Icons.grid_view_outlined,
    Icons.verified_user_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final entries = product.specifications.entries.toList();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(26, 30, 26, 34),
      decoration: _cardDecoration(radius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المواصفات الرئيسية',
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 23,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 26),
          LayoutBuilder(
            builder: (context, constraints) {
              final gap = constraints.maxWidth < 380 ? 10.0 : 14.0;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entries.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: gap,
                  mainAxisSpacing: gap,
                  childAspectRatio: constraints.maxWidth < 430 ? 1.85 : 2.65,
                ),
                itemBuilder: (context, index) =>
                    _SpecTile(entry: entries[index], icon: icons[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SpecTile extends StatelessWidget {
  final MapEntry<String, String> entry;
  final IconData icon;
  const _SpecTile({required this.entry, required this.icon});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 150;
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 7 : 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.navy.withValues(alpha: .09)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.orange, size: compact ? 20 : 30),
            SizedBox(width: compact ? 5 : 12),
            Expanded(
              child: Text(
                entry.key,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: compact ? 10 : 14,
                ),
              ),
            ),
            SizedBox(width: compact ? 3 : 8),
            Flexible(
              child: Text(
                entry.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: compact ? 10 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

BoxDecoration _cardDecoration({required double radius}) => BoxDecoration(
  color: AppColors.background,
  borderRadius: BorderRadius.circular(radius),
  boxShadow: [
    BoxShadow(
      color: AppColors.navy.withValues(alpha: .08),
      blurRadius: 14,
      offset: const Offset(0, 5),
    ),
  ],
);

BoxDecoration _decoratedCard({bool blueCorner = false}) => BoxDecoration(
  color: AppColors.background,
  borderRadius: BorderRadius.circular(16),
  gradient: blueCorner
      ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.background,
            AppColors.background,
            AppColors.blue.withValues(alpha: .18),
          ],
          stops: const [0, .72, 1],
        )
      : LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.background,
            AppColors.background,
            AppColors.blue.withValues(alpha: .24),
          ],
          stops: const [0, .74, 1],
        ),
  boxShadow: [
    BoxShadow(
      color: AppColors.navy.withValues(alpha: .08),
      blurRadius: 14,
      offset: const Offset(0, 5),
    ),
  ],
);

class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.blue.withValues(alpha: .38);
    for (double x = 4; x < size.width; x += 12) {
      for (double y = 4; y < size.height; y += 12) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
