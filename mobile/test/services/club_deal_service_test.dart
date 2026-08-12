import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aratel_mobile/services/club_deal_service.dart';
import 'package:aratel_mobile/models/club_deal_models.dart';

void main() {
  group('ClubDealService Tests', () {
    test('getClubDeals returns ClubDealListResponse on 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/v1/club_deals');
        expect(request.method, 'GET');
        return http.Response(
          jsonEncode({
            'club_deals': [
              {
                'id': 'deal_552',
                'brand': 'B&B Italia',
                'item_name': 'Camaleonda Sofa VVIP Club Deal',
                'original_price': 18500000,
                'deal_price': 14200000,
                'point_discount_limit': 1000000,
                'min_participants': 5,
                'current_participants': 3,
                'status': 'OPEN'
              }
            ]
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = ClubDealService(client: mockClient);
      final res = await service.getClubDeals();

      expect(res.clubDeals.length, 1);
      expect(res.clubDeals.first.dealPrice, 14200000);
    });

    test('getClubDeals throws Exception on error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 500);
      });

      final service = ClubDealService(client: mockClient);
      expect(() => service.getClubDeals(), throwsException);
    });

    test('placeOrder returns ClubDealOrderResponse on 201', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/v1/club_deals/deal_552/order');
        expect(request.method, 'POST');
        final body = jsonDecode(request.body);
        expect(body['used_points'], 500000);
        expect(body['cash_amount'], 13700000);

        return http.Response(
          jsonEncode({
            'order_id': 'ord_9901',
            'status': 'ORDER_PLACED',
            'remaining_points': 450000,
          }),
          201,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = ClubDealService(client: mockClient);
      final res = await service.placeOrder(
        'deal_552',
        const ClubDealOrderRequest(usedPoints: 500000, cashAmount: 13700000),
      );

      expect(res.orderId, 'ord_9901');
      expect(res.status, 'ORDER_PLACED');
      expect(res.remainingPoints, 450000);
    });

    test('placeOrder throws Exception on error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Bad Request', 400);
      });

      final service = ClubDealService(client: mockClient);
      expect(
        () => service.placeOrder(
          'deal_552',
          const ClubDealOrderRequest(usedPoints: 0, cashAmount: 0),
        ),
        throwsException,
      );
    });
  });
}
