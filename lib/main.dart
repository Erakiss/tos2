import 'package:flutter/material.dart';
import 'dart:math';

// ============================================================================
// MAIN ENTRY POINT
// Initializes and runs the Truth Or Shot application.
// ============================================================================
void main() {
  runApp(const TruthOrShotApp());
}

// region --- APP ROOT WIDGET ---
// Root widget setting up the global theme (Neon/Dark) and initial screen.
class TruthOrShotApp extends StatelessWidget {
  const TruthOrShotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Truth Or Shot',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.deepPurple,
      ),
      home: const SetupScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
// endregion

// ============================================================================
// MODELS
// Data structures representing core game entities.
// ============================================================================
// region --- MODELS ---

// Represents a game participant with their current score.
class Player {
  String name;
  String gender;
  int score;
  Player({required this.name, required this.gender, this.score = 0});
}

// Represents a playable card (Action/Truth) with dynamic penalty calculation.
class GameCard {
  final String type;
  final String difficulty;
  final String content;
  final String? targetGender;

  GameCard({required this.type, required this.difficulty, required this.content, this.targetGender});

  // Dynamically calculates penalty shots based on difficulty level.
  int get shots {
    switch (difficulty) {
      case 'SOFT': return 1;
      case 'FUN': return 2;
      case 'HOT': return 3;
      default: return 1;
    }
  }
}
// endregion

