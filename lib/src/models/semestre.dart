import 'package:cloud_firestore/cloud_firestore.dart';

class Semestre {
  final int id;
  final String descricao;

  Semestre({
    required this.id,
    required this.descricao,
  });

  factory Semestre.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Semestre(
      id: int.parse(doc.id),
      descricao: data['descricao'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Semestre{id: $id, descricao: $descricao}';
  }
}
