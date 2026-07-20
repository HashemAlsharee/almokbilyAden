import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/theme/app_colors.dart';

class SolarCalculatorUnavailablePage extends StatelessWidget {
  final double dayLoadWatts;
  final double nightLoadWatts;
  final int nightOperatingHours;
  final double requiredSystemKw;

  const SolarCalculatorUnavailablePage({
    super.key,
    required this.dayLoadWatts,
    required this.nightLoadWatts,
    required this.nightOperatingHours,
    required this.requiredSystemKw,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = (constraints.maxWidth / 894).clamp(.45, 1.0);
              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 894),
                    child: Column(
                      children: [
                        _UnavailableHeader(scale: scale),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            28 * scale,
                            0,
                            28 * scale,
                            36 * scale,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _UnavailableHero(scale: scale),
                              SizedBox(height: 28 * scale),
                              Text(
                                'تعذر إنشاء توصية مناسبة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.navy,
                                  fontSize: 43 * scale,
                                  fontWeight: FontWeight.w900,
                                  height: 1.25,
                                ),
                              ),
                              SizedBox(height: 18 * scale),
                              Text(
                                'تعذر إكمال الحساب، يرجى التحقق من التالي:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.navy,
                                  fontSize: 25 * scale,
                                  height: 1.45,
                                ),
                              ),
                              SizedBox(height: 48 * scale),
                              _ChecklistCard(scale: scale),
                              SizedBox(height: 24 * scale),
                              _UnavailableNote(scale: scale),
                              SizedBox(height: 22 * scale),
                              _RecalculateButton(scale: scale),
                              SizedBox(height: 16 * scale),
                              _ReturnHomeButton(scale: scale),
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

class _UnavailableHeader extends StatelessWidget {
  final double scale;

  const _UnavailableHeader({required this.scale});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130 * scale,
      child: ColoredBox(
        color: Colors.white,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30 * scale),
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
                        fontSize: 27 * scale,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 14 * scale),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(
                    width: 60 * scale,
                    height: 78 * scale,
                  ),
                  icon: Icon(
                    Icons.arrow_forward,
                    color: AppColors.orange,
                    size: 46 * scale,
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

class _UnavailableHero extends StatelessWidget {
  final double scale;

  const _UnavailableHero({required this.scale});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.72,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26 * scale)),
        child: Image.asset(
          'images/solar_calculator_scene.webp',
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  final double scale;

  const _ChecklistCard({required this.scale});

  static const _items = [
    'حمل النهار صحيح.',
    'حمل الليل صحيح.',
    'ساعات التشغيل الليلية صحيحة.',
    'توجد منتجات مناسبة في الكتالوج.',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        34 * scale,
        30 * scale,
        34 * scale,
        22 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25 * scale),
        border: Border.all(color: AppColors.navy.withValues(alpha: .035)),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: .05),
            blurRadius: 20 * scale,
            offset: Offset(0, 5 * scale),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'تحقق من التالي',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 31 * scale,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 18 * scale),
          for (var index = 0; index < _items.length; index++) ...[
            _ChecklistRow(scale: scale, text: _items[index]),
            if (index != _items.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.navy.withValues(alpha: .12),
              ),
          ],
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  final double scale;
  final String text;

  const _ChecklistRow({required this.scale, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 17 * scale),
      child: Row(
        children: [
          Container(
            width: 54 * scale,
            height: 54 * scale,
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: .1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: AppColors.green,
              size: 31 * scale,
            ),
          ),
          SizedBox(width: 20 * scale),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 23 * scale,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnavailableNote extends StatelessWidget {
  final double scale;

  const _UnavailableNote({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 30 * scale,
        vertical: 24 * scale,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6FF),
        borderRadius: BorderRadius.circular(22 * scale),
        border: Border.all(color: Colors.white, width: 5 * scale),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: .08),
            blurRadius: 14 * scale,
            offset: Offset(0, 3 * scale),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58 * scale,
            height: 58 * scale,
            decoration: const BoxDecoration(
              color: Color(0xFF1765B5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 36 * scale,
            ),
          ),
          SizedBox(width: 24 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ملاحظة',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 27 * scale,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8 * scale),
                Text(
                  'أدخل القدرة الإجمالية للأجهزة التي تعمل معًا\nخلال ساعة واحدة فقط.',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 22 * scale,
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

class _RecalculateButton extends StatelessWidget {
  final double scale;

  const _RecalculateButton({required this.scale});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78 * scale,
      child: FilledButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.refresh_outlined, size: 34 * scale),
        label: Text(
          'إعادة الحساب',
          style: TextStyle(fontSize: 27 * scale, fontWeight: FontWeight.w600),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14 * scale),
          ),
        ),
      ),
    );
  }
}

class _ReturnHomeButton extends StatelessWidget {
  final double scale;

  const _ReturnHomeButton({required this.scale});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78 * scale,
      child: OutlinedButton.icon(
        onPressed: () =>
            Navigator.of(context).popUntil((route) => route.isFirst),
        icon: Icon(Icons.home_outlined, size: 34 * scale),
        label: Text(
          'العودة للرئيسية',
          style: TextStyle(fontSize: 27 * scale, fontWeight: FontWeight.w500),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          backgroundColor: Colors.white,
          side: BorderSide(color: AppColors.navy, width: 1.5 * scale),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14 * scale),
          ),
        ),
      ),
    );
  }
}