// ============================================================================
// DATABASE (MOCK DATA)
// Pre-defined list of game cards categorized by difficulty and type.
// ============================================================================
// region --- ALL CARDS LIST ---
final List<GameCard> allCards = [
  GameCard(type: 'ACTION', difficulty: 'SOFT', content: 'Fais le tour de la maison à cloche-pied.'),
  GameCard(type: 'ACTION', difficulty: 'SOFT', content: 'Imite ton animal préféré pendant 30 secondes.'),
  GameCard(type: 'ACTION', difficulty: 'SOFT', content: 'Chante le refrain d\'une chanson de Disney de toutes tes forces.'),
  GameCard(type: 'ACTION', difficulty: 'SOFT', content: 'Fais 5 pompes ou 10 squats.'),
  GameCard(type: 'ACTION', difficulty: 'SOFT', content: 'Imite un lapin en train de manger une carotte de manière beaucoup trop agressive.'),
  GameCard(type: 'ACTION', difficulty: 'SOFT', content: 'Parle avec une voix de robot ou de GPS jusqu\'à ton prochain tour.'),
  GameCard(type: 'ACTION', difficulty: 'SOFT', content: 'Dessine le portrait du joueur à ta droite avec un stylo, mais les yeux fermés.'),
  GameCard(type: 'ACTION', difficulty: 'SOFT', content: 'Fais semblant de conduire une moto sur un circuit de course de manière ultra intense pendant 20 secondes.'),
  GameCard(type: 'ACTION', difficulty: 'SOFT', content: 'Raconte ta meilleure blague de papa (dad joke) en gardant un sérieux absolu.'),
  GameCard(type: 'ACTION', difficulty: 'SOFT', content: 'Laisse la personne à ta gauche te recoiffer exactement comme elle le souhaite.'),
  GameCard(type: 'ACTION', difficulty: 'SOFT', content: 'Imite une pub pour un parfum pour homme avec ton regard le plus ténébreux et une voix grave.', targetGender: 'M'),
  GameCard(type: 'ACTION', difficulty: 'SOFT', content: 'Fais un défilé de mode de 3 mètres dans la pièce avec ton meilleur regard "femme fatale".', targetGender: 'F'),

  GameCard(type: 'VERITE', difficulty: 'SOFT', content: 'Combien de douches as-tu prises cette semaine ?'),
  GameCard(type: 'VERITE', difficulty: 'SOFT', content: 'Quelle est la dernière chose que tu as cherchée sur Google ?'),
  GameCard(type: 'VERITE', difficulty: 'SOFT', content: 'As-tu déjà menti pour éviter une sortie parce que tu voulais juste rester chez toi ? Si oui, raconte.'),
  GameCard(type: 'VERITE', difficulty: 'SOFT', content: 'Quelle est ta plus grande peur ridicule ?'),
  GameCard(type: 'VERITE', difficulty: 'SOFT', content: 'Quel est le pire film ou anime que tu as regardé jusqu\'au bout sans oser l\'assumer ?'),
  GameCard(type: 'VERITE', difficulty: 'SOFT', content: 'Quel est ton talent le plus inutile ?'),
  GameCard(type: 'VERITE', difficulty: 'SOFT', content: 'Préfères-tu vraiment sortir en grosse soirée ou rester casanier(e) en pyjama ? Sois honnête.'),
  GameCard(type: 'VERITE', difficulty: 'SOFT', content: 'As-tu encore un doudou ou une vieille peluche de ton enfance cachée quelque part chez toi ?'),
  GameCard(type: 'VERITE', difficulty: 'SOFT', content: 'As-tu déjà pleuré devant un dessin animé ? Lequel ?'),
  GameCard(type: 'VERITE', difficulty: 'SOFT', content: 'Quelle est la pire gaffe que tu aies faite devant tes parents ?'),
  GameCard(type: 'VERITE', difficulty: 'SOFT', content: 'As-tu déjà essayé de faire contracter tes pecs (ou tes abdos) devant un miroir juste pour voir si tu y arrivais ?', targetGender: 'M'),
  GameCard(type: 'VERITE', difficulty: 'SOFT', content: 'As-tu déjà fait semblant de ne pas savoir faire un truc simple (comme ouvrir un bocal) juste pour flatter l\'égo d\'un garçon ?', targetGender: 'F'),

  GameCard(type: 'ACTION', difficulty: 'FUN', content: 'Envoie un SMS de drague à une personne de ton répertoire qui n\'est pas ton partenaire.'),
  GameCard(type: 'ACTION', difficulty: 'FUN', content: 'Imite l\'accent d\'un étranger jusqu\'à ton prochain tour.'),
  GameCard(type: 'ACTION', difficulty: 'FUN', content: 'Laisse le joueur à ta droite poster une story sur ton Instagram.'),
  GameCard(type: 'ACTION', difficulty: 'FUN', content: 'Danse sans aucune musique pendant 1 minute en fixant quelqu\'un.'),
  GameCard(type: 'ACTION', difficulty: 'FUN', content: 'Fais un moonwalk (ou du moins, essaie de survivre à ta tentative).'),
  GameCard(type: 'ACTION', difficulty: 'FUN', content: 'Fais un discours politique de 30 secondes pour convaincre les autres de voter pour toi en utilisant uniquement des arguments absurdes.'),
  GameCard(type: 'ACTION', difficulty: 'FUN', content: 'Explique un concept ultra simple à la fille de ton choix avec le ton le plus condescendant possible (mansplaining total).', targetGender: 'M'),
  GameCard(type: 'ACTION', difficulty: 'FUN', content: 'Explique comment on crée un site web, mais avec la voix la plus sensuelle et suave possible.'),
  GameCard(type: 'ACTION', difficulty: 'FUN', content: 'Mime la pire technique de drague que tu aies jamais vue ou utilisée dans la vraie vie.'),
  GameCard(type: 'ACTION', difficulty: 'FUN', content: 'Lance-toi dans un débat de 30 secondes pour expliquer pourquoi ton setup clavier/souris est supérieur, en utilisant des termes techniques totalement inventés.'),
  GameCard(type: 'ACTION', difficulty: 'FUN', content: 'Fais une fausse demande en mariage ultra dramatique et romantique à la fille de ton choix (utilise un objet absurde en guise de bague).', targetGender: 'M'),
  GameCard(type: 'ACTION', difficulty: 'FUN', content: 'Prends ton téléphone et montre aux autres comment tu te cambres ou quelle pose tu prends quand veux "le" selfie parfait.', targetGender: 'F'),

  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Entre un(e) militant(e) d\'extrême gauche et un(e) militant(e) d\'extrême droite, avec qui passerais-tu la nuit si tu étais obligé(e) ?'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Qui dans la pièce a les opinions politiques ou sociales les plus éclatées/problématiques selon toi ?'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'As-tu déjà profité d\'un cliché sexiste sur les femmes pour obtenir ce que tu voulais ?', targetGender: 'F'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'As-tu déjà prétendu coder ou être à fond dans ton télé-travail alors que tu faisais complètement autre chose ?'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Si tu devais faire l\'amour avec quelqu\'un qui a une tête d\'animal, tu choisirais quel animal ?'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Raconte la plus grande honte publique de ta vie.'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Quelle est la chose la plus illégale que tu aies faite ?'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Si tu pouvais être invisible pendant 1 heure, que ferais-tu de totally immoral ou absurde ?'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Quel est le pire tue-l\'amour chez un garçon selon toi ?', targetGender: 'F'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Quel est le pire tue-l\'amour chez une fille selon toi ?', targetGender: 'M'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'As-tu déjà consciemment joué la carte du "mec sensible" ou "incompris" uniquement pour attendrir une fille ?', targetGender: 'M'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Lequel des garçons de la pièce a le profil ou l\'attitude la plus "red flag" (drapeau rouge) selon toi, et pourquoi ?', targetGender: 'F'),

  GameCard(type: 'ACTION', difficulty: 'HOT', content: 'Enlève un vêtement de ton choix.'),
  GameCard(type: 'ACTION', difficulty: 'HOT', content: 'Fais un massage des épaules et de la nuque de 30 secondes au joueur à ta gauche.'),
  GameCard(type: 'ACTION', difficulty: 'HOT', content: 'Choisis un joueur et laisse-le te faire un bisou sur la joue ou dans le cou.'),
  GameCard(type: 'ACTION', difficulty: 'HOT', content: 'Chuchote quelque chose de très coquin ou tabou à l\'oreille de la personne de ton choix.'),
  GameCard(type: 'ACTION', difficulty: 'HOT', content: 'Prends une pose très suggestive et maintiens-la pendant 10 secondes.'),
  GameCard(type: 'ACTION', difficulty: 'HOT', content: 'Enlève ton soutif sans enlever ton t-shirt, tu as 30 secondes.', targetGender: 'F'),
  GameCard(type: 'ACTION', difficulty: 'HOT', content: 'Enlève ton t-shirt en utilisant qu\'une seule main, tu as 15 secondes.', targetGender: 'M'),
  GameCard(type: 'ACTION', difficulty: 'HOT', content: 'Mime la position du missionnaire ou de la levrette avec un coussin de manière excessivement dramatique.'),
  GameCard(type: 'ACTION', difficulty: 'HOT', content: 'Laisse le joueur de ton choix te donner une petite fessée.'),
  GameCard(type: 'ACTION', difficulty: 'HOT', content: 'Lèche langoureusement ton propre doigt en regardant la personne de ton choix droit dans les yeux.'),
  GameCard(type: 'ACTION', difficulty: 'HOT', content: 'Embrasse très lentement et tendrement le dos de la main, puis le creux du poignet de la fille de ton choix.', targetGender: 'M'),
  GameCard(type: 'ACTION', difficulty: 'HOT', content: 'Assieds-toi à califourchon sur les genoux du garçon de ton choix et soutiens son regard en silence pendant 15 secondes.', targetGender: 'F'),

  GameCard(type: 'VERITE', difficulty: 'HOT', content: 'As-tu déjà fantasmé sur un(e) prof, un(e) collègue ou un(e) supérieur(e) ?'),
  GameCard(type: 'VERITE', difficulty: 'HOT', content: 'Trouves-tu quelqu\'un du groupe particulièrement attirant sexuellement ? Qui ?'),
  GameCard(type: 'VERITE', difficulty: 'HOT', content: 'Quel est ton fantasme le plus inavouable ou tabou ?'),
  GameCard(type: 'VERITE', difficulty: 'HOT', content: 'À quel âge as-tu perdu ta virginité ?'),
  GameCard(type: 'VERITE', difficulty: 'HOT', content: 'Quelle est la partie de ton corps que tu préfères montrer ou qu\'on te touche ?'),
  GameCard(type: 'VERITE', difficulty: 'HOT', content: 'As-tu déjà expérimenté (ou voulu expérimenter) le BDSM ? Si oui, quoi exactement ?'),
  GameCard(type: 'VERITE', difficulty: 'HOT', content: 'Quel est ton fétichisme le plus bizarre ou inattendu ?'),
  GameCard(type: 'VERITE', difficulty: 'HOT', content: 'As-tu déjà pensé à quelqu\'un d\'autre pendant que tu faisais l\'amour ?'),
  GameCard(type: 'VERITE', difficulty: 'HOT', content: 'Quel est le lieu public le plus insolite ou risqué où tu as fait l\'amour ?'),
  GameCard(type: 'VERITE', difficulty: 'HOT', content: 'Si tu devais tourner une sex-tape, quel serait le scénario, le décor ou ton rôle ?'),
  GameCard(type: 'VERITE', difficulty: 'HOT', content: 'Quelle est l\'initiative féminine au lit (ou pendant les préliminaires) qui te fait perdre le contrôle instantanément ?', targetGender: 'M'),
  GameCard(type: 'VERITE', difficulty: 'HOT', content: 'Quelle est la zone érogène de ton corps que les garçons oublient ou négligent beaucoup trop souvent selon toi ?', targetGender: 'F'),
];
// endregion


