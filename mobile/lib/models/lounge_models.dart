class LoungePost {
  final String id;
  final String anonymousNickname;
  final String verifiedBadge;
  final String tier;
  final String complexName;
  final String title;
  final String contentEncrypted;
  final bool isDiamondWeighted;
  final int trustScore;
  final String createdAt;

  const LoungePost({
    required this.id,
    required this.anonymousNickname,
    required this.verifiedBadge,
    required this.tier,
    required this.complexName,
    required this.title,
    required this.contentEncrypted,
    required this.isDiamondWeighted,
    required this.trustScore,
    required this.createdAt,
  });

  factory LoungePost.fromJson(Map<String, dynamic> json) {
    return LoungePost(
      id: json['id'] as String,
      anonymousNickname: json['anonymous_nickname'] as String,
      verifiedBadge: json['verified_badge'] as String,
      tier: json['tier'] as String,
      complexName: json['complex_name'] as String,
      title: json['title'] as String,
      contentEncrypted: json['content_encrypted'] as String,
      isDiamondWeighted: json['is_diamond_weighted'] as bool? ?? false,
      trustScore: json['trust_score'] as int? ?? 0,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'anonymous_nickname': anonymousNickname,
        'verified_badge': verifiedBadge,
        'tier': tier,
        'complex_name': complexName,
        'title': title,
        'content_encrypted': contentEncrypted,
        'is_diamond_weighted': isDiamondWeighted,
        'trust_score': trustScore,
        'created_at': createdAt,
      };
}

class LoungePostListResponse {
  final List<LoungePost> posts;

  const LoungePostListResponse({required this.posts});

  factory LoungePostListResponse.fromJson(Map<String, dynamic> json) {
    return LoungePostListResponse(
      posts: (json['posts'] as List<dynamic>)
          .map((item) => LoungePost.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'posts': posts.map((p) => p.toJson()).toList(),
      };
}

class CreatePostRequest {
  final String title;
  final String content;

  const CreatePostRequest({
    required this.title,
    required this.content,
  });

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) {
    return CreatePostRequest(
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
      };
}

class CreatePostResponse {
  final String id;
  final bool cleanSignalVerified;
  final int earnedPoints;
  final String status;

  const CreatePostResponse({
    required this.id,
    required this.cleanSignalVerified,
    required this.earnedPoints,
    required this.status,
  });

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) {
    return CreatePostResponse(
      id: json['id'] as String,
      cleanSignalVerified: json['clean_signal_verified'] as bool? ?? false,
      earnedPoints: json['earned_points'] as int? ?? 0,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'clean_signal_verified': cleanSignalVerified,
        'earned_points': earnedPoints,
        'status': status,
      };
}
