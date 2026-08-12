class FurnitureItem {
  final String id;
  final String brand;
  final String name;
  final String model3dUrl;
  final int price;
  final int stock;

  const FurnitureItem({
    required this.id,
    required this.brand,
    required this.name,
    required this.model3dUrl,
    required this.price,
    required this.stock,
  });

  factory FurnitureItem.fromJson(Map<String, dynamic> json) {
    return FurnitureItem(
      id: json['id'] as String,
      brand: json['brand'] as String,
      name: json['name'] as String,
      model3dUrl: json['model_3d_url'] as String,
      price: json['price'] as int? ?? 0,
      stock: json['stock'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'brand': brand,
        'name': name,
        'model_3d_url': model3dUrl,
        'price': price,
        'stock': stock,
      };
}

class FlatMapResponse {
  final String flatMapUrl;
  final List<FurnitureItem> furnitureCatalog;

  const FlatMapResponse({
    required this.flatMapUrl,
    required this.furnitureCatalog,
  });

  factory FlatMapResponse.fromJson(Map<String, dynamic> json) {
    return FlatMapResponse(
      flatMapUrl: json['flat_map_url'] as String,
      furnitureCatalog: (json['furniture_catalog'] as List<dynamic>)
          .map((f) => FurnitureItem.fromJson(f as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'flat_map_url': flatMapUrl,
        'furniture_catalog': furnitureCatalog.map((f) => f.toJson()).toList(),
      };
}

class PlacementItem {
  final String furnitureId;
  final List<num> position;
  final List<num> rotation;

  const PlacementItem({
    required this.furnitureId,
    required this.position,
    required this.rotation,
  });

  factory PlacementItem.fromJson(Map<String, dynamic> json) {
    return PlacementItem(
      furnitureId: json['furniture_id'] as String,
      position: (json['position'] as List<dynamic>).map((e) => e as num).toList(),
      rotation: (json['rotation'] as List<dynamic>).map((e) => e as num).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'furniture_id': furnitureId,
        'position': position,
        'rotation': rotation,
      };
}

class SimulationRequest {
  final String flatMapId;
  final List<PlacementItem> placedItems;

  const SimulationRequest({
    required this.flatMapId,
    required this.placedItems,
  });

  factory SimulationRequest.fromJson(Map<String, dynamic> json) {
    return SimulationRequest(
      flatMapId: json['flat_map_id'] as String,
      placedItems: (json['placed_items'] as List<dynamic>)
          .map((i) => PlacementItem.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'flat_map_id': flatMapId,
        'placed_items': placedItems.map((i) => i.toJson()).toList(),
      };
}

class SimulationResponse {
  final String simulationId;
  final bool clubDealTriggered;
  final String? clubDealId;

  const SimulationResponse({
    required this.simulationId,
    required this.clubDealTriggered,
    this.clubDealId,
  });

  factory SimulationResponse.fromJson(Map<String, dynamic> json) {
    return SimulationResponse(
      simulationId: json['simulation_id'] as String,
      clubDealTriggered: json['club_deal_triggered'] as bool? ?? false,
      clubDealId: json['club_deal_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'simulation_id': simulationId,
        'club_deal_triggered': clubDealTriggered,
        if (clubDealId != null) 'club_deal_id': clubDealId,
      };
}
