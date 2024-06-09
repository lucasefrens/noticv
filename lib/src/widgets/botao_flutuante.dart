import 'package:flutter/material.dart';

class BotaoFlutuante extends StatelessWidget {
  final Function()? onPressed;

  const BotaoFlutuante({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFF596B31),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
