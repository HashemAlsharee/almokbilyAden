import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image Container
        Container(
          width: double.infinity,
          height: 240,
          decoration: const BoxDecoration(
            color: AppColors.background,
            // image: DecorationImage(
            //   image: AssetImage('assets/images/hero_background.jpg'),
            //   fit: BoxFit.cover,
            //   colorFilter: ColorFilter.mode(
            //     Colors.white.withOpacity(0.4),
            //     BlendMode.lighten,
            //   ),
            // ),
          ),
          // Placeholder for the background image
          child: const Opacity(
            opacity: 0.1,
            child: Icon(Icons.solar_power, size: 100, color: AppColors.primary),
          ),
        ),
        // Overlay Content
        Positioned.fill(
          child: SafeArea(
            top: false,
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                const Text(
                  'مرحباً بك',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'اختر الشركة التي ترغب باستعراض منتجاتها',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  width: 48,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.warning, // Orange divider
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
