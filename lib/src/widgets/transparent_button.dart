import 'package:flutter/material.dart';

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