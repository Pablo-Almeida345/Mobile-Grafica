import '../models/user_models.dart';
import '../repositories/user_repository.dart';

class AuthService {
  final UserRepository _userRepository = UserRepository();

  // Regra de Cadastro
  Future<String> register({
    required String name,
    required String email,
    required String cpf,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      return 'As senhas não conferem.';
    }

    var newUser = UserModel(
      name: name,
      email: email,
      cpf: cpf,
      password: password,
    );

    bool saved = await _userRepository.saveUser(newUser);
    if (!saved) {
      return 'Este e-mail já está cadastrado.';
    }

    return 'Sucesso';
  }

  // Regra de Login
  Future<bool> login(String email, String password) async {
    var user = await _userRepository.findByEmail(email);

    if (user != null && user.password == password) {
      return true; // Login autorizado
    }
    return false; // Credenciais incorretas
  }
}