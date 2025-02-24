//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  Donnees.init().whenComplete(() {
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
Media bd6 = Media("travis");

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

Media s1 = Media("sherlock");
Media s2 = Media("les_cites_d_or");
Media s3 = Media("chernobyl");

var baseMedia = [bd1,bd2,bd3,bd4,bd5,bd6,f1,f2,f3,f4,f5,cd1,cd2,cd3,cd4,cd5,s1,s2,s3];
var media = baseMedia;
var favorites = <Media>[];

Future<Map<String, dynamic>> readJsonFile(String fileName) async {
  final file = File(fileName);
  String fileContent = await file.readAsString();

  Map<String, dynamic> jsonData = jsonDecode(fileContent);

  return jsonData;
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

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(  
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: const Color.fromARGB(255, 60, 230, 160),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 60, 230, 160),
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

  static List<Widget> _widgetOptions = <Widget>[
    MediaPage(),
    FavoritesPage(),
    Text(
      'Auteur : Denis Dagbert \n Version 1.0',
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary, 
        title: const Text('TP1 App'),
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
        selectedItemColor: theme.colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
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
          spacing: 10, 
          runSpacing: 10, 
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
  String currentFilter = "all";
  @override
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
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  currentFilter = updateFilter("Série", currentFilter);
                  media = filterMedia(currentFilter);
                });
              },
              icon: Icon(Icons.density_medium),
              label: Text("Séries"),
            ),
          ]
        ),
        Wrap(
          spacing: 10, 
          runSpacing: 10, 
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color : const Color.fromARGB(255, 60, 230, 160),
            ),
          width: 200,
          height: 320,
          
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  type,
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
                child: Image(image: AssetImage(id + ".png"), width: 100, height: 100,),
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(titre),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (type == "Bande dessinée") ...[
                                Text("Catégorie: $type"),
                                Image(image: AssetImage(id + ".png"), width: 250, height: 250,),
                                Text("Note: $note"),
                                Text("Année: " + Donnees.data![id]["annee"].toString()),
                                Text("Tomes: " + Donnees.data![id]["tomes"].toString()),
                                Text("Genre: " + Donnees.data![id]["genre"].toString()),
                              ],
                              if (type == "Film") ...[
                                Text("Catégorie: $type"),
                                Image(image: AssetImage(id + ".png"), width: 250, height: 250,),
                                Text("Note: $note"),
                                Text("Année: " + Donnees.data![id]["annee"].toString()),
                                Text("Réalisateur: " + Donnees.data![id]["realisateur"]),
                                Text("Durée: " + Donnees.data![id]["duree"].toString()),
                                Text("Genre: " + Donnees.data![id]["genre"].toString()),
                              ],
                              if (type == "Musique") ...[
                                Text("Catégorie: $type"),
                                Image(image: AssetImage(id + ".png"), width: 250, height: 250,),
                                Text("Note: $note"),
                                Text("Année: " + Donnees.data![id]["annee"].toString()),
                                Text("Artiste: " + Donnees.data![id]["artiste"]),
                                Text("Durée: " + Donnees.data![id]["duree"].toString()),
                                Text("Genre: " + Donnees.data![id]["genre"].toString()),
                              ],
                              if (type == "Série") ...[
                                Text("Catégorie: $type"),
                                Image(image: AssetImage(id + ".png"), width: 250, height: 250,),
                                Text("Note: $note"),
                                Text("Année: " + Donnees.data![id]["annee"].toString()),
                                Text("Réalisateur: " + Donnees.data![id]["realisateur"]),
                                Text("Episodes: " + Donnees.data![id]["episodes"].toString()),
                                Text("Genre: " + Donnees.data![id]["genre"].toString()),
                              ],
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); 
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
