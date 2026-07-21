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
  final String? productOverlayLogoPath;
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
    this.productOverlayLogoPath,
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

final List<CompanyCatalog> companyCatalogs = [
  CompanyCatalog(
    id: 'longi',
    displayName: 'LONGi',
    productsPageTitle: 'LONGi',
    logoPath: 'images/LONGi_banner_2170x725.webp',
    heroImagePath: 'images/longi_design.webp',
    productOverlayLogoPath: 'images/longi_logo.jpg',
    heroHeadline: 'ألواح شمسية عالية الكفاءة',
    heroDescription: 'لالمشاريع السكنية والتجارية',
    accentColor: AppColors.green,
    products: [
      ProductItem(
        id: 'longi_lr8_66hvd_650m',
        companyName: 'LONGi',
        name: 'Hi-MO X10',
        model: 'LR8-66HVD-650M',
        power: '650W',
        type: 'ألواح شمسية ثنائية الوجه',
        imagePath: 'images/LONGi_Solar_Panel_1000x1600.png',
        description:
            'لوح شمسي ثنائي الوجه يعتمد تقنية HPBC 2.0 وخلايا N-Type. يوفر قدرة عالية وكفاءة مرتفعة لأنظمة الطاقة الشمسية التجارية ومحطات الطاقة. صُمم لتحقيق أداء مستقر وعمر تشغيلي طويل.',
        specifications: {
          'القدرة': '650 W',
          'الجهد': '49.72 V',
          'الكفاءة': '24.06 %',
          'الوزن': '33.5 kg',
          'نوع الخلايا': 'N-Type HPBC 2.0',
          'الضمان': '15 سنة ضمان المنتج / 30 سنة ضمان القدرة',
        },
        datasheetPath: 'datasheet/Hi-MO X10 650M.pdf',
      ),
    ],
  ),
  CompanyCatalog(
    id: 'canadian',
    displayName: 'Canadian Solar',
    productsPageTitle: 'Canadian Solar',
    logoPath: 'images/CanadianSolar_banner_2170x725.webp',
    productOverlayLogoPath: 'images/canadian.jpg',
    heroImagePath: 'images/Canadian_Solar_Hero_Banner.webp',
    heroHeadline: 'حلول كهروضوئية موثوقة',
    heroDescription: 'لالمشاريع السكنية والتجارية',
    accentColor: AppColors.green,
    products: [
      ProductItem(
        id: 'canadian_solar_cs7n_715tb_ag',
        companyName: 'Canadian Solar',
        name: 'TOPBiHiKu7',
        model: 'CS7N-715TB-AG',
        power: '715W',
        type: 'ألواح شمسية ثنائية الوجه',
        imagePath: 'images/candian.png',
        description:
            'لوح شمسي ثنائي الوجه يعتمد تقنية TOPCon من النوع N. يوفر قدرة مرتفعة وكفاءة عالية للاستخدام في أنظمة الطاقة الشمسية التجارية والصناعية. مناسب للتركيب في المشاريع ذات المساحات الكبيرة.',
        specifications: {
          'القدرة': '715 W',
          'الجهد': '48.5 V',
          'الكفاءة': '23.0 %',
          'الوزن': '37.8 kg',
          'نوع الخلايا': 'TOPCon cells',
          'الضمان': '30 سنة أداء خطي / 12 سنة ضمان المنتج',
        },
        datasheetPath: 'datasheet/candian solar 715w.pdf',
      ),
    ],
  ),
  CompanyCatalog(
    id: 'solis',
    displayName: 'Solis',
    productsPageTitle: 'Solis',
    logoPath: 'images/Solis_banner_2170x725.webp',
    productOverlayLogoPath: 'images/solis.jpg',
    heroImagePath: 'images/SOLIS_Hero_Banner.webp',
    heroHeadline: 'محولات شمسية ذكية',
    heroDescription: 'لأنظمة الطاقة المتجددة',
    accentColor: AppColors.green,
    products: [
      ProductItem(
        id: 'solis_s6_eh1p_6k_l_plus',
        companyName: 'Solis',
        name: 'SOLARATOR SERIES',
        model: 'S6-EH1P6K-L-PLUS',
        power: '6kW',
        type: 'انفرتر هجين',
        imagePath: 'images/6KW.webp',
        description:
            'انفرتر هجين أحادي الطور يعمل مع بطاريات الجهد المنخفض. يدعم التشغيل المتصل بالشبكة وخارجها مع زمن تحويل سريع. مناسب للأنظمة السكنية.',
        specifications: {
          'القدرة الاسمية': '6 kW',
          'أقصى كفاءة': '96.2 %',
          'عدد MPPT': '2',
          'أقصى جهد DC': '500 V',
          'الطور': 'أحادي',
          'الضمان': '-',
        },
        datasheetPath: 'datasheet/S6-EH1P(3-10)K-Global-Flyer-V4,0.pdf',
      ),
      ProductItem(
        id: 'solis_s6_eh3p_8k02_nv_yd_l',
        companyName: 'Solis',
        name: 'SOLARATOR SERIES',
        model: 'S6-EH3P8K02-NV-YD-L',
        power: '8kW',
        type: 'انفرتر هجين',
        imagePath: 'images/6KW.webp',
        description:
            'انفرتر هجين ثلاثي الطور يعمل مع بطاريات الجهد المنخفض. يدعم التشغيل داخل وخارج الشبكة مع إمكانية التوسع المتوازي. مناسب للتطبيقات التجارية الصغيرة.',
        specifications: {
          'القدرة الاسمية': '8 kW',
          'أقصى كفاءة': '97.5 %',
          'عدد MPPT': '2',
          'أقصى جهد DC': '1000 V',
          'الطور': 'ثلاثي',
          'الضمان': '-',
        },
        datasheetPath: 'datasheet/S6-EH3P(8-18)K-Global-Flyer-V3,8.pdf',
      ),
      ProductItem(
        id: 'solis_s6_eh1p12k03_nv_yd_l',
        companyName: 'Solis',
        name: 'SOLARATOR SERIES',
        model: 'S6-EH1P12K03-NV-YD-L',
        power: '12kW',
        type: 'انفرتر هجين',
        imagePath: 'images/9.6-16.webp',
        description:
            'انفرتر هجين أحادي الطور بقدرة مرتفعة لأنظمة التخزين السكنية. يدعم بطاريات الجهد المنخفض وإدارة الأحمال الاحتياطية.',
        specifications: {
          'القدرة الاسمية': '12 kW',
          'أقصى كفاءة': '97.6 %',
          'عدد MPPT': '3',
          'أقصى جهد DC': '550 V',
          'الطور': 'أحادي',
          'الضمان': '-',
        },
        datasheetPath:
            'datasheet/Solis_datasheet_S6-EH1P(12-16)K03-NV-YD-L_Global_V2,5_202409.pdf',
      ),
      ProductItem(
        id: 'solis_s6_eh3p15k02_nv_yd_l',
        companyName: 'Solis',
        name: 'SOLARATOR SERIES',
        model: 'S6-EH3P15K02-NV-YD-L',
        power: '15kW',
        type: 'انفرتر هجين',
        imagePath: 'images/15.webp',
        description:
            'انفرتر هجين ثلاثي الطور لأنظمة التخزين التجارية. يدعم التشغيل المتصل بالشبكة وخارجها مع بطاريات الجهد المنخفض.',
        specifications: {
          'القدرة الاسمية': '15 kW',
          'أقصى كفاءة': '97.5 %',
          'عدد MPPT': '2',
          'أقصى جهد DC': '1000 V',
          'الطور': 'ثلاثي',
          'الضمان': '-',
        },
        datasheetPath: 'datasheet/S6-EH3P(8-18)K-Global-Flyer-V3,8.pdf',
      ),
      ProductItem(
        id: 'solis_s6_eh1p16k03_nv_yd_l',
        companyName: 'Solis',
        name: 'SOLARATOR SERIES',
        model: 'S6-EH1P16K03-NV-YD-L',
        power: '16kW',
        type: 'انفرتر هجين',
        imagePath: 'images/9.6-16.webp',
        description:
            'انفرتر هجين أحادي الطور مخصص لأنظمة تخزين الطاقة السكنية. يدعم بطاريات الجهد المنخفض مع كفاءة تحويل مرتفعة وإدارة ذكية للطاقة.',
        specifications: {
          'القدرة الاسمية': '16 kW',
          'أقصى كفاءة': '97.6 %',
          'عدد MPPT': '3',
          'أقصى جهد DC': '550 V',
          'الطور': 'أحادي',
          'الضمان': '-',
        },
        datasheetPath:
            'datasheet/Solis_datasheet_S6-EH1P(12-16)K03-NV-YD-L_Global_V2,5_202409.pdf',
      ),
      ProductItem(
        id: 'solis_s6_eh3p18k02_nv_yd_l',
        companyName: 'Solis',
        name: 'SOLARATOR SERIES',
        model: 'S6-EH3P18K02-NV-YD-L',
        power: '18kW',
        type: 'انفرتر هجين',
        imagePath: 'images/15.webp',
        description:
            'انفرتر هجين ثلاثي الطور لأنظمة التخزين التجارية. يوفر أداءً مستقراً مع بطاريات الجهد المنخفض وإمكانية العمل داخل وخارج الشبكة.',
        specifications: {
          'القدرة الاسمية': '18 kW',
          'أقصى كفاءة': '97.5 %',
          'عدد MPPT': '2',
          'أقصى جهد DC': '1000 V',
          'الطور': 'ثلاثي',
          'الضمان': '-',
        },
        datasheetPath: 'datasheet/S6-EH3P(8-18)K-Global-Flyer-V3,8.pdf',
      ),
      ProductItem(
        id: 'solis_s6_eh3p30k_h',
        companyName: 'Solis',
        name: 'SOLARATOR SERIES',
        model: 'S6-EH3P30K-H',
        power: '30kW',
        type: 'انفرتر هجين',
        imagePath: 'images/30-50KW.webp',
        description:
            'انفرتر هجين ثلاثي الطور عالي الجهد للمشاريع التجارية. يدعم بطاريات الجهد العالي مع أداء مرتفع وإدارة متقدمة للطاقة.',
        specifications: {
          'القدرة الاسمية': '30 kW',
          'أقصى كفاءة': '97.8 %',
          'عدد MPPT': '3',
          'أقصى جهد DC': '1000 V',
          'الطور': 'ثلاثي',
          'الضمان': '-',
        },
        datasheetPath:
            'datasheet/Solis_Inverter_S6_EH3P29,9_50K_H_Datasheet_GLOBAL_V2,8_202507.pdf',
      ),
      ProductItem(
        id: 'solis_s6_eh3p50k_h',
        companyName: 'Solis',
        name: 'SOLARATOR SERIES',
        model: 'S6-EH3P50K-H',
        power: '50kW',
        type: 'انفرتر هجين',
        imagePath: 'images/30-50KW.webp',
        description:
            'انفرتر هجين ثلاثي الطور بجهد بطارية مرتفع مخصص للأنظمة التجارية والصناعية. يوفر كفاءة تحويل عالية وإدارة متقدمة للطاقة مع دعم التشغيل داخل وخارج الشبكة.',
        specifications: {
          'القدرة الاسمية': '50 kW',
          'أقصى كفاءة': '97.8 %',
          'عدد MPPT': '4',
          'أقصى جهد DC': '1000 V',
          'الطور': 'ثلاثي',
          'الضمان': '-',
        },
        datasheetPath:
            'datasheet/Solis_Inverter_S6_EH3P29,9_50K_H_Datasheet_GLOBAL_V2,8_202507.pdf',
      ),
      ProductItem(
        id: 'solis_s6_eh3p80k10_nv_yd_h',
        companyName: 'Solis',
        name: 'SOLARATOR SERIES',
        model: 'S6-EH3P80K10-NV-YD-H',
        power: '80kW',
        type: 'انفرتر هجين',
        imagePath: 'images/80-125 on grid.webp',
        description:
            'انفرتر هجين ثلاثي الطور عالي الجهد للتطبيقات التجارية والصناعية الكبيرة. يدعم بطاريات الليثيوم عالية الجهد ويوفر أداءً مستقراً مع كفاءة مرتفعة.',
        specifications: {
          'القدرة الاسمية': '80 kW',
          'أقصى كفاءة': '97.5 %',
          'عدد MPPT': '10',
          'أقصى جهد DC': '1000 V',
          'الطور': 'ثلاثي',
          'الضمان': '-',
        },
        datasheetPath: 'datasheet/S6-EH3P(80-125)K-ZA-Flyer-V2,2.pdf',
      ),
      ProductItem(
        id: 'solis_s6_eh3p125k10_nv_yd_h',
        companyName: 'Solis',
        name: 'SOLARATOR SERIES',
        model: 'S6-EH3P125K10-NV-YD-H',
        power: '125kW',
        type: 'انفرتر هجين',
        imagePath: 'images/80-125 on grid.webp',
        description:
            'انفرتر هجين ثلاثي الطور عالي الجهد بقدرة كبيرة للمشاريع الصناعية ومحطات تخزين الطاقة. يوفر دعماً لبطاريات الجهد العالي مع كفاءة تشغيل مرتفعة.',
        specifications: {
          'القدرة الاسمية': '125 kW',
          'أقصى كفاءة': '97.5 %',
          'عدد MPPT': '10',
          'أقصى جهد DC': '1000 V',
          'الطور': 'ثلاثي',
          'الضمان': '-',
        },
        datasheetPath: 'datasheet/S6-EH3P(80-125)K-ZA-Flyer-V2,2.pdf',
      ),
    ],
  ),
  CompanyCatalog(
    id: 'pylontech',
    displayName: 'Pylontech',
    productsPageTitle: 'Pylontech',
    logoPath: 'images/PYLONTECH_banner_1000x475.webp',
    productOverlayLogoPath: 'images/pylontech.jpg',
    heroImagePath: 'images/PYLONTECH_Hero_Banner.webp',
    heroHeadline: 'حلول بطاريات متقدمة',
    heroDescription: 'لتخزين الطاقة بكفاءة',
    accentColor: AppColors.green,
    products: [
      ProductItem(
        id: 'pylontech_fidus_battery',
        companyName: 'Pylontech',
        name: 'Fidus Battery',
        model: 'Fidus-Battery',
        power: '5.12kWh',
        type: 'بطارية تخزين طاقة ليثيوم',
        imagePath: 'images/fidus5KW.png',
        description:
            'بطارية تخزين طاقة تعتمد تقنية فوسفات الحديد والليثيوم (LiFePO4). مناسبة للتركيب الجداري أو الأرضي مع درجة حماية IP65. تدعم الاتصال عبر CAN وRS485 للاستخدام في الأنظمة السكنية.',
        specifications: {
          'السعة': '5.12 kWh',
          'الجهد الاسمي': '51.2 V',
          'سعة البطارية': '5.12 kWh',
          'الكيمياء': 'LiFePO4',
          'دورات الشحن': '>6000 cycles',
          'الضمان': '10 سنوات',
        },
        datasheetPath: 'datasheet/Fidus-Spec.pdf',
      ),
      ProductItem(
        id: 'pylontech_fb_l_16',
        companyName: 'Pylontech',
        name: 'Fidus Battery Plus',
        model: 'FB-L-16',
        power: '16.076kWh',
        type: 'بطارية تخزين طاقة ليثيوم',
        imagePath: 'images/Fidus 16KW.png',
        description:
            'بطارية تخزين طاقة منزلية تعتمد تقنية LiFePO4 مع درجة حماية IP65. توفر شاشة مدمجة ودعم Bluetooth وWi-Fi، ومناسبة للتركيب الأرضي أو الجداري.',
        specifications: {
          'السعة': '16.076 kWh',
          'الجهد الاسمي': '51.2 V',
          'سعة البطارية': '16.076 kWh',
          'الكيمياء': 'LiFePO4',
          'دورات الشحن': '8000 cycles',
          'الضمان': '-',
        },
        datasheetPath:
            'datasheet/EN_SD_250903_Fidus_Plus_Residential_Spec_Pylontech_20251028171331A368.pdf',
      ),
      ProductItem(
        id: 'pylontech_optim_us_a300_hy',
        companyName: 'Pylontech',
        name: 'OPTIM US',
        model: 'A300-HY',
        power: '313kWh',
        type: 'بطارية تخزين طاقة ليثيوم',
        imagePath: 'images/Pylontech 313KW.png',
        description:
            'نظام تخزين طاقة تجاري يعتمد بطاريات فوسفات الحديد والليثيوم مع انفرتر هجين مدمج. يوفر سعة تخزين كبيرة لدعم تطبيقات الطاقة الاحتياطية وإدارة الأحمال. مناسب للمشاريع التجارية والصناعية.',
        specifications: {
          'السعة': '313 kWh',
          'الجهد الاسمي': '560~720 V',
          'سعة البطارية': '313 kWh',
          'الكيمياء': 'Li-ion (LFP)',
          'دورات الشحن': '>7000 cycles',
          'الضمان': '-',
        },
        datasheetPath: 'datasheet/OPTIM US A300-HY_20240926105717A030.pdf',
      ),
      ProductItem(
        id: 'pylontech_uf5000',
        companyName: 'Pylontech',
        name: 'UF5000',
        model: 'UF5000',
        power: '5.12kWh',
        type: 'بطارية جهد منخفض',
        imagePath: 'images/Pylontech UF5000.png',
        description:
            'بطارية تخزين طاقة منخفضة الجهد تعتمد تقنية فوسفات الحديد والليثيوم. مصممة للتركيب داخل الرفوف القياسية مقاس 19 بوصة مع إمكانية التوسع في الأنظمة السكنية والتجارية الصغيرة.',
        specifications: {
          'السعة': '5.12 kWh',
          'الجهد الاسمي': '51.2 V',
          'سعة البطارية': '5.12 kWh',
          'الكيمياء': 'LiFePO4',
          'دورات الشحن': '>6000 cycles',
          'الضمان': '15 سنة',
        },
        datasheetPath: 'datasheet/UF5000_20240926105838A038.pdf',
      ),
      ProductItem(
        id: 'pylontech_us5000',
        companyName: 'Pylontech',
        name: 'US Series',
        model: 'US5000',
        power: '4.8kWh',
        type: 'بطارية جهد منخفض',
        imagePath: 'images/Pylontech US5000.png',
        description:
            'بطارية ليثيوم منخفضة الجهد تعتمد تقنية LiFePO4 ومخصصة لأنظمة تخزين الطاقة المنزلية. تدعم التوصيل على الرفوف القياسية مع إمكانية التوسع في السعة.',
        specifications: {
          'السعة': '4.8 kWh',
          'الجهد الاسمي': '48 V',
          'سعة البطارية': '4.8 kWh',
          'الكيمياء': 'LiFePO4',
          'دورات الشحن': '>8000 cycles',
          'الضمان': '15+ سنة',
        },
        datasheetPath: 'datasheet/US Series_20240926105858A040.pdf',
      ),
    ],
  ),
  CompanyCatalog(
    id: 'hithium',
    displayName: 'Hithium',
    productsPageTitle: 'Hithium',
    productOverlayLogoPath: 'images/hithium.jpg',
    logoPath: 'images/HITHIUM_banner_2170x725.webp',
    heroImagePath: 'images/HITHIUM_Hero_Banner.webp',
    heroHeadline: 'حلول تخزين الجيل القادم',
    heroDescription: 'لالمشاريع السكنية والتجارية',
    accentColor: AppColors.green,
    products: [
      ProductItem(
        id: 'hithium_heroee_16',
        companyName: 'Hithium',
        name: 'HeroEE',
        model: 'Hithium HeroEE 16',
        power: '16kWh',
        type: 'بطارية تخزين طاقة ليثيوم',
        imagePath: 'images/hithium.png',
        description:
            'بطارية تخزين طاقة تعتمد تقنية فوسفات الحديد والليثيوم (LiFePO4). مصممة لأنظمة التخزين السكنية مع دعم التوصيل المتوازي حتى 16 بطارية. توفر جهداً اسميًا 51.2 فولت وسعة تخزين 16 كيلوواط ساعة.',
        specifications: {
          'السعة': '16 kWh',
          'الجهد الاسمي': '51.2 V',
          'سعة البطارية': '16 kWh',
          'الكيمياء': 'Lithium-iron phosphate (LiFePO4)',
          'دورات الشحن': '>8000 cycles',
          'الضمان': '7 سنوات',
        },
        datasheetPath: 'datasheet/Datasheet HEROEE 16kW.pdf',
      ),
    ],
  ),
];

CompanyCatalog catalogById(String id) =>
    companyCatalogs.firstWhere((catalog) => catalog.id == id);
