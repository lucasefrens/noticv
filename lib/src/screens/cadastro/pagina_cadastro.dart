import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noticv/src/models/curso.dart';
import 'package:noticv/src/models/semestre.dart';
import 'package:noticv/src/models/tipo_usuario.dart';
import 'package:noticv/src/services/curso_service.dart';
import 'package:noticv/src/services/tipo_usuario_service.dart';
import 'package:noticv/src/services/usuario_service.dart';
import 'package:noticv/src/widgets/main_button.dart';
import 'package:noticv/src/widgets/select_input.dart';
import 'package:noticv/src/widgets/custom_text_input.dart';

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

  final CursoService _cursoService = CursoService();
  final TipoUsuarioService _tipoUsuarioService = TipoUsuarioService();
  final UsuarioService _usuarioService = UsuarioService();

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
      List<TipoUsuario> fetchedTiposUsuario = await _tipoUsuarioService.fetchTiposUsuario();

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
      List<Curso> fetchedCursos = await _cursoService.fetchCursos();

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
    try {
      List<Semestre> fetchedSemestres = await _cursoService.fetchSemestres(idCurso);

      setState(() {
        _semestres = fetchedSemestres;
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
        await _usuarioService.registrarUsuario(
          nome: _nomeController.text,
          email: _emailInserido,
          senha: _senhaInserida,
          tipoUsuario: _tipoUsuarioSelecionado!,
          curso: _tipoUsuarioSelecionado == 2 ? _cursoSelecionado : null,
          semestre: _tipoUsuarioSelecionado == 2 ? _semestreSelecionado : null,
        );
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
                    CustomTextInput(
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
                    CustomTextInput(
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
                    CustomTextInput(
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
                    CustomTextInput(
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
                            _semestreSelecionado = null; // Resetar a seleção de semestre
                            _semestres = []; // Limpar a lista de semestres
                          });

                          if (_cursoSelecionado != null) {
                            _fetchSemestres(_cursoSelecionado!);
                          }
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
                        valorSelecionado: _semestreSelecionado,
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
