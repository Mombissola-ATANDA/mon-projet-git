import 'package:flutter/material.dart';
import 'package:winx/NiveauPage.dart';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: HomePage(),
));

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map<String, int> meilleurScores = {
    'Facile':    0,
    'Moyen':     0,
    'Difficile': 0,
  };

  void _mettreAJourScore(String niveau, int score) {
    setState(() {
      if (score > (meilleurScores[niveau] ?? 0)) {
        meilleurScores[niveau] = score;
      }
    });
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Column(
              children: [

                const Text('🎵 ARTISTES',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4)),
                const Text('QUIZ',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFFB44FFF), letterSpacing: 6, height: 0.9)),

                const SizedBox(height: 24),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/musique.jpg', height: 200, width: double.infinity, fit: BoxFit.cover),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Identifie les artistes avant la fin du temps !\n25 artistes — 3 niveaux de difficulté',
                  style: TextStyle(fontSize: 15, color: Colors.white60, height: 1.5),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),

                // Bouton JOUER
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NiveauPage(
                          meilleurScores: meilleurScores,
                          onNouveauScore: _mettreAJourScore,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded, size: 28),
                    label: const Text('JOUER', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB44FFF),
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: const Color(0xFFB44FFF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                _menuButton(context, "MEILLEUR SCORE", Icons.emoji_events_rounded, () => _showScores(context)),
                _menuButton(context, "À PROPOS / COMMENT JOUER", Icons.info_outline_rounded, () => _showAPropos(context)),
                _menuButton(context, "QUITTER", Icons.exit_to_app_rounded, () => Navigator.pop(context), color: Colors.red.shade800),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuButton(BuildContext context, String text, IconData icon, VoidCallback action, {Color color = const Color(0xFF2A2A2A)}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Colors.white12)),
          ),
          onPressed: action,
          icon: Icon(icon, size: 20),
          label: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ),
      ),
    );
  }

  void _showScores(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('🏆 Meilleurs Scores', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ligneScore('😊 Facile',    meilleurScores['Facile']!,    const Color(0xFF1DB954)),
            const SizedBox(height: 10),
            _ligneScore('😏 Moyen',     meilleurScores['Moyen']!,     const Color(0xFFFF9800)),
            const SizedBox(height: 10),
            _ligneScore('🔥 Difficile', meilleurScores['Difficile']!, const Color(0xFFE53935)),
            const SizedBox(height: 16),
            const Text('Les scores sont remis à zéro\nà chaque redémarrage de l\'app.',
              style: TextStyle(color: Colors.white30, fontSize: 11), textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('FERMER', style: TextStyle(color: Color(0xFFB44FFF)))),
        ],
      ),
    );
  }

  Widget _ligneScore(String label, int score, Color couleur) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: couleur.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: couleur.withOpacity(0.4)),
          ),
          child: Text('$score pts', style: TextStyle(color: couleur, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ],
    );
  }

  void _showAPropos(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('ℹ️ À propos & Comment jouer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _sectionAPropos('🎮 Comment jouer',
                'Une grille de 25 artistes s\'affiche à l\'écran en format 5×5.\n'
                'Le nom d\'un artiste est indiqué en haut.\n'
                'Clique sur la bonne photo avant que le temps soit écoulé.\n'
                'Après chaque choix, la grille se mélange automatiquement et un nouveau nom s\'affiche.\n\n'
                '✅ Bonne réponse = tu gagnes des points\n'
                '❌ Mauvaise réponse = -5 pts\n'
                '⏱ Temps écoulé = fin de la partie !'),

              const SizedBox(height: 14),

              _sectionAPropos('😊 Niveau Facile',
                '• 15 secondes par question\n• +10 pts par bonne réponse\n• Idéal pour débuter'),

              const SizedBox(height: 10),

              _sectionAPropos('😏 Niveau Moyen',
                '• 8 secondes par question\n• +15 pts par bonne réponse\n• Pour les joueurs confirmés'),

              const SizedBox(height: 10),

              _sectionAPropos('🔥 Niveau Difficile',
                '• 3 secondes par question\n• +20 pts par bonne réponse\n• Réservé aux experts !'),

              const SizedBox(height: 14),

              _sectionAPropos('🎤 Les 25 artistes',
                'Rap FR : Gazo · Gims · Himra · Naza · Ninho · Niska · Tiakola · Damso · Youssoupha · Dadju\n\n'
                'Afro / R&B : Aya Nakamura · Ronisia · Tyla · Davido · Vano Baby · Ayra Starr · Didi B · Rema · Nikanor · Tems · Axel Merryl\n\n'
                'International : Rihanna · Cardi B · Stromae · Angélique Kidjo'),

              const SizedBox(height: 14),

              _sectionAPropos('📱 À propos',
                'Artistes Quiz — Jeu musical Flutter\nVersion 2.0 — 25 artistes\nDéveloppé en Flutter — 2026'),

            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
            child: const Text('FERMER', style: TextStyle(color: Color(0xFFB44FFF)))),
        ],
      ),
    );
  }

  Widget _sectionAPropos(String titre, String contenu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titre, style: const TextStyle(color: Color(0xFFB44FFF), fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        Text(contenu, style: const TextStyle(color: Colors.white60, fontSize: 12, height: 1.6)),
      ],
    );
  }
}