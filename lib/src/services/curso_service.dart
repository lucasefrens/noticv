import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noticv/src/models/curso.dart';
import 'package:noticv/src/models/semestre.dart';

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

  Future<List<Curso>> fetchCursos() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('cursos').get();
      return snapshot.docs.map((doc) => Curso.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar os cursos: $e');
    }
  }

  Future<List<Semestre>> fetchSemestres(int idCurso) async {
    String id = idCurso.toString();
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('cursos').doc(id).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        if (data.containsKey('quantidadeSemestre')) {
          int quantidadeSemestre = data['quantidadeSemestre'];

          List<Semestre> semestres = [];
          for (int i = 1; i <= quantidadeSemestre; i++) {
            semestres.add(Semestre(id: i, descricao: '$iº Semestre'));
          }

          return semestres;
        } else {
          throw Exception(
              'Campo quantidadeSemestre não encontrado no documento do curso');
        }
      } else {
        throw Exception('Documento do curso não encontrado');
      }
    } catch (e) {
      throw Exception('Erro ao buscar os semestres: $e');
    }
  }
}
