import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noticv/src/models/curso.dart';
import 'package:noticv/src/models/semestre.dart';
import 'package:noticv/src/models/tipo_usuario.dart';
import 'package:noticv/src/widgets/main_button.dart';
import 'package:noticv/src/widgets/select_input.dart';
import 'package:noticv/src/widgets/text_input.dart';

final _firebaseAuth = FirebaseAuth.instance;

class PaginaCadastro extends StatefulWidget {
  const PaginaCadastro({super.key});

  @override
  State<PaginaCadastro> createState() => _PaginaCadastroState();
}

class _PaginaCadastroState extends State<PaginaCadastro> {
  final _chaveForm = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController =
      TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _cursoController = TextEditingController();
  final TextEditingController _semestreController = TextEditingController();

  String _emailInserido = '';
  String _senhaInserida = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int? _tipoUsuarioSelecionado;
  List<TipoUsuario> _tiposUsuario = [];

  int? _cursoSelecionado;
  List<Curso> _cursos = [];

  int? _semestreSelecionado;
  List<Semestre> _semestres = [];

  @override
  void initState() {
    super.initState();
    _fetchTiposUsuario();
    _fetchCursos();
  }

  Future<void> _fetchTiposUsuario() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('tipoUsuario').get();
      List<TipoUsuario> fetchedTiposUsuario =
          snapshot.docs.map((doc) => TipoUsuario.fromFirestore(doc)).toList();

      setState(() {
        _tiposUsuario = fetchedTiposUsuario;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Erro ao buscar os tipos de usuário. Tente novamente.'),
          ),
        );
      }
    }
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
      // Obtém todos os documentos da subcoleção 'semestres' do curso específico
      QuerySnapshot snapshot = await _firestore
          .collection('cursos')
          .doc(id)
          .collection('semestres')
          .get();

      // Inicializa uma lista vazia para armazenar os semestres
      List<Semestre> semestres = [];

      // Itera sobre cada documento na coleção 'semestres'
      for (var doc in snapshot.docs) {
        int quantidade = doc['quantidade'];
        // Adiciona opções de semestre com base na quantidade
        for (int i = 1; i <= quantidade; i++) {
          semestres.add(Semestre(id: i, descricao: '$iº Semestre'));
        }
      }

      // Atualiza o estado com a lista de semestres
      setState(() {
        _semestres = semestres;
        _semestreSelecionado = null; // Limpar seleção anterior
      });
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

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();
    _areaController.dispose();
    _cursoController.dispose();
    _semestreController.dispose();
    super.dispose();
  }

  Future<void> _registrarUsuario(BuildContext context) async {
    if (_chaveForm.currentState!.validate()) {
      _chaveForm.currentState!.save();
      try {
        // Lógica para cadastro
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: _emailInserido,
          password: _senhaInserida,
        );
        // Salvar dados adicionais no Firestore
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(_firebaseAuth.currentUser!.uid)
            .set({
          'nome': _nomeController.text,
          'email': _emailInserido,
          'tipoUsuario': _tipoUsuarioSelecionado,
          if (_tipoUsuarioSelecionado == 2) 'curso': _cursoSelecionado,
          if (_tipoUsuarioSelecionado == 2) 'semestre': _semestreSelecionado,
        });
      } catch (e) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erro ao registrar usuário.'),
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
        backgroundColor: Colors.transparent, // Removendo a cor de fundo
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
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Alinha os elementos na extremidade
            children: [
              Container(), // Widget vazio para ocupar espaço à esquerda
              const Text(
                'Cadastro',
                style: TextStyle(
                  color: Color(0xFFDA983A),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        body: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _chaveForm,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SelectInput(
                      label: 'Tipo de Usuário',
                      textoDica: 'Selecione o tipo de usuário',
                      itens: _tiposUsuario
                          .map((tipo) => SelectItem(tipo.id, tipo.descricao))
                          .toList(),
                      onChanged: (valor) {
                        setState(() {
                          _tipoUsuarioSelecionado = valor;
                        });
                      },
                      validator: (valor) {
                        if (valor == null) {
                          return 'Por favor, selecione um tipo de usuário';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextInput(
                      label: 'Nome',
                      controller: _nomeController,
                      textoDica: 'Digite seu nome',
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return 'Por favor, insira seu nome';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextInput(
                      label: 'E-mail',
                      controller: _emailController,
                      textoDica: 'Digite seu e-mail',
                      tipoTeclado: TextInputType.emailAddress,
                      validator: (valor) {
                        if (valor == null ||
                            valor.trim().isEmpty ||
                            !valor.contains('@')) {
                          return 'Por favor, insira um e-mail válido';
                        }
                        return null;
                      },
                      onSaved: (valorEmail) {
                        _emailInserido = valorEmail!;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextInput(
                      label: 'Senha',
                      controller: _senhaController,
                      textoDica: 'Digite sua senha',
                      inputSenha: true,
                      validator: (valor) {
                        if (valor == null || valor.trim().length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                      onSaved: (valorSenha) {
                        _senhaInserida = valorSenha!;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextInput(
                      label: 'Confirme a Senha',
                      controller: _confirmaSenhaController,
                      textoDica: 'Confirme sua senha',
                      inputSenha: true,
                      validator: (valor) {
                        if (valor != _senhaController.text) {
                          return 'As senhas não coincidem';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_tipoUsuarioSelecionado == 2) ...[
                      SelectInput(
                        label: 'Curso',
                        textoDica: 'Selecione o seu curso',
                        itens: _cursos
                            .map((tipo) => SelectItem(tipo.id, tipo.descricao))
                            .toList(),
                        onChanged: (valor) {
                          setState(() {
                            _cursoSelecionado = valor;
                            if (_cursoSelecionado != null) {
                              _fetchSemestres(_cursoSelecionado!);
                            }
                          });
                        },
                        validator: (valor) {
                          if (valor == null) {
                            return 'Por favor, selecione um curso';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SelectInput(
                        label: 'Semestre',
                        textoDica: 'Selecione o seu semestre',
                        itens: _semestres
                            .map((tipo) => SelectItem(tipo.id, tipo.descricao))
                            .toList(),
                        onChanged: (valor) {
                          setState(() {
                            _semestreSelecionado = valor;
                          });
                        },
                        validator: (valor) {
                          if (valor == null) {
                            return 'Por favor, selecione seu semestre';
                          }
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                    MainButton(
                      label: 'Cadastre-se',
                      onPressed: () => _registrarUsuario(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
