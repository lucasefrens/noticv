import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noticv/src/models/curso.dart';
import 'package:noticv/src/models/semestre.dart';
import 'package:noticv/src/widgets/barra_navegacao.dart';
import 'package:noticv/src/widgets/main_button.dart';
import 'package:noticv/src/widgets/select_input.dart';
import 'package:noticv/src/widgets/text_area_input.dart';
import 'package:noticv/src/widgets/custom_text_input.dart';

class PaginaMensagens extends StatefulWidget {
  final int tipoUsuario;

  const PaginaMensagens({super.key, required this.tipoUsuario});

  @override
  State<PaginaMensagens> createState() => _PaginaMensagensState();
}

class _PaginaMensagensState extends State<PaginaMensagens> {
  final _chaveForm = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int? _cursoSelecionado;
  List<Curso> _cursos = [];

  int? _semestreSelecionado;
  List<Semestre> _semestres = [];

  @override
  void initState() {
    super.initState();
    _fetchCursos();
  }

  Future<void> _fetchCursos() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('cursos').get();
      List<Curso> fetchedCursos =
          snapshot.docs.map((doc) => Curso.fromFirestore(doc)).toList();

      setState(() {
        _cursos = fetchedCursos;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao buscar os cursos. Tente novamente.'),
          ),
        );
      }
    }
  }

  Future<void> _fetchSemestres(int idCurso) async {
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

          setState(() {
            _semestres = semestres;
            _semestreSelecionado = null;
          });
        } else {
          throw Exception(
              'Campo quantidadeSemestre não encontrado no documento do curso');
        }
      } else {
        throw Exception('Documento do curso não encontrado');
      }
    } catch (e) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao buscar os semestres. Tente novamente.'),
            ),
          );
        });
      }
    }
  }

  Future<void> _enviarMensagem(BuildContext context) async {
    if (_chaveForm.currentState!.validate()) {
      _chaveForm.currentState!.save();
      try {
        User? user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance.collection('notificacoes').doc().set({
          'curso': _cursoSelecionado,
          'semestre': _semestreSelecionado,
          'titulo': _titleController.text,
          'descricao': _messageController.text,
          'criadoPor': user!.email,
          'criadoEm': Timestamp.now(),
        });

        setState(() {
          _cursoSelecionado = null;
          _semestreSelecionado = null;
          _semestres = [];
        });
        _titleController.clear();
        _messageController.clear();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notificação enviada com sucesso'),
            ),
          );
        });
      } catch (e) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erro ao criar notificação.'),
              ),
            );
          });
        }
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
              const Text(
                'Envio Mensagens',
                style: TextStyle(
                  color: Color(0xFFDA983A),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        body: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
                key: _chaveForm,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Seletor de curso
                      SelectInput(
                        label: 'Curso',
                        textoDica: 'Selecione o curso',
                        itens: _cursos
                            .map((curso) =>
                                SelectItem(curso.id, curso.descricao))
                            .toList(),
                        valorSelecionado: _cursoSelecionado,
                        onChanged: (valor) {
                          setState(() {
                            _cursoSelecionado = valor;
                            _semestreSelecionado = null;
                            _semestres = [];
                          });

                          if (_cursoSelecionado != null) {
                            _fetchSemestres(_cursoSelecionado!);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      // Seletor de semestre
                      SelectInput(
                        label: 'Semestre',
                        textoDica: 'Selecione o semestre',
                        itens: _semestres
                            .map((semestre) =>
                                SelectItem(semestre.id, semestre.descricao))
                            .toList(),
                        valorSelecionado: _semestreSelecionado,
                        onChanged: (valor) {
                          setState(() {
                            _semestreSelecionado = valor;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextInput(
                          label: 'Título',
                          controller: _titleController,
                          textoDica: 'Digite o título aqui'),
                      const SizedBox(height: 16),
                      TextAreaInput(
                        label: 'Mensagem',
                        controller: _messageController,
                        textoDica: 'Digite sua mensagem aqui',
                        maxLines: 8,
                      ),
                      const SizedBox(height: 16),
                      MainButton(
                        label: 'Enviar Notificação',
                        onPressed: () => _enviarMensagem(context),
                      ),
                    ],
                  ),
                )),
          );
        }),
        bottomNavigationBar: BarraNavegacao(
          currentPage: 1,
          tipoUsuario: widget.tipoUsuario,
        ),
      ),
    );
  }
}
