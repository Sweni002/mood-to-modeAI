import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'vetements.dart'; // 🔹 importer ta page VetementPage
import 'assistantAI.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // 🔹 Variable pour afficher VetementPage ou pas
  bool vetement = false; // mets à false si tu veux cacher

  @override
  Widget build(BuildContext context) {
    // Liste des pages
    final List<Widget> _pages = [
      // 🔹 Page Accueil
      vetement
          ? const VetementPage() // 👈 si vetement == true
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Lottie.asset(
                      "assets/robot.json",
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Une IA qui crée des tenues adaptées à vos besoins, "
                      "tout en promouvant une mode éco-responsable.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(166, 146, 146, 100),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

      // Page Profil
      const Center(child: Text("Profil", style: TextStyle(fontSize: 22))),

      // Page Paramètres
      const Center(child: Text("Paramètres", style: TextStyle(fontSize: 22))),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mood-to-Mode AI",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(166, 146, 146, 100),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset("assets/logo.png", height: 32, width: 32),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color.fromARGB(255, 224, 224, 224),
            height: 1.0,
          ),
        ),
      ),
      body: _pages[_currentIndex],
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              label: const Text(
                "Créer ma tenue",
                style: TextStyle(letterSpacing: 1),
              ),
              backgroundColor: const Color.fromRGBO(82, 156, 161, 1),
              foregroundColor: Colors.white,
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  "/creer_tenue",
                );

                if (result == true) {
                  setState(() {
                    vetement = true; // 🔹 active la page VetementPage
                  });
                }
              },
              icon: const Icon(Icons.add),
            )
          : null,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // couleur de l’ombre
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, -2), // 🔹 vers le haut
            ),
          ],
        ),
        child:BottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) {
    if (index == 1) {
      // Naviguer vers l'AssistantAIPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AssistantAIPage()),
      );
    } else {
      setState(() => _currentIndex = index);
    }
  },
  showSelectedLabels: false,
  showUnselectedLabels: false,
  elevation: 0,
  items: const [
    BottomNavigationBarItem(
      icon: Icon(
        FontAwesomeIcons.house,
        color: Color.fromRGBO(108, 209, 216, 1),
        size: 33,
      ),
      label: "",
    ),
    BottomNavigationBarItem(
      icon: Icon(
        FontAwesomeIcons.comment,
        color: Color.fromRGBO(108, 209, 216, 1),
        size: 33,
      ),
      label: "",
    ),
  ],
),
    ),
    );
  }
}
