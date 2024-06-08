import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noticv/src/widgets/barra_navegacao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PaginaListaNotificacoes extends StatefulWidget {
  const PaginaListaNotificacoes({super.key});

  @override
  State<PaginaListaNotificacoes> createState() =>
      _PaginaListaNotificacoesState();
}

class _PaginaListaNotificacoesState extends State<PaginaListaNotificacoes> {
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _getUsuarioAtual(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('Usuário não encontrado no banco de dados');
        }

        final int tipoUsuario = snapshot.data!.get('tipoUsuario') as int;
        final String emailUsuario = snapshot.data!.get('email') as String;

        Stream<QuerySnapshot> notificacoesStream;

        if (tipoUsuario == 2) { // aluno
          final int cursoUsuario = snapshot.data!.get('curso') as int;
          final int semestreUsuario = snapshot.data!.get('semestre') as int;

          notificacoesStream = FirebaseFirestore.instance
              .collection('notificacoes')
              .where('curso', isEqualTo: cursoUsuario)
              .where('semestre', isEqualTo: semestreUsuario)
              .orderBy('criadoEm', descending: true)
              .snapshots();
        } else if (tipoUsuario == 1 || tipoUsuario == 0) { // professor ou coordenador
          notificacoesStream = FirebaseFirestore.instance
              .collection('notificacoes')
              .where('criadoPor', isEqualTo: emailUsuario)
              .orderBy('criadoEm', descending: true)
              .snapshots();
        } else {
          notificacoesStream = FirebaseFirestore.instance
              .collection('notificacoes')
              .orderBy('criadoEm', descending: true)
              .snapshots();
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          home: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              elevation: 0,
              centerTitle: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  const Text(
                    'Início',
                    style: TextStyle(
                      color: Color(0xFFDA983A),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: notificacoesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {                  
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Nenhuma notificação encontrada.'));
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    Timestamp timestamp = data['criadoEm'] as Timestamp;
                    String formattedDate = _dateFormat.format(timestamp.toDate());

                    return ListTile(
                      title: Text(data['titulo'] ?? 'Sem título'),
                      subtitle: Text(data['descricao'] ?? 'Sem descrição'),
                      trailing: Text(formattedDate),
                    );
                  }).toList(),
                );
              },
            ),
            bottomNavigationBar: BarraNavegacao(
              currentPage: 0,
              tipoUsuario: tipoUsuario,
            ),
          ),
        );
      },
    );
  }

  Future<DocumentSnapshot> _getUsuarioAtual() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? '';

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
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
