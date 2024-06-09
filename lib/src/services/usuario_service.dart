import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsuarioService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registrarUsuario({
    required String nome,
    required String email,
    required String senha,
    required int tipoUsuario,
    int? curso,
    int? semestre,
  }) async {
    try {
      // Cria o usuário com o Firebase Auth
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Salva os dados adicionais do usuário no Firestore
      await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
        'nome': nome,
        'email': email,
        'tipoUsuario': tipoUsuario,
        if (tipoUsuario == 2) 'curso': curso,
        if (tipoUsuario == 2) 'semestre': semestre,
      });
    } catch (e) {
      throw Exception('Erro ao registrar usuário: $e');
    }
  }

  Future<DocumentSnapshot> getUsuarioAtual() async {
    final User? user = _firebaseAuth.currentUser;
    final String email = user?.email ?? '';

    final QuerySnapshot querySnapshot = await _firestore
        .collection('usuarios')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      throw Exception('Usuário não encontrado');
    }
  }
}
