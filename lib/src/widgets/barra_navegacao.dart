import 'package:flutter/material.dart';
import 'package:noticv/src/screens/home/pagina_lista_notificacoes.dart';
import 'package:noticv/src/screens/manutencao/pagina_manutencao.dart';
import 'package:noticv/src/screens/mensagens/pagina_mensagens.dart';
import 'package:noticv/src/screens/perfil/pagina_perfil.dart';

class BarraNavegacao extends StatelessWidget {
  final int currentPage;
  final int tipoUsuario;

  const BarraNavegacao({
    super.key,
    required this.currentPage,
    required this.tipoUsuario,
  });

  void _onItemTapped(BuildContext context, int index) {
    int currentIndex = getIndexPagina(tipoUsuario, currentPage);

    if (index == currentIndex) return;
    if (tipoUsuario == 0) {
      switch (index) {
        case 0:
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const PaginaListaNotificacoes(),
            ),
            (route) => false,
          );
          break;

        case 1:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PaginaMensagens(tipoUsuario: tipoUsuario),
            ),
          );
          break;

        case 2:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PaginaManutencao(tipoUsuario: tipoUsuario),
            ),
          );
          break;

        case 3:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PaginaPerfil(tipoUsuario: tipoUsuario),
            ),
          );
          break;
      }
    }

    if (tipoUsuario == 1) {
      switch (index) {
        case 0:
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const PaginaListaNotificacoes(),
            ),
            (route) => false,
          );
          break;

        case 1:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PaginaMensagens(tipoUsuario: tipoUsuario),
            ),
          );
          break;

        case 2:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PaginaPerfil(tipoUsuario: tipoUsuario),
            ),
          );

          break;
      }
    }

    if (tipoUsuario == 2) {
      switch (index) {
        case 0:
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const PaginaListaNotificacoes(),
            ),
            (route) => false,
          );
          break;

        case 1:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PaginaPerfil(tipoUsuario: tipoUsuario),
            ),
          );

          break;
      }
    }
  }

  int getIndexPagina(int tipoUsuario, int currentPage) {
    switch (currentPage) {
      case 0: // inicial
        return 0;

      case 1: // mensagem
        if (tipoUsuario == 0) return 1; // coordenador
        if (tipoUsuario == 1) return 1; // professor
        return 0;

      case 2: // manutenção
        if (tipoUsuario == 0) return 2; // coordenador
        return 0;

      case 3:
        if (tipoUsuario == 0) return 3; // coordenador
        if (tipoUsuario == 1) return 2; // professor
        if (tipoUsuario == 2) return 1; // aluno
        return 0;

      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: const Color(0xFF596B31),
      ),
      child: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        currentIndex: getIndexPagina(tipoUsuario, currentPage),
        onTap: (index) => _onItemTapped(context, index),
        items: _getItemsForTipoUsuario(tipoUsuario),
      ),
    );
  }

  List<BottomNavigationBarItem> _getItemsForTipoUsuario(int tipoUsuario) {
    switch (tipoUsuario) {
      case 0:
        return const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Nova Notificação',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Manutenção',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ];
      case 1:
        return const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Nova Notificação',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ];
      case 2:
        return const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ];
      default:
        return const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Nova Notificação',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Manutenção',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ];
    }
  }
}
