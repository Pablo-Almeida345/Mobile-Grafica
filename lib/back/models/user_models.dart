class UserModel {
  final String name;
  final String email;
  final String cpf;
  final String password;

  UserModel({
    required this.name,
    required this.email,
    required this.cpf,
    required this.password,
  });

  // Converte os dados do usuário em JSON para transitar na API
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'cpf': cpf,
      'password': password,
    };
  }

  // Cria um UserModel a partir de um Map de dados
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      cpf: map['cpf'] ?? '',
      password: map['password'] ?? '',
    );
  }
}