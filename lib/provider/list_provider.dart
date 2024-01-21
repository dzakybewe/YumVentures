import 'package:flutter/material.dart';
import 'package:yum_ventures/data/api/api_service.dart';
import '../data/model/list_result.dart';
import '../data/result_state.dart';

class ListProvider extends ChangeNotifier{
  final ApiService apiService = ApiService();

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  ListProvider(){
    fetchList();
  }

  late ListResult _listResult;
  ListResult get listResult => _listResult;

  Future<dynamic> fetchList() async {
    try{
      _state = ResultState.loading;
      notifyListeners();
      final restaurants = await apiService.fetchList();
      if (restaurants.restaurants.isEmpty){
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'empty data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _listResult = restaurants;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error -> Something Went Wrong';
    }
  }
}