// ============================================================================
// SETUP SCREEN
// Initial interface to configure players and match duration.
// ============================================================================
// region --- SETUP SCREEN WIDGET ---

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});
  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  // --- State Variables ---
  int _currentIndex = 0;
  final List<GameCard> _currentDeck = List.from(allCards);
  final List<Player> _players = [];
  final TextEditingController _nameController = TextEditingController();
  String _selectedGender = 'M';
  double _selectedTurns = 20;

  // --- Logic Methods ---
  
  // Adds a new player to the game roster
  void _addPlayer() {
    if (_nameController.text.trim().isNotEmpty) {
      setState(() {
        _players.add(Player(name: _nameController.text.trim(), gender: _selectedGender));
        _nameController.clear();
      });
    }
  }

  // Resets scores and launches the main GameScreen
  void _startGame() {
    if (_players.length >= 2) {
      for (var player in _players) {
        player.score = 0;
      }
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => GameScreen(players: _players, deck: _currentDeck, maxTurns: _selectedTurns.toInt())
      ));
    }
  }

  // --- Build Methods ---
  
  // Main build for SetupScreen scaffolding and navigation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF050515), Color(0xFF1A1A40), Color(0xFF4B0082)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text(_currentIndex == 0 ? "Truth Or Shot" : "Créer une carte", 
                 style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
            Expanded(
              child: _currentIndex == 0 ? _buildPlayerSetup() : CreateCardScreen(onCardCreated: (c) => setState(() => _currentDeck.add(c))),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Joueurs'),
          BottomNavigationBarItem(icon: Icon(Icons.add_card), label: 'Créer'),
        ],
      ),
    );
  }

  // Builds the player creation list and game settings slider
  Widget _buildPlayerSetup() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(children: [
            _genderButton('M', '♂ Garçon', Colors.blue),
            const SizedBox(width: 10),
            _genderButton('F', '♀ Fille', Colors.pink),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: TextField(controller: _nameController, decoration: const InputDecoration(hintText: 'Prénom...', filled: true, fillColor: Colors.white10))),
            IconButton(onPressed: _addPlayer, icon: const Icon(Icons.add_circle, size: 40, color: Colors.green)),
          ]),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _players.length,
              itemBuilder: (context, i) => Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    Text(_players[i].gender == 'M' ? '♂' : '♀', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _players[i].gender == 'M' ? Colors.blue : Colors.pink)),
                    const SizedBox(width: 10),
                    Text(_players[i].name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => setState(() => _players.removeAt(i))),
                  ],
                ),
              ),
            ),
          ),
          
          if (_players.length >= 2) ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Text("Durée de la partie : ${_selectedTurns.toInt()} tours", style: const TextStyle(color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                  Slider(
                    value: _selectedTurns,
                    min: 5,
                    max: 50,
                    divisions: 9, 
                    activeColor: Colors.cyanAccent,
                    inactiveColor: Colors.white24,
                    onChanged: (val) => setState(() => _selectedTurns = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
              child: const Text('JOUER 🚀', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ]
        ],
      ),
    );
  }

  // Helper widget for gender selection styling
  Widget _genderButton(String g, String label, Color color) {
    return Expanded(child: GestureDetector(
      onTap: () => setState(() => _selectedGender = g),
      child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: _selectedGender == g ? color : Colors.white10, borderRadius: BorderRadius.circular(10)), child: Center(child: Text(label))),
    ));
  }
}
// endregion


