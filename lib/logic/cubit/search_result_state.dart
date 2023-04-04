// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_result_cubit.dart';

@immutable
abstract class SearchResultState {}

class SearchResultInitial extends SearchResultState {}

class SearchResultLoading extends SearchResultState {}

class SearchResultFetched extends SearchResultState {
  final List<SearchData> list;
  SearchResultFetched({
    required this.list,
  });

  List<SearchData> get listItem {
    return list;
  }
}

class SearchResultFailed extends SearchResultState {}
