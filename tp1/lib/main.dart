//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:io';

//import 'package:english_words/english_words.dart';

Map mediaDB = {"x":"y"};

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  Donnees.init().whenComplete(() {
    //Map mediaDB = Donnees.data!;
    runApp(const BottomNavigationBarExampleApp());
  });
}

class Donnees {
  static Map? data;

  static Future<void> init() async {
    var input = await rootBundle.loadString("assets/mediaDB.json");
    data = jsonDecode(input);
    return;
  }
}

//small database 
Media bd1 = Media("asterix");
Media bd2 = Media("gaston_lagaffe");
Media bd3 = Media("les_aventures_de_tintin");
Media bd4 = Media("la_quete_de_l_oignon_du_temps");
Media bd5 = Media("rubrique_a_brac");

Media f1 = Media("les_deux_tours");
Media f2 = Media("shrek");
Media f3 = Media("shrek_4");
Media f4 = Media("oignonheimer");
Media f5 = Media("fight_club");

Media cd1 = Media("the_dark_side_of_the_moon");
Media cd2 = Media("thriller");
Media cd3 = Media("the_hypnoflip_invasion");
Media cd4 = Media("hybrid_theory");
Media cd5 = Media("back_in_black");

var baseMedia = [bd1,bd2,bd3,bd4,bd5,f1,f2,f3,f4,f5,cd1,cd2,cd3,cd4,cd5];
var media = baseMedia;
var favorites = <Media>[];

Future<Map<String, dynamic>> readJsonFile(String fileName) async {
  //try {
    // Open the file and read its content as a String
    final file = File(fileName);
    String fileContent = await file.readAsString();

    // Decode the JSON content into a Map<String, dynamic>
    Map<String, dynamic> jsonData = jsonDecode(fileContent);

    // Return the decoded data
    return jsonData;
  /*} catch (e) {
    // Handle any errors (e.g., file not found, invalid JSON)
    print("Error reading or decoding the JSON file: $e");
    return {}; // Return an empty map in case of error
  }*/
}

List<Media> filterMedia(String filter){
  if (filter == "all"){
    return(baseMedia);
  }
  List<Media> filteredMedia = [];
  for (int i = 0; i < baseMedia.length; i++){
    if (baseMedia[i].type == filter){
      filteredMedia.add(baseMedia[i]);
    }
  }
  return(filteredMedia);
}

String updateFilter(String filter,String currentFilter){
  if (filter == currentFilter){
    return("all");
  }
  else{
    return(filter);
  }
}

//var tintinJson =  readJsonFile('les_aventures_de_tintin');
//var tintinTomes = getAuteurFromFuture(tintinJson);

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 20, 120, 80),
          ),
        ),
        home: BottomNavigationBarExample(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        home: MediaPage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {

  void toggleFavorite(current) {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static var theme = ThemeData(useMaterial3: true,colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 45, 194, 110)));
  
  static List<Widget> _widgetOptions = <Widget>[
    MediaPage(),
    FavoritesPage(),
    Text(
      'Index 2: About',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Scaffold(
      appBar: AppBar(
        ///selectedItemColor: const Color.fromARGB(255, 20, 120, 80),
        backgroundColor: theme.colorScheme.primary, 
        title: const Text('Bottom Text'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_media),
            label: 'Media',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'About',
          ),   
        ],
        currentIndex: _selectedIndex,
        ///selectedItemColor: const Color.fromARGB(255, 20, 120, 80),
        selectedItemColor: theme.colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    builder: (context,MyAppState);
    ///var appState = context.watch<MyAppState>();

    if (favorites.isEmpty) {
      return Center(child: Text('No favorites yet.'));
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'You have '
            '${favorites.length} favorites:',
          ),
        ),

        Wrap(
          spacing: 10, // Horizontal space
          runSpacing: 10, // Vertical space
          children: favorites.map((bd) => bd.toWidget(context)).toList(),
        )
      ],
    );
  }
}

class MediaPage extends StatefulWidget {
  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  @override
  String currentFilter = "all";
  Widget build(BuildContext context) {
    if (media.isEmpty) {
      return Center(child: Text('No media available.'));
    }

    return 
    ListView(
      children:[
        Row(
          children: [
            Text("Filtrer par catégorie :"),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  currentFilter = updateFilter("Bande dessinée", currentFilter);
                  media = filterMedia(currentFilter);
                });
              },
              icon: Icon(Icons.density_medium),
              label: Text("BD"),
            ),
                        ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  currentFilter = updateFilter("Film", currentFilter);
                  media = filterMedia(currentFilter);
                });
              },
              icon: Icon(Icons.density_medium),
              label: Text("Films"),
            ),
                        ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  currentFilter = updateFilter("Musique", currentFilter);
                  media = filterMedia(currentFilter);
                });
              },
              icon: Icon(Icons.density_medium),
              label: Text("Albums"),
            ),
          ]
        ),
        Wrap(
          spacing: 10, // Horizontal space
          runSpacing: 10, // Vertical space
          children: media.map((m) => m.toWidget(context)).toList(),
        )
      ],
    );
  }
}

//creating a class media

class Media{
  String type = "";
  String titre = "";
  String image = "insérer image";
  double note = 0; 
  String id = "";

  Media(String i,){
    id = i;
    type = (Donnees.data![id]["type"]);
    titre = (Donnees.data![id]["titre"]);
    note = (Donnees.data![id]["note"]);
  }

  Widget toWidget(BuildContext context ){
      var appState = context.watch<MyAppState>();
      return
        Container(
          color : const Color.fromARGB(255, 20, 120, 80),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  type,
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  titre,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  image,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  note.toString(),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                    appState.toggleFavorite(this);
                  },
                label: Icon(Icons.favorite)),
              ElevatedButton.icon(
                onPressed: () {
                    //show more info
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(titre),
                          content: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: [
                              if (type == "Bande dessinée") ...[
                                Text("Catégorie: $type"),
                                //Text("Titre: $titre"),
                                Text("Note: $note"),
                                Text("Année: " + Donnees.data![id]["annee"].toString()),
                                Text("Tomes: " + Donnees.data![id]["tomes"].toString()),
                                Text("Genre: " + Donnees.data![id]["genre"].toString()),
                              ],
                              if (type == "Film") ...[
                                Text("Catégorie: $type"),
                                //Text("Titre: $titre"),
                                Text("Note: $note"),
                                Text("Année: " + Donnees.data![id]["annee"].toString()),
                                Text("Réalisateur: " + Donnees.data![id]["realisateur"]),
                                Text("Durée: " + Donnees.data![id]["duree"].toString()),
                                Text("Genre: " + Donnees.data![id]["genre"].toString()),
                              ],
                              if (type == "Musique") ...[
                                Text("Catégorie: $type"),
                                //Text("Titre: $titre"),
                                Text("Note: $note"),
                                Text("Année: " + Donnees.data![id]["annee"].toString()),
                                Text("Artiste: " + Donnees.data![id]["artiste"]),
                                Text("Durée: " + Donnees.data![id]["duree"].toString()),
                                Text("Genre: " + Donnees.data![id]["genre"].toString()),
                              ],

                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the popup
                              },
                              child: Text("Close"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                label: Icon(Icons.density_medium)),
            ]
          ),
        );
    }
  }
