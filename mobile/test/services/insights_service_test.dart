import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aratel_mobile/services/insights_service.dart';
import 'package:aratel_mobile/models/insights_models.dart';

void main() {
  group('InsightsService Tests', () {
    test('getInsights returns InsightsResponse on 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/v1/insights/transactions');
        expect(request.method, 'GET');

        return http.Response(
          jsonEncode({
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
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = InsightsService(client: mockClient);
      final res = await service.getInsights();

      expect(res.complexName, '디에이치 방배');
      expect(res.transactions.length, 2);
      expect(res.supplyGasIndex.riskLevel, 'LOW');
    });

    test('getInsights throws Exception on error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server error', 500);
      });

      final service = InsightsService(client: mockClient);
      expect(() => service.getInsights(), throwsException);
    });
  });
}
