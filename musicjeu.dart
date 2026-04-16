import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MyJeu extends StatefulWidget {
  final String niveau;
  final int tempsParQuestion;

  const MyJeu({super.key, required this.niveau, required this.tempsParQuestion});

  @override
  State<MyJeu> createState() => _MyJeuState();
}

class _MyJeuState extends State<MyJeu> {
  int score       = 0;
  String message  = '';
  int? indexCible;
  int indexClique = -1;
  bool enAttente  = false;

  late int tempsRestant;
  Timer? _timer;

  int get pointsBonne =>
      widget.niveau == 'Facile' ? 10 : widget.niveau == 'Moyen' ? 15 : 20;

  // ── Pool complet : 25 artistes ──────────────────────────────────────────────
  final List<Map<String, String>> _tousLesArtistes = [
    {"nom": "Aya Nakamura",    "image": "assets/images/aya.jpg"},
    {"nom": "Gazo",            "image": "assets/images/gazo.jpg"},
    {"nom": "Gims",            "image": "assets/images/Djims.jpg"},
    {"nom": "Himra",           "image": "assets/images/himra.jpg"},
    {"nom": "Naza",            "image": "assets/images/naza.jpg"},
    {"nom": "Ninho",           "image": "assets/images/ninho.jpg"},
    {"nom": "Niska",           "image": "assets/images/niska.jpg"},
    {"nom": "Ronisia",         "image": "assets/images/ronisia.jpg"},
    {"nom": "Tiakola",         "image": "assets/images/mon_tiako.jpg"},
    {"nom": "Tyla",            "image": "assets/images/tyla.jpg"},
    {"nom": "Davido",          "image": "assets/images/Davido.jpg"},
    {"nom": "Vano Baby",       "image": "assets/images/Vano.jpg"},
    {"nom": "Ayra Starr",      "image": "assets/images/Ayra_Star.jpg"},
    {"nom": "Didi B",          "image": "assets/images/Didi_B.jpg"},
    {"nom": "Rihanna",         "image": "assets/images/Rihanna.jpg"},
    {"nom": "Rema",            "image": "assets/images/Rema.jpg"},
    {"nom": "Cardi B",         "image": "assets/images/Cardi_B.jpg"},
    {"nom": "Nikanor",         "image": "assets/images/Nikanor.jpg"},
    {"nom": "Angélique Kidjo", "image": "assets/images/Angelique_Kidjo.jpg"},
    {"nom": "Tems",            "image": "assets/images/Tems.jpg"},
    {"nom": "Youssoupha",      "image": "assets/images/Youssoupha.jpg"},
    {"nom": "Damso",           "image": "assets/images/Damso.jpg"},
    {"nom": "Axel Merryl",     "image": "assets/images/axel.jpg"},
    {"nom": "Stromae",         "image": "assets/images/Stromae.jpg"},
    {"nom": "Dadju",           "image": "assets/images/Dadju.jpg"},
  ];

  // ── Les 9 artistes affichés dans la grille ─────────────────────────────────
  List<Map<String, String>> _grilleActuelle = [];

  // ── Pioche 9 artistes aléatoires parmi les 25 ─────────────────────────────
  void _piocherArtistes() {
    final pool = List<Map<String, String>>.from(_tousLesArtistes)
      ..shuffle(Random());
    _grilleActuelle = pool.take(9).toList();
  }

