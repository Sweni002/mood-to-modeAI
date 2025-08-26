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
  }) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              return ListTile(
                iconColor: Color.fromRGBO(82, 156, 161, 1),
                leading: icons != null ? Icon(icons[index]) : null,
                title: Text(
                  options[index],
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                onTap: () {
                  controller.text = options[index];
                  Navigator.pop(context);
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
  // Validation des champs
  if (humeurController.text.isEmpty ||
      meteoController.text.isEmpty ||
      activiteController.text.isEmpty) {
    _showError("Tous les champs doivent être remplis !");
    return;
  }

  // Validation des images
  if (_images.length < 3) {
    _showError("Vous devez sélectionner au moins 3 images !");
    return;
  }

  // Si tout est OK
  print("Humeur: ${humeurController.text}");
  print("Météo: ${meteoController.text}");
  print("Activité: ${activiteController.text}");
  print("Motifs: ${motifsController.text}");

  setState(() {
    _isLoading = true; // afficher le loader
  });

  await Future.delayed(const Duration(seconds: 3));

  setState(() {
    _isLoading = false; // cacher le loader
  });
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
                          FontAwesomeIcons.faceSmile,
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
                            );
                          },
                        ),

                        // Card 2: Météo
                        _buildCard(
                          "Météo du jour",
                          meteoController,
                          FontAwesomeIcons.cloud,
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
                            );
                          },
                        ),

                        // Card 3: Activité
                        _buildCard(
                          "Quelle est ton activité du jour ?",
                          activiteController,
                          FontAwesomeIcons.chevronDown,
                          () {
                            _showSelectionDialog(
                              title: "Sélectionner l'activité",
                              options: ["Travail", "Sport", "Etude", "Loisir"],
                              controller: activiteController,
                              icons: [
                                FontAwesomeIcons.briefcase,
                                FontAwesomeIcons.dumbbell,
                                FontAwesomeIcons.book,
                                FontAwesomeIcons.gamepad,
                              ],
                            );
                          },
                        ),

                        // Card 4: Images
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(21),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Des captures de vos vêtements",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 25),

                              if (_images.isNotEmpty) ...[
                                Text(
                                  "${_images.length} image${_images.length > 1 ? 's' : ''} sélectionnée${_images.length > 1 ? 's' : ''}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],

                              ElevatedButton.icon(
                                onPressed: _pickImages,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(156, 134, 124, 136),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                icon: const Icon(FontAwesomeIcons.download, size: 15),
                                label: const Text(
                                  "add files",
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(21),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 25),
          TextFormField(
            controller: controller,
            readOnly: true,
            onTap: onTap,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: const UnderlineInputBorder(),
              suffixIcon: Icon(
                icon,
                size: 19,
                color: Color.fromRGBO(82, 156, 161, 1),
              ),
              hintText: "Clique pour choisir",
            ),
          ),
        ],
      ),
    );
  }
}
