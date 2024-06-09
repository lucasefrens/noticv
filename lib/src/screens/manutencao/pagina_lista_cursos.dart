import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noticv/src/screens/manutencao/pagina_curso.dart';
import 'package:noticv/src/widgets/barra_navegacao.dart';
import 'package:noticv/src/widgets/botao_flutuante.dart';
import 'package:noticv/src/widgets/caixa_dialogo.dart';
import 'package:noticv/src/widgets/curso_widget.dart';

class PaginaListaCursos extends StatefulWidget {
  final int tipoUsuario;

  const PaginaListaCursos({super.key, required this.tipoUsuario});

  @override
  State<PaginaListaCursos> createState() => _PaginaListaCursosState();
}

class _PaginaListaCursosState extends State<PaginaListaCursos> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFDA983A)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              const Text(
                'Lista Cursos',
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
          stream: FirebaseFirestore.instance.collection('cursos').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('Nenhum curso encontrado.'));
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return CursoWidget(
                  titulo: data['descricao'] ?? 'Sem título',
                  quantidadeSemestre:
                      data['quantidadeSemestre']?.toString() ?? '0',
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CaixaDialogo(
                          title: 'Confirmar exclusão',
                          content:
                              'Tem certeza de que deseja excluir este item?',
                          onConfirm: () {
                            FirebaseFirestore.instance
                                .collection('cursos')
                                .doc(document.id)
                                .delete();
                          },
                        );
                      },
                    );
                  },
                  onEdit: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PaginaCurso(
                          tipoUsuario: widget.tipoUsuario,
                          edicao: true,
                          idCurso: document.id,
                          nome: data['descricao'],
                          quantidadeSemestre: data['quantidadeSemestre'],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
        floatingActionButton: BotaoFlutuante(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PaginaCurso(
                  tipoUsuario: widget.tipoUsuario,
                  edicao: false,
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BarraNavegacao(
          currentPage: 2,
          tipoUsuario: widget.tipoUsuario,
        ),
      ),
    );
  }
}
