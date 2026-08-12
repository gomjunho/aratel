import 'package:flutter_test/flutter_test.dart';
import 'package:aratel_mobile/models/insights_models.dart';

void main() {
  group('Insights Models Tests', () {
    test('TransactionItem, SupplyGasIndex, and InsightsResponse fromJson & toJson', () {
      final json = {
        'complex_name': '디에이치 방배',
        'transactions': [
          {'floor': 15, 'price': 2850000000, 'deal_date': '2026-07-15'},
          {'floor': 3, 'price': 2510000000, 'deal_date': '2026-07-10'}
        ],
        'supply_gas_index': {
          'risk_level': 'LOW',
          'upcoming_supply_units': 450,
          'analysis_summary': '향후 2년간 주변 과잉 공급 물량이 적어 자산 가치가 매우 안정적입니다.'
        }
      };

      final res = InsightsResponse.fromJson(json);

      expect(res.complexName, '디에이치 방배');
      expect(res.transactions.length, 2);
      expect(res.transactions.first.floor, 15);
      expect(res.transactions.first.price, 2850000000);
      expect(res.transactions.first.dealDate, '2026-07-15');

      expect(res.supplyGasIndex.riskLevel, 'LOW');
      expect(res.supplyGasIndex.upcomingSupplyUnits, 450);
      expect(res.supplyGasIndex.analysisSummary, contains('안정적입니다'));

      final serialized = res.toJson();
      expect(serialized['complex_name'], '디에이치 방배');
      expect((serialized['transactions'] as List).length, 2);
    });
  });
}
