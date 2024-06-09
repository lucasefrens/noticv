import 'package:flutter/material.dart';

class Notificacao extends StatelessWidget {
  final String titulo;
  final String descricao;
  final String data;
  final String criadoPor;

  const Notificacao({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.criadoPor,
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFF596B31),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(
                criadoPor.substring(0, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  descricao,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data,
                  style: const TextStyle(fontSize: 8),
                  textAlign: TextAlign.right,
                ),
                Text(
                  criadoPor,
                  style: const TextStyle(fontSize: 8),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
