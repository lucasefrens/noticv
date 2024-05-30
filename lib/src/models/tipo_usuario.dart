enum TipoUsuario {
  coordenador,
  professor,
  aluno,
}

class TipoUsuarioHelper {
  static const Map<TipoUsuario, String> descriptions = {
    TipoUsuario.coordenador: 'Coordenador',
    TipoUsuario.professor: 'Professor',
    TipoUsuario.aluno: 'Aluno',
  };

  static const Map<TipoUsuario, int> values = {
    TipoUsuario.coordenador: 0,
    TipoUsuario.professor: 1,
    TipoUsuario.aluno: 2,
  };

  static TipoUsuario? fromString(String description) {
    return descriptions.entries
        .firstWhere((element) => element.value == description, orElse: () => const MapEntry(TipoUsuario.aluno, 'Aluno'))
        .key;
  }

  static int toValue(TipoUsuario tipoUsuario) {
    return values[tipoUsuario]!;
  }

  static String toDescription(TipoUsuario tipoUsuario) {
    return descriptions[tipoUsuario]!;
  }
}
