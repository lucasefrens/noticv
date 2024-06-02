import 'package:cloud_firestore/cloud_firestore.dart';

class Curso {
  final int id;
  final String descricao;

  Curso({
    required this.id,
    required this.descricao,
  });

  factory Curso.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Curso(
      id: int.parse(doc.id),
      descricao: data['descricao'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Curso{id: $id, descricao: $descricao}';
  }
}
