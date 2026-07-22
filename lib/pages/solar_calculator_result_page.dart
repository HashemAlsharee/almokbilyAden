import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../catalog_data.dart';
import '../core/theme/app_colors.dart';
import '../solar_recommendation_engine.dart';
import 'product_details_page.dart';

class SolarCalculatorResultPage extends StatelessWidget {
  final double dayLoadWatts;
  final double nightLoadWatts;
  final int nightOperatingHours;
  final double requiredSystemKw;
  final RecommendationResult? result;

  const SolarCalculatorResultPage({
    super.key,
    required this.dayLoadWatts,
    required this.nightLoadWatts,
    required this.nightOperatingHours,
    required this.requiredSystemKw,
    this.result,
  });

  @override
  Widget build(BuildContext context) {
    final activeResult = result ??
        SolarRecommendationEngine().calculate(
          SolarInput(
            dayLoadWatts: dayLoadWatts,
            nightLoadWatts: nightLoadWatts,
            nightOperatingHours: nightOperatingHours,
          ),
        );

    final panelCatalog = catalogById(
      activeResult.selectedPanel.companyName.toLowerCase() == 'longi' ? 'longi' : 'longi',
    );
    final inverterCatalog = catalogById(
      activeResult.selectedInverter.companyName.toLowerCase() == 'solis' ? 'solis' : 'solis',
    );
    final batteryCatalog = catalogById(
      activeResult.selectedBattery.companyName.toLowerCase() == 'hithium' ? 'hithium' : 'pylontech',
    );

    final panelCount = activeResult.panelQuantity;
    final panelWattage = 650.0;
    final previewCapacityKw = panelCount * panelWattage / 1000.0;

    final recommendedProducts = <_RecommendedProduct>[
      _RecommendedProduct(
        catalog: panelCatalog,
        product: activeResult.selectedPanel,
        category:
            'ألواح شمسية (${activeResult.calculatedDayPanels} لوح للنهار + ${activeResult.calculatedChargingPanels} لوح للشحن)',
        quantity: '$panelCount لوح',
        fallbackIcon: Icons.solar_power_outlined,
      ),
      _RecommendedProduct(
        catalog: inverterCatalog,
        product: activeResult.selectedInverter,
        category:
            'عاكس شمسي هجين (مطلوب ${(activeResult.requiredInverterPowerWatts / 1000.0).toStringAsFixed(1)} kW)',
        quantity: '${activeResult.inverterQuantity} جهاز',
        fallbackIcon: Icons.electrical_services_outlined,
      ),
      _RecommendedProduct(
        catalog: batteryCatalog,
        product: activeResult.selectedBattery,
        category:
            'بطارية تخزين (مطلوب ${(activeResult.requiredBatteryCapacityWh / 1000.0).toStringAsFixed(1)} kWh)',
        quantity: '${activeResult.batteryQuantity} وحدة',
        fallbackIcon: Icons.battery_charging_full_outlined,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = (constraints.maxWidth / 862).clamp(.46, 1.0);
              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 862),
                    child: Column(
                      children: [
                        _ResultHeader(scale: scale),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20 * scale),
                          child: _ResultHero(scale: scale),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            48 * scale,
                            30 * scale,
                            48 * scale,
                            36 * scale,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _SectionTitle(
                                scale: scale,
                                title: 'ملخص النظام الموصى به',
                                icon: Icons.check_rounded,
                              ),
                              SizedBox(height: 22 * scale),
                              _SummaryCards(
                                scale: scale,
                                dayLoadWatts: dayLoadWatts,
                                nightLoadWatts: nightLoadWatts,
                                nightOperatingHours: nightOperatingHours,
                              ),
                              SizedBox(height: 26 * scale),
                              _RecommendationCard(
                                scale: scale,
                                panelCount: panelCount,
                                panelWattage: panelWattage,
                                previewCapacityKw: previewCapacityKw,
                              ),
                              SizedBox(height: 32 * scale),
                              Text(
                                'المنتجات الموصى بها',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: AppColors.navy,
                                  fontSize: 28 * scale,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 18 * scale),
                              ...recommendedProducts.map(
                                (item) => Padding(
                                  padding: EdgeInsets.only(bottom: 12 * scale),
                                  child: _ProductRecommendationCard(
                                    scale: scale,
                                    item: item,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8 * scale),
                              _ImportantNote(scale: scale),
                              SizedBox(height: 24 * scale),
                              _OutlinedActionButton(
                                scale: scale,
                                label: 'إجراء حساب جديد',
                                icon: Icons.calculate_outlined,
                                onPressed: () => Navigator.pop(context),
                              ),
                              SizedBox(height: 12 * scale),
                              _HomeButton(scale: scale),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

}

class _RecommendedProduct {
  final CompanyCatalog catalog;
  final ProductItem product;
  final String category;
  final String quantity;
  final IconData fallbackIcon;

  const _RecommendedProduct({
    required this.catalog,
    required this.product,
    required this.category,
    required this.quantity,
    required this.fallbackIcon,
  });
}

class _ResultHeader extends StatelessWidget {
  final double scale;

  const _ResultHeader({required this.scale});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 124 * scale,
      child: ColoredBox(
        color: Colors.white,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 26 * scale),
            child: Row(
              children: [
                Expanded(
                  flex: 14,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset(
                      'images/0.svg',
                      height: 78 * scale,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerLeft,
                      colorFilter: const ColorFilter.mode(
                        AppColors.navy,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 18 * scale),
                Expanded(
                  flex: 6,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      'نتيجة الحاسبة',
                      maxLines: 1,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 26 * scale,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12 * scale),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(
                    width: 58 * scale,
                    height: 76 * scale,
                  ),
                  icon: Icon(
                    Icons.arrow_forward,
                    color: AppColors.orange,
                    size: 44 * scale,
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

class _ResultHero extends StatelessWidget {
  final double scale;

  const _ResultHero({required this.scale});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3.0,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24 * scale)),
        child: Image.asset(
          'images/solar_interface.webp',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final double scale;
  final String title;
  final IconData icon;

  const _SectionTitle({
    required this.scale,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44 * scale,
          height: 44 * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.orange, width: 2 * scale),
          ),
          child: Icon(icon, color: AppColors.orange, size: 27 * scale),
        ),
        SizedBox(width: 16 * scale),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 29 * scale,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryCards extends StatelessWidget {
  final double scale;
  final double dayLoadWatts;
  final double nightLoadWatts;
  final int nightOperatingHours;

  const _SummaryCards({
    required this.scale,
    required this.dayLoadWatts,
    required this.nightLoadWatts,
    required this.nightOperatingHours,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _SummaryCard(
            scale: scale,
            title: 'حمل النهار',
            value: '${_formatNumber(dayLoadWatts)} واط',
            subtitle: 'لكل ساعة',
            icon: Icons.wb_sunny_outlined,
            iconColor: AppColors.orange,
          ),
        ),
        SizedBox(width: 10 * scale),
        Expanded(
          child: _SummaryCard(
            scale: scale,
            title: 'حمل الليل',
            value: '${_formatNumber(nightLoadWatts)} واط',
            subtitle: 'لكل ساعة',
            icon: Icons.dark_mode_outlined,
            iconColor: AppColors.navy,
          ),
        ),
        SizedBox(width: 10 * scale),
        Expanded(
          child: _SummaryCard(
            scale: scale,
            title: 'ساعات التشغيل الليلي',
            value: '$nightOperatingHours ساعات',
            subtitle: 'عمل المنظومة ليلاً',
            icon: Icons.access_time_outlined,
            iconColor: AppColors.navy,
          ),
        ),
      ],
    );
  }

  static String _formatNumber(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);
}

class _SummaryCard extends StatelessWidget {
  final double scale;
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const _SummaryCard({
    required this.scale,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 166 * scale,
      padding: EdgeInsets.symmetric(
        horizontal: 14 * scale,
        vertical: 16 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15 * scale),
        border: Border.all(color: AppColors.navy.withValues(alpha: .055)),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: .045),
            blurRadius: 11 * scale,
            offset: Offset(0, 2.5 * scale),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 42 * scale,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 30 * scale),
                SizedBox(width: 8 * scale),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 20 * scale,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8 * scale),
          SizedBox(
            height: 38 * scale,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 29 * scale,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
            ),
          ),
          SizedBox(height: 7 * scale),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                subtitle,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.navy.withValues(alpha: .88),
                  fontSize: 17 * scale,
                  height: 1.25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final double scale;
  final int panelCount;
  final double panelWattage;
  final double previewCapacityKw;

  const _RecommendationCard({
    required this.scale,
    required this.panelCount,
    required this.panelWattage,
    required this.previewCapacityKw,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (scale < .48 ? 270 : 230) * scale,
      padding: EdgeInsets.fromLTRB(
        22 * scale,
        12 * scale,
        26 * scale,
        12 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15 * scale),
        border: Border(
          right: BorderSide(color: AppColors.orange, width: 5 * scale),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: .045),
            blurRadius: 13 * scale,
            offset: Offset(0, 3 * scale),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'السعة الشمسية الموصى بها',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 21 * scale,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 11 * scale),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$panelCount لوح شمسي',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 43 * scale,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                    ),
                  ),
                ),
                SizedBox(height: 7 * scale),
                Text(
                  '${_cleanNumber(panelWattage)} واط لكل لوح',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: const Color(0xFFE88A3A),
                    fontSize: 23 * scale,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 11 * scale),
                Text(
                  'إجمالي القدرة الشمسية النهائية: ${previewCapacityKw.toStringAsFixed(2)} كيلوواط',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 16 * scale,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16 * scale),
          Expanded(
            flex: 2,
            child: Center(
              child: SizedBox(
                height: 196 * scale,
                child: Image.asset(
                  'images/solar_panel_icon.webp',
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _cleanNumber(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);
}

class _ProductRecommendationCard extends StatelessWidget {
  final double scale;
  final _RecommendedProduct item;

  const _ProductRecommendationCard({required this.scale, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 168 * scale,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13 * scale),
          border: Border.all(color: AppColors.navy.withValues(alpha: .055)),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: .035),
              blurRadius: 10 * scale,
              offset: Offset(0, 2 * scale),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13 * scale),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 18 * scale),
              SizedBox(
                width: 160 * scale,
                height: 58 * scale,
                child: Center(
                  child: SizedBox.expand(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => ProductDetailsPage(
                            product: item.product,
                            catalog: item.catalog,
                          ),
                        ),
                      ),
                      icon: Icon(Icons.inventory_2_outlined, size: 20 * scale),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('عرض التفاصيل'),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE88A3A),
                        side: BorderSide(
                          color: const Color(0xFFE88A3A),
                          width: 1.5 * scale,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10 * scale),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9 * scale),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20 * scale),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15 * scale),
                  child: LayoutBuilder(
                    builder: (context, constraints) => FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.category,
                              style: TextStyle(
                                color: const Color(0xFFE88A3A),
                                fontSize: 17 * scale,
                                height: 1.15,
                              ),
                            ),
                            SizedBox(height: 7 * scale),
                            Text(
                              '${item.product.companyName} ${item.product.model}',
                              maxLines: 2,
                              style: TextStyle(
                                color: AppColors.navy,
                                fontSize: 21 * scale,
                                fontWeight: FontWeight.w700,
                                height: 1.15,
                              ),
                            ),
                            SizedBox(height: 9 * scale),
                            Text(
                              item.quantity,
                              style: TextStyle(
                                color: AppColors.navy,
                                fontSize: 18 * scale,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8 * scale),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'عرض التفاصيل',
                                    style: TextStyle(
                                      color: AppColors.navy,
                                      fontSize: 15 * scale,
                                    ),
                                  ),
                                  SizedBox(width: 8 * scale),
                                  Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: const Color(0xFFE88A3A),
                                    size: 15 * scale,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 14 * scale),
              Container(
                width: 280 * scale,
                height: double.infinity,
                padding: EdgeInsets.all(7 * scale),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9FC),
                  border: Border(
                    left: BorderSide(color: AppColors.orange, width: 2 * scale),
                  ),
                ),
                child: _ProductVisual(
                  imagePath: item.product.imagePath,
                  fallbackIcon: item.fallbackIcon,
                  scale: scale,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductVisual extends StatelessWidget {
  final String imagePath;
  final IconData fallbackIcon;
  final double scale;

  const _ProductVisual({
    required this.imagePath,
    required this.fallbackIcon,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.isNotEmpty) {
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return Center(
      child: Icon(
        fallbackIcon,
        color: AppColors.navy.withValues(alpha: .72),
        size: 72 * scale,
      ),
    );
  }
}

class _ImportantNote extends StatelessWidget {
  final double scale;

  const _ImportantNote({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 26 * scale,
        vertical: 20 * scale,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4EA),
        borderRadius: BorderRadius.circular(12 * scale),
      ),
      child: Row(
        children: [
          Container(
            width: 52 * scale,
            height: 52 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFE88A3A),
                width: 2 * scale,
              ),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: const Color(0xFFE88A3A),
              size: 32 * scale,
            ),
          ),
          SizedBox(width: 22 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ملاحظة مهمة',
                  style: TextStyle(
                    color: const Color(0xFFE88A3A),
                    fontSize: 18 * scale,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6 * scale),
                Text(
                  'هذه التوصية تقديرية وتعتمد على المعلومات التي أدخلتها.\nيرجى مراجعة فريقنا الهندسي قبل التنفيذ.',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 17 * scale,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  final double scale;
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _OutlinedActionButton({
    required this.scale,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64 * scale,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 28 * scale),
        label: Text(
          label,
          style: TextStyle(fontSize: 22 * scale, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFE88A3A),
          side: BorderSide(color: const Color(0xFFE88A3A), width: 1.6 * scale),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11 * scale),
          ),
        ),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final double scale;

  const _HomeButton({required this.scale});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58 * scale,
      child: TextButton.icon(
        onPressed: () =>
            Navigator.of(context).popUntil((route) => route.isFirst),
        icon: Icon(
          Icons.home_outlined,
          color: AppColors.navy,
          size: 28 * scale,
        ),
        label: Text(
          'العودة للرئيسية',
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 21 * scale,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
