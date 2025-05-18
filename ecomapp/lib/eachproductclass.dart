// lib/eachproductclass.dart

class eachProduct {
  // We no longer rely on json['id'] at the top level.
  // Instead, we'll capture productId from detail.product when grouping.
  String? name;
  String? describtion;
  bool? isDigital;
  String? brandName;
  String? categoryName;
  String? baseCategoryName;
  String? image;
  bool? addedToCart;
  List<ProductDetail>? productDetail;

  eachProduct({
    this.name,
    this.describtion,
    this.isDigital,
    this.brandName,
    this.categoryName,
    this.baseCategoryName,
    this.image,
    this.addedToCart,
    this.productDetail,
  });

  eachProduct.fromJson(Map<String, dynamic> json) {
    name             = json['name'] as String?;
    describtion      = json['describtion'] as String?;
    isDigital        = json['is_digital'] as bool?;
    brandName        = json['brand_name'] as String?;
    categoryName     = json['category_name'] as String?;
    baseCategoryName = json['base_category_name'] as String?;
    image            = json['image'] as String?;
    addedToCart      = json['added_to_cart'] as bool?;

    if (json['product_detail'] != null) {
      productDetail = <ProductDetail>[];
      for (var v in json['product_detail'] as List<dynamic>) {
        productDetail!.add(ProductDetail.fromJson(v as Map<String, dynamic>));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name']               = name;
    data['describtion']        = describtion;
    data['is_digital']         = isDigital;
    data['brand_name']         = brandName;
    data['category_name']      = categoryName;
    data['base_category_name'] = baseCategoryName;
    data['image']              = image;
    data['added_to_cart']      = addedToCart;
    if (productDetail != null) {
      data['product_detail'] = productDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductDetail {
  int? id;
  String? price;
  int? stockQuantity;
  String? sku;
  bool? isActive;
  int? product; // THIS is the product’s PK

  ProductDetail({
    this.id,
    this.price,
    this.stockQuantity,
    this.sku,
    this.isActive,
    this.product,
  });

  ProductDetail.fromJson(Map<String, dynamic> json) {
    id            = json['id'] as int?;
    price         = json['price'] as String?;
    stockQuantity = json['stock_quantity'] as int?;
    sku           = json['sku'] as String?;
    isActive      = json['is_active'] as bool?;
    product       = json['product'] as int?; // the product PK
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id']             = id;
    data['price']          = price;
    data['stock_quantity'] = stockQuantity;
    data['sku']            = sku;
    data['is_active']      = isActive;
    data['product']        = product;
    return data;
  }
}
