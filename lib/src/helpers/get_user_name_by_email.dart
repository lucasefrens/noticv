import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getUserNameByEmail(String email) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data();
      return userData['nome']; // Supondo que o campo de nome seja 'nome'
    } else {
      return null; // Retorna null se o usuário não for encontrado
    }
  } catch (e) {
    print('Erro ao buscar nome do usuário: $e');
    return null;
  }
}
