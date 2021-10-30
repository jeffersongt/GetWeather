import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:getweather/models/post.dart';

Future<Post> fetchPost(_finalUrl) async {
  final _response = await http.get(Uri.parse(_finalUrl));

  if (_response.statusCode == 200) {
    return Post.fromJson(json.decode(_response.body));
  } else {
    throw Exception('Failed to load data. Please submit an other city.');
  }
}
