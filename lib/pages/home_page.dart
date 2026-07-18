import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Everything for the HomePage (models, data, widgets) is defined in this file

class CompanyItem {
  final String title;
  final String subtitle;
  final String backgroundImage;
  final String logoImage;
  final String routeName;
  final bool isArabic;

  const CompanyItem({
    required this.title,
    required this.subtitle,
    required this.backgroundImage,
    required this.logoImage,
    required this.routeName,
    this.isArabic = false,
  });
}

const List<CompanyItem> companies = [
  CompanyItem(
    title: 'LONGI',
    subtitle: 'High-efficiency\nsolar panels',
    backgroundImage: 'images/2.jpg',
    logoImage: 'images/longi.png',
    routeName: 'longi',
  ),
  CompanyItem(
    title: 'Canadian Solar',
    subtitle: 'Reliable photovoltaic\nsolutions',
    backgroundImage: 'images/3.jpg',
    logoImage: 'images/canadian.webp',
    routeName: 'canadian',
  ),
  CompanyItem(
    title: 'Solis',
    subtitle: 'Smart solar\ninverters',
    backgroundImage: 'images/4.jpg',
    logoImage: 'images/solis.png',
    routeName: 'solis',
  ),
  CompanyItem(
    title: 'PYLONTECH',
    subtitle: 'Advanced lithium\nbattery storage',
    backgroundImage: 'images/5.jpg',
    logoImage: 'images/pylontech.png',
    routeName: 'pylontech',
  ),
  CompanyItem(
    title: 'HITHIUM',
    subtitle: 'Next-generation\nenergy storage',
    backgroundImage: 'images/6.jpg',
    logoImage: 'images/hthium.png',
    routeName: 'hithium',
  ),
  CompanyItem(
    title: 'حاسبة الأنظمة الشمسية',
    subtitle: 'احسب نظامك الشمسي\nالموصى به.',
    backgroundImage: 'images/7.jpg',
    logoImage: 'images/calculator.png',
    routeName: 'calculator',
    isArabic: true,
  ),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openPlaceholder(BuildContext context, String title) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => PlaceholderPage(title: title)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
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
                    onTap: () => _openPlaceholder(context, c.title),
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
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: SizedBox(height: 56, child: _safeSvg('images/0.svg'))),
          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8EEF3)),
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
                Container(color: Colors.grey.shade200),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(255, 255, 255, 0.85),
                  Color.fromRGBO(255, 255, 255, 0.10),
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
                    'مرحباً بك',
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Color(0xFF082A4A),
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اختر الشركة التي ترغب باستعراض منتجاتها',
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Color(0xFF082A4A),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5A000),
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

class DiagonalWhitePanelClipper extends CustomClipper<Path> {
  const DiagonalWhitePanelClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.61, 0)
      ..quadraticBezierTo(
        size.width * 0.57,
        size.height * 0.15,
        size.width * 0.54,
        size.height * 0.36,
      )
      ..quadraticBezierTo(
        size.width * 0.50,
        size.height * 0.68,
        size.width * 0.46,
        size.height,
      )
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant DiagonalWhitePanelClipper oldClipper) {
    return false;
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
        final double cardHeight = (constraints.maxWidth * 0.30).clamp(
          170.0,
          205.0,
        );
        final double panelWidth = maxWidth * 0.55;
        final double arrowWidth = 54;
        final double responsiveFontSize = (constraints.maxWidth * 0.012).clamp(
          13.0,
          16.0,
        );

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  child: Ink(
                    height: cardHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(cardHeight * 0.11),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(11, 31, 52, 0.08),
                          blurRadius: 18,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(cardHeight * 0.11),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              item.backgroundImage,
                              fit: BoxFit.cover,
                              alignment: Alignment.centerRight,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: Icon(Icons.broken_image),
                                    ),
                                  ),
                            ),
                          ),
                          const Positioned.fill(
                            child: ClipPath(
                              clipper: DiagonalWhitePanelClipper(),
                              child: ColoredBox(color: Color(0xFFFDFDFD)),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: panelWidth,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: maxWidth * 0.035,
                                vertical: cardHeight * 0.10,
                              ),
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: arrowWidth,
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        color: const Color(0xFF078C65),
                                        size: cardHeight * 0.22,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: SizedBox(
                                              width: panelWidth * 0.60,
                                              height: cardHeight * 0.30,
                                              child: Image.asset(
                                                item.logoImage,
                                                fit: BoxFit.contain,
                                                alignment: Alignment.centerLeft,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Text(
                                                        item.title,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: const Color(
                                                            0xFF082A4A,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              responsiveFontSize +
                                                              2,
                                                        ),
                                                      );
                                                    },
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: cardHeight * 0.08),
                                          Flexible(
                                            child: Text(
                                              item.subtitle,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: const Color(0xFF263D53),
                                                fontSize: responsiveFontSize,
                                                height: 1.25,
                                              ),
                                              textDirection: item.isArabic
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
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
                        ],
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

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF082A4A),
      ),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
