import 'dart:convert';

import 'package:flutter/foundation.dart' hide Category;

import 'category.dart';

class Product {
  final int id;
  final String title;
  final String slug;
  final int price;
  final String description;
  final Category category;
  final List<String> images;
  final String creationAt;
  final String updatedAt;
  Product({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
    required this.creationAt,
    required this.updatedAt,
  });

  Product copyWith({
    int? id,
    String? title,
    String? slug,
    int? price,
    String? description,
    Category? category,
    List<String>? images,
    String? creationAt,
    String? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      images: images ?? this.images,
      creationAt: creationAt ?? this.creationAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'slug': slug,
      'price': price,
      'description': description,
      'category': category.toMap(),
      'images': images,
      'creationAt': creationAt,
      'updatedAt': updatedAt,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'].toInt() as int,
      title: map['title'] as String,
      slug: map['slug'] as String,
      price: map['price'].toInt() as int,
      description: map['description'] as String,
      category: Category.fromMap(map['category'] as Map<String, dynamic>),
      images: List<String>.from(
        (map['images'] as List<String>),
      ),
      creationAt: map['creationAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, title: $title, slug: $slug, price: $price, description: $description, category: $category, images: $images, creationAt: $creationAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.slug == slug &&
        other.price == price &&
        other.description == description &&
        other.category == category &&
        listEquals(other.images, images) &&
        other.creationAt == creationAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        slug.hashCode ^
        price.hashCode ^
        description.hashCode ^
        category.hashCode ^
        images.hashCode ^
        creationAt.hashCode ^
        updatedAt.hashCode;
  }
}
