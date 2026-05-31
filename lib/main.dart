import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const TruthOrShotApp());
}

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

// --- MODÈLES ---
class Player {
  String name;
  String gender;
  int score;
  Player({required this.name, required this.gender, this.score = 0});
}

class GameCard {
  final String type;
  final String difficulty;
  final String content;
  final String? targetGender;

  GameCard({required this.type, required this.difficulty, required this.content, this.targetGender});

  // Le calcul automatique : plus besoin de stocker la valeur !
  int get shots {
    switch (difficulty) {
      case 'SOFT': return 1;
      case 'FUN': return 2;
      case 'HOT': return 3;
      default: return 1;
    }
  }
}

// --- BASE DE DONNÉES ---
  final List<GameCard> allCards = [
  // --- SOFT ---
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

  // --- FUN ---
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

  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Entre un(e) militant(e) d\'extrême gauche et un(e) militant(e) d\'extrême droite, avec qui passerais-tu la nuit si tu étais obligé(e) ?'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Qui dans la pièce a les opinions politiques ou sociales les plus éclatées/problématiques selon toi ?'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'As-tu déjà profité d\'un cliché sexiste sur les femmes pour obtenir ce que tu voulais ?', targetGender: 'F'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'As-tu déjà prétendu coder ou être à fond dans ton télé-travail alors que tu faisais complètement autre chose ?'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Si tu devais faire l\'amour avec quelqu\'un qui a une tête d\'animal, tu choisirais quel animal ?'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Raconte la plus grande honte publique de ta vie.'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Quelle est la chose la plus illégale que tu aies faite ?'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Si tu pouvais être invisible pendant 1 heure, que ferais-tu de totalement immoral ou absurde ?'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Quel est le pire tue-l\'amour chez un garçon selon toi ?', targetGender: 'F'),
  GameCard(type: 'VERITE', difficulty: 'FUN', content: 'Quel est le pire tue-l\'amour chez une fille selon toi ?', targetGender: 'M'),

  // --- HOT ---
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
];

// ================= SETUP SCREEN =================
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

  void _addPlayer() {
    if (_nameController.text.trim().isNotEmpty) {
      setState(() {
        _players.add(Player(name: _nameController.text.trim(), gender: _selectedGender));
        _nameController.clear();
      });
    }
  }

  void _startGame() {
    if (_players.length >= 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GameScreen(players: _players, deck: _currentDeck)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_currentIndex == 0 ? "Configuration Joueurs" : "Créer une carte")),
      body: _currentIndex == 0 ? _buildPlayerSetup() : CreateCardScreen(onCardCreated: (c) => setState(() => _currentDeck.add(c))),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Joueurs'),
          BottomNavigationBarItem(icon: Icon(Icons.add_card), label: 'Créer'),
        ],
      ),
    );
  }

  Widget _buildPlayerSetup() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(children: [
            Expanded(child: GestureDetector(onTap: () => setState(() => _selectedGender = 'M'), child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: _selectedGender == 'M' ? Colors.blue : Colors.grey[800], borderRadius: BorderRadius.circular(10)), child: const Center(child: Text('👦 Garçon'))))),
            const SizedBox(width: 10),
            Expanded(child: GestureDetector(onTap: () => setState(() => _selectedGender = 'F'), child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: _selectedGender == 'F' ? Colors.pink : Colors.grey[800], borderRadius: BorderRadius.circular(10)), child: const Center(child: Text('👧 Fille'))))),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: TextField(controller: _nameController, decoration: const InputDecoration(hintText: 'Prénom...', filled: true))),
            IconButton(onPressed: _addPlayer, icon: const Icon(Icons.add_circle, size: 40, color: Colors.green)),
          ]),
          Expanded(child: ListView.builder(itemCount: _players.length, itemBuilder: (context, i) => ListTile(title: Text(_players[i].name), trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _players.removeAt(i)))))),
          if (_players.length >= 2) ElevatedButton(onPressed: _startGame, style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20)), child: const Text('JOUER 🚀', style: TextStyle(fontSize: 20))),
        ],
      ),
    );
  }
}

// ================= GAME SCREEN =================
class GameScreen extends StatefulWidget {
  final List<Player> players;
  final List<GameCard> deck;
  const GameScreen({super.key, required this.players, required this.deck});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  int _currentPlayerIndex = 0;
  String? _chosenType;
  GameCard? _currentCard;
  final List<GameCard> _hiddenCards = [];
  final List<GameCard> _playedCards = [];
  
