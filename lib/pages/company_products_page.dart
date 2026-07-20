import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../catalog_data.dart';
import '../core/theme/app_colors.dart';
import 'product_details_page.dart';

class CompanyProductsPage extends StatelessWidget {
  final CompanyCatalog catalog;

  const CompanyProductsPage({super.key, required this.catalog});

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
                child: _Header(title: catalog.productsPageTitle),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 790),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                      child: _Hero(catalog: catalog),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 790),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxWidth < 410;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: catalog.products.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: compact ? 10 : 16,
                                  mainAxisSpacing: compact ? 10 : 16,
                                  childAspectRatio: compact ? 1.04 : 1.1,
                                ),
                            itemBuilder: (context, index) {
                              final product = catalog.products[index];
                              return _ProductCard(
                                product: product,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailsPage(
                                      product: product,
                                      catalog: catalog,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
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
                      color: AppColors.green,
                      size: 30,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: SizedBox(
                      width: (constraints.maxWidth * .43).clamp(135.0, 260.0),
                      height: 62,
                      child: const _MainLogo(),
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

class _MainLogo extends StatelessWidget {
  const _MainLogo();
  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'images/0.svg',
    fit: BoxFit.contain,
    colorFilter: const ColorFilter.mode(AppColors.navy, BlendMode.srcIn),
    placeholderBuilder: (_) => const _LogoFallback(),
    errorBuilder: (_, __, ___) => const _LogoFallback(),
  );
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback();
  @override
  Widget build(BuildContext context) => const FittedBox(
    fit: BoxFit.scaleDown,
    alignment: Alignment.centerLeft,
    child: Text(
      'ALMOKBILY',
      style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900),
    ),
  );
}

class _Hero extends StatelessWidget {
  final CompanyCatalog catalog;
  const _Hero({required this.catalog});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = (constraints.maxWidth * .61).clamp(240.0, 470.0);
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: height,
            child: Image.asset(
              catalog.heroImagePath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductItem product;
  final VoidCallback onTap;
  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final horizontalInset = (cardWidth * .045).clamp(7.0, 16.0);
        final buttonSize = (cardWidth * .17).clamp(36.0, 58.0);
        final nameSize = (cardWidth * .045).clamp(12.0, 16.0);
        final detailSize = (cardWidth * .039).clamp(10.5, 14.0);
        final categorySize = (cardWidth * .035).clamp(10.0, 13.0);

        return Material(
          color: const Color(0xFFFCFCFD),
          borderRadius: BorderRadius.circular(16),
          elevation: 3,
          shadowColor: AppColors.navy.withValues(alpha: .11),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const RepaintBoundary(
                  child: CustomPaint(painter: _ProductCardBackgroundPainter()),
                ),
                Positioned(
                  left: horizontalInset,
                  top: constraints.maxHeight * .055,
                  bottom: constraints.maxHeight * .055,
                  width: cardWidth * .45,
                  child: _ProductImage(product: product),
                ),
                Positioned(
                  right: horizontalInset,
                  left: cardWidth * .48,
                  bottom: constraints.maxHeight * .075,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: AppColors.navy,
                            fontSize: nameSize,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * .025),
                      Text(
                        product.model,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: AppColors.navy,
                          fontSize: detailSize,
                          height: 1.15,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * .025),
                      Text(
                        product.power,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: AppColors.navy,
                          fontSize: detailSize,
                          height: 1.15,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * .025),
                      Text(
                        product.type,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFF14966B),
                          fontSize: categorySize,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: horizontalInset,
                  bottom: constraints.maxHeight * .035,
                  child: Container(
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCFCFD),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.navy.withValues(alpha: .1),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: const Color(0xFF14966B),
                      size: buttonSize * .4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProductCardBackgroundPainter extends CustomPainter {
  const _ProductCardBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final blueShape = Path()
      ..moveTo(size.width * .29, size.height)
      ..cubicTo(
        size.width * .4,
        size.height * .76,
        size.width * .48,
        size.height * .43,
        size.width * .7,
        size.height * .35,
      )
      ..cubicTo(
        size.width * .84,
        size.height * .3,
        size.width * .94,
        size.height * .34,
        size.width,
        size.height * .27,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(
      blueShape,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE7F4FA), Color(0xFFCFE6F3)],
        ).createShader(Offset.zero & size),
    );

    final peachShape = Path()
      ..moveTo(0, size.height * .67)
      ..cubicTo(
        size.width * .14,
        size.height * .55,
        size.width * .25,
        size.height * .57,
        size.width * .36,
        size.height * .69,
      )
      ..cubicTo(
        size.width * .45,
        size.height * .8,
        size.width * .56,
        size.height * .86,
        size.width * .72,
        size.height,
      )
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      peachShape,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF1E3), Color(0xFFF8DDC5)],
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(_ProductCardBackgroundPainter oldDelegate) => false;
}

class _ProductImage extends StatelessWidget {
  final ProductItem product;
  const _ProductImage({required this.product});

  @override
  Widget build(BuildContext context) {
    if (product.imagePath.isNotEmpty) {
      return Image.asset(
        product.imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const _ProductPlaceholder(),
      );
    }
    return const _ProductPlaceholder();
  }
}

class _ProductPlaceholder extends StatelessWidget {
  const _ProductPlaceholder();

  @override
  Widget build(BuildContext context) => Center(
    child: AspectRatio(
      aspectRatio: .78,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: FractionallySizedBox(
            widthFactor: .42,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Icon(Icons.image_outlined, color: Color(0xFF9AA7B2)),
            ),
          ),
        ),
      ),
    ),
  );
}
