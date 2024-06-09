import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noticv/src/helpers/get_user_name_by_email.dart';
import 'package:noticv/src/services/notificacao_service.dart';
import 'package:noticv/src/services/usuario_service.dart';
import 'package:noticv/src/widgets/barra_navegacao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:noticv/src/widgets/notificacao.dart';

class PaginaListaNotificacoes extends StatefulWidget {
  const PaginaListaNotificacoes({super.key});

  @override
  State<PaginaListaNotificacoes> createState() => _PaginaListaNotificacoesState();
}

class _PaginaListaNotificacoesState extends State<PaginaListaNotificacoes> {
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  final NotificacaoService _notificacaoService = NotificacaoService();
  final UsuarioService _usuarioService = UsuarioService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _usuarioService.getUsuarioAtual(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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

        if (tipoUsuario == 2) {
          // aluno
          final int cursoUsuario = snapshot.data!.get('curso') as int;
          final int semestreUsuario = snapshot.data!.get('semestre') as int;
          notificacoesStream = _notificacaoService.fetchNotificacoesParaAluno(cursoUsuario, semestreUsuario);
        } else if (tipoUsuario == 1 || tipoUsuario == 0) {
          // professor ou coordenador
          notificacoesStream = _notificacaoService.fetchNotificacoesParaProfessorOuCoordenador(emailUsuario);
        } else {
          notificacoesStream = _notificacaoService.fetchTodasNotificacoes();
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
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Nenhuma notificação encontrada.'));
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    Timestamp timestamp = data['criadoEm'] as Timestamp;
                    String formattedDate = _dateFormat.format(timestamp.toDate());

                    return FutureBuilder<String?>(
                      future: _getUserName(document),
                      builder: (context, asyncSnapshot) {
                        String? nomeUsuario = asyncSnapshot.data;

                        return Notificacao(
                          titulo: data['titulo'] ?? 'Sem título',
                          descricao: data['descricao'] ?? 'Sem descrição',
                          data: formattedDate,
                          criadoPor: nomeUsuario ?? 'Sem autor',
                        );
                      },
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

  Future<String?> _getUserName(DocumentSnapshot document) async {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    String? email = data['criadoPor'] as String?;
    if (email != null) {
      return await getUserNameByEmail(email);
    } else {
      return null;
    }
  }
}
