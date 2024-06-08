import 'package:flutter/material.dart';

class TextAreaInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String textoDica;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final int maxLines; // Adicionamos essa propriedade para controlar o número máximo de linhas

  const TextAreaInput({
    super.key,
    required this.label,
    required this.controller,
    required this.textoDica,
    this.enabled = true,
    this.validator,
    this.onSaved,
    this.maxLines = 3, // Definimos um valor padrão para o número máximo de linhas
  });

  @override
  State<TextAreaInput> createState() => _TextAreaInputState();
}

class _TextAreaInputState extends State<TextAreaInput> {
  @override
  void initState() {
    super.initState();
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
        TextField( // Substituímos TextFormField por TextField
          controller: widget.controller,
          keyboardType: TextInputType.multiline,
          maxLines: widget.maxLines, // Definimos o número máximo de linhas
          enabled: widget.enabled,
          decoration: InputDecoration(
            hintText: widget.textoDica,
            filled: true,
            fillColor: const Color.fromARGB(255, 238, 238, 238),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
