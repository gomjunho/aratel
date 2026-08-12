import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aratel_mobile/services/atelier_service.dart';
import 'package:aratel_mobile/models/atelier_models.dart';

void main() {
  group('AtelierService Tests', () {
    test('getFlatMaps returns FlatMapResponse on 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/v1/atelier/flat_maps');
        expect(request.method, 'GET');
        return http.Response(
          jsonEncode({
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
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = AtelierService(client: mockClient);
      final res = await service.getFlatMaps();

      expect(res.furnitureCatalog.length, 1);
      expect(res.furnitureCatalog.first.brand, 'B&B Italia');
    });

    test('getFlatMaps throws Exception on error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final service = AtelierService(client: mockClient);
      expect(() => service.getFlatMaps(), throwsException);
    });

    test('createSimulation returns SimulationResponse on 201', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/v1/atelier/simulations');
        expect(request.method, 'POST');
        final body = jsonDecode(request.body);
        expect(body['flat_map_id'], 'flat_84a');

        return http.Response(
          jsonEncode({
            'simulation_id': 'sim_8812',
            'club_deal_triggered': true,
            'club_deal_id': 'deal_552'
          }),
          201,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = AtelierService(client: mockClient);
      final res = await service.createSimulation(
        const SimulationRequest(
          flatMapId: 'flat_84a',
          placedItems: [
            PlacementItem(furnitureId: 'furn_101', position: [1.2, 0.0, 3.4], rotation: [0, 90, 0])
          ],
        ),
      );

      expect(res.simulationId, 'sim_8812');
      expect(res.clubDealTriggered, isTrue);
      expect(res.clubDealId, 'deal_552');
    });

    test('createSimulation throws Exception on error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Bad Request', 400);
      });

      final service = AtelierService(client: mockClient);
      expect(
        () => service.createSimulation(
          const SimulationRequest(flatMapId: 'flat_84a', placedItems: []),
        ),
        throwsException,
      );
    });
  });
}
