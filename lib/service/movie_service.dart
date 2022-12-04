import 'package:f290_acf_themoviedb_api_ct/model/movie_model.dart';
import 'package:f290_acf_themoviedb_api_ct/repository/movie_repository.dart';

class MovieDBService {
  final MovieRepository repository;

  MovieDBService(this.repository);

  Future<List<MovieModel>> getMovies(String title) async {
    if (title.isEmpty) {
      return repository.getUpComming();
    }

    return repository.findMovies(title);
  }
}
