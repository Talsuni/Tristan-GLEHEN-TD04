import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';


//Test récupération API
Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://geocoding-api.open-meteo.com/v1/search?name=Paris&count=1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final String name;
  final String latitude;
  final String longitude;
  final String country;

  const Album({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      country: json['country'],
    );
  }
}

/*
Liste de récupération des datas avec les différents calls API à faire :

Récupérer les coordonnées et le pays :
🔗 https://geocoding-api.open-meteo.com/v1/search?name=””&count=1
Paramètres à extraire :
latitude
longitude
country

Écran "Mes villes" :
🔗 **https://api.open-meteo.com/v1/forecast?latitude=48.85&longitude=2.35&current_weather=true**
Paramètres à extraire :
temperature
weathercode

Détail de ville - Hourly temperatures :
🔗 **https://api.open-meteo.com/v1/forecast?latitude=48.85&longitude=2.35&forecast_days=1&hourly=temperature_2m,weathercode**
Paramètres à extraire :
time
temperature
weathercode

Détail de ville - Weekly temperatures :
🔗 **https://api.open-meteo.com/v1/forecast?latitude=48.85&longitude=2.35&timezone=auto&daily=weathercode,temperature_2m_max,temperature_2m_min**
Paramètres à extraire :
time
weathercode
temperature_2m_max
temperature_2m_min

Détail de ville - Plus d’infos :
🔗 **https://api.open-meteo.com/v1/forecast?latitude=48.85&longitude=2.35&forecast_days=1&hourly=relativehumidity_2m,apparent_temperature,precipitation_probability,windspeed_10m,winddirection_10m**
Paramètres à extraire :
relativehumidity_2m
apparent_temperature
precipitation probability
windspeed_10m
winddirection_10m
 */

//weathercode to description :
/*
Code	Description
0	Clear sky
1, 2, 3	Mainly clear, partly cloudy, and overcast
45, 48	Fog and depositing rime fog
51, 53, 55	Drizzle: Light, moderate, and dense intensity
56, 57	Freezing Drizzle: Light and dense intensity
61, 63, 65	Rain: Slight, moderate and heavy intensity
66, 67	Freezing Rain: Light and heavy intensity
71, 73, 75	Snow fall: Slight, moderate, and heavy intensity
77	Snow grains
80, 81, 82	Rain showers: Slight, moderate, and violent
85, 86	Snow showers slight and heavy
95 *	Thunderstorm: Slight or moderate
96, 99 *	Thunderstorm with slight and heavy hail
 */

void main (){
  runApp( MyApp() );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AddCity(title: 'Ajouter une ville'),
    );
  }
}

class AddCity extends StatefulWidget {
  const AddCity ({super.key, required this.title});
  final String title;

  @override
  State<AddCity> createState() => _AddCityState();
}

class _AddCityState extends State<AddCity> {
  final TextEditingController _searchController = TextEditingController();

  List<String> ville = ['a','b','c'];
  List<String> pays = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row (
          children: [
            Text(widget.title, style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Column(
        children:[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Saisissez le nom d'une ville",
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute (builder: (context) => CityList()));
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.separated(
              itemCount: ville.length,
              itemBuilder: (context, i) {
                //Construction du widget à répéter
                return ListTile(
                  title: Text(ville[i], style: TextStyle(color: Colors.black,fontStyle: FontStyle.italic)),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CityList extends StatelessWidget {
  const CityList ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text('Mes villes', style: TextStyle(color: Colors.black)),
          actions: <Widget> [
            IconButton(
              icon: Icon(Icons.add, color: Colors.black), onPressed: () {Navigator.push(context, MaterialPageRoute (builder: (context) => MyApp()));},
            ),
          ]
        ),

        body:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Paris, France'),
                Text('20°'),
                Text('Ensoleillé'),
              ],
            ),
            SvgPicture.asset ('assets/images/overcast.svg'),
          ],
        ),
      ),
    );
  }
  /*
  // Test requête API
  void fetchcoordinates() async {
    const url = 'https://geocoding-api.open-meteo.com/v1/search?name=Paris&count=1';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    country = json['results'];
  }
  */

}

