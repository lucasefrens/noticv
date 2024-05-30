import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final TextEditingController _confirmaSenhaController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _cursoController = TextEditingController();
  final TextEditingController _semestreController = TextEditingController();

  String _emailInserido = '';
  String _senhaInserida = '';

  TipoUsuario? _tipoUsuarioSelecionado;
  final List<String> _tiposUsuarios = TipoUsuarioHelper.descriptions.values.toList();

  String? _cursoSelecionado;
  final List<String> _cursos = ['Análise e Desenvolvimento de Sistemas', 'Engenharia de Software', 'Administração'];

  String? _semestreSelecionado;
  final List<String> _semestres = ['1º Semestre', '2º Semestre', '3º Semestre'];

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinha os elementos na extremidade
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
        body: Padding(
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
                    itens: _tiposUsuarios,
                    valorSelecionado: _tipoUsuarioSelecionado != null
                        ? TipoUsuarioHelper.toDescription(_tipoUsuarioSelecionado!)
                        : null,
                    onChanged: (valor) {
                      setState(() {
                        _tipoUsuarioSelecionado = TipoUsuarioHelper.fromString(valor!);
                      });
                    },
                    validator: (valor) {
                      if (valor == null || valor.isEmpty) {
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
                    onSaved: (valorEmail) {
                      _senhaInserida = valorEmail!;
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
                  if (_tipoUsuarioSelecionado == TipoUsuario.aluno) ...[
                    SelectInput(
                      label: 'Curso',
                      textoDica: 'Selecione o seu curso',
                      itens: _cursos,
                      valorSelecionado: _cursoSelecionado,
                      onChanged: (valor) {
                        setState(() {
                          _cursoSelecionado = valor;
                        });
                      },
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return 'Por favor, selecione um curso';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SelectInput(
                      label: 'Semestre',
                      textoDica: 'Selecione o seu semestre',
                      itens: _semestres,
                      valorSelecionado: _semestreSelecionado,
                      onChanged: (valor) {
                        setState(() {
                          _semestreSelecionado = valor;
                        });
                      },
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return 'Por favor, selecione um semestre';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  MainButton(
                    label: 'Cadastre-se',
                    onPressed: () async {
                      if (_chaveForm.currentState!.validate()) {
                        _chaveForm.currentState!.save();
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
                          'tipoUsuario': TipoUsuarioHelper.toValue(_tipoUsuarioSelecionado!),
                          if (_tipoUsuarioSelecionado == TipoUsuario.aluno) 'curso': _cursoSelecionado,
                          if (_tipoUsuarioSelecionado == TipoUsuario.aluno) 'semestre': _semestreSelecionado,
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
