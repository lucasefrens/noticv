import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noticv/src/widgets/barra_navegacao.dart';
import 'package:noticv/src/widgets/main_button.dart';
import 'package:noticv/src/widgets/custom_text_input.dart';
import 'package:noticv/src/widgets/select_input.dart';
import 'package:noticv/src/models/curso.dart';
import 'package:noticv/src/models/semestre.dart';

class PaginaPerfil extends StatefulWidget {
  final int tipoUsuario;

  const PaginaPerfil({
    super.key,
    required this.tipoUsuario,
  });

  @override
  State<PaginaPerfil> createState() => _PaginaPerfilState();
}

class _PaginaPerfilState extends State<PaginaPerfil> {
  final _chaveForm = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cursoController = TextEditingController();
  final TextEditingController _semestreController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingSemestres = false;

  int? _cursoSelecionado;
  List<Curso> _cursos = [];
  int? _semestreSelecionado;
  List<Semestre> _semestres = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchCursos();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final String email = user?.email ?? '';

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>?;
        if (userData != null) {
          setState(() {
            _nomeController.text = userData['nome'] ?? '';
            _emailController.text = userData['email'] ?? '';
            _cursoSelecionado = userData['curso'];
            _semestreSelecionado = userData['semestre'];
          });

          if (_cursoSelecionado != null) {
            await _fetchSemestres(_cursoSelecionado!, keepSelected: true);
          }
        }
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao buscar dados do usuário'),
          ),
        );
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchCursos() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('cursos').get();
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

  Future<void> _fetchSemestres(int idCurso, {bool keepSelected = false}) async {
    setState(() {
      _isLoadingSemestres = true;
    });

    String id = idCurso.toString();
    try {
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance.collection('cursos').doc(id).get();
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
            if (!keepSelected ||
                !_semestres.any((s) => s.id == _semestreSelecionado)) {
              _semestreSelecionado = null;
            }
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
    } finally {
      setState(() {
        _isLoadingSemestres = false;
      });
    }
  }

  Future<void> _atualizarUsuario(BuildContext context) async {
    if (_chaveForm.currentState!.validate()) {
      _chaveForm.currentState!.save();
      try {
        User? user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user!.uid)
            .update({
          'nome': _nomeController.text,
          'curso': _cursoSelecionado,
          'semestre': _semestreSelecionado,
          'alteradoPor': user.email,
          'alteradoEm': Timestamp.now(),
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dados atualizados com sucesso'),
            ),
          );
        });
      } catch (e) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erro ao atualizar dados do usuário.'),
              ),
            );
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
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
          title: const Text(
            'Perfil',
            style: TextStyle(
              color: Color(0xFFDA983A),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Color(0xFFDA983A)),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
        body: _isLoading ? _buildLoadingIndicator() : _buildProfileForm(),
        bottomNavigationBar: BarraNavegacao(
          currentPage: 3,
          tipoUsuario: widget.tipoUsuario,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildProfileForm() {
    return Builder(builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _chaveForm,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  label: 'Email',
                  controller: _emailController,
                  textoDica: 'Digite seu e-mail',
                  enabled: false, // Desabilita edição do email
                  validator: (valor) {
                    if (valor == null ||
                        valor.trim().isEmpty ||
                        !valor.contains('@')) {
                      return 'Por favor, insira um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (widget.tipoUsuario == 2) ...[
                  SelectInput(
                    label: 'Curso',
                    textoDica: 'Selecione o seu curso',
                    itens: _cursos
                        .map((tipo) => SelectItem(tipo.id, tipo.descricao))
                        .toList(),
                    valorSelecionado: _cursoSelecionado,
                    onChanged: (valor) {
                      setState(() {
                        _cursoSelecionado = valor;
                        _semestreSelecionado =
                            null; // Resetar a seleção de semestre
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
                  _isLoadingSemestres
                      ? const Center(child: CircularProgressIndicator())
                      : SelectInput(
                          label: 'Semestre',
                          textoDica: 'Selecione o seu semestre',
                          itens: _semestres
                              .map(
                                  (tipo) => SelectItem(tipo.id, tipo.descricao))
                              .toList(),
                          valorSelecionado: _semestreSelecionado,
                          onChanged: (valor) {
                            setState(() {
                              _semestreSelecionado = valor;
                            });
                          },
                          validator: (valor) {
                            if (valor == null) {
                              return 'Por favor, selecione um semestre';
                            }
                            return null;
                          },
                        ),
                ],
                const SizedBox(height: 24),
                MainButton(
                  label: 'Salvar',
                  onPressed: () => _atualizarUsuario(context),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
