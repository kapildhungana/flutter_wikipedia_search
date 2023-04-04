// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:search_app/repository/search_repository.dart';

import '../../models/search_data.dart';

part 'search_result_state.dart';

class SearchResultCubit extends Cubit<SearchResultState> {
  final SearchRepository searchRepository = SearchRepository();
  SearchResultCubit() : super(SearchResultInitial());

  Future<void> fetchSearchData(String data) async {
    emit(SearchResultLoading());
    try {
      List<SearchData> result = await searchRepository.fetchData(data);
      debugPrint("************************* $result.length");
      emit(SearchResultFetched(list: result));
    } catch (err) {
      emit(SearchResultFailed());
    }
  }
}
