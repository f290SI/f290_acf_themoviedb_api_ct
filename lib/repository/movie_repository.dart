import 'dart:convert';
import 'dart:io';

import 'package:f290_acf_themoviedb_api_ct/model/movie_model.dart';
import 'package:http/http.dart';

class MovieRepository {
  static String apiKey = 'SUA_API_KEY';

  Future getData(String url) async {
    final response = await get(Uri.parse(url));

    if (response.statusCode == HttpStatus.ok) {
      return response.body;
    }

    throw Exception('Falha getData(). URL: $url. Message: ${response.body}');
  }

  Future<List<MovieModel>> getUpComming() async {
    final String urlGetUpcomming =
        'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey&language=pt-BR&page=1';

    var json = await getData(urlGetUpcomming);
    var movieMap = jsonDecode(json);
    var movieList = movieMap['results'];

    List<MovieModel> movies =
        movieList.map<MovieModel>((json) => MovieModel.fromJson(json)).toList();

    return movies;
  }
}
