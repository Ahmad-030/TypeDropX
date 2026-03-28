import 'dart:math';

enum WordDifficulty { easy, medium, hard }

class WordList {
  static const List<String> easy = [
    'CAT', 'DOG', 'RUN', 'FLY', 'SKY', 'SUN', 'MAP', 'CUP', 'HAT', 'BAT',
    'BIG', 'BOX', 'BUS', 'CAN', 'CAR', 'COW', 'CRY', 'CUT', 'DAY', 'DIG',
    'DIP', 'EAR', 'EAT', 'EGG', 'ELF', 'END', 'EYE', 'FAR', 'FAT', 'FIG',
    'FIN', 'FIT', 'FIX', 'FOX', 'FUN', 'GAS', 'GET', 'GOT', 'GUM', 'GUN',
    'GUY', 'GYM', 'HIT', 'HOP', 'HOT', 'HUG', 'HUT', 'ICE', 'ILL', 'INK',
    'JAB', 'JAM', 'JAR', 'JAW', 'JET', 'JOB', 'JOG', 'JOT', 'JOY', 'JUG',
    'KEY', 'KID', 'LAB', 'LAD', 'LAP', 'LAW', 'LAY', 'LEG', 'LET', 'LID',
    'LIP', 'LOG', 'LOT', 'LOW', 'MAD', 'MAN', 'MAT', 'MIX', 'MOP', 'MUD',
    'MUG', 'NAP', 'NET', 'NEW', 'NIP', 'NIT', 'NUT', 'OAK', 'OAR', 'ODD',
    'OIL', 'OLD', 'OPT', 'ORB', 'OWL', 'OWN', 'PAD', 'PAN', 'PAW', 'PAY',
    'PEA', 'PEG', 'PET', 'PIE', 'PIG', 'PIN', 'PIT', 'PLY', 'POD', 'POT',
  ];

  static const List<String> medium = [
    'JUMP', 'PLAY', 'RACE', 'FAST', 'BOLD', 'BLUE', 'BIRD', 'BOOK', 'CAKE',
    'CALL', 'CAMP', 'CARD', 'CART', 'CAVE', 'CITY', 'CLAP', 'CLAY', 'CLIP',
    'CLUB', 'COAL', 'COAT', 'CODE', 'COIN', 'COLD', 'COOK', 'COOL', 'CORN',
    'COST', 'CRAB', 'CREW', 'CROP', 'CUBE', 'CURE', 'CURL', 'CUTE', 'DARK',
    'DART', 'DASH', 'DATA', 'DAWN', 'DEAL', 'DECK', 'DEEP', 'DEER', 'DENY',
    'DESK', 'DIET', 'DIRT', 'DISK', 'DIVE', 'DOCK', 'DOLL', 'DOME', 'DOOR',
    'DOVE', 'DOWN', 'DRAW', 'DRIP', 'DROP', 'DRUM', 'DUCK', 'DUEL', 'DUMP',
    'DUSK', 'DUST', 'DUTY', 'EARL', 'EARN', 'EAST', 'EASY', 'EDGE', 'EPIC',
    'EVEN', 'EVIL', 'EXAM', 'EXIT', 'FACE', 'FACT', 'FAIL', 'FAIR', 'FALL',
    'FAME', 'FARM', 'FATE', 'FEAT', 'FEEL', 'FEET', 'FILE', 'FILL', 'FILM',
    'FIND', 'FIRE', 'FIRM', 'FISH', 'FIST', 'FLAG', 'FLAT', 'FLEW', 'FLEX',
    'FLIP', 'FLOW', 'FOAM', 'FOLD', 'FOLK', 'FOND', 'FONT', 'FOOL', 'FOOT',
    'FORM', 'FORT', 'FOUR', 'FREE', 'FUEL', 'FULL', 'FUND', 'FUSE', 'GAIN',
    'GAME', 'GANG', 'GATE', 'GAVE', 'GAZE', 'GEAR', 'GIFT', 'GIVE', 'GLAD',
    'GLOW', 'GLUE', 'GOAL', 'GOLD', 'GOLF', 'GONE', 'GOOD', 'GRAB', 'GRAY',
    'GRID', 'GRIN', 'GRIP', 'GROW', 'GULF', 'GUST', 'HACK', 'HAIL', 'HAIR',
    'HALF', 'HALL', 'HAND', 'HANG', 'HARD', 'HARM', 'HAVE', 'HAWK', 'HEAL',
    'HEAP', 'HEAR', 'HEAT', 'HEEL', 'HELP', 'HERB', 'HERE', 'HERO', 'HIGH',
    'HIKE', 'HILL', 'HINT', 'HIRE', 'HOLD', 'HOLE', 'HOLY', 'HOME', 'HOOK',
    'HOPE', 'HORN', 'HOSE', 'HOST', 'HOUR', 'HUGE', 'HULL', 'HUNT', 'HURL',
  ];

