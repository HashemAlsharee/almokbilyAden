import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/theme/app_colors.dart';
import '../solar_recommendation_engine.dart';
import 'solar_calculator_result_page.dart';
import 'solar_calculator_unavailable_page.dart';

class SolarCalculatorPage extends StatefulWidget {
  const SolarCalculatorPage({super.key});

  @override
  State<SolarCalculatorPage> createState() => _SolarCalculatorPageState();
}

class _SolarCalculatorPageState extends State<SolarCalculatorPage> {
  static const double _contentMaxWidth = 760;
  final _formKey = GlobalKey<FormState>();
  final _dayLoadController = TextEditingController();
  final _nightLoadController = TextEditingController();
  final _nightHoursController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _dayLoadController.dispose();
    _nightLoadController.dispose();
    _nightHoursController.dispose();
    super.dispose();
  }

  String? _validateLoad(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'هذا الحقل مطلوب';
    final number = double.tryParse(input);
    if (number == null || !number.isFinite) return 'أدخل قيمة رقمية صحيحة';
    if (number <= 0) return 'يجب أن تكون القيمة أكبر من صفر';
    return null;
  }

  String? _validateNightHours(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'هذا الحقل مطلوب';
    final hours = int.tryParse(input);
    if (hours == null) return 'أدخل عدد ساعات صحيحًا';
    if (hours <= 0) return 'يجب أن تكون ساعات التشغيل أكبر من صفر';
    if (hours >= 18) {
      return 'يجب أن تكون ساعات التشغيل الليلي أقل من 18 ساعة';
    }
    return null;
  }

  void _clearFields() {
    _dayLoadController.clear();
    _nightLoadController.clear();
    _nightHoursController.clear();
    _formKey.currentState?.reset();
    if (mounted) {
      setState(() {
        _autovalidateMode = AutovalidateMode.disabled;
      });
    }
  }

  Future<void> _calculate() async {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
      return;
    }

    final dayLoadWatts = double.parse(_dayLoadController.text.trim());
    final nightLoadWatts = double.parse(_nightLoadController.text.trim());
    final nightOperatingHours = int.parse(_nightHoursController.text.trim());

    // Clear fields immediately after reading user inputs
    _clearFields();

    final engine = SolarRecommendationEngine();
    final input = SolarInput(
      dayLoadWatts: dayLoadWatts,
      nightLoadWatts: nightLoadWatts,
      nightOperatingHours: nightOperatingHours,
    );

    Widget destination;
    try {
      final result = engine.calculate(input);
      destination = SolarCalculatorResultPage(
        dayLoadWatts: dayLoadWatts,
        nightLoadWatts: nightLoadWatts,
        nightOperatingHours: nightOperatingHours,
        requiredSystemKw: result.requiredInverterPowerWatts / 1000.0,
        result: result,
      );
    } on RecommendationFailure catch (failure) {
      destination = SolarCalculatorUnavailablePage(
        dayLoadWatts: dayLoadWatts,
        nightLoadWatts: nightLoadWatts,
        nightOperatingHours: nightOperatingHours,
        requiredSystemKw: (dayLoadWatts * 1.20) / 1000.0,
        failureReason: failure.message,
      );
    } catch (_) {
      destination = SolarCalculatorUnavailablePage(
        dayLoadWatts: dayLoadWatts,
        nightLoadWatts: nightLoadWatts,
        nightOperatingHours: nightOperatingHours,
        requiredSystemKw: (dayLoadWatts * 1.20) / 1000.0,
        failureReason: 'حدث خطأ أثناء حساب التوصية المناسبة',
      );
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => destination),
    );

    if (mounted) {
      _clearFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = (constraints.maxWidth / 853).clamp(.44, 1.0);

              return SingleChildScrollView(
                child: Column(
                  children: [
                    _CalculatorHeader(scale: scale),
                    _HeroAndIntroduction(scale: scale),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _contentMaxWidth,
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            48 * scale,
                            16 * scale,
                            48 * scale,
                            52 * scale,
                          ),
                          child: Column(
                            children: [
                              _CalculatorFormCard(
                                scale: scale,
                                formKey: _formKey,
                                dayLoadController: _dayLoadController,
                                nightLoadController: _nightLoadController,
                                nightHoursController: _nightHoursController,
                                autovalidateMode: _autovalidateMode,
                                loadValidator: _validateLoad,
                                hoursValidator: _validateNightHours,
                              ),
                              SizedBox(height: 12 * scale),
                              _ValidationNote(scale: scale),
                              SizedBox(height: 16 * scale),
                              _CalculateButton(
                                scale: scale,
                                onPressed: _calculate,
                              ),
                              SizedBox(height: 24 * scale),
                              _InformationCard(scale: scale),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CalculatorHeader extends StatelessWidget {
  final double scale;

  const _CalculatorHeader({required this.scale});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 134 * scale,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 34 * scale),
            child: Row(
              children: [
                Expanded(
                  flex: 14,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset(
                      'images/0.svg',
                      height: 84 * scale,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerLeft,
                      colorFilter: const ColorFilter.mode(
                        AppColors.navy,
                        BlendMode.srcIn,
                      ),
                      placeholderBuilder: (_) => const SizedBox.shrink(),
                    ),
                  ),
                ),
                SizedBox(width: 20 * scale),
                Expanded(
                  flex: 7,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      'حاسبة النظام الشمسي',
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
                SizedBox(width: 16 * scale),
                IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(
                    width: 68 * scale,
                    height: 84 * scale,
                  ),
                  icon: Icon(
                    Icons.arrow_forward,
                    color: AppColors.orange,
                    size: 48 * scale,
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

class _HeroAndIntroduction extends StatelessWidget {
  final double scale;

  const _HeroAndIntroduction({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 853),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final heroHeight = (constraints.maxWidth * .6).clamp(205.0, 512.0);
            final introHeight = 168 * scale;

            return SizedBox(
              height: heroHeight + introHeight * .72,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: heroHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(28 * scale),
                          bottomRight: Radius.circular(28 * scale),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.navy.withValues(alpha: .035),
                            blurRadius: 8 * scale,
                            offset: Offset(0, 2 * scale),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(28 * scale),
                          bottomRight: Radius.circular(28 * scale),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'images/calculator.webp',
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: heroHeight * .25,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0x00F8FAFC),
                                      Color(0xDDF8FAFC),
                                      AppColors.background,
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
                  Positioned(
                    left: 40 * scale,
                    right: 40 * scale,
                    top: heroHeight - 52 * scale,
                    child: Column(
                      children: [
                        Text(
                          'احسب النظام المناسب حسب الأحمال الكهربائية',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.navy,
                            fontSize: 36 * scale,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 14 * scale),
                        Text(
                          'أدخل متوسط القدرة (واط) للأجهزة التي تعمل معًا خلال ساعة واحدة\nللحصول على توصية تقريبية.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.navy,
                            fontSize: 24 * scale,
                            fontWeight: FontWeight.w400,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CalculatorFormCard extends StatelessWidget {
  final double scale;
  final GlobalKey<FormState> formKey;
  final TextEditingController dayLoadController;
  final TextEditingController nightLoadController;
  final TextEditingController nightHoursController;
  final AutovalidateMode autovalidateMode;
  final FormFieldValidator<String> loadValidator;
  final FormFieldValidator<String> hoursValidator;

  const _CalculatorFormCard({
    required this.scale,
    required this.formKey,
    required this.dayLoadController,
    required this.nightLoadController,
    required this.nightHoursController,
    required this.autovalidateMode,
    required this.loadValidator,
    required this.hoursValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          28 * scale,
          30 * scale,
          28 * scale,
          22 * scale,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24 * scale),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: .07),
              blurRadius: 22 * scale,
              offset: Offset(0, 6 * scale),
            ),
          ],
        ),
        child: Column(
          children: [
            _CalculatorField(
              scale: scale,
              controller: dayLoadController,
              validator: loadValidator,
              title: 'حمل النهار (واط لكل ساعة)',
              description:
                  'أدخل القدرة الإجمالية (واط) للأجهزة التي تعمل معًا خلال ساعة واحدة في النهار.',
              hintText: 'مثال: 2500',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            SizedBox(height: 24 * scale),
            _CalculatorField(
              scale: scale,
              controller: nightLoadController,
              validator: loadValidator,
              title: 'حمل الليل (واط لكل ساعة)',
              description:
                  'أدخل القدرة الإجمالية (واط) للأجهزة التي تعمل معًا خلال ساعة واحدة في الليل.',
              hintText: 'مثال: 3500',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            SizedBox(height: 24 * scale),
            _CalculatorField(
              scale: scale,
              controller: nightHoursController,
              validator: hoursValidator,
              title: 'ساعات التشغيل الليلي (ساعات)',
              description:
                  'أدخل عدد الساعات التي تريد أن تعمل فيها المنظومة ليلاً.',
              hintText: 'مثال: 5',
              showClockIcon: true,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}

class _CalculatorField extends StatelessWidget {
  final double scale;
  final String title;
  final String description;
  final String hintText;
  final bool showClockIcon;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;

  const _CalculatorField({
    required this.scale,
    required this.title,
    required this.description,
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.keyboardType,
    this.showClockIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 56 * scale,
              height: 56 * scale,
              decoration: const BoxDecoration(
                color: AppColors.navy,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: showClockIcon
                    ? Icon(
                        Icons.access_time_outlined,
                        color: AppColors.orange,
                        size: 29 * scale,
                      )
                    : SizedBox.square(
                        dimension: 29 * scale,
                        child: const CustomPaint(painter: _LightningPainter()),
                      ),
              ),
            ),
            SizedBox(width: 18 * scale),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 26 * scale,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8 * scale),
        Text(
          description,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: AppColors.navy.withValues(alpha: .88),
            fontSize: 21 * scale,
            fontWeight: FontWeight.w400,
            height: 1.35,
          ),
        ),
        SizedBox(height: 16 * scale),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: TextStyle(color: AppColors.navy, fontSize: 30 * scale),
          decoration: InputDecoration(
            hintText: hintText,
            hintTextDirection: TextDirection.rtl,
            hintStyle: TextStyle(
              color: AppColors.navy.withValues(alpha: .28),
              fontSize: 30 * scale,
            ),
            errorStyle: TextStyle(
              color: const Color(0xFFB45353),
              fontSize: 19 * scale,
              height: 1.25,
            ),
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 28 * scale,
              vertical: 25 * scale,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18 * scale),
              borderSide: BorderSide(color: AppColors.navy, width: 2.8 * scale),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18 * scale),
              borderSide: BorderSide(color: AppColors.navy, width: 3.2 * scale),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18 * scale),
              borderSide: BorderSide(
                color: const Color(0xFFB45353),
                width: 2.8 * scale,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18 * scale),
              borderSide: BorderSide(
                color: const Color(0xFFB45353),
                width: 3.2 * scale,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LightningPainter extends CustomPainter {
  const _LightningPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bolt = Path()
      ..moveTo(size.width * .62, size.height * .04)
      ..lineTo(size.width * .22, size.height * .53)
      ..lineTo(size.width * .48, size.height * .53)
      ..lineTo(size.width * .36, size.height * .96)
      ..lineTo(size.width * .79, size.height * .42)
      ..lineTo(size.width * .53, size.height * .42)
      ..close();

    canvas.drawPath(
      bolt,
      Paint()
        ..color = AppColors.orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = (size.shortestSide * .075).clamp(1.15, 2.1)
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_LightningPainter oldDelegate) => false;
}

class _ValidationNote extends StatelessWidget {
  final double scale;

  const _ValidationNote({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline_rounded,
          color: AppColors.navy,
          size: 30 * scale,
        ),
        SizedBox(width: 12 * scale),
        Text(
          'أدخل قيمة صحيحة فقط',
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 21 * scale,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _CalculateButton extends StatelessWidget {
  final double scale;
  final VoidCallback onPressed;

  const _CalculateButton({required this.scale, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 88 * scale,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          elevation: 1,
          shadowColor: AppColors.navy.withValues(alpha: .16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18 * scale),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calculate_outlined,
              color: AppColors.orange,
              size: 42 * scale,
            ),
            SizedBox(width: 24 * scale),
            Text(
              'احسب النظام',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32 * scale,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InformationCard extends StatelessWidget {
  final double scale;

  const _InformationCard({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 28 * scale,
        vertical: 20 * scale,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FB),
        borderRadius: BorderRadius.circular(20 * scale),
      ),
      child: Row(
        children: [
          Container(
            width: 56 * scale,
            height: 56 * scale,
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: .9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 36 * scale,
            ),
          ),
          SizedBox(width: 20 * scale),
          Expanded(
            child: Text(
              'تعتمد نتائج الحاسبة على القدرة التي تدخلها لكل ساعة،\nلذلك احرص على إدخال قدرة الأجهزة التي تعمل في نفس الوقت.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 22 * scale,
                fontWeight: FontWeight.w500,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
