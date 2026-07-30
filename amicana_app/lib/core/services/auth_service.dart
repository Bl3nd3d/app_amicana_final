import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:amicana_app/core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final firebase.FirebaseAuth _firebaseAuth = firebase.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User> _userFromFirebase(firebase.User fbUser) async {
    final userDoc = await _firestore.collection('users').doc(fbUser.uid).get();
    if (!userDoc.exists) {
      // This might happen if a user exists in Auth but not in Firestore.
      // We can create it here, or throw an error. For now, let's throw.
      throw Exception('El documento del usuario no existe en Firestore.');
    }
    return User.fromFirestore(userDoc);
  }

  Future<void> _createUserDocument(firebase.User user, String name) async {
    final userRef = _firestore.collection('users').doc(user.uid);
    // Verificar si el documento ya existe para no sobrescribir roles
    final doc = await userRef.get();
    if (!doc.exists) {
      await userRef.set({
        'displayName': name,
        'email': user.email,
        'roles': ['usuario'],
        'globalScore': 0,
        'categoryStats': {},
        'completedQuizzes': [],
        'completedChapterIds': [],
        'savedBookIds': [],
        'savedChapterIds': [],
        'savedQuizIds': [],
      });
    }
  }

  Future<User> login({required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user == null) {
        throw Exception('No se encontró el usuario.');
      }
      return await _userFromFirebase(credential.user!);
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
      
      final fbUser = credential.user;
      if (fbUser == null) {
        throw Exception('No se pudo completar el registro.');
      }

      await fbUser.updateDisplayName(name);
      await _createUserDocument(fbUser, name);
      await fbUser.reload();
      
      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser == null) {
        throw Exception('No se pudo recargar el usuario post-registro.');
      }

      return await _userFromFirebase(updatedUser);
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
      final fbUser = userCredential.user;

      if (fbUser == null) {
        throw Exception('No se pudo iniciar sesión con Google.');
      }

      // Si es un usuario nuevo, crea su documento en Firestore
      await _createUserDocument(fbUser, fbUser.displayName ?? googleUser.displayName ?? 'Sin Nombre');

      return await _userFromFirebase(fbUser);
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
