class User {
  final int? id;
  final String username;
  final String password;
  final String name;
  final String phoneNumber;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.phoneNumber,
  });

  // Método copyWith para crear una copia del objeto con algunos campos modificados
  User copyWith({
    int? id,
    String? username,
    String? password,
    String? name,
    String? phoneNumber,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}