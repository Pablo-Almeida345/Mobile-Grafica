import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:crud_mobile_grafica/back/services/auth_service.dart';

void main(List<String> args) async {
  final authService = AuthService();
  final router = Router();

  // Rota de Cadastro (POST)
  router.post('/api/register', (shelf.Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      String name = data['name'] ?? '';
      String email = data['email'] ?? '';
      String cpf = data['cpf'] ?? '';
      String password = data['password'] ?? '';
      String confirmPassword = data['confirmPassword'] ?? '';

      String result = await authService.register(
        name: name,
        email: email,
        cpf: cpf,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (result != 'Sucesso') {
        return shelf.Response.badRequest(
          body: jsonEncode({'error': result}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return shelf.Response.ok(
        jsonEncode({'message': 'Usuário cadastrado com sucesso!'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': 'Erro ao processar requisição: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // Rota de Login (POST)
  router.post('/api/login', (shelf.Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      String email = data['email'] ?? '';
      String password = data['password'] ?? '';

      bool success = await authService.login(email, password);

      if (!success) {
        return shelf.Response.forbidden(
          jsonEncode({'error': 'E-mail ou senha inválidos'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return shelf.Response.ok(
        jsonEncode({'message': 'Login realizado com sucesso!'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': 'Erro ao processar requisição: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // Configuração e inicialização do servidor
  final ip = InternetAddress.anyIPv4;
  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(router);

  const port = 8081;
  final server = await shelf_io.serve(handler, ip, port);
  print('Servidor rodando em http://localhost:${server.port}');
}