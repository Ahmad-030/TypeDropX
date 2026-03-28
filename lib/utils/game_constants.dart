enum PowerType { slow, blast, magnet, life }

class GameConstants {
  static const int initialLives = 3;
  static const int scorePerLetter = 10;
  static const double initialFallSpeed = 4.5; // seconds to cross screen
  static const double minFallSpeed = 2.0;
  static const double speedIncrement = 0.06;
  static const double powerUpChance = 0.12; // 12%
  static const int powerUpDuration = 5; // seconds
  static const int comboThreshold = 3; // letters before combo activates
  static const int letterSpawnIntervalMs = 1800;
  static const int maxSimultaneousLetters = 6;

  static const List<String> letters = [
    'A','B','C','D','E','F','G','H','I','J','K','L','M',
    'N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
  ];

  static const Map<PowerType, String> powerUpEmoji = {
    PowerType.slow: '🐢',
    PowerType.blast: '💥',
    PowerType.magnet: '🧲',
    PowerType.life: '❤️',
  };

  static const Map<PowerType, String> powerUpLabel = {
    PowerType.slow: 'SLOW MO',
    PowerType.blast: 'BLAST',
    PowerType.magnet: 'MAGNET',
    PowerType.life: 'EXTRA LIFE',
  };
}
