import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';

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
                          const SizedBox(height: 20),
                          _DatasheetButtonCard(
                            datasheetPath: product.datasheetPath,
                            productTitle:
                                '${catalog.displayName} ${product.model}',
                          ),
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
    final overlayLogo = catalog.productOverlayLogoPath;

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
            Center(
              child: FractionallySizedBox(
                heightFactor: .92,
                widthFactor: .82,
                child: _LargeProductImage(product: product),
              ),
            ),
            if (overlayLogo != null && overlayLogo.isNotEmpty)
              Positioned(
                left: 20,
                top: 20,
                child: SizedBox(
                  width: 120,
                  height: 44,
                  child: Image.asset(
                    overlayLogo,
                    fit: BoxFit.contain,
                    alignment: Alignment.topLeft,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
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

class _DatasheetButtonCard extends StatelessWidget {
  final String? datasheetPath;
  final String productTitle;

  const _DatasheetButtonCard({
    required this.datasheetPath,
    required this.productTitle,
  });

  void _openDatasheet(BuildContext context) {
    final path = datasheetPath ?? '';
    if (path.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'كتيب البيانات للمنتج غير متاح حالياً',
            textDirection: TextDirection.rtl,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DatasheetPdfViewerPage(
          datasheetPath: path,
          productTitle: productTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: _cardDecoration(radius: 18),
      child: Material(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _openDatasheet(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE88A3A), width: 1.6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'عرض كتيب البيانات',
                  style: TextStyle(
                    color: Color(0xFFE88A3A),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 14),
                Icon(
                  Icons.picture_as_pdf_outlined,
                  color: Color(0xFFE88A3A),
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DatasheetPdfViewerPage extends StatefulWidget {
  final String datasheetPath;
  final String productTitle;

  const DatasheetPdfViewerPage({
    super.key,
    required this.datasheetPath,
    required this.productTitle,
  });

  @override
  State<DatasheetPdfViewerPage> createState() => _DatasheetPdfViewerPageState();
}

class _DatasheetPdfViewerPageState extends State<DatasheetPdfViewerPage> {
  String? _localFilePath;
  bool _isLoading = true;
  String? _errorMessage;
  int _totalPages = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _preparePdfFile();
  }

  Future<void> _preparePdfFile() async {
    try {
      final ByteData data = await rootBundle.load(widget.datasheetPath);
      final bytes = data.buffer.asUint8List();

      Directory tempDir;
      try {
        tempDir = await getTemporaryDirectory();
      } catch (_) {
        tempDir = Directory.systemTemp;
      }

      final filename = widget.datasheetPath.split('/').last;
      final file = File('${tempDir.path}/$filename');

      await file.writeAsBytes(bytes, flush: true);

      if (mounted) {
        setState(() {
          _localFilePath = file.path;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'تعذر قراءة ملف الكتيب: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              _PdfHeader(
                title: 'كتيب البيانات: ${widget.productTitle}',
                currentPage: _currentPage,
                totalPages: _totalPages,
              ),
              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFE88A3A)),
            SizedBox(height: 16),
            Text(
              'جاري تحميل ملف كتيب البيانات...',
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null || _localFilePath == null) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 790),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: _cardDecoration(radius: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4EA),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE88A3A),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf_outlined,
                      color: Color(0xFFE88A3A),
                      size: 52,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.productTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'مسار الملف:\n${widget.datasheetPath}',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4EA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: Color(0xFFE88A3A),
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            _errorMessage ?? 'عذراً، تعذر فتح ملف الكتيب',
                            style: const TextStyle(
                              color: AppColors.navy,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  PDFView(
                    filePath: _localFilePath,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: true,
                    pageFling: true,
                    pageSnap: true,
                    fitPolicy: FitPolicy.BOTH,
                    onRender: (pages) {
                      setState(() {
                        _totalPages = pages ?? 0;
                      });
                    },
                    onPageChanged: (int? page, int? total) {
                      setState(() {
                        _currentPage = page ?? 0;
                        _totalPages = total ?? _totalPages;
                      });
                    },
                    onError: (error) {
                      setState(() {
                        _errorMessage = error.toString();
                      });
                    },
                  ),
                  if (_totalPages > 1)
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.navy.withValues(alpha: .85),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'صفحة ${_currentPage + 1} من $_totalPages',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
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

class _PdfHeader extends StatelessWidget {
  final String title;
  final int currentPage;
  final int totalPages;

  const _PdfHeader({
    required this.title,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFFE88A3A),
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
                if (totalPages > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4EA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE88A3A)),
                    ),
                    child: Text(
                      '${currentPage + 1} / $totalPages',
                      style: const TextStyle(
                        color: Color(0xFFE88A3A),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
