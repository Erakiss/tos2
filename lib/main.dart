import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'package:tos2/models/player.dart';
import 'package:tos2/models/game_card.dart';
import 'package:tos2/data/deck_data.dart';

// ============================================================================
// MAIN ENTRY POINT
// ============================================================================
void main() {
  runApp(const TruthOrShotApp());
}

// region --- APP ROOT WIDGET ---
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
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
// endregion

// ============================================================================
// MODELS
// ============================================================================
// region --- MODELS ---

// Model pour le bouton Retour
class TurnRecord {
  final int playerIndex;
  final GameCard card;
  final String displayContent;
  final bool failed;
  final int turnCount;

  TurnRecord(this.playerIndex, this.card, this.displayContent, this.failed, this.turnCount);
}
// endregion


// ============================================================================
// SPLASH SCREEN
// ============================================================================
// region --- SPLASH SCREEN WIDGET ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(context, PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, _, _) => const SetupScreen(),
          transitionsBuilder: (_, animation, _ , child) => FadeTransition(opacity: animation, child: child),
        ));
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF050515), Color(0xFF1A1A40), Color(0xFF4B0082)]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 180, height: 180,
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.3), blurRadius: 40, spreadRadius: 10)]),
                child: ClipOval(child: Image.asset('assets/app_icon.png', fit: BoxFit.cover)),
              ),
            ),
            const SizedBox(height: 50),
            const Text("TRUTH OR SHOT", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.cyanAccent, letterSpacing: 3)),
            const SizedBox(height: 20),
            const SizedBox(width: 40, height: 40, child: CircularProgressIndicator(color: Colors.pinkAccent, strokeWidth: 3)),
          ],
        ),
      ),
    );
  }
}
// endregion

