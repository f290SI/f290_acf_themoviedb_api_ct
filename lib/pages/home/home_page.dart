import 'dart:developer';

import 'package:f290_acf_themoviedb_api_ct/model/movie_model.dart';
import 'package:f290_acf_themoviedb_api_ct/pages/detail/detail_page.dart';
import 'package:f290_acf_themoviedb_api_ct/repository/movie_repository.dart';
import 'package:f290_acf_themoviedb_api_ct/service/movie_service.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget searchBar = const Text('TheMovieDB');
  Icon selectIcon = const Icon(Icons.search);
  String title = '';

  late MovieDBService service;
  late MovieRepository repository;
  List<MovieModel>? movies = [];

  @override
  void initState() {
    super.initState();

    service = MovieDBService(MovieRepository());
    service.getMovies(title).then((value) {
      movies = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    const imageUrlTemplate = 'https://image.tmdb.org/t/p/w500/';
    const defaultImage =
        'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg';

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: searchBar,
        actions: [
          IconButton(
            icon: selectIcon,
            onPressed: () {
              setState(() {
                if (selectIcon.icon == Icons.search) {
                  selectIcon = const Icon(Icons.cancel);
                  searchBar = TextField(
                    onSubmitted: (text) {
                      setState(() {
                        title = text;
                      });
                    },
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  );
                } else {
                  setState(() {
                    selectIcon = const Icon(Icons.search);
                    searchBar = const Text('The MovieDB');
                    title = "";
                  });
                }
              });
            },
          )
        ],
      ),
      body: FutureBuilder(
        initialData: movies,
        future: service.getMovies(title),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return loadingSpinner();
          }
          movies = snapshot.data as List<MovieModel>;
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GridView.builder(
              itemCount: movies?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 2 / 3,
                  crossAxisCount: 2),
              itemBuilder: ((context, index) {
                var movie = movies![index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Expanded(
                        child: Ink.image(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            movie.posterPath == null
                                ? '$imageUrlTemplate$defaultImage'
                                : '$imageUrlTemplate${movie.posterPath}',
                          ),
                          child: InkWell(onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        DetailPage(movie: movie))));
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }

  Widget loadingSpinner() {
    return const Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: LoadingIndicator(
          indicatorType: Indicator.ballRotateChase,
          colors: [
            Colors.blue,
            Colors.green,
            Colors.yellow,
            Colors.orange,
            Colors.red
          ],
        ),
      ),
    );
  }
}
