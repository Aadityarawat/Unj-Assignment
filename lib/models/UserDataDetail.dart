class User {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? company;
  final String? website;
  final String? latitude;
  final String? longitude;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.company,
    this.website,
    this.latitude,
    this.longitude,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      company: json['company']?['name'],
      website: json['website'],
      latitude: json['geo_location']?['latitude'],
      longitude: json['geo_location']?['longitude'],
    );
  }
}