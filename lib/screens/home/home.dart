import 'package:flutter/material.dart';
import 'package:getweather/models/post.dart';
import 'package:getweather/services/open_weather.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
            width: 300,
            child: TextField(
                controller: _textFieldController,
                decoration: const InputDecoration(
                    hintText: 'Type the name of a city',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    )))),
        automaticallyImplyLeading: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                //_searchMeteo(_textFieldController.text);
                printIt();
              },
            );
          },
        ),
        actions: [
          RoundedLoadingButton(
            child:
                const Text('Geolocate', style: TextStyle(color: Colors.white)),
            color: Colors.blue.shade400,
            controller: _btnController,
            onPressed: () => {
              Timer(const Duration(seconds: 1), () {
                _btnController.success();
              })
              // call API for geolocation use golocator package
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10.0),
        // Body of the widget weather api response
        child: FutureBuilder<Post>(
            future: fetchPost(_searchMeteo(_textFieldController.text)),
            builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Result: ${snapshot.data}'),
                  )
                ];
              } else if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              );
            }),
        // Body of the widget weather api response
      ),
    );
  }

  Future<void> printIt() async {
    print(await fetchPost(_searchMeteo(_textFieldController.text)));
  }

  String _searchMeteo(String city) {
    _textFieldController.clear();
    return _httpCall(city);
  }

  String _httpCall(String city) {
    String _key =
        'e1a37bf384234632be1873a25bb9aa13'; // hide it before publishing on github
    String _url1 = 'http://api.openweathermap.org/data/2.5/weather?q=';
    String _url2 = '&appid=';
    String _finalUrl = _url1 + city + _url2 + _key;
    return _finalUrl;
  }
}
