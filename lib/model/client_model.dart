class Client {
  int? id;
  String name;
  String address;
  String phone;
  String email;

  Client({
    this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toMap() =>
      {
        'id': id,
        'name': name,
        'address': address,
        'phone': phone,
        'email': email
      };

  factory Client.fromMap(Map<String, dynamic> json) =>
      Client(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        phone: json['phone'],
        email: json['email'],
      );
}
