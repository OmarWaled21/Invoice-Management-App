class ItemsModel {
  final int id;
  String? name;
  String? description;
  int? quantity;
  String? unite;
  double? price;
  int? tva;
  double? totalPrice;
  double? discount;

  ItemsModel({
    required this.id,
    this.name,
    this.description,
    this.quantity,
    this.unite,
    this.price,
    this.tva,
    this.totalPrice,
    this.discount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'unite': unite,
      'price': price,
      'tva': tva,
      'totalPrice': totalPrice,
      'discount': discount,
    };
  }

  factory ItemsModel.fromJson(Map<String, dynamic> json) {
    return ItemsModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      quantity: json['quantity'] ?? 1,
      unite: json['unite'] ?? '',
      price: json['price'] ?? 0.0,
      totalPrice: json['totalPrice'] ?? 0.0,
      discount: json['discount'] ?? 0.0,
      tva: json['tva'] ?? 0,
    );
  }
}
