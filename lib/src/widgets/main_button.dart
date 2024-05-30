import 'package:flutter/material.dart';

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