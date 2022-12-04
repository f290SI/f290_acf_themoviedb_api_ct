import 'package:f290_acf_themoviedb_api_ct/model/movie_model.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final MovieModel? movie;

  const DetailPage({super.key, required this.movie});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final imageUrl = 'https://image.tmdb.org/t/p/w780/';
  double sliderRateValue = 5.0;
  String sliderLabel = '';

  get image {
    if (widget.movie?.posterPath == null) {
      return 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg';
    }
    return '$imageUrl${widget.movie?.backdropPath}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.network(image),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  widget.movie!.title!,
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.movie!.overview!.isEmpty
                      ? 'Ainda não existe overview...'
                      : widget.movie!.overview!,
                  style: const TextStyle(fontSize: 22),
                  textAlign: TextAlign.justify,
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Text(widget.movie!.voteAverage!.toString()),
                ),
                title: Text(widget.movie!.originalTitle!),
                subtitle: Text('Popularidade: ${widget.movie!.popularity}'),
              ),
              Text(
                'Avaliar',
                style: Theme.of(context).textTheme.headline6,
              ),
              Slider(
                value: sliderRateValue,
                min: 0,
                max: 10,
                divisions: 10,
                onChanged: ((value) {
                  setState(() {
                    sliderRateValue = value;
                    sliderLabel = value.toString();
                  });
                }),
              ),
              Center(
                child: Text(
                  sliderLabel,
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //TODO: Criar POST
        },
        icon: const Icon(Icons.rate_review),
        label: const Text('AVALIAR'),
      ),
    );
  }
}
