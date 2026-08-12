import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aratel_mobile/screens/atelier_screen.dart';
import 'package:aratel_mobile/services/atelier_service.dart';

void main() {
  group('AtelierScreen Widget Tests', () {
    testWidgets('renders flat map and furniture catalog, allows placing furniture & running simulation', (WidgetTester tester) async {
      final mockClient = MockClient((request) async {
        if (request.method == 'GET' && request.url.path == '/api/v1/atelier/flat_maps') {
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
        } else if (request.method == 'POST' && request.url.path == '/api/v1/atelier/simulations') {
          return http.Response(
            jsonEncode({
              'simulation_id': 'sim_8812',
              'club_deal_triggered': true,
              'club_deal_id': 'deal_552'
            }),
            201,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        return http.Response('Not Found', 404);
      });

      final service = AtelierService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: AtelierScreen(atelierService: service),
        ),
      );

      // Loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();

      // Check header and catalog item
      expect(find.text('AI 아뜰리에 3D 평면도'), findsOneWidget);
      expect(find.text('Camaleonda Sofa'), findsOneWidget);
      expect(find.textContaining('B&B Italia'), findsOneWidget);

      // Tap on furniture item to place into simulation
      final placeBtn = find.descendant(
        of: find.byKey(const Key('furniture_item_furn_101')),
        matching: find.text('배치'),
      );
      expect(placeBtn, findsOneWidget);
      await tester.tap(placeBtn);
      await tester.pumpAndSettle();

      // Verify item placed in simulation canvas
      expect(find.textContaining('배치된 가구 (1개)'), findsOneWidget);

      // Save simulation
      final saveBtn = find.byKey(const Key('save_simulation_button'));
      expect(saveBtn, findsOneWidget);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Check success notification / dialog with club deal info
      expect(find.textContaining('클럽딜 연결 혜택'), findsOneWidget);
    });

    testWidgets('handles error state gracefully on load failure', (WidgetTester tester) async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 500);
      });

      final service = AtelierService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: AtelierScreen(atelierService: service),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.textContaining('평면도를 불러올 수 없습니다'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
