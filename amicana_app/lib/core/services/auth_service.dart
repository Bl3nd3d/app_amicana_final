import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:amicana_app/core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final firebase.FirebaseAuth _firebaseAuth = firebase.FirebaseAuth.instance;

  // Convierte un usuario de Firebase a nuestro modelo de User
  User _userFromFirebase(firebase.User fbUser) {
    return User(
      id: fbUser.uid,
      name: fbUser.displayName ?? 'No Name',
      email: fbUser.email ?? 'No Email',
      roles: ['usuario_normal'],
    );
  }

  Future<User> login({required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw Exception('No se pudo iniciar sesión.');
      }
      if (email == 'admin@amicana.com') {
        final user = _userFromFirebase(credential.user!);
        return User(
            id: user.id,
            name: user.name,
            email: user.email,
            roles: ['superusuario', 'usuario_normal']);
      }
      return _userFromFirebase(credential.user!);
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        throw Exception('Correo o contraseña incorrectos.');
      } else {
        throw Exception('Ocurrió un error: ${e.message}');
      }
    }
  }

  Future<User> register(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
      final updatedUser = _firebaseAuth.currentUser;

      if (updatedUser == null) {
        throw Exception('No se pudo completar el registro.');
      }
      return _userFromFirebase(updatedUser);
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('La contraseña es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('El correo electrónico ya está en uso.');
      } else {
        throw Exception('Ocurrió un error: ${e.message}');
      }
    }
  }

  // --- MÉTODO AÑADIDO PARA LOGIN CON GOOGLE ---
  Future<User> signInWithGoogle() async {
    try {
      // Inicia el flujo de inicio de sesión de Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // El usuario canceló el proceso
        throw Exception('Inicio de sesión con Google cancelado.');
      }
      // Obtiene los detalles de autenticación de la petición
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // Crea una credencial de Firebase
      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Inicia sesión en Firebase con la credencial de Google
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      if (userCredential.user == null) {
        throw Exception('No se pudo iniciar sesión con Google.');
      }
      return _userFromFirebase(userCredential.user!);
    } catch (e) {
      // Re-lanza la excepción para que el BLoC pueda manejarla
      throw Exception('Error al iniciar sesión con Google: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    // También cerramos sesión de Google por si acaso
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> saveSelectedRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_role', role);
  }

  Future<String?> getSelectedRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_role');
  }
}
