import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noticv/src/screens/cadastro/pagina_cadastro.dart';

// widgets
import '../../widgets/main_button.dart';
import '../../widgets/text_input.dart';
import '../../widgets/transparent_button.dart';

final _firebaseAuth = FirebaseAuth.instance;

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  final _chaveForm = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  String _emailInserido = '';
  String _senhaInserida = '';

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String title = 'Notificações UNICV';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      title: title,
      home: Scaffold(
        body: Builder(
          builder: (context) => Container(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 96),
                    width: 168,
                    child: Image.asset('lib/src/assets/images/logo-unicv.png'),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  const Text(
                    'Preencha e-mail e senha para entrar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  Form(
                    key: _chaveForm,
                    child: Column(
                      children: [
                        TextInput(
                          label: 'Digite seu e-mail',
                          controller: _emailController,
                          textoDica: 'E-mail',
                          tipoTeclado: TextInputType.emailAddress,
                          validator: (valorEmail) {
                            if (valorEmail == null ||
                                valorEmail.trim().isEmpty ||
                                !valorEmail.contains("@")) {
                              return 'Por favor, insira um endereço de email válido.';
                            }
                            return null;
                          },
                          onSaved: (valorEmail) {
                            _emailInserido = valorEmail!;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextInput(
                          label: 'Digite sua senha',
                          controller: _senhaController,
                          textoDica: 'Senha',
                          tipoTeclado: TextInputType.visiblePassword,
                          inputSenha: true,
                          validator: (valorSenha) {
                            if (valorSenha == null || valorSenha.trim().length < 6) {
                              return 'A senha deve ter pelo menos 6 caracteres';
                            }
                            return null;
                          },
                          onSaved: (valorSenha) {
                            _senhaInserida = valorSenha!;
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        MainButton(
                          label: 'Entrar',
                          onPressed: () async {
                            if (!_chaveForm.currentState!.validate()) {
                              return;
                            }
                            _chaveForm.currentState!.save();

                            try {
                              await _firebaseAuth.signInWithEmailAndPassword(
                                email: _emailInserido,
                                password: _senhaInserida,
                              );
                            } catch (_) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Falha na autenticação'),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        TransparentButton(
                          label: 'Criar nova conta',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PaginaCadastro(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 14,
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