  Offset _swipeOffset = Offset.zero;
  bool _isDragging = false;
  late AnimationController _drawController;
  late Animation<double> _flipAnimation, _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _drawController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(CurvedAnimation(parent: _drawController, curve: Curves.easeInOut));
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _drawController, curve: Curves.elasticOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(CurvedAnimation(parent: _drawController, curve: Curves.easeOutQuart));
  }

  void _nextTurn() {
    setState(() {
      _currentPlayerIndex = (_currentPlayerIndex + 1) % widget.players.length;
      _chosenType = null;
      _currentCard = null;
      _swipeOffset = Offset.zero;
    });
  }

  void _handleSuccess() => _nextTurn();
  void _handleFail() {
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
          Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/tapis.jpg'), fit: BoxFit.cover))),
          Container(color: Colors.black.withValues(alpha: 0.6)),
          if (_currentCard != null) ...[
            IgnorePointer(child: Container(color: Colors.green.withValues(alpha: valuesFait * 0.8), alignment: Alignment.center, child: valuesFait > 0.1 ? Transform.rotate(angle: -0.2, child: const Text("FAIT ! 😎", style: TextStyle(fontSize: 60, fontWeight: FontWeight.w900, color: Colors.white))) : null)),
            IgnorePointer(child: Container(color: Colors.red.withValues(alpha: valuesRefuse * 0.8), alignment: Alignment.center, child: valuesRefuse > 0.1 ? Transform.rotate(angle: 0.2, child: const Text("REFUSÉ ! 🥴", style: TextStyle(fontSize: 60, fontWeight: FontWeight.w900, color: Colors.white))) : null)),
          ],
          SafeArea(
            child: Column(
              children: [
                Align(alignment: Alignment.topLeft, child: IconButton(icon: const Icon(Icons.home, size: 32, color: Colors.white70), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SetupScreen())))),
                const Text("C'est au tour de", style: TextStyle(fontSize: 20, color: Colors.white70)),
                Text(currentPlayer.name, style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: currentPlayer.gender == 'M' ? Colors.blue : Colors.pink)),
                Text("Gorgées : ${currentPlayer.score} 🍺", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
                const Spacer(),
                if (_currentCard != null) _buildSwipeableCard()
                else if (_chosenType != null) _buildDifficultySelection()
                else _buildActionTruthSelection(),
                const Spacer(),
              ],
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
                if (_swipeOffset.dx < -120) _handleSuccess();
                else if (_swipeOffset.dx > 120) _handleFail();
                else _swipeOffset = Offset.zero;
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
    return Container(
      width: 300, height: 450, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: _currentCard!.difficulty == 'SOFT' ? Colors.green : _currentCard!.difficulty == 'FUN' ? Colors.orange : Colors.red, width: 15), boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 20, spreadRadius: 2)]),
      child: Stack(children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("${_currentCard!.type} • ${_currentCard!.difficulty}", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(_currentCard!.content, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 30),
          Text("Pénalité : ${_currentCard!.shots} 🍺", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.pinkAccent)),
          const Spacer(),
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("👈 Fait", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)), Text("Refusé 👉", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))]),
        ]),
        Positioned(right: 0, top: 0, child: IconButton(icon: const Icon(Icons.thumb_down, color: Colors.grey), onPressed: () => setState(() { _hiddenCards.add(_currentCard!); _nextTurn(); }))),
      ]),
    );
  }

  Widget _buildCardBack(String imagePath) {
    return Container(width: 300, height: 450, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 20, spreadRadius: 2)], image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover)));
  }

  Widget _buildDifficultySelection() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      _diffButton('SOFT', 'SOFT 🟢', 'assets/card_green.png'),
      _diffButton('FUN', 'FUN 🟠', 'assets/card_orange.png'),
      _diffButton('HOT', 'HOT 🔴', 'assets/card_red.png'),
    ]);
  }

  Widget _diffButton(String difficulty, String displayTitle, String imagePath) {
    return GestureDetector(
      onTap: () => _drawCard(difficulty),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 100, height: 150, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade800, width: 3), image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover))),
        const SizedBox(height: 12), Text(displayTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
      ]),
    );
  }

  Widget _buildActionTruthSelection() {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [
      Expanded(child: ElevatedButton(onPressed: () => setState(() => _chosenType = 'ACTION'), style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)), child: const Text('ACTION'))),
      const SizedBox(width: 20),
      Expanded(child: ElevatedButton(onPressed: () => setState(() => _chosenType = 'VERITE'), style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)), child: const Text('VÉRITÉ'))),
    ]));
  }
}

// ================= CREATE CARD SCREEN =================
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
      DropdownButtonFormField(value: _type, items: const [DropdownMenuItem(value: 'ACTION', child: Text('ACTION')), DropdownMenuItem(value: 'VERITE', child: Text('VERITE'))], onChanged: (v) => setState(() => _type = v!)),
      DropdownButtonFormField(value: _difficulty, items: const [DropdownMenuItem(value: 'SOFT', child: Text('SOFT')), DropdownMenuItem(value: 'FUN', child: Text('FUN')), DropdownMenuItem(value: 'HOT', child: Text('HOT'))], onChanged: (v) => setState(() => _difficulty = v!)),
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