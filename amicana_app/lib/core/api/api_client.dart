import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio _dio;

  // URL base de tu API. Debería estar en un archivo de configuración,
  // pero por ahora la ponemos aquí.
  static const String _baseUrl = 'https://tu-api.amicana.com/api/v1';

  ApiClient() : _dio = Dio(BaseOptions(baseUrl: _baseUrl)) {
    // Añadimos un interceptor para manejar la lógica de forma automática.
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Antes de cada petición, busca un token de autenticación.
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');

          if (token != null) {
            // Si hay un token, lo añade a las cabeceras.
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options); // Continúa con la petición.
        },
        onError: (DioException e, handler) {
          // Puedes manejar errores de forma centralizada aquí.
          // Por ejemplo, si el error es 401 (No autorizado), podrías
          // redirigir al login.
          // TODO: Implementar logger apropiado (ej: logger package)
          // print('ERROR EN PETICIÓN: ${e.message}');
          return handler.next(e); // Continúa con el error.
        },
      ),
    );
  }

  // Métodos genéricos para peticiones GET y POST
  Future<Response> get(String path) async {
    return await _dio.get(path);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }
}
