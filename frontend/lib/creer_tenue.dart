import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:lottie/lottie.dart';

class CreerTenuePage extends StatefulWidget {
  const CreerTenuePage({super.key});

  @override
  State<CreerTenuePage> createState() => _CreerTenuePageState();
}

class _CreerTenuePageState extends State<CreerTenuePage> {
  final TextEditingController humeurController = TextEditingController();
  final TextEditingController meteoController = TextEditingController();
  final TextEditingController activiteController = TextEditingController();
  final TextEditingController motifsController = TextEditingController();
String humeurImage = "assets/mood.png"; // image par défaut
String meteoImage = "assets/soleil.png"; 
String activiteImage = "assets/travail.jpg"; 

  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];
  bool _isLoading = false; // 👉 gestion du loader

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage(
      imageQuality: 80, // réduit la taille si besoin
    );

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
      });
    } else {
      print("Aucune image sélectionnée");
    }
  }

  @override
  void dispose() {
    humeurController.dispose();
    meteoController.dispose();
    activiteController.dispose();
    motifsController.dispose();
    super.dispose();
  }
Future<void> _showSelectionDialog({
  required String title,
  required List<String> options,
  required TextEditingController controller,
  List<IconData>? icons,
  bool isHumeur = false,
    bool isMeteo = false,
      bool isActive = false, // ajout pour météo
 // 👉 option pour changer l'image de l'humeur
}) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (context, index) {
            return ListTile(
              iconColor: const Color.fromRGBO(82, 156, 161, 1),
              leading: icons != null ? Icon(icons[index]) : null,
              title: Text(
                options[index],
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              onTap: () {
                // Mettre à jour le TextField
                controller.text = options[index];

                // Changer l'image si c'est pour l'humeur
                if (isHumeur) {
                  setState(() {
                    switch (options[index]) {
                      case "Heureux":
                        humeurImage = "assets/heureux.png";
                        break;
                      case "Triste":
                        humeurImage = "assets/triste.png";
                        break;
                      case "Neutre":
                        humeurImage = "assets/neutre.png";
                        break;
                      case "Excité":
                        humeurImage = "assets/excite.png";
                        break;
                      default:
                        humeurImage = "assets/mood.png";
                    }
                  });
                }
                   if (isMeteo) {
                  setState(() {
                    switch (options[index]) {
                      case "Soleil":
                        meteoImage = "assets/soleil.png";
                        break;
                      case "Pluie":
                        meteoImage = "assets/pluie.png";
                        break;
                      case "Nuageux":
                        meteoImage = "assets/nuage.png";
                        break;
                      case "Neige":
                        meteoImage = "assets/neige.png";
                        break;
                    }
                  });
                }

 if (isActive) {
                  setState(() {
                    switch (options[index]) {
                      case "Travail":
                        activiteImage = "assets/travail.jpg";
                        break;
                      case "Sport":
                        activiteImage = "assets/sport.png";
                        break;
                      case "Loisir":
                        activiteImage = "assets/loisir.jpg";
                        break;
                      case "Eglise":
                        activiteImage = "assets/eglise.png";
                        break;
                      case "Etude":
                        activiteImage = "assets/etude.jpg";
                        break;
              
                    }
                  });
                }

                Navigator.pop(context); // fermer le dialog
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
      ],
    ),
  );
}


void _valider() async {
 if (humeurController.text.isEmpty ||
      meteoController.text.isEmpty ||
      activiteController.text.isEmpty) {
    _showError("Tous les champs doivent être remplis !");
    return;
  }

  if (_images.length < 3) {
    _showError("Vous devez sélectionner au moins 3 images !");
    return;
  }

  setState(() {
    _isLoading = true;
  });

  await Future.delayed(const Duration(seconds: 3));

  setState(() {
    _isLoading = false;
  });

  // 🔹 Retourner à Home et transmettre que vetement doit être true
  Navigator.pop(context, true);
}


