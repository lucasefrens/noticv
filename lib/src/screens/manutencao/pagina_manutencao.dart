import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noticv/src/screens/manutencao/pagina_lista_cursos.dart';
import 'package:noticv/src/widgets/barra_navegacao.dart';
import 'package:noticv/src/widgets/main_button.dart';

class PaginaManutencao extends StatefulWidget {
  final int tipoUsuario;

  const PaginaManutencao({super.key, required this.tipoUsuario});

  @override
  State<PaginaManutencao> createState() => _PaginaManutencaoState();
}

class _PaginaManutencaoState extends State<PaginaManutencao> {
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
                'Manutenção',
                style: TextStyle(
                  color: Color(0xFFDA983A),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MainButton(
                label: 'Manutenção Curso',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PaginaListaCursos(tipoUsuario: widget.tipoUsuario)
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              MainButton(
                label: 'Manutenção Turma',
                onPressed: () {
                  // Adicione a lógica de navegação ou funcionalidade aqui
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BarraNavegacao(
          currentPage: 2,
          tipoUsuario: widget.tipoUsuario,
        ),
      ),
    );
  }
}