  static const List<String> hard = [
    'SWIFT', 'BLEND', 'FLASH', 'GLOOM', 'GRASP', 'GRIND', 'GROWL', 'QUAKE',
    'SCORE', 'SPARK', 'SPEAK', 'SPELL', 'SPEND', 'SPICE', 'SPIKE', 'SPILL',
    'SPINE', 'SPITE', 'SPRAY', 'SQUAT', 'SQUAD', 'SQUID', 'STACK', 'STAFF',
    'STAGE', 'STAIN', 'STAKE', 'STAND', 'STARE', 'START', 'STATE', 'STEAM',
    'STEEL', 'STEEP', 'STERN', 'STICK', 'STILL', 'STING', 'STOCK', 'STONE',
    'STORM', 'STORY', 'STRAP', 'STRAW', 'STRAY', 'STRIP', 'STUCK', 'STUDY',
    'STUFF', 'STUMP', 'STUNT', 'STYLE', 'SUGAR', 'SUPER', 'SURGE', 'SWAMP',
    'SWEAR', 'SWEAT', 'SWEEP', 'SWEET', 'SWIFT', 'SWING', 'SWIPE', 'SWIRL',
    'TABLE', 'TASTE', 'TEACH', 'TEETH', 'TEMPO', 'TENSE', 'THEFT', 'THEME',
    'THICK', 'THING', 'THINK', 'THORN', 'THREE', 'THROW', 'THUMB', 'TIGER',
    'TIGHT', 'TIMER', 'TITLE', 'TODAY', 'TOKEN', 'TOUCH', 'TOUGH', 'TOWER',
    'TOXIC', 'TRACE', 'TRACK', 'TRADE', 'TRAIL', 'TRAIN', 'TRAIT', 'TRASH',
    'TREND', 'TRIAL', 'TRIBE', 'TRICK', 'TROOP', 'TRUCK', 'TRULY', 'TRUNK',
    'TRUST', 'TRUTH', 'TWICE', 'TWIST', 'ULTRA', 'UNDER', 'UNION', 'UNITY',
    'UNTIL', 'UPPER', 'UPSET', 'URBAN', 'USAGE', 'USUAL', 'VALID', 'VALUE',
    'VAPOR', 'VAULT', 'VENOM', 'VERSE', 'VIDEO', 'VIGOR', 'VIRAL', 'VIRUS',
    'VISIT', 'VISTA', 'VITAL', 'VIVID', 'VOCAL', 'VOICE', 'VOTER', 'WAGER',
    'WATCH', 'WATER', 'WEAVE', 'WEDGE', 'WEIRD', 'WHALE', 'WHEAT', 'WHEEL',
    'WHILE', 'WHIRL', 'WINDY', 'WITCH', 'WORLD', 'WORRY', 'WORSE', 'WORST',
    'WORTH', 'WOUND', 'WRATH', 'WRIST', 'WRITE', 'WRONG', 'YACHT', 'YIELD',
    'YOUNG', 'YOUTH', 'ZEBRA', 'ZESTY', 'ABIDE', 'ABORT', 'ABOUT', 'ABOVE',
    'ABUSE', 'ABYSS', 'ACHED', 'ACIDS', 'ACRES', 'ACTED', 'ACUTE', 'ADAGE',
  ];

  static String random(Random rng, WordDifficulty diff) {
    switch (diff) {
      case WordDifficulty.easy:
        return easy[rng.nextInt(easy.length)];
      case WordDifficulty.medium:
        return medium[rng.nextInt(medium.length)];
      case WordDifficulty.hard:
        return hard[rng.nextInt(hard.length)];
    }
  }
}
