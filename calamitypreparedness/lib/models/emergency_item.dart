class EmergencyItem {
  final String id;
  final String itemName;
  final String category;
  final int quantity;
  final bool isReady;
  final DateTime createdAt;
  final DateTime updatedAt;

  EmergencyItem({
    required this.id,
    required this.itemName,
    required this.category,
    required this.quantity,
    required this.isReady,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmergencyItem.fromJson(Map<String, dynamic> json) {
    return EmergencyItem(
      id: json['id'],
      itemName: json['item_name'],
      category: json['category'],
      quantity: json['quantity'] ?? 1,
      isReady: json['is_ready'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'category': category,
      'quantity': quantity,
      'is_ready': isReady,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  EmergencyItem copyWith({
    String? id,
    String? itemName,
    String? category,
    int? quantity,
    bool? isReady,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EmergencyItem(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      isReady: isReady ?? this.isReady,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
