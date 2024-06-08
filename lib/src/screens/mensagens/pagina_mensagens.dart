import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noticv/src/widgets/barra_navegacao.dart';

class PaginaMensagens extends StatefulWidget {
  final int tipoUsuario;

  const PaginaMensagens({super.key, required this.tipoUsuario});

  @override
  State<PaginaMensagens> createState() => _PaginaMensagensState();
}

class _PaginaMensagensState extends State<PaginaMensagens> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFDA983A)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              const Text(
                'Envio Mensagens',
                style: TextStyle(
                  color: Color(0xFFDA983A),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        body:
            Placeholder(), //_isLoading ? _buildLoadingIndicator() : _buildProfileForm(),
        bottomNavigationBar: BarraNavegacao(
          currentPage: 1,
          tipoUsuario: widget.tipoUsuario,
        ),
      ),
    );
  }
}
