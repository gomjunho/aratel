import 'package:flutter_test/flutter_test.dart';
import 'package:aratel_mobile/models/club_deal_models.dart';

void main() {
  group('ClubDeal Models Tests', () {
    test('ClubDeal fromJson and toJson', () {
      final json = {
        'id': 'deal_552',
        'brand': 'B&B Italia',
        'item_name': 'Camaleonda Sofa VVIP Club Deal',
        'original_price': 18500000,
        'deal_price': 14200000,
        'point_discount_limit': 1000000,
        'min_participants': 5,
        'current_participants': 3,
        'status': 'OPEN',
      };

      final deal = ClubDeal.fromJson(json);
      expect(deal.id, 'deal_552');
      expect(deal.brand, 'B&B Italia');
      expect(deal.itemName, 'Camaleonda Sofa VVIP Club Deal');
      expect(deal.originalPrice, 18500000);
      expect(deal.dealPrice, 14200000);
      expect(deal.pointDiscountLimit, 1000000);
      expect(deal.minParticipants, 5);
      expect(deal.currentParticipants, 3);
      expect(deal.status, 'OPEN');

      final serialized = deal.toJson();
      expect(serialized['id'], 'deal_552');
      expect(serialized['deal_price'], 14200000);
    });

    test('ClubDealListResponse fromJson and toJson', () {
      final json = {
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
            'status': 'OPEN',
          }
        ]
      };

      final res = ClubDealListResponse.fromJson(json);
      expect(res.clubDeals.length, 1);
      expect(res.clubDeals.first.id, 'deal_552');
      expect(res.toJson()['club_deals'], isA<List>());
    });

    test('ClubDealOrderRequest and ClubDealOrderResponse', () {
      const req = ClubDealOrderRequest(usedPoints: 500000, cashAmount: 13700000);
      final reqJson = req.toJson();
      expect(reqJson['used_points'], 500000);
      expect(reqJson['cash_amount'], 13700000);
      expect(ClubDealOrderRequest.fromJson(reqJson).usedPoints, 500000);

      final resJson = {
        'order_id': 'ord_9901',
        'status': 'ORDER_PLACED',
        'remaining_points': 450000,
      };

      final res = ClubDealOrderResponse.fromJson(resJson);
      expect(res.orderId, 'ord_9901');
      expect(res.status, 'ORDER_PLACED');
      expect(res.remainingPoints, 450000);
      expect(res.toJson()['remaining_points'], 450000);
    });
  });
}
