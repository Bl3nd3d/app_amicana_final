import 'package:amicana_app/core/api/api_client.dart';
import 'package:amicana_app/core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // NO es necesario un ApiClient para esta simulación mejorada.
  // final ApiClient _apiClient = ApiClient();

  // --- NUESTRA BASE DE DATOS EN MEMORIA ---
  // Un mapa estático para que no se pierda entre instancias de la clase.
  // Guardaremos los usuarios usando su email como clave.
  static final Map<String, Map<String, dynamic>> _users = {
    // Precargamos el usuario administrador
    'admin@amicana.com': {
      'id': '1',
      'name': 'Admin User',
      'password': 'admin123', // Guardamos la contraseña para verificarla
      'roles': ['superusuario', 'usuario_normal'],
    }
  };

  Future<void> saveSelectedRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_role', role);
    print('Rol guardado: $role');
  }

  // --- MÉTODO DE LOGIN MEJORADO ---
  Future<User> login({required String email, required String password}) async {
    print(
        'Verificando credenciales para $email en la base de datos en memoria...');
    await Future.delayed(const Duration(seconds: 1));

    // Busca al usuario por su email en nuestro mapa.
    if (_users.containsKey(email)) {
      final userData = _users[email]!;
      // Si el usuario existe, verifica que la contraseña coincida.
      if (userData['password'] == password) {
        final user = User(
          id: userData['id'],
          name: userData['name'],
          email: email,
          roles: List<String>.from(userData['roles']),
        );
        await _saveToken('un_token_jwt_simulado_para_${user.name}');
        return user;
      }
    }
    // Si el usuario no existe o la contraseña es incorrecta, lanza un error.
    throw Exception('Credenciales incorrectas');
  }

  // --- MÉTODO DE REGISTRO MEJORADO ---
  Future<void> register(
      {required String name,
      required String email,
      required String password}) async {
    print('Registrando a $name en la base de datos en memoria...');
    await Future.delayed(const Duration(seconds: 1));

    // Verifica si el email ya existe en nuestro mapa.
    if (_users.containsKey(email)) {
      throw Exception('Este correo ya está registrado.');
    }

    // Si no existe, añade el nuevo usuario al mapa.
    _users[email] = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(), // ID único
      'name': name,
      'password': password,
      'roles': ['usuario_normal'], // Por defecto, todos son usuarios normales
    };

    print('Usuario registrado con éxito. Base de datos actual: $_users');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
