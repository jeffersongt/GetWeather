class Post {
  final String city;
  final String skyDesc;
  final double temp;
  final double feel;
  final double humidity;

  Post(
      {required this.city,
      required this.skyDesc,
      required this.temp,
      required this.feel,
      required this.humidity});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      city: json['name'],
      skyDesc: json['weather'][0]['description'],
      temp: json['main']['temp'],
      feel: json['main']['feels_like'],
      humidity: json['main']['humidity'],
    );
  }
}
