import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noticv/src/models/tipo_usuario.dart';

class TipoUsuarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TipoUsuario>> fetchTiposUsuario() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('tipoUsuario').get();
      return snapshot.docs.map((doc) => TipoUsuario.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar os tipos de usuário: $e');
    }
  }
}
