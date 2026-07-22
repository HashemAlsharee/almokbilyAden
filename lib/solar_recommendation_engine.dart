import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'catalog_data.dart';

/// Centralized Constants for the Solar Recommendation Engine
abstract class SolarEngineConstants {
  /// Fixed solar panel power rating in Watts (LONGi 650W)
  static const double fixedPanelPowerWatts = 650.0;

  /// System loss multiplier (20% loss = 1.20)
  static const double systemLossMultiplier = 1.20;

  /// Peak sun hours per day
  static const double peakSunHours = 5.0;

  /// Allowed brand identifiers
  static const String longiBrandId = 'longi';
  static const String solisBrandId = 'solis';
  static const List<String> batteryBrandIds = ['pylontech', 'hithium'];

  /// Specific required panel model ID
  static const String longi650wPanelId = 'longi_lr8_66hvd_650m';
}

/// Represents failure conditions during recommendation calculation
class RecommendationFailure implements Exception {
  final String message;
  final String? code;

  const RecommendationFailure(this.message, {this.code});

  @override
  String toString() => 'RecommendationFailure: $message';
}

/// User inputs for solar system recommendation
class SolarInput {
  final double dayLoadWatts;
  final double nightLoadWatts;
  final int nightOperatingHours;

  const SolarInput({
    required this.dayLoadWatts,
    required this.nightLoadWatts,
    required this.nightOperatingHours,
  });

  /// Validates input values against safety rules
  RecommendationFailure? validate() {
    if (dayLoadWatts.isNaN || dayLoadWatts.isInfinite || dayLoadWatts <= 0) {
      return const RecommendationFailure(
        'حمل النهار يجب أن يكون رقمًا موجبًا أكبر من صفر',
        code: 'INVALID_DAY_LOAD',
      );
    }
    if (nightLoadWatts.isNaN ||
        nightLoadWatts.isInfinite ||
        nightLoadWatts <= 0) {
      return const RecommendationFailure(
        'حمل الليل يجب أن يكون رقمًا موجبًا أكبر من صفر',
        code: 'INVALID_NIGHT_LOAD',
      );
    }
    if (nightOperatingHours <= 0 || nightOperatingHours > 24) {
      return const RecommendationFailure(
        'ساعات التشغيل الليلي يجب أن تكون بين 1 و 24 ساعة',
        code: 'INVALID_NIGHT_HOURS',
      );
    }
    if (dayLoadWatts > 1000000 || nightLoadWatts > 1000000) {
      return const RecommendationFailure(
        'الأحمال المدخلة تتجاوز القدرة التشغيلية المسموحة',
        code: 'LOAD_OVERFLOW',
      );
    }
    return null;
  }
}

/// Internal inverter sizing candidate helper
class InverterOptionCandidate {
  final ProductItem product;
  final int requiredQuantity;

  const InverterOptionCandidate({
    required this.product,
    required this.requiredQuantity,
  });
}

/// Internal battery sizing candidate helper
class BatteryOptionCandidate {
  final ProductItem product;
  final double capacityWh;
  final int requiredQuantity;
  final double totalProvidedCapacityWh;
  final double excessPercentage;
  final int priority;

  const BatteryOptionCandidate({
    required this.product,
    required this.capacityWh,
    required this.requiredQuantity,
    required this.totalProvidedCapacityWh,
    required this.excessPercentage,
    required this.priority,
  });
}

/// Final Output Model of Recommendation Engine
class RecommendationResult {
  final ProductItem selectedPanel;
  final int panelQuantity;

  final ProductItem selectedInverter;
  final int inverterQuantity;
  final ProductItem selectedBattery;
  final int batteryQuantity;

  final int calculatedDayPanels;
  final int calculatedChargingPanels;
  final int calculatedTotalPanels;
  final double requiredInverterPowerWatts;
  final double requiredBatteryCapacityWh;