// ============================================================================
// GAME SCREEN
// Core gameplay loop, turn management, and card animations.
// ============================================================================
// region --- GAME SCREEN WIDGET ---

class GameScreen extends StatefulWidget {
  final List<Player> players;
  final List<GameCard> deck;
  final int maxTurns; 

  const GameScreen({super.key, required this.players, required this.deck, required this.maxTurns});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // --- State Variables ---
  int _currentPlayerIndex = 0;
  int _currentTurnCount = 1;
  String? _chosenType;
  GameCard? _currentCard;
  final List<GameCard> _hiddenCards = [];
  final List<GameCard> _playedCards = [];
  bool _isTransitioning = false; 

  // --- Animation Controllers ---
  Offset _swipeOffset = Offset.zero;
  bool _isDragging = false;
  late AnimationController _drawController;
  late AnimationController _dealController;
  late Animation<double> _flipAnimation, _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  // Initializes controllers and animation curves
  @override
  void initState() {
    super.initState();
    _drawController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _dealController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(CurvedAnimation(parent: _drawController, curve: Curves.easeInOut));
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _drawController, curve: Curves.elasticOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(CurvedAnimation(parent: _drawController, curve: Curves.easeOutQuart));
  }

  // --- Game Logic Methods ---

  // Advances to the next player, increments round if necessary, or ends game
  void _nextTurn() {
    setState(() {
      _isTransitioning = true;
      _currentCard = null;
      _chosenType = null;
      _swipeOffset = Offset.zero;
      
      _currentPlayerIndex = (_currentPlayerIndex + 1) % widget.players.length;
      
      if (_currentPlayerIndex == 0) {
        _currentTurnCount++;
      }
    });

    if (_currentTurnCount > widget.maxTurns) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ScoreBoardScreen(players: widget.players)));
      return;
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _isTransitioning = false);
    });
  }

  // Handles successful completion of a card (no penalty)
  void _handleSuccess() => _nextTurn();
  
  // Handles refusal of a card (adds penalty shots to player score)
  void _handleFail() {
    setState(() => widget.players[_currentPlayerIndex].score += _currentCard!.shots);
    _nextTurn();
  }

  // Randomly draws a card based on chosen type, difficulty, and player gender
  void _drawCard(String difficulty) {
    final player = widget.players[_currentPlayerIndex];
    final allCategoryCards = widget.deck.where((c) => c.type == _chosenType && c.difficulty == difficulty && (c.targetGender == null || c.targetGender == player.gender) && !_hiddenCards.contains(c)).toList();
    var availableCards = allCategoryCards.where((c) => !_playedCards.contains(c)).toList();

    if (availableCards.isEmpty) {
      setState(() => _playedCards.removeWhere((c) => c.type == _chosenType && c.difficulty == difficulty));
      availableCards = allCategoryCards;
    }

    if (availableCards.isNotEmpty) {
      availableCards.shuffle();
      setState(() {
        _currentCard = availableCards.first;
        _playedCards.add(_currentCard!);
        _drawController.forward(from: 0.0);
      });
    }
  }

  // --- Build Methods ---

  // Main UI build handling background, swipe overlays, and the game/transition switcher
  @override
  Widget build(BuildContext context) {
    final currentPlayer = widget.players[_currentPlayerIndex];
    double valuesFait = (_swipeOffset.dx < -50) ? min(1.0, (_swipeOffset.dx.abs() - 50) / 100) : 0.0;
    double valuesRefuse = (_swipeOffset.dx > 50) ? min(1.0, (_swipeOffset.dx - 50) / 100) : 0.0;

    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [Color.fromARGB(255, 119, 0, 187), Color(0xFF1A1A40),  Color.fromARGB(255, 0, 195, 255), ],stops: [0.0, 0.5, 1.0],),),), 
          Container(color: Colors.black.withValues(alpha: 0.3)),
          
          if (_currentCard != null && !_isTransitioning) ...[
            IgnorePointer(child: Container(color: Colors.green.withValues(alpha: valuesFait * 0.8), alignment: Alignment.center, child: valuesFait > 0.1 ? Transform.rotate(angle: -0.2, child: const Text("FAIT ! 😎", style: TextStyle(fontSize: 60, fontWeight: FontWeight.w900, color: Colors.white))) : null)),
            IgnorePointer(child: Container(color: Colors.red.withValues(alpha: valuesRefuse * 0.8), alignment: Alignment.center, child: valuesRefuse > 0.1 ? Transform.rotate(angle: 0.2, child: const Text("REFUSÉ ! 🥴", style: TextStyle(fontSize: 60, fontWeight: FontWeight.w900, color: Colors.white))) : null)),
          ],
          
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: ScaleTransition(scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation), child: child));
            },
            child: _isTransitioning ? _buildTransitionScreen(currentPlayer) : _buildMainGameArea(currentPlayer),
          ),
        ],
      ),
    );
  }

  // Renders the glowing text transition shown between player turns
  Widget _buildTransitionScreen(Player currentPlayer) {
    return Center(
      key: const ValueKey('TransitionScreen'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("🔥 PRÉPARE-TOI 🔥", style: TextStyle(fontSize: 24, color: Colors.white70, letterSpacing: 4)),
          const SizedBox(height: 20),
          Text(currentPlayer.name.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(fontSize: 60, fontWeight: FontWeight.w900, color: currentPlayer.gender == 'M' ? Colors.cyanAccent : Colors.pinkAccent, shadows: [Shadow(color: currentPlayer.gender == 'M' ? Colors.cyan : Colors.pink, blurRadius: 20), Shadow(color: currentPlayer.gender == 'M' ? Colors.blue : Colors.purple, blurRadius: 40)])),
          const SizedBox(height: 20),
          const Text("C'est à ton tour de jouer...", style: TextStyle(fontSize: 20, color: Colors.white54, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  // Renders the main table layout including turn info, table mat, and action area
  Widget _buildMainGameArea(Player currentPlayer) {
    return SafeArea(
      key: const ValueKey('GameScreen'),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.home, size: 32, color: Colors.white70), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SetupScreen()))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
                  child: Text("Tour $_currentTurnCount / ${widget.maxTurns}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
                ),
              ],
            ),
          ),

          const Text("C'est au tour de", style: TextStyle(fontSize: 20, color: Colors.white70)),
          Text(currentPlayer.name, style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: currentPlayer.gender == 'M' ? Colors.blue : Colors.pink)),
          Text("Gorgées : ${currentPlayer.score} 🍺", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
          
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _chosenType == null
                  ? _buildActionTruthSelection()
                  : Stack(
                      key: const ValueKey('TapisArea'),
                      alignment: Alignment.center, 
                      clipBehavior: Clip.none,    
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.43,
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white24, width: 2),
                            boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 20, spreadRadius: 5)],
                            image: const DecorationImage(image: AssetImage('assets/tapis.jpg'), fit: BoxFit.cover),
                          ),
                        ),
                        if (_currentCard != null) _buildSwipeableCard()
                        else _buildDifficultySelection(),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Renders the drawn card with 3D flip and swipe gestures built-in
  Widget _buildSwipeableCard() {
    return AnimatedBuilder(
      animation: _drawController,
      builder: (context, child) {
        bool isFront = _flipAnimation.value >= (pi / 2);
        double angle = _flipAnimation.value;
        if (isFront) angle -= pi;
        String backImage = 'assets/card_green.png';
        if (_currentCard!.difficulty == 'FUN') backImage = 'assets/card_orange.png';
        if (_currentCard!.difficulty == 'HOT') backImage = 'assets/card_red.png';

        return SlideTransition(
          position: _slideAnimation,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onPanStart: _drawController.isAnimating ? null : (d) => setState(() => _isDragging = true),
              onPanUpdate: _drawController.isAnimating ? null : (d) => setState(() => _swipeOffset += d.delta),
              onPanEnd: _drawController.isAnimating ? null : (d) {
                setState(() => _isDragging = false);
                if (_swipeOffset.dx < -120) {_handleSuccess();}
                else if (_swipeOffset.dx > 120) {_handleFail();}
                else {_swipeOffset = Offset.zero;}
              },
              child: AnimatedContainer(
                duration: _isDragging ? Duration.zero : const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                transform: Matrix4.translationValues(_swipeOffset.dx, _swipeOffset.dy, 0)..rotateZ(_swipeOffset.dx / 1000),
                child: Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.identity()..setEntry(3, 2, 0.0015)..rotateY(angle),
                  child: isFront ? _buildCardFront() : _buildCardBack(backImage),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Renders the readable front face of the card (neon borders and text)
  Widget _buildCardFront() {
    Color accentColor = _currentCard!.difficulty == 'SOFT' ? Colors.greenAccent : _currentCard!.difficulty == 'FUN' ? Colors.orangeAccent : Colors.redAccent;

    return Container(
      width: 300,
      height: 450,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF050515).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.6), width: 2),
        boxShadow: [BoxShadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 2)],
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${_currentCard!.type} • ${_currentCard!.difficulty}", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              const SizedBox(height: 30),
              Text(_currentCard!.content, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white, height: 1.4)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
                child: Text("Pénalité : ${_currentCard!.shots} 🍺", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("👈 Fait", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold)),
                  Text("Refusé 👉", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
          Positioned(
            right: -10,
            top: -10,
            child: IconButton(icon: const Icon(Icons.thumb_down, color: Colors.redAccent), onPressed: () => setState(() { _hiddenCards.add(_currentCard!); _nextTurn(); })),
          ),
        ],
      ),
    );
  }

  // Renders the image-based back face of the card
  Widget _buildCardBack(String imagePath) {
    return Container(width: 300, height: 450, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 20, spreadRadius: 2)], image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover)));
  }

  // Renders the 3 difficulty decks distributed by the virtual dealer
  Widget _buildDifficultySelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDealtDifficultyCard('SOFT', 'assets/card_green.png', 0.0),
        _buildDealtDifficultyCard('FUN', 'assets/card_orange.png', 0.2),
        _buildDealtDifficultyCard('HOT', 'assets/card_red.png', 0.4),
      ],
    );
  }

  // Animated sub-widget representing a single deck sliding onto the table
  Widget _buildDealtDifficultyCard(String difficulty, String imagePath, double delay) {
    Animation<Offset> slide = Tween<Offset>(begin: const Offset(0, 2.0), end: Offset.zero).animate(CurvedAnimation(parent: _dealController, curve: Interval(delay, 1.0, curve: Curves.easeOutBack)));
    return SlideTransition(
      position: slide,
      child: GestureDetector(
        onTap: () => _drawCard(difficulty),
        child: Container(
          width: 110, height: 165, 
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover), boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 5))]),
        ),
      ),
    );
  }

  // Initial choice buttons appearing at the very beginning of a player's turn
  Widget _buildActionTruthSelection() {
    return Padding(
      key: const ValueKey('ActionTruthButtons'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: ElevatedButton(onPressed: () { setState(() => _chosenType = 'ACTION'); _dealController.forward(from: 0.0); }, style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20),backgroundColor: const Color(0xFF00E5FF).withValues(alpha: 0.2), side: const BorderSide(color: Color(0xFF00E5FF), width: 2), ), child: const Text('ACTION', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
          const SizedBox(width: 20),
          Expanded(child: ElevatedButton(onPressed: () { setState(() => _chosenType = 'VERITE'); _dealController.forward(from: 0.0); }, style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20),backgroundColor: const Color(0xFFD500F9).withValues(alpha: 0.2), side: const BorderSide(color: Color(0xFFD500F9), width: 2), ), child: const Text('VÉRITÉ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
        ],
      ),
    );
  }
}
// endregion


