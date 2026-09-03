import '../models/user_models.dart';

class UserRepository {
  // Banco de dados simulado em memória (uma lista temporária)
  static final List<UserModel> _fakeDatabase = [];

  // Salva o usuário na lista
  Future<bool> saveUser(UserModel user) async {
    // Verifica se o e-mail já existe
    bool exists = _fakeDatabase.any((u) => u.email == user.email);
    if (exists) return false;

    _fakeDatabase.add(user);
    return true;
  }

  // Busca o usuário pelo e-mail (usado no login)
  Future<UserModel?> findByEmail(String email) async {
    try {
      return _fakeDatabase.firstWhere((u) => u.email == email);
    } catch (e) {
      return null; // Retorna nulo se não encontrar
    }
  }
}