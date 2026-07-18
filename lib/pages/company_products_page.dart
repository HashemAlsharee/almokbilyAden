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
                                  childAspectRatio: compact ? .82 : .92,
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
            child: catalog.id == 'longi'
                ? Image.asset(catalog.heroImagePath, fit: BoxFit.cover)
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        catalog.heroImagePath,
                        fit: BoxFit.cover,
                        alignment: Alignment.centerRight,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              AppColors.background,
                              AppColors.background.withValues(alpha: .82),
                              AppColors.background.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 22,
                        top: 18,
                        bottom: 18,
                        width: constraints.maxWidth * .48,
                        child: LayoutBuilder(
                          builder: (context, contentConstraints) {
                            final compact = constraints.maxWidth < 500;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: compact ? 42 : 68,
                                  width: double.infinity,
                                  child: Image.asset(
                                    catalog.logoPath,
                                    fit: BoxFit.contain,
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                                SizedBox(height: compact ? 10 : 18),
                                Text(
                                  catalog.heroHeadline,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.navy,
                                    fontSize: compact ? 16 : 21,
                                    fontWeight: FontWeight.w700,
                                    height: 1.35,
                                  ),
                                ),
                                SizedBox(height: compact ? 5 : 8),
                                Text(
                                  catalog.heroDescription,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.navy,
                                    fontSize: compact ? 13 : 17,
                                    height: 1.35,
                                  ),
                                ),
                                SizedBox(height: compact ? 10 : 18),
                                Container(
                                  width: compact ? 34 : 50,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.green,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            );
                          },
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

class _ProductCard extends StatelessWidget {
  final ProductItem product;
  final VoidCallback onTap;
  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      shadowColor: AppColors.navy.withValues(alpha: .12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned(
              right: -35,
              bottom: -35,
              child: Container(
                width: 180,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: .32),
                  borderRadius: BorderRadius.circular(70),
                ),
              ),
            ),
            Positioned(
              left: 45,
              bottom: -60,
              child: Transform.rotate(
                angle: -.45,
                child: Container(
                  width: 85,
                  height: 190,
                  color: AppColors.orange.withValues(alpha: .48),
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 10,
              bottom: 22,
              width: 58,
              child: _ProductImage(product: product),
            ),
            Positioned(
              right: 10,
              top: 34,
              bottom: 12,
              left: 74,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.model,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(color: AppColors.navy, fontSize: 11),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.power,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(color: AppColors.navy, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.navy.withValues(alpha: .08),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.green,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
    child: Container(
      width: 58,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.navy,
        border: Border.all(color: AppColors.blue, width: 2),
        borderRadius: BorderRadius.circular(3),
      ),
      child: const Icon(
        Icons.solar_power_outlined,
        color: AppColors.blue,
        size: 34,
      ),
    ),
  );
}
