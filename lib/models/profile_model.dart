class ProfileModel {
  final String name;
  final String address;
  final String? address2;
  final String? city;
  final String? postalCode;
  final String? tvaNumber;
  final String? email;
  final String? phone;
  final String country;
  final String? siret;
  String? image;
  String? iban;
  String? swift;

  ProfileModel({
    required this.name,
    required this.address,
    this.address2,
    this.siret,
    this.city,
    this.postalCode,
    this.tvaNumber,
    this.email,
    this.phone,
    required this.country,
    this.image,
    this.iban,
    this.swift,
  });

  // Convert a ProfileModel to a Map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'address2': address2,
      'city': city,
      'postalCode': postalCode,
      'tvaNumber': tvaNumber,
      'email': email,
      'phone': phone,
      'country': country,
      'image': image,
      'siret': siret,
      'iban': iban,
      'swift': swift,
    };
  }

  // Convert a Map to a ProfileModel.
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'],
      address: json['address'],
      address2: json['address2'],
      city: json['city'],
      postalCode: json['postalCode'],
      tvaNumber: json['tvaNumber'],
      email: json['email'],
      phone: json['phone'],
      country: json['country'],
      image: json['image'],
      siret: json['siret'],
      iban: json['iban'],
      swift: json['swift'],
    );
  }

  // Add the copyWith method
  ProfileModel copyWith({
    String? name,
    String? address,
    String? address2,
    String? city,
    String? postalCode,
    String? tvaNumber,
    String? email,
    String? phone,
    String? country,
    String? siret,
    String? image,
    String? iban,
    String? swift,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      address: address ?? this.address,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      tvaNumber: tvaNumber ?? this.tvaNumber,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      siret: siret ?? this.siret,
      image: image ?? this.image,
      iban: iban ?? this.iban,
      swift: swift ?? this.swift,
    );
  }
}
