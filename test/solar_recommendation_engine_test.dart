import 'package:flutter_test/flutter_test.dart';
import 'package:almokbily_aden/solar_recommendation_engine.dart';
import 'package:almokbily_aden/catalog_data.dart';

void main() {
  late SolarRecommendationEngine engine;

  setUp(() {
    engine = SolarRecommendationEngine(catalogs: companyCatalogs);
  });

  group('SolarRecommendationEngine - Input Validation Tests', () {
    test('Should throw error for zero day load', () {
      const input = SolarInput(
        dayLoadWatts: 0,
        nightLoadWatts: 1000,
        nightOperatingHours: 8,
      );
      expect(() => engine.calculate(input), throwsA(isA<RecommendationFailure>()));
    });

    test('Should throw error for negative night load', () {
      const input = SolarInput(
        dayLoadWatts: 2000,
        nightLoadWatts: -500,
        nightOperatingHours: 8,
      );
      expect(() => engine.calculate(input), throwsA(isA<RecommendationFailure>()));
    });

    test('Should throw error for invalid night operating hours (> 24)', () {
      const input = SolarInput(
        dayLoadWatts: 2000,
        nightLoadWatts: 1000,
        nightOperatingHours: 25,
      );
      expect(() => engine.calculate(input), throwsA(isA<RecommendationFailure>()));
    });

    test('Should throw error for NaN load inputs', () {
      const input = SolarInput(
        dayLoadWatts: double.nan,
        nightLoadWatts: 1000,
        nightOperatingHours: 8,
      );
      expect(() => engine.calculate(input), throwsA(isA<RecommendationFailure>()));
    });

    test('Should throw error for Infinity load inputs', () {
      const input = SolarInput(
        dayLoadWatts: double.infinity,
        nightLoadWatts: 1000,
        nightOperatingHours: 8,
      );
      expect(() => engine.calculate(input), throwsA(isA<RecommendationFailure>()));
    });
  });

  group('SolarRecommendationEngine - Calculation Steps Verification', () {
    test('Should calculate normal load correctly following official company steps', () {
      const input = SolarInput(
        dayLoadWatts: 2600,
        nightLoadWatts: 1000,
        nightOperatingHours: 8,
      );

      final result = engine.calculate(input);

      // STEP 1: Day Panels = ceil((2600 / 650) * 1.20) = ceil(4.8) = 5
      expect(result.calculatedDayPanels, equals(5));

      // STEP 2: Required Inverter Power = 2600 * 1.20 = 3120 W (3.12 kW)
      expect(result.requiredInverterPowerWatts, equals(3120.0));
      expect(result.selectedInverter.companyName.toLowerCase(), equals('solis'));

      // STEP 3: Battery Capacity = 1000 * 8 = 8000 Wh
      expect(result.requiredBatteryCapacityWh, equals(8000.0));

      // STEP 4: Battery Charging Panels = ceil(8000 / 650 / 5) = ceil(2.4615) = 3
      expect(result.calculatedChargingPanels, equals(3));

      // STEP 5: Total Panels = 5 + 3 = 8
      expect(result.calculatedTotalPanels, equals(8));

      // STEP 6: Battery Selection
      expect(
        ['pylontech', 'hithium'].contains(result.selectedBattery.companyName.toLowerCase()),
        isTrue,
      );
      expect(result.batteryQuantity, greaterThanOrEqualTo(1));

      // STEP 7: Panel Selection
      expect(result.selectedPanel.companyName.toLowerCase(), equals('longi'));
      expect(result.selectedPanel.power, contains('650'));
      expect(result.panelQuantity, equals(8));
    });

    test('Should calculate small load correctly', () {
      const input = SolarInput(
        dayLoadWatts: 500,
        nightLoadWatts: 200,
        nightOperatingHours: 4,
      );

      final result = engine.calculate(input);

      // Day Panels = ceil((500 / 650) * 1.20) = ceil(0.923) = 1
      expect(result.calculatedDayPanels, equals(1));

      // Charging Panels = ceil((200 * 4) / 650 / 5) = ceil(800 / 3250) = 1
      expect(result.calculatedChargingPanels, equals(1));

      // Total Panels = 2
      expect(result.calculatedTotalPanels, equals(2));
      expect(result.panelQuantity, equals(2));
    });

    test('Should choose battery with lowest quantity and priority tie-breaker', () {
      const input = SolarInput(
        dayLoadWatts: 3000,
        nightLoadWatts: 1500,
        nightOperatingHours: 10, // 15,000 Wh required
      );

      final result = engine.calculate(input);

      expect(result.requiredBatteryCapacityWh, equals(15000.0));
      // For 15,000 Wh: 16kWh battery requires 1 unit vs 5.12kWh requiring 3 units.
      expect(result.batteryQuantity, equals(1));
    });

    test('Should select 5x 16kWh batteries for 76.5kWh load instead of 15x 5.12kWh batteries (User Screenshot Case)', () {
      const input = SolarInput(
        dayLoadWatts: 10000,
        nightLoadWatts: 8500,
        nightOperatingHours: 9, // 76,500 Wh required
      );

      final result = engine.calculate(input);

      expect(result.requiredBatteryCapacityWh, equals(76500.0));
      // 5x 16kWh batteries (80kWh) vs 15x 5.12kWh batteries (76.8kWh).
      // System MUST choose 5 batteries (lowest quantity)!
      expect(result.batteryQuantity, equals(5));
      expect(
        result.selectedBattery.power.contains('16') ||
            result.selectedBattery.model.contains('FB-L-16') ||
            result.selectedBattery.model.contains('HeroEE 16'),
        isTrue,
      );
    });

    test('Should reject 313kWh battery container when excess > 20% for 450kWh load and choose 16kWh batteries instead', () {
      const input = SolarInput(
        dayLoadWatts: 10000,
        nightLoadWatts: 45000,
        nightOperatingHours: 10, // 450,000 Wh (450 kWh) required
      );

      final result = engine.calculate(input);

      expect(result.requiredBatteryCapacityWh, equals(450000.0));
      // 2x 313kWh containers (626kWh) would have 39.11% excess (>20%), so MUST be rejected!
      // Must choose 16kWh batteries (28 or 29 units) with excess <= 20%
      expect(result.selectedBattery.power, isNot(contains('313kWh')));
      expect(result.batteryQuantity, greaterThanOrEqualTo(28));
      expect(result.batteryQuantity, lessThanOrEqualTo(29));
    });

    test('Should recommend 1x 5kWh battery for small night load under 5kWh', () {
      const input = SolarInput(
        dayLoadWatts: 1000,
        nightLoadWatts: 500,
        nightOperatingHours: 4, // 2000 Wh (2 kWh) required < 5 kWh
      );

      final result = engine.calculate(input);

      expect(result.requiredBatteryCapacityWh, equals(2000.0));
      expect(result.batteryQuantity, equals(1));
      expect(result.selectedBattery.power, contains('5'));
    });

    test('Should select multiple units of largest inverter when system size exceeds max single inverter capacity', () {
      const input = SolarInput(
        dayLoadWatts: 250000, // 250 kW -> requires 300 kW inverter power
        nightLoadWatts: 5000,
        nightOperatingHours: 8,
      );

      final result = engine.calculate(input);

      // Required Inverter Power = 250 kW * 1.2 = 300 kW
      expect(result.requiredInverterPowerWatts, equals(300000.0));
      // Largest Solis inverter available in catalog is 125kW
      // Quantity = ceil(300 / 125) = 3
      expect(result.inverterQuantity, equals(3));
      expect(result.selectedInverter.power, contains('125'));
    });

    test('Should select 2x 125kW inverters for 150kW day load requiring 180kW capacity', () {
      const input = SolarInput(
        dayLoadWatts: 150000, // 150 kW -> requires 180 kW inverter power
        nightLoadWatts: 1000,
        nightOperatingHours: 4,
      );

      final result = engine.calculate(input);

      expect(result.requiredInverterPowerWatts, equals(180000.0));
      // 180kW / 125kW = 1.44 -> 2 units of 125kW
      expect(result.inverterQuantity, equals(2));
      expect(result.selectedInverter.power, contains('125'));
    });
  });
}
