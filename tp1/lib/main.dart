//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:io';

//import 'package:english_words/english_words.dart';

Map tintinData = {"qrgstdhyf" : "rqstdf"};

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  Donnees.init().whenComplete(() {
    runApp(const BottomNavigationBarExampleApp());
    Map tintinData = Donnees.data!;
  });
}

class Donnees {
  static Map? data;

  static Future<void> init() async {
    var input = await rootBundle.loadString("assets/les_aventures_de_tintin.json");
    data = jsonDecode(input);
    return;
  }
}

//small database 
Media bd1 = Media("Bande dessinée", "Astérix", 4.64,"asterix",{});
Media bd2 = Media("Bande dessinée", "Gaston Lagaffe", 4.61,"gaston_lagaffe",{});
Media bd3 = Media("Bande dessinée", "Les aventures de Tintin", 3.82,"les_aventures_de_tintin",tintinData);
Media f1 = Media("Film", "Les deux tours", 4.7,"les_deux_tours",{});

var media = [bd1,bd2,bd3,f1];
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
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
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

/*class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext, context) {
    return
      Text('HomePage');
  }
}*/

class FavoritesPage extends StatelessWidget {
  @override
    ///@override
  ///Widget build(BuildContext context) {
    ///return 
    ///Text(
    ///  'FavoritesPage',
    ///);
  ///}
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

        /*for (var bd in favorites)
          bd.widgetBD(),
          SizedBox(
            height: 10
          ),
          /*ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),*/*/
      ],
    );
  }
}

class MediaPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) {
      return Center(child: Text('No media available.'));
    }

    return ListView(
      children: [
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
  Map json = {};

  Media(String ty, String ti, double n, String i, Map j){
    type = ty;
    titre = ti;
    note = n;
    id = i;
    json = j;
  }

  Map tintinData = Donnees.data!;

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
                              Text("Type: $type"),
                              Text("Titre: $titre"),
                              Text("Note: $note"),
                              
                              Text(tintinData.toString()),

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


//creating a class bandeDessinee

class BandeDessinee{
  String titreSerie = "";
  int tome = 0;
  String titreAlbum = "";
  String auteur = "";
  int date = 0;
  double note = 0;

  BandeDessinee(String tS, int t, String tA, String a, int d, double n){
    titreSerie = tS;
    tome = t;
    titreAlbum = tA;
    auteur = a;
    date = d;
    note = n; 
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
                titreSerie,
                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                tome.toString(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                titreAlbum,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                  appState.toggleFavorite(this);
                },
              label: Icon(Icons.favorite)),
          ]
        ),
      );
  }
}

//creating a class film

class Film{
  String titreFilm = "";
  int duree = 0;
  String realisateur = "";
  int date = 0;
  double note = 0;

  Film(String tF, int du, String r, int da, double n){
    titreFilm = tF;
    duree = da;
    realisateur = r;
    date = da;
    note = n; 
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
                titreFilm,
                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                duree.toString(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                realisateur,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                  appState.toggleFavorite(this);
                },
              label: Icon(Icons.favorite)),
          ]
        ),
      );
  }
}