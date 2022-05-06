import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/asset_constants.dart';
import 'package:tmdb_movie_app/core/utils/navigation.dart';
import 'package:tmdb_movie_app/core/utils/routes.dart';
import 'package:tmdb_movie_app/models/movie.dart';
import 'package:tmdb_movie_app/providers/favorite_movie_provider.dart';
import 'package:tmdb_movie_app/providers/profile_provider.dart';
import 'package:tmdb_movie_app/widgets/movie_widget.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 10),
            userProfile(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Your Favourite",
                style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            userFavourite(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget userFavourite() {
    return Consumer<FavoriteMovieProvider>(
      builder: (context, model, child) {
        if (model.listMovie.isEmpty) {
          return Container(
            width: double.infinity,
            height: 250,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AssetConstant.kIconNotFound,
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 10),
                Text(
                  "You don't have any favourite movie",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          );
        } else {
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              childAspectRatio: 3 / 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: model.listMovie.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Movie movie = model.listMovie[index];
              return MovieWidget(
                movie: movie,
                isGridView: true,
                tag: "favorite",
              );
            },
          );
        }
      },
    );
  }

  Widget userProfile() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              Consumer<ProfileProvider>(
                builder: (context, model, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: model.user.imageProfile != null
                            ? Image.file(
                                model.user.imageProfile!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : FittedBox(
                                child: Icon(
                                  Icons.account_circle,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.blueGrey 
                                      : Colors.lightBlue,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Material(
                  color: Theme.of(context).colorScheme.primary,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Provider.of<ProfileProvider>(context, listen: false)
                          .changeImageProfile(context);
                    },
                    splashFactory: InkRipple.splashFactory,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.edit,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<ProfileProvider>(builder: (context, model, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    model.user.name != null ? model.user.name! : "(Your Name)",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontStyle: model.user.name != null
                              ? FontStyle.normal
                              : FontStyle.italic,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    model.user.birthDateFormatted != null
                        ? model.user.birthDateFormatted!
                        : "(Your BirthDate)",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontStyle: model.user.birthDateFormatted != null
                              ? FontStyle.normal
                              : FontStyle.italic,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    model.user.birthPlace != null
                        ? model.user.birthPlace!
                        : "(Your BirthPlace)",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontStyle: model.user.birthPlace != null
                              ? FontStyle.normal
                              : FontStyle.italic,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigation.intent(editProfileRoute);
                      },
                      child: const Text("Edit Profile"),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
