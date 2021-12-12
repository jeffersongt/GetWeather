import 'package:flutter/material.dart';
import 'package:getweather/services/open_weather.dart';
import 'package:getweather/models/structs.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class GetWeather extends StatefulWidget {
  const GetWeather({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<GetWeather> createState() => _GetWeatherState();
}

class _GetWeatherState extends State<GetWeather> {
  final TextEditingController _textFieldController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  String city = "N/a";
  String skyDesc = "N/a";
  double temp = 0;
  double feel = 0;
  int humidity = 0;
  String bgImage =
      "https://cdn.futura-sciences.com/buildsv6/images/wide1920/6/2/b/62b0677a23_129709_soleil-brille.jpg";
  double lat = 0;
  double long = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.grey,
        title: Text('GetWeather',
            style: TextStyle(
                fontFamily: GoogleFonts.satisfy().fontFamily,
                color: Colors.black)),
        automaticallyImplyLeading: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                search();
              },
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.location_on, color: Colors.black),
            onPressed: () {
              geolocateWeather();
            },
          ),
        ],
      ),
      body: appBody(context),
    );
  }

  Stack appBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.all(30),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: NetworkImage(bgImage), fit: BoxFit.cover),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            skyDesc,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.normal),
                          ),
                        ])))),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Text(
                    city,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  )),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                        padding: EdgeInsets.all(8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Temp : ',
                            style: TextStyle(),
                          ),
                        )),
                    Text(
                      '$temp °C',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const Padding(
                        padding: EdgeInsets.all(8),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '     Feels : ',
                              style: TextStyle(),
                            ))),
                    Text(
                      '$feel °C',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ]),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                        padding: EdgeInsets.all(8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Humidity :',
                          ),
                        )),
                    Text(
                      ' $humidity %',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ]),
            ]),
      ],
    );
  }

  String getCityUrl(String city) {
    String openweather_key =
        'e1a37bf384234632be1873a25bb9aa13';
    String _url1 = 'http://api.openweathermap.org/data/2.5/weather?q=';
    String _url2 = '&units=metric&appid=';
    String _finalUrl = _url1 + city + _url2 + openweather_key;
    _textFieldController.clear();
    return _finalUrl;
  }

  String getGeolocationUrl(double lat, double long) {
    String _key =
        'e1a37bf384234632be1873a25bb9aa13'; // hide it before publishing on github
    String _url1 = 'https://api.openweathermap.org/data/2.5/onecall?lat=';
    String _url2 = '&lon=';
    String _url3 = '&exclude=hourly,daily&units=metric&appid=';
    String _finalUrl =
        _url1 + lat.toString() + _url2 + long.toString() + _url3 + _key;
    _textFieldController.clear();
    return _finalUrl;
  }

  void geolocateWeather() {
    determinePosition().then((value) {
      lat = value.latitude;
      long = value.longitude;
    });
    getGeolocationWeather(getGeolocationUrl(lat, long))
        .then((value) => setState(() {
              city = value.timezone;
              skyDesc = value.skyDesc;
              temp = value.temp;
              feel = value.feel;
              humidity = value.humidity;
              checkIdGeo(value);
            }));
  }

  void search() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: SizedBox(
                child: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                hintText: 'Search for a city',
                hintStyle: TextStyle(fontFamily: GoogleFonts.b612().fontFamily),
              ),
            )),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: RoundedLoadingButton(
                        width: 100,
                        height: 30,
                        child: const Text('Search',
                            style: TextStyle(color: Colors.black)),
                        controller: _btnController,
                        color: Colors.white,
                        successColor: Colors.white,
                        errorColor: Colors.white,
                        valueColor: Colors.black,
                        onPressed: () => {
                          searchBtn(_btnController, context),
                        },
                      )),
                ],
              )
            ],
          );
        });
  }

  void searchBtn(
      RoundedLoadingButtonController _btnController, BuildContext context) {
    Timer(const Duration(seconds: 1), () {
      getCityWeather(getCityUrl(_textFieldController.text)).then(
          (value) => setState(() {
                _btnController.success();
                city = value.city;
                skyDesc = value.skyDesc;
                temp = value.temp;
                feel = value.feel;
                humidity = value.humidity;
                checkIdCity(value);
              }), onError: (error) {
        _btnController.error();
      });
      Timer(const Duration(seconds: 1), () {
        Navigator.pop(context);
        _textFieldController.clear();
      });
    });
  }

  void checkIdCity(City value) {
    if (value.skyId.toString()[0] == '2') {
      bgImage =
          "https://images.immediate.co.uk/production/volatile/sites/4/2020/08/GettyImages-NA006117-b5eac24.jpg?quality=90&resize=960%2C408";
    }
    if (value.skyId.toString()[0] == '3') {
      bgImage = "http://apikabu.ru/img_n/2012-07_1/fj0.jpg";
    }
    if (value.skyId.toString()[0] == '5') {
      bgImage =
          "https://pbs.twimg.com/profile_images/977468494261440512/5P6pFu15.jpg";
    }
    if (value.skyId.toString()[0] == '6') {
      bgImage =
          "https://images.unsplash.com/photo-1516431883659-655d41c09bf9?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8c25vd2luZ3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80";
    }
    if (value.skyId.toString()[0] == '7') {
      bgImage =
          "https://cdn.futura-sciences.com/buildsv6/images/wide1920/6/2/b/62b0677a23_129709_soleil-brille.jpg";
    }
    if (value.skyId == 800) {
      bgImage =
          "https://cdn.futura-sciences.com/buildsv6/images/wide1920/6/2/b/62b0677a23_129709_soleil-brille.jpg";
    }
    if (value.skyId.toString()[0] == '8' && value.skyId.toString()[1] == '0') {
      bgImage =
          "https://miro.medium.com/max/1200/1*HEou12Vvyanhf_8m-94EsQ.jpeg";
    }
  }

  void checkIdGeo(Geo value) {
    if (value.skyId.toString()[0] == '2') {
      bgImage =
          "https://images.immediate.co.uk/production/volatile/sites/4/2020/08/GettyImages-NA006117-b5eac24.jpg?quality=90&resize=960%2C408";
    }
    if (value.skyId.toString()[0] == '3') {
      bgImage = "http://apikabu.ru/img_n/2012-07_1/fj0.jpg";
    }
    if (value.skyId.toString()[0] == '5') {
      bgImage =
          "https://pbs.twimg.com/profile_images/977468494261440512/5P6pFu15.jpg";
    }
    if (value.skyId.toString()[0] == '6') {
      bgImage =
          "https://images.unsplash.com/photo-1516431883659-655d41c09bf9?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8c25vd2luZ3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80";
    }
    if (value.skyId.toString()[0] == '7') {
      bgImage =
          "https://cdn.futura-sciences.com/buildsv6/images/wide1920/6/2/b/62b0677a23_129709_soleil-brille.jpg";
    }
    if (value.skyId == 800) {
      bgImage =
          "https://cdn.futura-sciences.com/buildsv6/images/wide1920/6/2/b/62b0677a23_129709_soleil-brille.jpg";
    }
    if (value.skyId.toString()[0] == '8' && value.skyId.toString()[1] == '0') {
      bgImage =
          "https://miro.medium.com/max/1200/1*HEou12Vvyanhf_8m-94EsQ.jpeg";
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
