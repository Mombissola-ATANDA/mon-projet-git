import 'package:flutter/material.dart';
import 'package:winx/musicjeu.dart';

class NiveauPage extends StatelessWidget {
  final Map<String, int> meilleurScores;
  final Function(String niveau, int score) onNouveauScore;

  const NiveauPage({
    super.key,
    required this.meilleurScores,
    required this.onNouveauScore,
  });

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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text('CHOISIR UN NIVEAU',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 3)),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text('🎯 Quel niveau ?',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 6),
              const Text('25 artistes — mélange automatique',
                style: TextStyle(fontSize: 13, color: Colors.white38)),

              const SizedBox(height: 40),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _carteNiveau(context,
                        niveau: 'Facile', emoji: '😊', temps: 15,
                        couleur: const Color(0xFF1DB954),
                        description: '15 secondes par question\n+10 pts si bonne réponse / -5 pts si erreur',
                        meilleur: meilleurScores['Facile'] ?? 0),
                      const SizedBox(height: 16),
                      _carteNiveau(context,
                        niveau: 'Moyen', emoji: '😏', temps: 8,
                        couleur: const Color(0xFFFF9800),
                        description: '8 secondes par question\n+15 pts si bonne réponse / -5 pts si erreur',
                        meilleur: meilleurScores['Moyen'] ?? 0),
                      const SizedBox(height: 16),
                      _carteNiveau(context,
                        niveau: 'Difficile', emoji: '🔥', temps: 3,
                        couleur: const Color(0xFFE53935),
                        description: '3 secondes par question\n+20 pts si bonne réponse / -5 pts si erreur',
                        meilleur: meilleurScores['Difficile'] ?? 0),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _carteNiveau(BuildContext context, {
    required String niveau,
    required String emoji,
    required int temps,
    required Color couleur,
    required String description,
    required int meilleur,
  }) {
    return GestureDetector(
      onTap: () async {
        final resultat = await Navigator.push<int>(
          context,
          MaterialPageRoute(builder: (_) => MyJeu(niveau: niveau, tempsParQuestion: temps)),
        );
        if (resultat != null && resultat > (meilleurScores[niveau] ?? 0)) {
          onNouveauScore(niveau, resultat);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: couleur.withOpacity(0.6), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: couleur.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 26))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(niveau.toUpperCase(),
                    style: TextStyle(color: couleur, fontWeight: FontWeight.w900, fontSize: 17, letterSpacing: 2)),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(color: Colors.white54, fontSize: 12, height: 1.5)),
                ],
              ),
            ),
            Column(
              children: [
                const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 18),
                const SizedBox(height: 2),
                Text('$meilleur', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 15)),
                const Text('record', style: TextStyle(color: Colors.white30, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}