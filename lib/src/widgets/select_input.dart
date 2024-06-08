import 'package:flutter/material.dart';

class SelectItem {
  final int id;
  final String descricao;

  SelectItem(this.id, this.descricao);
}

class SelectInput extends StatefulWidget {
  final String label;
  final String textoDica;
  final List<SelectItem> itens;
  final int? valorSelecionado;
  final Function(int?) onChanged;
  final String? Function(int?)? validator;

  const SelectInput({
    required this.label,
    required this.textoDica,
    required this.itens,
    this.valorSelecionado,
    required this.onChanged,
    this.validator,
    super.key,
  });

  @override
  State<SelectInput> createState() => _SelectInputState();
}

class _SelectInputState extends State<SelectInput> {
  int? _valorSelecionado;

  @override
  void initState() {
    super.initState();
    _valorSelecionado = widget.valorSelecionado;
  }

  @override
  void didUpdateWidget(SelectInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Atualiza _valorSelecionado quando widget.valorSelecionado muda
    if (oldWidget.valorSelecionado != widget.valorSelecionado) {
      setState(() {
        _valorSelecionado = widget.valorSelecionado;
      });
    }
    // Reseta _valorSelecionado se o item altera e não existe um semestre no novo curso
    if (!widget.itens.any((item) => item.id == _valorSelecionado)) {
      setState(() {
        _valorSelecionado = null;
      });
    }
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
        DropdownButtonFormField<int>(
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
            return DropdownMenuItem<int>(
              value: item.id,
              child: Text(item.descricao),
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
