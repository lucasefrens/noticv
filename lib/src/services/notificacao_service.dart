import 'package:cloud_firestore/cloud_firestore.dart';

class NotificacaoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> fetchNotificacoesParaAluno(int curso, int semestre) {
    return _firestore
        .collection('notificacoes')
        .where('curso', isEqualTo: curso)
        .where('semestre', isEqualTo: semestre)
        .orderBy('criadoEm', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> fetchNotificacoesParaProfessorOuCoordenador(String email) {
    return _firestore
        .collection('notificacoes')
        .where('criadoPor', isEqualTo: email)
        .orderBy('criadoEm', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> fetchTodasNotificacoes() {
    return _firestore
        .collection('notificacoes')
        .orderBy('criadoEm', descending: true)
        .snapshots();
  }
}
