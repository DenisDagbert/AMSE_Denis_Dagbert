//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:english_words/english_words.dart';


/// Flutter code sample for [BottomNavigationBar].

void main() => runApp(const BottomNavigationBarExampleApp());

//creating small database  manually
BandeDessinee bd1 = new BandeDessinee('Astérix',7,'Le combat des chefs','Uderzo - Goscinny',1966,4.61);
BandeDessinee bd2 = new BandeDessinee('Astérix',11,'Le bouclier Arverne','Uderzo - Goscinny',1968,4.61);
BandeDessinee bd3 = new BandeDessinee('Gaston',14,'La saga des gaffes','Franquin',1982,4.61);
var favorites = <BandeDessinee>[bd1,bd2,bd3];

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      theme: ThemeData(useMaterial3: true,colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 20, 120, 80))),
      home: BottomNavigationBarExample(),
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
        home: HomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {

  //var favorites = <WordPair>[];

  void toggleFavorite(current) {
    ///if (favorites.contains(current)) {
      ///favorites.remove(current);
    ///} else {
      ///favorites.add(current);
    ///}
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
    //Text(
    //  'Index 1: Media',
    //  style: optionStyle,
    //),
    ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: 50,
          color : theme.colorScheme.primary,
          //color: theme.colorScheme.primary,
          //color: (ThemeData get).colorScheme.primary,
          child: const Center(child: Text('Entry A')),      
        ),
      ],
    ),
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
          children: favorites.map((bd) => bd.widgetBD()).toList(),
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

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return 
    Text(
      'HomePage',
    );
  }
}

//creating manually small db for tests

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

  Widget widgetBD(){
    return
      Container(
        color : const Color.fromARGB(255, 20, 120, 80),
        child: Column(
          
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                titreSerie,
                style: TextStyle(color: Colors.orange),
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
          ]
        ),
      );
      /*Padding(
        padding: const EdgeInsets.all(8),
        child: TextSpan(
          children: <TextSpan>[
            TextSpan(text: 'hello', style: TextStyle(color: Colors.red)),
          ]
        ),
      )*/
  }
}

/*
      children: <Widget>[
        Container(
          height: 50,
          color : theme.colorScheme.primary,
          //color: theme.colorScheme.primary,
          //color: (ThemeData get).colorScheme.primary,
          child: const Center(child: Text('Entry A')),      
        ),*/
