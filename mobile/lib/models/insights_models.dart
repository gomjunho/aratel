class TransactionItem {
  final int floor;
  final int price;
  final String dealDate;

  const TransactionItem({
    required this.floor,
    required this.price,
    required this.dealDate,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      floor: json['floor'] as int? ?? 0,
      price: json['price'] as int? ?? 0,
      dealDate: json['deal_date'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'floor': floor,
        'price': price,
        'deal_date': dealDate,
      };
}

class SupplyGasIndex {
  final String riskLevel;
  final int upcomingSupplyUnits;
  final String analysisSummary;

  const SupplyGasIndex({
    required this.riskLevel,
    required this.upcomingSupplyUnits,
    required this.analysisSummary,
  });

  factory SupplyGasIndex.fromJson(Map<String, dynamic> json) {
    return SupplyGasIndex(
      riskLevel: json['risk_level'] as String,
      upcomingSupplyUnits: json['upcoming_supply_units'] as int? ?? 0,
      analysisSummary: json['analysis_summary'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'risk_level': riskLevel,
        'upcoming_supply_units': upcomingSupplyUnits,
        'analysis_summary': analysisSummary,
      };
}

class InsightsResponse {
  final String complexName;
  final List<TransactionItem> transactions;
  final SupplyGasIndex supplyGasIndex;

  const InsightsResponse({
    required this.complexName,
    required this.transactions,
    required this.supplyGasIndex,
  });

  factory InsightsResponse.fromJson(Map<String, dynamic> json) {
    return InsightsResponse(
      complexName: json['complex_name'] as String,
      transactions: (json['transactions'] as List<dynamic>)
          .map((t) => TransactionItem.fromJson(t as Map<String, dynamic>))
          .toList(),
      supplyGasIndex: SupplyGasIndex.fromJson(json['supply_gas_index'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'complex_name': complexName,
        'transactions': transactions.map((t) => t.toJson()).toList(),
        'supply_gas_index': supplyGasIndex.toJson(),
      };
}