  const RecommendationResult({
    required this.selectedPanel,
    required this.panelQuantity,
    required this.selectedInverter,
    this.inverterQuantity = 1,
    required this.selectedBattery,
    required this.batteryQuantity,
    required this.calculatedDayPanels,
    required this.calculatedChargingPanels,
    required this.calculatedTotalPanels,
    required this.requiredInverterPowerWatts,
    required this.requiredBatteryCapacityWh,
  });
}

/// Complete Recommendation Engine Implementation
class SolarRecommendationEngine {
  final List<CompanyCatalog> _catalogs;

  SolarRecommendationEngine({List<CompanyCatalog>? catalogs})
      : _catalogs = catalogs ?? companyCatalogs;

  /// Loads catalogs directly from companyCatalogs or local JSON assets
  static Future<SolarRecommendationEngine> loadFromAssets() async {
    return SolarRecommendationEngine(catalogs: companyCatalogs);
  }

  /// Calculates the complete solar recommendation based on official company rules
  RecommendationResult calculate(SolarInput input) {
    // Input Validation
    final validationError = input.validate();
    if (validationError != null) {
      throw validationError;
    }

    // STEP 1: DAY PANELS
    // Day Panels = Day Load / 650, add 20% system loss, round UP
    final rawDayPanels = input.dayLoadWatts / SolarEngineConstants.fixedPanelPowerWatts;
    final dayPanelsWithLoss = rawDayPanels * SolarEngineConstants.systemLossMultiplier;
    final calculatedDayPanels = dayPanelsWithLoss.ceil();

    // STEP 2: INVERTER SIZE
    // Required Inverter Power = Day Load + 20%
    final requiredInverterPowerWatts =
        input.dayLoadWatts * SolarEngineConstants.systemLossMultiplier;

    // STEP 3: BATTERY CAPACITY
    // Battery Capacity = Night Load * Night Hours
    final requiredBatteryCapacityWh =
        input.nightLoadWatts * input.nightOperatingHours;

    // STEP 4: BATTERY CHARGING PANELS
    // Charging Panels = Battery Capacity / 650 / 5, round UP
    final rawChargingPanels = requiredBatteryCapacityWh /
        SolarEngineConstants.fixedPanelPowerWatts /
        SolarEngineConstants.peakSunHours;
    final calculatedChargingPanels = rawChargingPanels.ceil();

    // STEP 5: TOTAL PANELS
    final calculatedTotalPanels = calculatedDayPanels + calculatedChargingPanels;

    // STEP 6: BATTERY SELECTION (Pylontech & Hithium)
    final selectedBatterySolution =
        _selectOptimalBattery(requiredBatteryCapacityWh);

    // STEP 7: PANEL SELECTION (LONGi 650W)
    final selectedPanel = _selectLongiPanel();

    // STEP 8: INVERTER SELECTION (Solis)
    final selectedInverterSolution =
        _selectSolisInverter(requiredInverterPowerWatts);

    return RecommendationResult(
      selectedPanel: selectedPanel,
      panelQuantity: calculatedTotalPanels,
      selectedInverter: selectedInverterSolution.product,
      inverterQuantity: selectedInverterSolution.requiredQuantity,
      selectedBattery: selectedBatterySolution.product,
      batteryQuantity: selectedBatterySolution.requiredQuantity,
      calculatedDayPanels: calculatedDayPanels,
      calculatedChargingPanels: calculatedChargingPanels,
      calculatedTotalPanels: calculatedTotalPanels,
      requiredInverterPowerWatts: requiredInverterPowerWatts,
      requiredBatteryCapacityWh: requiredBatteryCapacityWh,
    );
  }

