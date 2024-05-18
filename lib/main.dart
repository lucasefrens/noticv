// firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const TelaLogin());
}

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _chaveForm = GlobalKey<FormState>();
  String _emailInserido = '';
  String _senhaInserida = '';

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
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 96),
                  width: 168,
                  child: Image.asset('../images/logo-unicv.png'),
                ),
                const SizedBox(height: 36,),
                const Text(
                  'Preencha e-mail e senha para entrar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 36,),
                Form(
                  key: _chaveForm,
                  child: Column(
                    children: [
                      TextInput(
                        label: 'Digite seu e-mail',
                        controller: TextEditingController(),
                        textoDica: 'E-mail',
                        tipoTeclado: TextInputType.emailAddress,
                        validator: (valorEmail) {
                          if (valorEmail == null || valorEmail.trim().isEmpty || !valorEmail.contains("@")) {
                            return 'Por favor, insira um endereço de email válido.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16,),
                      TextInput(
                        label: 'Digite sua senha',
                        controller: TextEditingController(),
                        textoDica: 'Senha',
                        tipoTeclado: TextInputType.visiblePassword,
                        inputSenha: true,
                      ),
                      const SizedBox(height: 24,),
                      MainButton(
                        label: 'Entrar',
                        onPressed: () {
                          if (!_chaveForm.currentState!.validate()) {
                            return;
                          }
                        }
                      ),
                      const SizedBox(height: 14,),
                      TransparentButton(label: 'Criar nova conta', onPressed: () {},),
                    ],
                  ),
                ),
                const SizedBox(height: 14,),
              ],
            )
          ),
        )
      ),
    );
  }
}

class TextInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String textoDica;
  final TextInputType tipoTeclado;
  final bool inputSenha;
  final Function(String?)? validator;
  final Function()? onSaved;

  const TextInput({
    super.key,
    required this.label,
    required this.controller,
    required this.textoDica,
    this.tipoTeclado = TextInputType.text,
    this.inputSenha = false,
    this.validator,
    this.onSaved
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.inputSenha;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 8,),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.tipoTeclado,
          obscureText: _obscureText,
          validator: (value) => widget.validator?.call(value),
          onSaved: (value) => widget.onSaved?.call(),
          decoration: InputDecoration(
            hintText: widget.textoDica,
            filled: true,
            fillColor: const Color.fromARGB(255, 238, 238, 238),
            suffixIcon: widget.inputSenha ? 
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: _obscureText ? const Icon(Icons.visibility, color: Color.fromARGB(255, 176, 176, 176)) : const Icon(Icons.visibility_off, color: Color.fromARGB(255, 176, 176, 176)),
                ) : null,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide.none
            ),
          ),
        ),
      ],
    );
  }
}

class MainButton extends StatelessWidget {
  final String label;
  final Function()? onPressed;

  final buttonStyle = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 15),
    padding: const EdgeInsets.all(25),
    backgroundColor: const Color.fromARGB(255, 89, 107, 49),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5)
    )
  );

  MainButton({
    super.key,
    required this.label,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Text(label),
      ),
    );
  }
}

class TransparentButton extends StatelessWidget {
  final String label;
  final Function()? onPressed;

  final buttonStyle = ElevatedButton.styleFrom(
    textStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold
    ),
    padding: const EdgeInsets.all(35),
    backgroundColor: Colors.transparent,
    foregroundColor: const Color.fromARGB(255, 89, 107, 49),
    elevation: 0,
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: Color.fromARGB(255, 89, 107, 49)),
      borderRadius: BorderRadius.circular(5)
    )
  );

  TransparentButton({
    super.key,
    required this.label,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 100,
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Text(label),
      ),
    );
  }
}