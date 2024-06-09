import 'package:cloud_firestore/cloud_firestore.dart';

class CursoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> salvarCurso({
    required String idCurso,
    required String nome,
    required int quantidadeSemestre,
    required bool edicao,
  }) async {
    if (edicao) {
      // Editar curso existente
      await _firestore.collection('cursos').doc(idCurso).update({
        'descricao': nome,
        'quantidadeSemestre': quantidadeSemestre,
      });
    } else {
      int proximoId = await _proximoId();
      // Adicionar novo curso
      await _firestore.collection('cursos')
        .doc(proximoId.toString()).set({
          'descricao': nome,
          'quantidadeSemestre': quantidadeSemestre,
        });
    }
  }

  Future<int> _proximoId() async {
    QuerySnapshot snapshot = await _firestore
        .collection('cursos')
        .orderBy(FieldPath.documentId)
        .get();

    int proximoId = 1;
    if (snapshot.docs.isNotEmpty) {
      proximoId = int.parse(snapshot.docs.last.id) + 1;
    }
    return proximoId;
  }
}
