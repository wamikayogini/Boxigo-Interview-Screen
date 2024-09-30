// lib/models.dart
import 'dart:convert';


class Item {
  final String? size;
  final List<dynamic> childItems; // Assuming childItems can be of any type
  final List<String> typeOptions; // Changed to List for better handling
  final Meta meta;
  final int uniqueId;
  final String name;
  final String displayName;
  final int order;
  final String nameOld;
  final int qty;

  Item({
    required this.size,
    required this.childItems,
    required this.typeOptions,
    required this.meta,
    required this.uniqueId,
    required this.name,
    required this.displayName,
    required this.order,
    required this.nameOld,
    required this.qty,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      size: json['size'],
      childItems: json['childItems'] ?? [],
      typeOptions: (json['typeOptions'] as String).split(', '),
      meta: Meta.fromJson(json['meta']),
      uniqueId: json['uniquieId'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['displayName'] ?? '',
      order: json['order'] ?? 0,
      nameOld: json['name_old'] ?? '',
      qty: json['qty'] ?? 0,
    );
  }
}

// Define Meta Class
class Meta {
  final bool hasType;
  final String selectType;
  final bool hasVariation;
  final bool hasSize;

  Meta({
    required this.hasType,
    required this.selectType,
    required this.hasVariation,
    required this.hasSize,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      hasType: json['hasType'] ?? false,
      selectType: json['selectType'] ?? '',
      hasVariation: json['hasVariation'] ?? false,
      hasSize: json['hasSize'] ?? false,
    );
  }
}

// Define Category Class
class Category {
  final String id;
  final int order;
  final String name;
  final String displayName;
  final List<Item> items;

  Category({
    required this.id,
    required this.order,
    required this.name,
    required this.displayName,
    required this.items,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      order: json['order'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['displayName'] ?? '',
      items: (json['items'] as List)
          .map((item) => Item.fromJson(item))
          .toList(),
    );
  }
}

// Define Inventory Class
class Inventory {
  final String id;
  final int order;
  final String name;
  final String displayName;
  final List<Category> categories;

  Inventory({
    required this.id,
    required this.order,
    required this.name,
    required this.displayName,
    required this.categories,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'] ?? '',
      order: json['order'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['displayName'] ?? '',
      categories: (json['category'] as List)
          .map((cat) => Category.fromJson(cat))
          .toList(),
    );
  }
}
