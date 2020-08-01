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

    if (event is FetchEvent) {
      if (currentState is AppUninitialized) {
        final photos = await this.repository.fetchPhotos(1);

        yield AppLoaded(photos: photos, hasReachedMax: false, page: 1);
      }
      if (currentState is AppLoaded) {
        final photos = await this.repository.fetchPhotos(currentState.page + 1);

        if(event.clearAll) {
          yield photos.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : AppLoaded(
              photos: photos,
              hasReachedMax: false,
              page: currentState.page + 1);
        } else {
          yield photos.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : AppLoaded(
              photos: currentState.photos + photos,
              hasReachedMax: false,
              page: currentState.page + 1);
        }
      }
    }

    if (event is FetchWithQueryEvent) {
      if (currentState is AppUninitialized) {
        final photos = await this.repository.searchByKeywords(event.query, 1);

        yield AppLoaded(photos: photos, hasReachedMax: false, page: 1);
      }
      if (currentState is AppLoaded) {
        final photos = await this.repository.searchByKeywords(event.query, currentState.page + 1);

        if(currentState.query == event.query) {
          yield photos.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : AppLoaded(
              photos: currentState.photos + photos,
              hasReachedMax: false,
              page: currentState.page + 1,
              query: event.query);
        } else {
          yield photos.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : AppLoaded(
              photos: photos,
              hasReachedMax: false,
              page: currentState.page + 1,
              query: event.query);
        }
      }
    }

    if (event is LikeEvent) {
      if (currentState is AppLoaded) {
        final response = await this.repository.likePhoto(event.photoId);

        final List updatedList = (state as AppLoaded).photos.map((photo) {
          if (photo.id == event.photoId && photo is Photo) {
            Photo newPhoto = photo.copyWith(
                likedByUser: true, likes: response['photo']['likes']);

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
            Photo newPhoto = photo.copyWith(
                likedByUser: false, likes: response['photo']['likes']);

            return newPhoto;
          }

          return photo;
        }).toList();

        yield currentState.copyWith(photos: updatedList);
      }
    }
  }
}
