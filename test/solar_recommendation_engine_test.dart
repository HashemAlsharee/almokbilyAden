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

    test('Should throw Failure when system size exceeds max available Solis inverter', () {
      const input = SolarInput(
        dayLoadWatts: 250000, // 250 kW -> requires 300 kW inverter
        nightLoadWatts: 5000,
        nightOperatingHours: 8,
      );

      expect(
        () => engine.calculate(input),
        throwsA(
          isA<RecommendationFailure>().having(
            (e) => e.code,
            'code',
            equals('NO_SUITABLE_INVERTER'),
          ),
        ),
      );
    });
  });
}