  @override
  void initState() {
    super.initState();
    nouveauTour();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _demarrerChrono() {
    _timer?.cancel();
    tempsRestant = widget.tempsParQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => tempsRestant--);
      if (tempsRestant <= 0) {
        t.cancel();
        _finDuJeu();
      }
    });
  }

  // ── Nouveau tour = nouveau tirage de 9 + nouvelle cible ────────────────────
  void nouveauTour() {
    if (!mounted) return;
    _piocherArtistes(); // ← tirage aléatoire à chaque question
    setState(() {
      indexCible  = Random().nextInt(_grilleActuelle.length);
      indexClique = -1;
      enAttente   = false;
      message     = '';
    });
    _demarrerChrono();
  }

  void resetJeu() {
    _timer?.cancel();
    setState(() { score = 0; message = ''; });
    nouveauTour();
  }

  void _finDuJeu() {
    _timer?.cancel();
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _dialogFinJeu(),
    );
  }

  Color _couleurBordure(int index) {
    if (indexClique == -1) return Colors.white12;
    if (index == indexCible)  return Colors.greenAccent;
    if (index == indexClique) return Colors.redAccent;
    return Colors.white12;
  }

  Color get _couleurChrono {
    if (tempsRestant > widget.tempsParQuestion * 0.5) return Colors.greenAccent;
    if (tempsRestant > widget.tempsParQuestion * 0.25) return Colors.orange;
    return Colors.redAccent;
  }

  Color _niveauCouleur() {
    switch (widget.niveau) {
      case 'Facile':    return const Color(0xFF1DB954);
      case 'Moyen':     return const Color(0xFFFF9800);
      case 'Difficile': return const Color(0xFFE53935);
      default:          return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0D0D), Color(0xFF1A0533), Color(0xFF0D0D0D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              // ── BARRE DU HAUT ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
                      onPressed: () { _timer?.cancel(); Navigator.pop(context, score); },
                    ),
                    Column(
                      children: [
                        const Text('MODE JEU', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 2)),
                        Text(widget.niveau.toUpperCase(), style: TextStyle(color: _niveauCouleur(), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
                      onPressed: resetJeu,
                    ),
                  ],
                ),
              ),

              // ── SCORE + CHRONO ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFB44FFF), size: 18),
                            const SizedBox(width: 6),
                            Text('SCORE : $score', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFB44FFF))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                      decoration: BoxDecoration(
                        color: _couleurChrono.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _couleurChrono.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer_rounded, color: _couleurChrono, size: 18),
                          const SizedBox(width: 5),
                          Text('${tempsRestant}s', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _couleurChrono)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // ── MESSAGE BRAVO / ERREUR ──
              if (message.isNotEmpty)
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: message.contains('BRAVO') ? Colors.greenAccent : Colors.redAccent,
                  ),
                  textAlign: TextAlign.center,
                ),

              // ── QUESTION ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  indexCible != null
                      ? 'Trouve : ${_grilleActuelle[indexCible!]['nom']!} 🎯'
                      : '',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ),

              // ── GRILLE 3×3 (9 artistes aléatoires) ────────────────────────
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: _grilleActuelle.length, // 9
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (enAttente) return;
                        _timer?.cancel();
                        setState(() {
                          enAttente   = true;
                          indexClique = index;
                          if (index == indexCible) {
                            score  += pointsBonne;
                            message = '✅ BRAVO ! +$pointsBonne pts';
                          } else {
                            score   = max(0, score - 5);
                            message = '❌ ERREUR ! -5 pts';
                          }
                        });
                        Future.delayed(const Duration(milliseconds: 1500), nouveauTour);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _couleurBordure(index),
                            width: indexClique != -1 && (index == indexCible || index == indexClique) ? 3.5 : 1.5,
                          ),
                          image: DecorationImage(
                            image: AssetImage(_grilleActuelle[index]['image']!),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: indexClique != -1 && index == indexCible
                              ? [BoxShadow(color: Colors.greenAccent.withOpacity(0.5), blurRadius: 12)]
                              : [],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ── BOUTON RECOMMENCER ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: resetJeu,
                    icon: const Icon(Icons.replay_rounded, size: 18),
                    label: const Text('RECOMMENCER', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A2A2A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white12)),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogFinJeu() {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('⏱ Temps écoulé !', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Partie terminée !', style: TextStyle(color: Colors.white60, fontSize: 14)),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFB44FFF).withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFB44FFF).withOpacity(0.4)),
            ),
            child: Column(
              children: [
                const Text('SCORE FINAL', style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 2)),
                const SizedBox(height: 6),
                Text('$score pts', style: const TextStyle(color: Color(0xFFB44FFF), fontSize: 36, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('Niveau : ${widget.niveau}', style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton.icon(
          onPressed: () { Navigator.pop(context); resetJeu(); },
          icon: const Icon(Icons.replay_rounded, size: 18),
          label: const Text('REJOUER', style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB44FFF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: () {
            _timer?.cancel();
            Navigator.pop(context);
            Navigator.pop(context, score);
          },
          icon: const Icon(Icons.list_rounded, size: 18, color: Colors.white70),
          label: const Text('NIVEAUX', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}