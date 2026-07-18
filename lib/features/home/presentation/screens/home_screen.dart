import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/brand_card.dart';
import '../widgets/calculator_card.dart';
import '../widgets/hero_banner.dart';
import '../widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HomeHeader(),
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const HeroBanner(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        BrandCard(
                          brandName: 'LONGi',
                          subtitle: 'High-efficiency solar panels',
                          logoWidget: const Text(
                            'LONGi',
                            style: TextStyle(
                              color: Color(0xFFD32F2F), // LONGi Red
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          onTap: () {},
                        ),
                        BrandCard(
                          brandName: 'CanadianSolar',
                          subtitle: 'Reliable photovoltaic solutions',
                          logoWidget: Row(
                            children: const [
                              Icon(
                                Icons.wb_sunny,
                                color: Color(0xFFF57C00),
                                size: 28,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'CanadianSolar',
                                style: TextStyle(
                                  color: Color(0xFFD32F2F),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                        BrandCard(
                          brandName: 'solis',
                          subtitle: 'Smart solar inverters',
                          logoWidget: Row(
                            children: const [
                              Icon(
                                Icons.wb_twilight,
                                color: Color(0xFFF57C00),
                                size: 36,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'solis',
                                style: TextStyle(
                                  color: Color(0xFFF57C00), // Solis Orange
                                  fontSize: 28,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                        BrandCard(
                          brandName: 'PYLONTECH',
                          subtitle: 'Advanced lithium battery storage',
                          logoWidget: Row(
                            children: const [
                              Icon(
                                Icons.battery_charging_full,
                                color: Color(0xFF388E3C),
                                size: 32,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'PYLONTECH',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                        BrandCard(
                          brandName: 'HITHIUM',
                          subtitle: 'Next-generation energy storage',
                          logoWidget: Row(
                            children: const [
                              Icon(
                                Icons.hexagon,
                                color: Color(0xFF1976D2),
                                size: 32,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'HITHIUM',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                        CalculatorCard(onTap: () {}),
                        const SizedBox(height: 32),
                      ],
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
