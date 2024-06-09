import 'package:flutter/material.dart';
import 'package:yum_ventures/data/api/api_service.dart';
import 'package:yum_ventures/data/model/search_result.dart';
import '../utils/result_state.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  SearchProvider({required query}) {
    fetchSearch(query);
  }

  late SearchResult _searchResult;
  SearchResult get searchResult => _searchResult;

  Future<dynamic> fetchSearch(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final search = await apiService.fetchSearch(query);
      if (search.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'empty data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _searchResult = search;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error -> Something Went Wrong';
    }
  }
}