  /// Selects the LONGi 650W panel
  ProductItem _selectLongiPanel() {
    final longiCatalog = _catalogs.firstWhere(
      (c) => c.id.toLowerCase() == SolarEngineConstants.longiBrandId,
      orElse: () => throw const RecommendationFailure(
        'علامة LONGi غير متوفرة في المنتجات',
        code: 'BRAND_NOT_FOUND',
      ),
    );

    final panel = longiCatalog.products.firstWhere(
      (p) =>
          p.id == SolarEngineConstants.longi650wPanelId ||
          (p.power.contains('650') && p.companyName.toLowerCase() == 'longi'),
      orElse: () => throw const RecommendationFailure(
        'اللوح الشمسي LONGi 650W غير متوفر',
        code: 'PANEL_UNAVAILABLE',
      ),
    );

    return panel;
  }

  /// Selects Solis inverter(s). If no single inverter is sufficient,
  /// selects multiple units of the largest inverter model to cover requiredPower.
  InverterOptionCandidate _selectSolisInverter(double requiredPowerWatts) {
    final solisCatalog = _catalogs.firstWhere(
      (c) => c.id.toLowerCase() == SolarEngineConstants.solisBrandId,
      orElse: () => throw const RecommendationFailure(
        'علامة Solis غير متوفرة في المنتجات',
        code: 'BRAND_NOT_FOUND',
      ),
    );

    if (solisCatalog.products.isEmpty) {
      throw const RecommendationFailure(
        'لا توجد انفرترات Solis متوفرة في النظام',
        code: 'INVERTER_UNAVAILABLE',
      );
    }

    // Map each inverter to its rated power in Watts
    final candidates = <MapEntry<ProductItem, double>>[];
    for (final product in solisCatalog.products) {
      final powerWatts = _extractInverterPowerWatts(product);
      if (powerWatts > 0) {
        candidates.add(MapEntry(product, powerWatts));
      }
    }

    if (candidates.isEmpty) {
      throw const RecommendationFailure(
        'تعذر تحديد قدرة انفرترات Solis المتاحة',
        code: 'INVERTER_UNAVAILABLE',
      );
    }

    // Sort ascending by rated power
    candidates.sort((a, b) => a.value.compareTo(b.value));

    // 1. Choose first single inverter with rated power >= requiredPowerWatts
    for (final candidate in candidates) {
      if (candidate.value >= requiredPowerWatts) {
        return InverterOptionCandidate(
          product: candidate.key,
          requiredQuantity: 1,
        );
      }
    }

    // 2. If no single inverter is sufficient, pick the largest available inverter
    // and calculate the required quantity to satisfy requiredPowerWatts
    final largestCandidate = candidates.last;
    final requiredQuantity =
        (requiredPowerWatts / largestCandidate.value).ceil();

    return InverterOptionCandidate(
      product: largestCandidate.key,
      requiredQuantity: requiredQuantity,
    );
  }

