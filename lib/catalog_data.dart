import 'package:flutter/material.dart';

import 'core/theme/app_colors.dart';

class CompanyCatalog {
  final String id;
  final String displayName;
  final String productsPageTitle;
  final String logoPath;
  final String heroImagePath;
  final String heroHeadline;
  final String heroDescription;
  final Color accentColor;
  final List<ProductItem> products;

  const CompanyCatalog({
    required this.id,
    required this.displayName,
    required this.productsPageTitle,
    required this.logoPath,
    required this.heroImagePath,
    required this.heroHeadline,
    required this.heroDescription,
    required this.accentColor,
    required this.products,
  });
}

class ProductItem {
  final String id;
  final String companyName;
  final String name;
  final String model;
  final String power;
  final String type;
  final String imagePath;
  final String description;
  final Map<String, String> specifications;
  final String? datasheetPath;

  const ProductItem({
    required this.id,
    required this.companyName,
    required this.name,
    required this.model,
    required this.power,
    required this.type,
    required this.imagePath,
    required this.description,
    required this.specifications,
    this.datasheetPath,
  });
}

// بيانات وصور مؤقتة، تُستبدل مباشرة هنا عند وصول بيانات الشركات الرسمية.
List<ProductItem> _products(String company, String prefix) {
  const longiNames = [
    ('Hi-MO 6 Explorer', 'LR5-72HTH', '580W', 'ألواح أحادية الوجه'),
    ('Hi-MO 6 Scientist', 'LR5-72HTD', '565W', 'ألواح ثنائية الوجه'),
    ('Hi-MO 5m', 'LR5-72HPH', '540W', 'ألواح أحادية الوجه'),
    ('Hi-MO 5', 'LR5-72HBD', '535W', 'ألواح ثنائية الوجه'),
    ('Hi-MO 4m', 'LR4-72HPH', '450W', 'ألواح أحادية الوجه'),
    ('Hi-MO X6 Max', 'LR7-72HVH', '620W', 'ألواح عالية القدرة'),
  ];

  return List.generate(6, (index) {
    final sample = prefix == 'longi'
        ? longiNames[index]
        : (
            'منتج $company ${index + 1}',
            'MODEL-00${index + 1}',
            '${450 + index * 25}W',
            'منتج طاقة متجددة',
          );
    return ProductItem(
      id: '$prefix-${index + 1}',
      companyName: company,
      name: sample.$1,
      model: sample.$2,
      power: sample.$3,
      type: sample.$4,
      imagePath: '',
      description:
          'منتج عالي الكفاءة مصمم لتوفير أداء موثوق وطاقة أعلى في المشاريع السكنية والتجارية الكبرى ومحطات الطاقة.',
      specifications: {
        'القدرة': sample.$3,
        'الجهد الكهربائي': '49.8V',
        'الكفاءة': '22.5%',
        'الوزن': '27.5kg',
        'نوع الخلايا': 'Mono PERC',
        'ضمان المنتج': '25 Years',
      },
    );
  });
}

final List<CompanyCatalog> companyCatalogs = [
  CompanyCatalog(
    id: 'longi',
    displayName: 'LONGi',
    productsPageTitle: 'LONGi',
    logoPath: 'images/LONGi_banner_2170x725.webp',
    heroImagePath: 'images/longi_design.webp',
    heroHeadline: 'ألواح شمسية عالية الكفاءة',
    heroDescription: 'للمشاريع السكنية والتجارية',
    accentColor: AppColors.green,
    products: _products('LONGi', 'longi'),
  ),
  CompanyCatalog(
    id: 'canadian',
    displayName: 'Canadian Solar',
    productsPageTitle: 'Canadian Solar',
    logoPath: 'images/CanadianSolar_banner_2170x725.webp',
    heroImagePath: 'images/Canadian_Solar_Hero_Banner.webp',
    heroHeadline: 'حلول كهروضوئية موثوقة',
    heroDescription: 'للمشاريع السكنية والتجارية',
    accentColor: AppColors.green,
    products: _products('Canadian Solar', 'canadian'),
  ),
  CompanyCatalog(
    id: 'solis',
    displayName: 'Solis',
    productsPageTitle: 'Solis',
    logoPath: 'images/Solis_banner_2170x725.webp',
    heroImagePath: 'images/SOLIS_Hero_Banner.webp',
    heroHeadline: 'محولات شمسية ذكية',
    heroDescription: 'لأنظمة الطاقة المتجددة',
    accentColor: AppColors.green,
    products: _products('Solis', 'solis'),
  ),
  CompanyCatalog(
    id: 'pylontech',
    displayName: 'Pylontech',
    productsPageTitle: 'Pylontech',
    logoPath: 'images/PYLONTECH_banner_1000x475.webp',
    heroImagePath: 'images/PYLONTECH_Hero_Banner.webp',
    heroHeadline: 'حلول بطاريات متقدمة',
    heroDescription: 'لتخزين الطاقة بكفاءة',
    accentColor: AppColors.green,
    products: _products('Pylontech', 'pylontech'),
  ),
  CompanyCatalog(
    id: 'hithium',
    displayName: 'Hithium',
    productsPageTitle: 'Hithium',
    logoPath: 'images/HITHIUM_banner_2170x725.webp',
    heroImagePath: 'images/HITHIUM_Hero_Banner.webp',
    heroHeadline: 'حلول تخزين الجيل القادم',
    heroDescription: 'للمشاريع السكنية والتجارية',
    accentColor: AppColors.green,
    products: _products('Hithium', 'hithium'),
  ),
];

CompanyCatalog catalogById(String id) =>
    companyCatalogs.firstWhere((catalog) => catalog.id == id);
