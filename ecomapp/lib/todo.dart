import 'package:flutter/material.dart';

class Todo {
  int id;
  String price;
  int stock_quantity;
  String sku;
  bool is_active;
  int product;
  Todo({
    required this.id,
    required this.price,
    required this.stock_quantity,
    required this.sku,
    required this.is_active,
    required this.product,
  });
}

class Brand {
  int id;
  String name;
  Brand({required this.id, required this.name});
}

class Category {
  int id;
  String name;
  int lft;
  int rght;
  int tree_id;
  int level;
  int? parent;
  Category({
    required this.id,
    required this.name,
    required this.lft,
    required this.rght,
    required this.tree_id,
    required this.level,
    required this.parent,
  });
}
