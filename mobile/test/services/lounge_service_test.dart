import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aratel_mobile/services/lounge_service.dart';
import 'package:aratel_mobile/models/lounge_models.dart';

void main() {
  group('LoungeService Tests', () {
    test('getPosts returns LoungePostListResponse on 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/v1/lounge/posts');
        expect(request.method, 'GET');
        return http.Response(
          jsonEncode({
            'posts': [
              {
                'id': 'post_7001',
                'anonymous_nickname': '은밀한 자산가 42',
                'verified_badge': 'VERIFIED_OWNER',
                'tier': 'DIAMOND',
                'complex_name': '디에이치 방배',
                'title': '2026 하반기 종합소득세 및 증여 절세 노하우',
                'content_encrypted': 'EncryptedBodyPayload...',
                'is_diamond_weighted': true,
                'trust_score': 98,
                'created_at': '2026-08-13T01:50:00Z'
              }
            ]
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = LoungeService(client: mockClient);
      final response = await service.getPosts();

      expect(response.posts.length, 1);
      expect(response.posts.first.title, contains('종합소득세'));
    });

    test('getPosts throws Exception on HTTP error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Error', 500);
      });

      final service = LoungeService(client: mockClient);
      expect(() => service.getPosts(), throwsException);
    });

    test('createPost returns CreatePostResponse on 201', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/v1/lounge/posts');
        expect(request.method, 'POST');
        final body = jsonDecode(request.body);
        expect(body['title'], '제목');
        expect(body['content'], '내용');

        return http.Response(
          jsonEncode({
            'id': 'post_7002',
            'clean_signal_verified': true,
            'earned_points': 50,
            'status': 'PUBLISHED',
          }),
          201,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = LoungeService(client: mockClient);
      final response = await service.createPost(
        const CreatePostRequest(title: '제목', content: '내용'),
      );

      expect(response.id, 'post_7002');
      expect(response.cleanSignalVerified, isTrue);
      expect(response.earnedPoints, 50);
    });

    test('createPost throws Exception on error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Bad Request', 400);
      });

      final service = LoungeService(client: mockClient);
      expect(
        () => service.createPost(const CreatePostRequest(title: '제목', content: '내용')),
        throwsException,
      );
    });
  });
}
