import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/widget/weather_data_tile.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget{
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget{
  const WeatherPage({super.key});



  @override
  State<StatefulWidget> createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();
  String _bgImage = 'assets/images/clear.jpg';
  String _iconImg = 'assets/icons/Clear.png';
  String _cityName = '';
  String _temperature = '';
  String _tempMax = '';
  String _tempMin = '';
  String _sunrise = '';
  String _sunset = '';
  String _main = '';
  String _pressure = '';
  String _humidity = '';
  String _visibility = '';
  String _windSpeed = '';

  getData(String cityName) async {
    final weatherService = WeatherService();
    final weatherData = await weatherService.getWeather(cityName);
    debugPrint(weatherData.toString());

    setState(() {
       cityName = weatherData['name'];
      _temperature = weatherData['main']['temp'].toStringAsFixed(1);
      _main = weatherData['weather'][0]['main'];
      _tempMax = weatherData['main']['temp_max'].toStringAsFixed(1);
      _tempMin = weatherData['main']['temp_min'].toStringAsFixed(1);
      
      _sunrise = DateFormat('hh:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(weatherData['sys']['sunrise'] * 1000)
      );

      _sunset = DateFormat('hh:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(weatherData['sys']['sunset'] * 1000)
      );

      _pressure = weatherData['main']['pressure'].toString();
      _visibility = weatherData['visibility'].toString(); // Corrected access
      _humidity = weatherData['main']['humidity'].toString();
      _windSpeed = weatherData['wind']['speed'].toString(); 
      
      if(_main == 'Clear'){
        _bgImage = 'assets/images/clear.jpg';
        _iconImg = 'assets/icons/Clear.jpg';
      }
      else if(_main == 'Clouds'){
        _bgImage = 'assets/images/clouds.jpg';
        _iconImg = 'assets/icons/Clouds.jpg';
      }
      else if(_main == 'Rain'){
        _bgImage = 'assets/images/rain.jpg';
        _iconImg = 'assets/icons/Rain.jpg';
      }
      else if(_main == 'Fog'){
        _bgImage = 'assets/images/fog.jpg';
        _iconImg = 'assets/icons/Fog.jpg';
      }
       
       else {
        _bgImage = 'assets/images/haze.jpg';
        _iconImg = 'assets/icons/Haze.jpg';
      } // Corrected access
    });
  }

  
  @override
 Widget build(BuildContext context){
  return Scaffold(
     body: Stack(
    children: [
      Image.asset(
        'assets/images/haze.jpg',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),

      Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(child:Column(children:[
          SizedBox(height: 40,),
          TextField(
            controller: _controller,
            onChanged: (value) {
              getData(value);
            },
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.black26,
              hintText: 'Enter City name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))
              )
            ),
          ),

          SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on
              ),
              Text(
                _cityName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              )
            ],
          ),

          SizedBox(height: 50,),
          Text('$_temperature°C',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 90,
            fontWeight: FontWeight.bold
          ),
          ),
          Row(
            children: [
              Text(
                _main,
                style: 
                TextStyle(fontSize: 40,fontWeight: FontWeight.w500),
              ),
              Image.asset(_iconImg,
              height: 80,
              )
            ],
          ),

          const SizedBox(
            height: 35,
          ),
          Row(
            children: [
              const Icon(Icons.arrow_upward),
              Text('$_tempMax°C',style: TextStyle(
                fontSize: 22,fontStyle: FontStyle.italic
              ),),

              const Icon(Icons.arrow_downward),
              Text('$_tempMin°C',style: TextStyle(
                fontSize: 22,fontStyle: FontStyle.italic)
              )

            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Card(
            elevation: 5,
            child: Container(
              color: Colors.transparent,
              child: Padding(padding: EdgeInsets.all(15), 
              child: Column(
                children: [
                  WeatherDataTile(
                    index1: 'Sunrise', 
                    index2: 'Sunset', 
                    value1: '12:40 AM', 
                    value2: '12:36 PM'),
                  SizedBox(height: 15,),
                  WeatherDataTile(
                    index1: 'Humidity', 
                    index2: 'Visibility', 
                    value1: '4', 
                    value2: '10000'),
                  SizedBox(height: 15,),
                  WeatherDataTile(
                    index1: 'Precipitation', 
                    index2: 'Wind speed', 
                    value1: "6", 
                    value2: "45"),
                  SizedBox(height: 15,),
                ],
              ),
            ),
          )
          )

        ],),)
      )
    ],
     )
  );
 }
  }


  
