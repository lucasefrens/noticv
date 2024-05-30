import 'package:flutter/material.dart';

class SelectInput extends StatefulWidget {
  final String label;
  final String textoDica;
  final List<dynamic> itens;
  final dynamic valorSelecionado;
  final Function(dynamic) onChanged;
  final String? Function(dynamic)? validator;

  const SelectInput({
    required this.label,
    required this.textoDica,
    required this.itens,
    required this.valorSelecionado,
    required this.onChanged,
    this.validator,
    super.key,
  });

  @override
  State<SelectInput> createState() => _SelectInputState();
}

class _SelectInputState extends State<SelectInput> {
  String? _valorSelecionado;

  @override
  void initState() {
    super.initState();
    _valorSelecionado = widget.valorSelecionado;
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
        DropdownButtonFormField<String>(
          value: _valorSelecionado,
          decoration: InputDecoration(
            hintText: widget.textoDica,
            filled: true,
            fillColor: const Color.fromARGB(255, 238, 238, 238),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide.none,
            ),
          ),
          items: widget.itens.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item.toString()),
            );
          }).toList(),
          onChanged: (valor) {
            setState(() {
              _valorSelecionado = valor;
            });
            widget.onChanged(valor);
          },
          validator: widget.validator,
        ),
      ],
    );
  }
}
