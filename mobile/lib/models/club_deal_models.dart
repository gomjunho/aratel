class ClubDeal {
  final String id;
  final String brand;
  final String itemName;
  final int originalPrice;
  final int dealPrice;
  final int pointDiscountLimit;
  final int minParticipants;
  final int currentParticipants;
  final String status;

  const ClubDeal({
    required this.id,
    required this.brand,
    required this.itemName,
    required this.originalPrice,
    required this.dealPrice,
    required this.pointDiscountLimit,
    required this.minParticipants,
    required this.currentParticipants,
    required this.status,
  });

  factory ClubDeal.fromJson(Map<String, dynamic> json) {
    return ClubDeal(
      id: json['id'] as String,
      brand: json['brand'] as String,
      itemName: json['item_name'] as String,
      originalPrice: json['original_price'] as int? ?? 0,
      dealPrice: json['deal_price'] as int? ?? 0,
      pointDiscountLimit: json['point_discount_limit'] as int? ?? 0,
      minParticipants: json['min_participants'] as int? ?? 0,
      currentParticipants: json['current_participants'] as int? ?? 0,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'brand': brand,
        'item_name': itemName,
        'original_price': originalPrice,
        'deal_price': dealPrice,
        'point_discount_limit': pointDiscountLimit,
        'min_participants': minParticipants,
        'current_participants': currentParticipants,
        'status': status,
      };
}

class ClubDealListResponse {
  final List<ClubDeal> clubDeals;

  const ClubDealListResponse({required this.clubDeals});

  factory ClubDealListResponse.fromJson(Map<String, dynamic> json) {
    return ClubDealListResponse(
      clubDeals: (json['club_deals'] as List<dynamic>)
          .map((d) => ClubDeal.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'club_deals': clubDeals.map((d) => d.toJson()).toList(),
      };
}

class ClubDealOrderRequest {
  final int usedPoints;
  final int cashAmount;

  const ClubDealOrderRequest({
    required this.usedPoints,
    required this.cashAmount,
  });

  factory ClubDealOrderRequest.fromJson(Map<String, dynamic> json) {
    return ClubDealOrderRequest(
      usedPoints: json['used_points'] as int? ?? 0,
      cashAmount: json['cash_amount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'used_points': usedPoints,
        'cash_amount': cashAmount,
      };
}

class ClubDealOrderResponse {
  final String orderId;
  final String status;
  final int remainingPoints;

  const ClubDealOrderResponse({
    required this.orderId,
    required this.status,
    required this.remainingPoints,
  });

  factory ClubDealOrderResponse.fromJson(Map<String, dynamic> json) {
    return ClubDealOrderResponse(
      orderId: json['order_id'] as String,
      status: json['status'] as String,
      remainingPoints: json['remaining_points'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'status': status,
        'remaining_points': remainingPoints,
      };
}
