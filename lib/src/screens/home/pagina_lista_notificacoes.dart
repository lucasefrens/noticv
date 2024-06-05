import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noticv/src/widgets/barra_navegacao.dart';

class PaginaListaNotificacoes extends StatefulWidget {
  const PaginaListaNotificacoes({super.key});

  @override
  State<PaginaListaNotificacoes> createState() =>
      _PaginaListaNotificacoesState();
}

class _PaginaListaNotificacoesState extends State<PaginaListaNotificacoes> {
  final List listaChats = [];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            elevation: 0,
            centerTitle: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Alinha os elementos na extremidade
              children: [
                Container(), // Widget vazio para ocupar espaço à esquerda
                const Text(
                  'Início',
                  style: TextStyle(
                    color: Color(0xFFDA983A),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          body: Container(), // Corpo em branco por enquanto
          bottomNavigationBar: BarraNavegacao(
              currentIndex: _selectedIndex, onTap: _onItemTapped)),
    );
  }
}
