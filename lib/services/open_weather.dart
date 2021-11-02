import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:getweather/models/structs.dart';

Future<City> getCityWeather(_finalUrl) async {
  final _response = await http.get(Uri.parse(_finalUrl));

  if (_response.statusCode == 200) {
    return City.fromJson(json.decode(_response.body));
  } else {
    throw Exception('Failed to load data. Please submit an other city.');
  }
}

Future<Geo> getGeolocationWeather(_finalUrl) async {
  final _response = await http.get(Uri.parse(_finalUrl));

  if (_response.statusCode == 200) {
    return Geo.fromJson(json.decode(_response.body));
  } else {
    throw Exception('Failed to load data. Please submit an other city.');
  }
}
