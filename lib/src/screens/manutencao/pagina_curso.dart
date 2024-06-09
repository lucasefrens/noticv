import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noticv/src/services/curso_service.dart';
import 'package:noticv/src/widgets/barra_navegacao.dart';
import 'package:noticv/src/widgets/main_button.dart';
import 'package:noticv/src/widgets/custom_text_input.dart';

class PaginaCurso extends StatefulWidget {
  final int tipoUsuario;
  final bool edicao;
  final String idCurso;
  final String nome;
  final int quantidadeSemestre;

  const PaginaCurso({
    super.key,
    required this.tipoUsuario,
    required this.edicao,
    this.idCurso = '',
    this.nome = '',
    this.quantidadeSemestre = 0,
  });

  @override
  State<PaginaCurso> createState() => _PaginaCursoState();
}

class _PaginaCursoState extends State<PaginaCurso> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomeCursoController;
  late TextEditingController quantidadeSemestresController;
  final CursoService _cursoService = CursoService();

  @override
  void initState() {
    super.initState();
    nomeCursoController = TextEditingController(text: widget.nome);
    quantidadeSemestresController = TextEditingController(
        text: widget.edicao ? widget.quantidadeSemestre.toString() : '');
  }

  String? validarQuantidade(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite a quantidade de semestres';
    }
    final n = num.tryParse(value);
    if (n == null) {
      return 'Por favor, digite um número válido';
    }
    return null;
  }

  Future<void> salvarCurso() async {
    if (_formKey.currentState!.validate()) {
      final nome = nomeCursoController.text;
      final quantidadeSemestre = int.parse(quantidadeSemestresController.text);

      await _cursoService.salvarCurso(
        idCurso: widget.idCurso,
        nome: nome,
        quantidadeSemestre: quantidadeSemestre,
        edicao: widget.edicao,
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

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
              Text(
                widget.edicao ? 'Edição' : 'Inclusão',
                style: const TextStyle(
                  color: Color(0xFFDA983A),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextInput(
                  label: 'Nome do Curso',
                  controller: nomeCursoController,
                  textoDica: 'Digite o nome do curso',
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Por favor, informe o nome do curso';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextInput(
                  label: 'Quantidade de Semestres',
                  controller: quantidadeSemestresController,
                  textoDica: 'Digite a quantidade de semestres',
                  tipoTeclado: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: validarQuantidade,
                ),
                const SizedBox(height: 16),
                MainButton(
                  label: 'Salvar',
                  onPressed: salvarCurso,
                ),
              ],
            ),
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