// ============================================================================
// SCOREBOARD SCREEN
// Final screen displaying the ranking, penalties, and funny titles.
// ============================================================================
// region --- SCOREBOARD SCREEN WIDGET ---
class ScoreBoardScreen extends StatelessWidget {
  final List<Player> players;
  const ScoreBoardScreen({super.key, required this.players});

  // --- Logic Method ---
  
  // Generates a funny title based on the player's ranking and total shots
  String _getPlayerTitle(int rank, int score, int totalPlayers) {
    if (score == 0) return "L'Ange 😇 (Même pas soif)";
    if (rank == 0) {
      if (score >= 15) return "L'Éponge Légendaire 🧽";
      return "Le Pilier de Bar 🍺";
    }
    if (rank == totalPlayers - 1) {
      return "Le Sam (Capitaine de soirée) 🚗";
    }
    if (score <= 3) return "L'Esquiveur 🥷";
    if (score <= 8) return "Vitesse de Croisière 🛥️";
    return "Bien Chaud 🔥";
  }

  // --- Build Method ---
  
  // Renders the final podium UI and replay button
  @override
  Widget build(BuildContext context) {
    final sortedPlayers = List<Player>.from(players)..sort((a, b) => b.score.compareTo(a.score));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF050515), Color(0xFF1A1A40), Color(0xFF4B0082)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text("🏆 FIN DE PARTIE 🏆", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.cyanAccent, shadows: [Shadow(color: Colors.cyan, blurRadius: 15)])),
              const SizedBox(height: 10),
              const Text("Qui a pris le plus cher ce soir ?", style: TextStyle(fontSize: 18, color: Colors.white70, fontStyle: FontStyle.italic)),
              const SizedBox(height: 40),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    itemCount: sortedPlayers.length,
                    itemBuilder: (context, i) {
                      final player = sortedPlayers[i];
                      final isFirst = i == 0;
                      final String playerTitle = _getPlayerTitle(i, player.score, sortedPlayers.length);
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: isFirst ? Colors.redAccent : Colors.white24, width: isFirst ? 2 : 1),
                          boxShadow: isFirst ? [const BoxShadow(color: Colors.redAccent, blurRadius: 15)] : null,
                        ),
                        child: Row(
                          children: [
                            Text("#${i + 1}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isFirst ? Colors.redAccent : Colors.white54)),
                            const SizedBox(width: 20),
                            Text(player.gender == 'M' ? '♂' : '♀', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: player.gender == 'M' ? Colors.blue : Colors.pink)),
                            const SizedBox(width: 15),
                            
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(player.name, style: TextStyle(fontSize: 22, fontWeight: isFirst ? FontWeight.bold : FontWeight.normal, color: Colors.white)),
                                  const SizedBox(height: 4),
                                  Text(playerTitle, style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: isFirst ? Colors.redAccent : Colors.cyanAccent)),
                                ],
                              )
                            ),
                            
                            Text("${player.score} 🍺", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: isFirst ? Colors.redAccent : Colors.pinkAccent)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh, size: 28),
                  label: const Text('REJOUER', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SetupScreen()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// endregion


// ============================================================================
// CREATE CARD SCREEN
// Interface allowing users to inject custom challenges into the deck.
// ============================================================================
// region --- CREATE CARD SCREEN WIDGET ---
class CreateCardScreen extends StatefulWidget {
  final Function(GameCard) onCardCreated;
  const CreateCardScreen({super.key, required this.onCardCreated});
  @override
  State<CreateCardScreen> createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends State<CreateCardScreen> {
  // --- State Variables ---
  final _contentController = TextEditingController();
  String _type = 'ACTION';
  String _difficulty = 'SOFT';

  // --- Build Method ---
  
  // Renders the input form for new custom cards
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(20), child: Column(children: [
      TextField(controller: _contentController, decoration: const InputDecoration(labelText: 'Ton défi :', filled: true), maxLines: 2),
      const SizedBox(height: 10),
      DropdownButtonFormField(initialValue: _type, items: const [DropdownMenuItem(value: 'ACTION', child: Text('ACTION')), DropdownMenuItem(value: 'VERITE', child: Text('VERITE'))], onChanged: (v) => setState(() => _type = v!)),
      DropdownButtonFormField(initialValue: _difficulty, items: const [DropdownMenuItem(value: 'SOFT', child: Text('SOFT')), DropdownMenuItem(value: 'FUN', child: Text('FUN')), DropdownMenuItem(value: 'HOT', child: Text('HOT'))], onChanged: (v) => setState(() => _difficulty = v!)),
      const SizedBox(height: 20),
      ElevatedButton(onPressed: () { 
        if (_contentController.text.isNotEmpty) {
          widget.onCardCreated(GameCard(type: _type, difficulty: _difficulty, content: _contentController.text)); 
          _contentController.clear(); 
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Carte ajoutée !"))); 
        }
      }, child: const Text('AJOUTER')),
    ]));
  }
}
// endregion