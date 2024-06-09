import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String textoDica;
  final TextInputType tipoTeclado;
  final bool inputSenha;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters; // Adicionando esta linha

  const CustomTextInput({
    super.key, // Corrigindo a definição do construtor
    required this.label,
    required this.controller,
    required this.textoDica,
    this.tipoTeclado = TextInputType.text,
    this.inputSenha = false,
    this.enabled = true,
    this.validator,
    this.onSaved,
    this.inputFormatters,
  }); // Corrigindo a definição do construtor

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
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
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.tipoTeclado,
          enabled: widget.enabled,
          obscureText: _obscureText,
          validator: widget.validator,
          onSaved: widget.onSaved,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            hintText: widget.textoDica,
            filled: true,
            fillColor: const Color.fromARGB(255, 238, 238, 238),
            suffixIcon: widget.inputSenha
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: _obscureText
                        ? const Icon(Icons.visibility, color: Color(0xFFB0B0B0))
                        : const Icon(Icons.visibility_off,
                            color: Color.fromARGB(255, 176, 176, 176)),
                  )
                : null,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
