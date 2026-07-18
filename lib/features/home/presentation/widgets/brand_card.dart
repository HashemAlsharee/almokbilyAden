import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class BrandCard extends StatelessWidget {
  final String brandName;
  final String subtitle;
  final Widget? logoWidget;
  final VoidCallback onTap;

  const BrandCard({
    super.key,
    required this.brandName,
    required this.subtitle,
    this.logoWidget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 140,
          child: Stack(
            children: [
              // Background Image Placeholder (Left side)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width * 0.55,
                child: Container(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 40,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ),
              // Gradient fade from White (Right) to Transparent (Left)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      stops: const [0.4, 0.7],
                      colors: [
                        AppColors.surface,
                        AppColors.surface.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (logoWidget != null)
                            logoWidget!
                          else
                            Text(
                              brandName,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_left,
                      color: AppColors.success,
                      size: 32,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