void _showError(String message) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              "assets/errors.json",
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 15),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("OK"),
            ),
          ],
        ),
      ),
    ),
  );
}
 
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // 👉 bloque le retour si loader affiché
      onWillPop: () async => !_isLoading,
      child: Stack(
        children: [
 Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              if (!_isLoading) Navigator.pop(context);
            },
          ),
          title: const Text(
            "Créer ma tenue",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(166, 146, 146, 1),
            ),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(
              height: 1,
              color: Color.fromARGB(255, 224, 224, 224),
            ),
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
        ),
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 5),

                    Column(
                      children: [
                        // Card 1: Humeur
                        _buildCard(
                          "Quelle est ton humeur aujourd’hui ?",
                          humeurController,
                            humeurImage, // image dynamique, // 👉 ton PNG
    () {
                            _showSelectionDialog(
                              title: "Sélectionner ton humeur",
                              options: ["Heureux", "Triste", "Neutre", "Excité"],
                              controller: humeurController,
                              icons: [
                                FontAwesomeIcons.faceSmile,
                                FontAwesomeIcons.faceFrown,
                                FontAwesomeIcons.faceMeh,
                                FontAwesomeIcons.grinStars,
                              ],
                               isHumeur: true, // 🔹 permet de changer l'image

                            );
                          },
                        ),

                       // Card 2: Météo
                   _buildCard(
                          "Météo du jour",
                          meteoController,
                        meteoImage,
                             () {
                            _showSelectionDialog(
                              title: "Sélectionner la météo",
                              options: ["Soleil", "Pluie", "Nuageux", "Neige"],
                              controller: meteoController,
                              icons: [
                                FontAwesomeIcons.sun,
                                FontAwesomeIcons.cloudRain,
                                FontAwesomeIcons.cloud,
                                FontAwesomeIcons.snowflake,
                              ],
                                isMeteo: true, // permet de changer l'image
  
                            );
                          },
                        ),

                        // Card 3: Activité
                   _buildCard(
                          "Quelle est ton activité du jour ?",
                          activiteController,
                        activiteImage,
                          () {
                            _showSelectionDialog(
                              title: "Sélectionner l'activité",
                              options: ["Travail", "Sport", "Etude", "Loisir" ,"Eglise"],
                              controller: activiteController,
                              icons: [
                                FontAwesomeIcons.briefcase,
                                FontAwesomeIcons.dumbbell,
                                FontAwesomeIcons.book,
                                FontAwesomeIcons.gamepad,
                                  FontAwesomeIcons.church,
                              ],
                              isActive :true ,
                            );
                          },
                        ),

                        // Card 4: Images
                  _buildImagesCard()          
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Boutons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              if (!_isLoading) Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              side: const BorderSide(color: Colors.grey),
                              foregroundColor:  Color.fromRGBO(82, 156, 161, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Retour" ,style: TextStyle(letterSpacing: 1),),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _valider,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              backgroundColor: Color.fromRGBO(82, 156, 161, 1) ,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Valider" ,style: TextStyle(letterSpacing:  1),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 👉 Overlay Loader
             ],
        ),
      ),
        if (_isLoading)
              Container(
                color: Colors.black87,
                child: Center(
                  child: Lottie.asset(
                    "assets/loading.json",
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
       
   
        ],
      )
      );
  }
Widget _buildCard(
  String label,
  TextEditingController controller,
  String imagePath, // image PNG à droite
  VoidCallback onTap,
) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 12),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22), // un peu moins haut pour compacter
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
       BoxShadow(
  color: Colors.grey.withOpacity(0.4), // plus sombre
  spreadRadius: 1,
  blurRadius: 6,
  offset: const Offset(0, 3),
),

      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 👉 Texte + Champ à gauche
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14, // légèrement plus petit
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 13), // réduire l'espace
              TextFormField(
                controller: controller,
                readOnly: true,
                onTap: onTap,
                style: const TextStyle(
                  fontSize: 13, // texte du TextField plus petit
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: "Cliquez pour choisir",
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  filled: true,
                  fillColor: Colors.grey[100],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color.fromRGBO(82, 156, 161, 1)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16), // réduire un peu l'espace entre texte et image

        // 👉 Image à droite
        Container(
          padding: const EdgeInsets.all(6), // un peu moins de padding autour de l'image
          child: Image.asset(
            imagePath,
            width: 90,
            height: 95, // taille conservée
            fit: BoxFit.contain,
          ),
        ),
      ],
    ),
  );
}

Widget _buildImagesCard() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 12),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4), // plus sombre
          spreadRadius: 1,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Texte + Bouton à gauche
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Des captures de vos vêtements",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickImages,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(156, 134, 124, 136),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                icon: const Icon(FontAwesomeIcons.download, size: 16),
                label: const Text(
                  "add files",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 13),
              if (_images.isNotEmpty)
                Text(
                  "${_images.length} image${_images.length > 1 ? 's' : ''} sélectionnée${_images.length > 1 ? 's' : ''}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // 👉 Image fixe à droite
        Container(
          padding: const EdgeInsets.all(6),
          child: Image.asset(
            "assets/vetement.png",
            width: 100,
            height: 90,
            fit: BoxFit.contain,
          ),
        ),
      ],
    ),
  );
}






}