// ============================================================================
// SETUP SCREEN
// ============================================================================
// region --- SETUP SCREEN WIDGET ---
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});
  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _currentIndex = 0;
  final List<GameCard> _currentDeck = List.from(allCards);
  final List<Player> _players = [];
  final TextEditingController _nameController = TextEditingController();
  String _selectedGender = 'M';
  double _selectedTurns = 20;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  // --- LOCAL STORAGE LOGIC ---
  Future<void> _loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString('saved_players');
    if (saved != null) {
      final List<dynamic> decoded = jsonDecode(saved);
      setState(() {
        _players.clear();
        _players.addAll(decoded.map((p) => Player.fromJson(p)));
      });
    }
  }

  Future<void> _savePlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(_players.map((p) => p.toJson()).toList());
    prefs.setString('saved_players', encodedData);
  }

  void _addPlayer() {
    if (_nameController.text.trim().isNotEmpty) {
      setState(() {
        _players.add(Player(name: _nameController.text.trim(), gender: _selectedGender));
        _nameController.clear();
        _savePlayers(); // Sauvegarde à chaque ajout
      });
    }
  }

  void _removePlayer(int index) {
    setState(() {
      _players.removeAt(index);
      _savePlayers(); // Sauvegarde à chaque suppression
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF050515), Color(0xFF1A1A40), Color(0xFF4B0082)]),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text(_currentIndex == 0 ? "Truth Or Shot" : "Créer une carte", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
            Expanded(child: _currentIndex == 0 ? _buildPlayerSetup() : CreateCardScreen(onCardCreated: (c) => setState(() => _currentDeck.add(c)))),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Joueurs'), BottomNavigationBarItem(icon: Icon(Icons.add_card), label: 'Créer')],
      ),
    );
  }

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
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white24)),
                child: Row(
                  children: [
                    Text(_players[i].gender == 'M' ? '♂' : '♀', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _players[i].gender == 'M' ? Colors.blue : Colors.pink)),
                    const SizedBox(width: 10),
                    Text(_players[i].name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => _removePlayer(i)),
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
                  Slider(value: _selectedTurns, min: 5, max: 50, divisions: 9, activeColor: Colors.cyanAccent, inactiveColor: Colors.white24, onChanged: (val) => setState(() => _selectedTurns = val)),
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
  int _currentPlayerIndex = 0;
  int _currentTurnCount = 1;
  String? _chosenType;
  GameCard? _currentCard;
  String? _currentDisplayContent; // Texte formaté avec les noms injectés
  
  final List<GameCard> _hiddenCards = [];
  final List<GameCard> _playedCards = [];
  final List<TurnRecord> _history = []; // Historique pour le bouton Undo
  
  bool _isTransitioning = false; 

  Offset _swipeOffset = Offset.zero;
  bool _isDragging = false;
  late AnimationController _drawController;
  late AnimationController _dealController;
  late Animation<double> _flipAnimation, _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _drawController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _dealController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(CurvedAnimation(parent: _drawController, curve: Curves.easeInOut));
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _drawController, curve: Curves.elasticOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(CurvedAnimation(parent: _drawController, curve: Curves.easeOutQuart));
  }

  // --- DYNAMIC INJECTION LOGIC ---
  String _processCardContent(String content, Player currentPlayer) {
    if (!content.contains('{TARGET}')) return content;
    
    // Cherche d'abord quelqu'un du sexe opposé
    List<Player> validTargets = widget.players.where((p) => p.name != currentPlayer.name && p.gender != currentPlayer.gender).toList();
    
    // S'il n'y en a pas (ex: que des gars), prend n'importe qui d'autre
    if (validTargets.isEmpty) {
      validTargets = widget.players.where((p) => p.name != currentPlayer.name).toList();
    }
    
    validTargets.shuffle();
    String targetName = validTargets.isNotEmpty ? validTargets.first.name : "quelqu'un";
    
    return content.replaceAll('{TARGET}', targetName);
  }

  void _recordTurn(bool failed) {
    _history.add(TurnRecord(_currentPlayerIndex, _currentCard!, _currentDisplayContent!, failed, _currentTurnCount));
  }

  void _undoTurn() {
    if (_history.isEmpty) return;
    final last = _history.removeLast();
    setState(() {
      // Restaure les variables
      _currentPlayerIndex = last.playerIndex;
      _currentCard = last.card;
      _currentDisplayContent = last.displayContent;
      _currentTurnCount = last.turnCount;
      _chosenType = last.card.type;
      
      // Annule la pénalité si c'était un refus
      if (last.failed) widget.players[_currentPlayerIndex].score -= last.card.shots;
      
      _isTransitioning = false;
      _swipeOffset = Offset.zero;
      
      // Assure que la carte est visible (remet l'animation à la fin)
      _drawController.value = 1.0; 
    });
  }

  void _nextTurn() {
    setState(() {
      _isTransitioning = true;
      _currentCard = null;
      _chosenType = null;
      _swipeOffset = Offset.zero;
      
      _currentPlayerIndex = (_currentPlayerIndex + 1) % widget.players.length;
      if (_currentPlayerIndex == 0) _currentTurnCount++;
    });

    if (_currentTurnCount > widget.maxTurns) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ScoreBoardScreen(players: widget.players)));
      return;
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _isTransitioning = false);
    });
  }

  void _handleSuccess() {
    _recordTurn(false);
    _nextTurn();
  }
  
  void _handleFail() {
    _recordTurn(true);
    setState(() => widget.players[_currentPlayerIndex].score += _currentCard!.shots);
    _nextTurn();
  }

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
        // On génère et fixe le texte injecté ici pour qu'il ne change pas à chaque frame
        _currentDisplayContent = _processCardContent(_currentCard!.content, player);
        _playedCards.add(_currentCard!);
        _drawController.forward(from: 0.0);
      });
    }
  }

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
            transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(opacity: animation, child: ScaleTransition(scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation), child: child)),
            child: _isTransitioning ? _buildTransitionScreen(currentPlayer) : _buildMainGameArea(currentPlayer),
          ),
        ],
      ),
    );
  }

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
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.home, size: 32, color: Colors.white70), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SetupScreen()))),
                    // --- NOUVEAU BOUTON UNDO ---
                    if (_history.isNotEmpty && _currentCard == null)
                      IconButton(
                        icon: const Icon(Icons.undo, size: 30, color: Colors.cyanAccent), 
                        onPressed: _undoTurn,
                        tooltip: "Annuler le dernier tour",
                      ),
                  ],
                ),
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

  Widget _buildCardFront() {
    Color accentColor = _currentCard!.difficulty == 'SOFT' ? Colors.greenAccent : _currentCard!.difficulty == 'FUN' ? Colors.orangeAccent : Colors.redAccent;

    return Container(
      width: 300, height: 450, padding: const EdgeInsets.all(25),
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
              // --- UTILISATION DU TEXTE INJECTÉ ICI ---
              Text(_currentDisplayContent ?? _currentCard!.content, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white, height: 1.4)),
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
            right: -10, top: -10,
            child: IconButton(icon: const Icon(Icons.thumb_down, color: Colors.redAccent), onPressed: () { 
              _hiddenCards.add(_currentCard!); 
              _recordTurn(false); // Le ban n'est pas une pénalité, juste on passe
              _nextTurn(); 
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(String imagePath) {
    return Container(width: 300, height: 450, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 20, spreadRadius: 2)], image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover)));
  }

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

  Widget _buildDealtDifficultyCard(String difficulty, String imagePath, double delay) {
    Animation<Offset> slide = Tween<Offset>(begin: const Offset(0, 2.0), end: Offset.zero).animate(CurvedAnimation(parent: _dealController, curve: Interval(delay, 1.0, curve: Curves.easeOutBack)));
    return SlideTransition(
      position: slide,
      child: GestureDetector(
        onTap: () => _drawCard(difficulty),
        child: Container(width: 110, height: 165, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover), boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 5))])),
      ),
    );
  }

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
// ============================================================================
// region --- SCOREBOARD SCREEN WIDGET ---
class ScoreBoardScreen extends StatelessWidget {
  final List<Player> players;
  const ScoreBoardScreen({super.key, required this.players});

