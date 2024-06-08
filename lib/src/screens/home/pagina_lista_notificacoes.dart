import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noticv/src/widgets/barra_navegacao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaginaListaNotificacoes extends StatefulWidget {
  const PaginaListaNotificacoes({super.key});

  @override
  State<PaginaListaNotificacoes> createState() =>
      _PaginaListaNotificacoesState();
}

class _PaginaListaNotificacoesState extends State<PaginaListaNotificacoes> {
  final List listaChats = [];

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
            body: Container(),
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
