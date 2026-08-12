import 'package:flutter_test/flutter_test.dart';
import 'package:aratel_mobile/models/atelier_models.dart';

void main() {
  group('Atelier Models Tests', () {
    test('FurnitureItem fromJson and toJson', () {
      final json = {
        'id': 'furn_101',
        'brand': 'B&B Italia',
        'name': 'Camaleonda Sofa',
        'model_3d_url': 'https://storage.aratel.com/3d/sofa_bb.gltf',
        'price': 18500000,
        'stock': 3,
      };

      final item = FurnitureItem.fromJson(json);
      expect(item.id, 'furn_101');
      expect(item.brand, 'B&B Italia');
      expect(item.name, 'Camaleonda Sofa');
      expect(item.price, 18500000);
      expect(item.stock, 3);

      final serialized = item.toJson();
      expect(serialized['brand'], 'B&B Italia');
      expect(serialized['price'], 18500000);
    });

    test('FlatMapResponse fromJson and toJson', () {
      final json = {
        'flat_map_url': 'https://storage.aratel.com/3d/dh_bangbae_84a.gltf',
        'furniture_catalog': [
          {
            'id': 'furn_101',
            'brand': 'B&B Italia',
            'name': 'Camaleonda Sofa',
            'model_3d_url': 'https://storage.aratel.com/3d/sofa_bb.gltf',
            'price': 18500000,
            'stock': 3
          }
        ]
      };

      final res = FlatMapResponse.fromJson(json);
      expect(res.flatMapUrl, contains('dh_bangbae_84a.gltf'));
      expect(res.furnitureCatalog.length, 1);
      expect(res.furnitureCatalog.first.name, 'Camaleonda Sofa');

      final serialized = res.toJson();
      expect(serialized['flat_map_url'], contains('dh_bangbae_84a.gltf'));
    });

    test('PlacementItem, SimulationRequest and SimulationResponse', () {
      const placement = PlacementItem(
        furnitureId: 'furn_101',
        position: [1.2, 0.0, 3.4],
        rotation: [0.0, 90.0, 0.0],
      );
      final pJson = placement.toJson();
      expect(pJson['furniture_id'], 'furn_101');
      expect(pJson['position'], [1.2, 0.0, 3.4]);
      expect(PlacementItem.fromJson(pJson).furnitureId, 'furn_101');

      const req = SimulationRequest(
        flatMapId: 'flat_84a',
        placedItems: [placement],
      );
      final reqJson = req.toJson();
      expect(reqJson['flat_map_id'], 'flat_84a');
      expect((reqJson['placed_items'] as List).length, 1);

      final resJson = {
        'simulation_id': 'sim_8812',
        'club_deal_triggered': true,
        'club_deal_id': 'deal_552',
      };
      final res = SimulationResponse.fromJson(resJson);
      expect(res.simulationId, 'sim_8812');
      expect(res.clubDealTriggered, isTrue);
      expect(res.clubDealId, 'deal_552');
      expect(res.toJson()['club_deal_id'], 'deal_552');
    });
  });
}
