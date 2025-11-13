import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:amicana_app/core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final firebase.FirebaseAuth _firebaseAuth = firebase.FirebaseAuth.instance;

  User _userFromFirebase(firebase.User fbUser) {
    final name = fbUser.displayName ?? fbUser.email!.split('@').first;
    final capitalizedName =
        name.substring(0, 1).toUpperCase() + name.substring(1);

    if (fbUser.email == 'admin@amicana.com') {
      return User(
        id: fbUser.uid,
        name: capitalizedName,
        email: fbUser.email!,
        roles: ['superusuario', 'usuario_normal'],
      );
    }
    return User(
      id: fbUser.uid,
      name: capitalizedName,
      email: fbUser.email!,
      roles: ['usuario_normal'],
    );
  }

  Future<User> login({required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user == null) {
        throw Exception('No se encontró el usuario.');
      }
      return _userFromFirebase(credential.user!);
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Ocurrió un error desconocido.');
    }
  }

  Future<User> register(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser == null) {
        throw Exception('No se pudo completar el registro.');
      }
      return _userFromFirebase(updatedUser);
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Ocurrió un error desconocido.');
    }
  }

  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Inicio de sesión con Google cancelado.');
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = firebase.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      if (userCredential.user == null) {
        throw Exception('No se pudo iniciar sesión con Google.');
      }
      return _userFromFirebase(userCredential.user!);
    } catch (e) {
      throw Exception('Error al iniciar sesión con Google: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> saveSelectedRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_role', role);
  }
}
