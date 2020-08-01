import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash/models/photo.dart';
import 'package:unsplash/repositories/api_repository.dart';

import 'app_events.dart';
import 'app_states.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final APIRepository repository;

  AppBloc({@required this.repository, initialState}) : super(initialState);

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    dynamic currentState = state;
    print(event);
    try {
      if (event is FetchEvent) {
        if (currentState is AppUninitialized) {
          final photos = await this.repository.fetchPhotos(1);

          yield AppLoaded(photos: photos, hasReachedMax: false, page: 1);
        }

        if (currentState is AppLoaded) {
          int nextPage = event.initial ? 1 : currentState.page + 1;

          final photos = await this.repository.fetchPhotos(nextPage);

          List<dynamic> newPhotos = [];

          if (!event.clearAll) {
            newPhotos = currentState.photos + photos;
          } else {
            newPhotos = photos;
          }

          yield AppLoaded(photos: newPhotos, hasReachedMax: false, page: nextPage);
        }
      }

      if (event is FetchWithQueryEvent) {
        if (currentState is AppUninitialized) {
          final photos = await this.repository.searchByKeywords(event.query, 1);

          yield AppLoaded(photos: photos, hasReachedMax: false, page: 1);
        }
        if (currentState is AppLoaded) {
          int nextPage = event.initial ? 1 : currentState.page + 1;

          final photos = await this.repository.searchByKeywords(event.query, nextPage);

          List<dynamic> newPhotos = [];

          if (currentState.query == event.query) {
            newPhotos = currentState.photos + photos;
          } else {
            newPhotos = photos;
          }

          yield AppLoaded(photos: newPhotos, hasReachedMax: false, page: nextPage, query: event.query);
        }
      }

      if (event is LikeEvent) {
        if (currentState is AppLoaded) {
          final response = await this.repository.likePhoto(event.photoId);

          final List updatedList = (state as AppLoaded).photos.map((photo) {
            if (photo.id == event.photoId && photo is Photo) {
              Photo newPhoto = photo.copyWith(likedByUser: true, likes: response['photo']['likes']);

              return newPhoto;
            }

            return photo;
          }).toList();

          yield currentState.copyWith(photos: updatedList);
        }
      }

      if (event is UnlikeEvent) {
        if (currentState is AppLoaded) {
          final response = await this.repository.unlikePhoto(event.photoId);

          final List updatedList = (state as AppLoaded).photos.map((photo) {
            if (photo.id == event.photoId && photo is Photo) {
              Photo newPhoto = photo.copyWith(likedByUser: false, likes: response['photo']['likes']);

              return newPhoto;
            }

            return photo;
          }).toList();

          yield currentState.copyWith(photos: updatedList);
        }
      }
    } catch(e) {
      yield AppError(message: e.toString());
    }
  }
}
