import 'package:flutter/material.dart';

class VetementPage extends StatelessWidget {
  const VetementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // 🔹 largeur écran

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // 🔹 Tags en haut avec ElevatedButton
      // 🔹 Tags en haut avec ElevatedButton sans Expanded
Row(
  children: [
    Expanded(
      child: Container(
        width: double.infinity,
        alignment: Alignment.center, // 🔹 centre le bouton
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor:  const Color.fromRGBO(82, 156, 161, 1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20 ,horizontal: 20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // bouton prend juste sa taille
            children: const [
              Text("Heureux", style: TextStyle(letterSpacing: 1, fontSize: 15)),
              SizedBox(width: 5),
              Icon(Icons.close, color: Colors.white, size: 17),
            ],
          ),
        ),
      ),
    ),
    const SizedBox(width: 16), // espace entre les deux boutons
    Expanded(
      child: Container(
        width: double.infinity,
        alignment: Alignment.center, // 🔹 centre le bouton
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(color: Colors.grey),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20 ,horizontal: 20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("Nuageux"),
              SizedBox(width: 5),
              Icon(Icons.close, color: Colors.black, size: 20),
            ],
          ),
        ),
      ),
    ),
  ],
)

 , 
 
 const SizedBox(height: 15,) ,
 Row(
  children: [
    Expanded(
      child: Container(
        width: double.infinity,
        alignment: Alignment.center, // 🔹 centre le bouton
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
           shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(color: Colors.grey),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20 ,horizontal: 20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // bouton prend juste sa taille
            children: const [
              Text("Travail", style: TextStyle(letterSpacing: 1, fontSize: 15)),
              SizedBox(width: 5),
              Icon(Icons.close, color: Colors.black, size: 17),
            ],
          ),
        ),
      ),
    ),
    const SizedBox(width: 16), // espace entre les deux boutons
    Expanded(
      child: Container(
        width: double.infinity,
        alignment: Alignment.center, // 🔹 centre le bouton
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(color: Colors.grey),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20 ,horizontal: 20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("tes photos"),
              SizedBox(width: 5),
              Icon(Icons.close, color: Colors.black, size: 20),
            ],
          ),
        ),
      ),
    ),
  ],
)

 ,         const SizedBox(height: 30),

              // 🔹 Section : Veste proposée
              _buildSectionTitle("Veste proposée"),
              const SizedBox(height: 15),
              _buildClothesRow(
                  ["assets/sweet.png", "assets/eglise.png"], [4, 3], screenWidth),

              const SizedBox(height: 30),

              // 🔹 Section : Chaussures
              _buildSectionTitle("Chaussures"),
              const SizedBox(height: 15),
              _buildClothesRow(
                  ["assets/sweet.png", "assets/blouson1.webp"], [4, 3], screenWidth),

              const SizedBox(height: 30),

              // 🔹 Section : Pantalon
              _buildSectionTitle("Pantalon"),
              const SizedBox(height: 15),
              _buildClothesRow(
                  ["assets/sweet.png", "assets/blouson.png"], [3, 4], screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Titre de section
  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold ,letterSpacing: 1)),
        const Text("tout afficher",
            style: TextStyle(fontSize: 12, color: Colors.grey ,fontWeight: FontWeight.bold)),
      ],
    );
  }

  // 🔹 Ligne de vêtements responsive avec rating
// 🔹 Ligne de vêtements responsive avec rating
Widget _buildClothesRow(
    List<String> imageUrls, List<int> ratings, double screenWidth) {
  return Row(
    children: List.generate(imageUrls.length, (index) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth < 400 ? 8 : 15,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  height: screenWidth < 400 ? 90 : 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Image.asset(
                    imageUrls[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // 🔹 Affiche une image de remplacement si l'asset n'existe pas
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey, size: 40),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                _buildRatingStars(ratings[index]),
              ],
            ),
          ),
        ),
      );
    }),
  );
}

  // 🔹 Étoiles de notation
  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        return Icon(
          i < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 22, // 🔹 un peu plus petit pour mobile
        );
      }),
    );
  }
}