  /// Selects optimal battery model based on maximum 20% excess threshold,
  /// minimum 5kWh capacity rule, lowest quantity & priority tie-breaker.
  BatteryOptionCandidate _selectOptimalBattery(double requiredCapacityWh) {
    final candidateBatteries = <ProductItem>[];

    for (final brandId in SolarEngineConstants.batteryBrandIds) {
      final catalog = _catalogs.firstWhere(
        (c) => c.id.toLowerCase() == brandId,
        orElse: () => CompanyCatalog(
          id: brandId,
          displayName: brandId,
          productsPageTitle: brandId,
          logoPath: '',
          heroImagePath: '',
          heroHeadline: '',
          heroDescription: '',
          accentColor: const Color(0xFF000000),
          products: const [],
        ),
      );
      candidateBatteries.addAll(catalog.products);
    }

    if (candidateBatteries.isEmpty) {
      throw const RecommendationFailure(
        'لا توجد بطاريات متوفرة في المنتجات',
        code: 'BATTERY_UNAVAILABLE',
      );
    }

    final options = <BatteryOptionCandidate>[];

    for (int i = 0; i < candidateBatteries.length; i++) {
      final battery = candidateBatteries[i];
      final capacityWh = _extractBatteryCapacityWh(battery);
      if (capacityWh <= 0) continue;

      final quantity = math.max(1, (requiredCapacityWh / capacityWh).ceil());
      final totalCapacity = quantity * capacityWh;
      final excessPercentage = ((totalCapacity - requiredCapacityWh) / requiredCapacityWh) * 100.0;

      options.add(BatteryOptionCandidate(
        product: battery,
        capacityWh: capacityWh,
        requiredQuantity: quantity,
        totalProvidedCapacityWh: totalCapacity,
        excessPercentage: excessPercentage,
        priority: i, // Priority defaults to product catalog index order
      ));
    }

    if (options.isEmpty) {
      throw const RecommendationFailure(
        'تعذر حساب سعة البطاريات المطلوبة',
        code: 'NO_SUITABLE_BATTERY',
      );
    }

    // RULE 1: If consumption is < 5 kWh (5000 Wh), recommend a ~5 kWh battery with quantity 1
    if (requiredCapacityWh < 5000.0) {
      final smallOptions = options
          .where((opt) => opt.capacityWh <= 6000.0 && opt.requiredQuantity == 1)
          .toList();
      if (smallOptions.isNotEmpty) {
        smallOptions.sort((a, b) => a.priority.compareTo(b.priority));
        return smallOptions.first;
      }
    }

    // RULE 2: Filter options where excessPercentage <= 20.0%
    final reasonableOptions =
        options.where((opt) => opt.excessPercentage <= 20.0).toList();

    if (reasonableOptions.isNotEmpty) {
      // Primary rule: Choose solution with the LOWEST quantity.
      // Tie-breaker: Choose product with lowest priority value.
      reasonableOptions.sort((a, b) {
        final quantityComparison =
            a.requiredQuantity.compareTo(b.requiredQuantity);
        if (quantityComparison != 0) return quantityComparison;

        return a.priority.compareTo(b.priority);
      });
      return reasonableOptions.first;
    }

    // Fallback: If no option has excess <= 20%, pick option with lowest excess percentage
    options.sort((a, b) => a.excessPercentage.compareTo(b.excessPercentage));
    return options.first;
  }

  /// Extracts rated power in Watts from Solis product specs
  double _extractInverterPowerWatts(ProductItem item) {
    // First try item.power e.g. "6kW", "8kW", "12kW", "110kW"
    final powerStr = item.power.replaceAll('kW', '').replaceAll('W', '').trim();
    final parsed = double.tryParse(powerStr);
    if (parsed != null && parsed > 0) {
      return item.power.contains('kW') ? parsed * 1000.0 : parsed;
    }

    // Try specifications map "القدرة الاسمية"
    final specPower = item.specifications['القدرة الاسمية'];
    if (specPower != null) {
      final clean = specPower.replaceAll('kW', '').replaceAll('W', '').trim();
      final p = double.tryParse(clean);
      if (p != null && p > 0) {
        return specPower.contains('kW') ? p * 1000.0 : p;
      }
    }

    return 0.0;
  }

  /// Extracts capacity in Wh from Battery product specs
  double _extractBatteryCapacityWh(ProductItem item) {
    // Try item.power e.g. "5.12kWh", "16kWh"
    final powerStr = item.power.replaceAll('kWh', '').replaceAll('Wh', '').trim();
    final parsed = double.tryParse(powerStr);
    if (parsed != null && parsed > 0) {
      return item.power.contains('kWh') ? parsed * 1000.0 : parsed;
    }

    // Try specifications map "السعة" or "سعة البطارية"
    final specCap = item.specifications['السعة'] ?? item.specifications['سعة البطارية'];
    if (specCap != null) {
      final clean = specCap.replaceAll('kWh', '').replaceAll('Wh', '').trim();
      final c = double.tryParse(clean);
      if (c != null && c > 0) {
        return specCap.contains('kWh') ? c * 1000.0 : c;
      }
    }

    return 0.0;
  }
}
