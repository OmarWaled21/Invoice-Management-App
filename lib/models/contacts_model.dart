class ContactsModel {
  int id;
  final String name;
  final String address;
  final String? address2;
  final String? city;
  final int? postalCode;
  final String? tvaNumber;
  final String? email;
  final int? phone;
  final String? note;
  final String clientType;
  final String country;

  ContactsModel({
    required this.id,
    required this.name,
    required this.address,
    this.address2,
    this.city,
    this.postalCode,
    this.tvaNumber,
    this.email,
    this.phone,
    this.note,
    required this.clientType,
    required this.country,
  });

  // Convert a ContactsModel to a Map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'address2': address2,
      'city': city,
      'postalCode': postalCode,
      'tvaNumber': tvaNumber,
      'email': email,
      'phone': phone,
      'note': note,
      'clientType': clientType,
      'country': country,
    };
  }

  // Convert a Map to a ContactsModel.
  factory ContactsModel.fromJson(Map<String, dynamic> json) {
    return ContactsModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      address2: json['address2'],
      city: json['city'],
      postalCode: json['postalCode'],
      tvaNumber: json['tvaNumber'],
      email: json['email'],
      phone: json['phone'],
      note: json['note'],
      clientType: json['clientType'],
      country: json['country'],
    );
  }
}
