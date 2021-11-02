class City {
  final String city;
  final String skyDesc;
  final int skyId;
  final double temp;
  final double feel;
  final int humidity;

  City(
      {required this.city,
      required this.skyDesc,
      required this.skyId,
      required this.temp,
      required this.feel,
      required this.humidity});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      city: json['name'],
      skyDesc: json['weather'][0]['description'],
      skyId: json['weather'][0]['id'],
      temp: json['main']['temp'],
      feel: json['main']['feels_like'],
      humidity: json['main']['humidity'],
    );
  }
}

class Geo {
  final String timezone;
  final String skyDesc;
  final int skyId;
  final double temp;
  final double feel;
  final int humidity;

  Geo(
      {required this.timezone,
      required this.skyDesc,
      required this.skyId,
      required this.temp,
      required this.feel,
      required this.humidity});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(
      timezone: json['timezone'],
      skyDesc: json['current']['weather'][0]['description'],
      skyId: json['current']['weather'][0]['id'],
      temp: json['current']['temp'],
      feel: json['current']['feels_like'],
      humidity: json['current']['humidity'],
    );
  }
}
