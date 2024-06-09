import 'package:flutter/material.dart';

class CursoWidget extends StatelessWidget {
  final String titulo;
  final String quantidadeSemestre;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CursoWidget({
    super.key,
    required this.titulo,
    required this.quantidadeSemestre,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$quantidadeSemestre semestres',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF596B31)),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Color.fromRGBO(218, 58, 58, 1)),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}