  String _getPlayerTitle(int rank, int score, int totalPlayers) {
    if (score == 0) return "L'Ange 😇 (Même pas soif)";
    if (rank == 0) {
      if (score >= 15) return "L'Éponge Légendaire 🧽";
      return "Le Pilier de Bar 🍺";
    }
    if (rank == totalPlayers - 1) return "Le Sam (Capitaine de soirée) 🚗";
    if (score <= 3) return "L'Esquiveur 🥷";
    if (score <= 8) return "Vitesse de Croisière 🛥️";
    return "Bien Chaud 🔥";
  }

  @override
  Widget build(BuildContext context) {
    final sortedPlayers = List<Player>.from(players)..sort((a, b) => b.score.compareTo(a.score));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF050515), Color(0xFF1A1A40), Color(0xFF4B0082)])),
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
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: isFirst ? Colors.redAccent : Colors.white24, width: isFirst ? 2 : 1)),
                        child: Row(
                          children: [
                            Text("#${i + 1}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isFirst ? Colors.redAccent : Colors.white54)),
                            const SizedBox(width: 20),
                            Text(player.gender == 'M' ? '♂' : '♀', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: player.gender == 'M' ? Colors.blue : Colors.pink)),
                            const SizedBox(width: 15),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(player.name, style: TextStyle(fontSize: 22, fontWeight: isFirst ? FontWeight.bold : FontWeight.normal, color: Colors.white)), const SizedBox(height: 4), Text(playerTitle, style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: isFirst ? Colors.redAccent : Colors.cyanAccent))])),
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
                child: ElevatedButton.icon(icon: const Icon(Icons.refresh, size: 28), label: const Text('REJOUER', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SetupScreen()))),
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
// ============================================================================
// region --- CREATE CARD SCREEN WIDGET ---
class CreateCardScreen extends StatefulWidget {
  final Function(GameCard) onCardCreated;
  const CreateCardScreen({super.key, required this.onCardCreated});
  @override
  State<CreateCardScreen> createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends State<CreateCardScreen> {
  final _contentController = TextEditingController();
  String _type = 'ACTION';
  String _difficulty = 'SOFT';

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