const gameLevels = <GameLevel>[
  (
    number: 1,
    winScore: 3,
    canSpawnTall: false,
    gameType: GameType.endlessRunner,
  ),
  (
    number: 2,
    winScore: 5,
    canSpawnTall: true,
    gameType: GameType.endlessRunner,
  ),
  (
    number: 3,
    winScore: 5,
    canSpawnTall: false,
    gameType: GameType.hurdleJumping,
  ),
  (
    number: 4,
    winScore: 10,
    canSpawnTall: false,
    gameType: GameType.hurdleJumping,
  ),
];

typedef GameLevel = ({
  int number,
  int winScore,
  bool canSpawnTall,
  GameType gameType,
});

enum GameType {
  endlessRunner,
  hurdleJumping,
}
