import 'package:flutter/material.dart';

class CaixaDialogo extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const CaixaDialogo({
    super.key,
    required this.title,
    required this.content,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFD9D9D9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        content,
        style: const TextStyle(
          fontSize: 14.0,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (onCancel != null) onCancel!();
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancelar',
            style: TextStyle(
              color: Color(0xFF596B31),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (onConfirm != null) onConfirm!();
            Navigator.of(context).pop();
          },
          child: const Text(
            'Confirmar',
            style: TextStyle(
              color: Color(0xFF596B31),
            ),
          ),
        ),
      ],
    );
  }
}
