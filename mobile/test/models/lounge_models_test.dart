import 'package:flutter_test/flutter_test.dart';
import 'package:aratel_mobile/models/lounge_models.dart';

void main() {
  group('Lounge Models Tests', () {
    test('LoungePost.fromJson and toJson', () {
      final json = {
        'id': 'post_7001',
        'anonymous_nickname': '은밀한 자산가 42',
        'verified_badge': 'VERIFIED_OWNER',
        'tier': 'DIAMOND',
        'complex_name': '디에이치 방배',
        'title': '2026 하반기 종합소득세 및 증여 절세 노하우',
        'content_encrypted': 'EncryptedBodyPayload...',
        'is_diamond_weighted': true,
        'trust_score': 98,
        'created_at': '2026-08-13T01:50:00Z',
      };

      final post = LoungePost.fromJson(json);

      expect(post.id, 'post_7001');
      expect(post.anonymousNickname, '은밀한 자산가 42');
      expect(post.verifiedBadge, 'VERIFIED_OWNER');
      expect(post.tier, 'DIAMOND');
      expect(post.complexName, '디에이치 방배');
      expect(post.title, '2026 하반기 종합소득세 및 증여 절세 노하우');
      expect(post.contentEncrypted, 'EncryptedBodyPayload...');
      expect(post.isDiamondWeighted, isTrue);
      expect(post.trustScore, 98);
      expect(post.createdAt, '2026-08-13T01:50:00Z');

      final serialized = post.toJson();
      expect(serialized['id'], 'post_7001');
      expect(serialized['anonymous_nickname'], '은밀한 자산가 42');
      expect(serialized['is_diamond_weighted'], isTrue);
    });

    test('LoungePostListResponse.fromJson and toJson', () {
      final json = {
        'posts': [
          {
            'id': 'post_7001',
            'anonymous_nickname': '은밀한 자산가 42',
            'verified_badge': 'VERIFIED_OWNER',
            'tier': 'DIAMOND',
            'complex_name': '디에이치 방배',
            'title': '절세 노하우',
            'content_encrypted': 'EncryptedBodyPayload...',
            'is_diamond_weighted': true,
            'trust_score': 98,
            'created_at': '2026-08-13T01:50:00Z',
          }
        ]
      };

      final res = LoungePostListResponse.fromJson(json);
      expect(res.posts.length, 1);
      expect(res.posts.first.id, 'post_7001');
      expect(res.toJson()['posts'], isA<List>());
    });

    test('CreatePostRequest and CreatePostResponse', () {
      const req = CreatePostRequest(
        title: '단지 내 스카이라운지 조식 이용 관련 제안',
        content: '조식 시간대를 10시까지 연장하는 건에 대해 논의해봅시다.',
      );
      final reqJson = req.toJson();
      expect(reqJson['title'], '단지 내 스카이라운지 조식 이용 관련 제안');
      expect(reqJson['content'], '조식 시간대를 10시까지 연장하는 건에 대해 논의해봅시다.');

      final reqFrom = CreatePostRequest.fromJson(reqJson);
      expect(reqFrom.title, req.title);

      final resJson = {
        'id': 'post_7002',
        'clean_signal_verified': true,
        'earned_points': 50,
        'status': 'PUBLISHED',
      };
      final res = CreatePostResponse.fromJson(resJson);
      expect(res.id, 'post_7002');
      expect(res.cleanSignalVerified, isTrue);
      expect(res.earnedPoints, 50);
      expect(res.status, 'PUBLISHED');
      expect(res.toJson()['id'], 'post_7002');
    });
  });
}
