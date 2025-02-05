class UserDataList {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;

  UserDataList({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory UserDataList.fromJson(Map<String, dynamic> json) {
    return UserDataList(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }
}
