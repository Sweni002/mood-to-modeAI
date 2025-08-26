import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Liste des pages
    final List<Widget> _pages = [
      // Page Accueil avec Lottie
  // Page Accueil avec Lottie et texte centré
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Lottie.asset(
        "assets/robot.json",
        width: 250,
        height: 250,
        fit: BoxFit.contain,
      ),
    ),
   
    const Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        "Une IA qui crée des tenues selon votre besoin des marques éthiques pour une mode durable.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color.fromRGBO(166, 146, 146, 100) ,
          height: 1.5,
        ),
      ),
    ),
  ],
)
    ,  // Page Profil
      const Center(child: Text("Profil", style: TextStyle(fontSize: 22))),
      // Page Paramètres
      const Center(child: Text("Paramètres", style: TextStyle(fontSize: 22))),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mood-to-Mode AI",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Color.fromRGBO(166, 146, 146, 100)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset(
              "assets/logo.png",
              height: 32,
              width: 32,
            ),
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
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Créer ma tenue" ,style: TextStyle(letterSpacing: 1 ),),
        backgroundColor: Color.fromRGBO(82, 156, 161, 1), 
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, "/creer_tenue");
        },
        icon: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house,
                color:  Color.fromRGBO(108, 209, 216, 1), size: 27),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.comment,
                color:  Color.fromRGBO(108, 209, 216, 1) ,size: 27),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.users,
                color:   Color.fromRGBO(108, 209, 216, 1), size: 27),
            label: "",
          ),
        ],
      ),
    );
  }
}
