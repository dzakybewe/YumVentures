import 'package:flutter/material.dart';
import 'package:yum_ventures/data/api/api_service.dart';
import 'package:yum_ventures/data/model/detail_result.dart';
import '../data/result_state.dart';

class DetailProvider extends ChangeNotifier{
  final ApiService apiService = ApiService();

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  DetailProvider({required id}){
    fetchDetail(id);
  }

  late DetailResult _detailResult;
  DetailResult get detailResult => _detailResult;

  Future<dynamic> fetchDetail(String id) async {
    try{
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.fetchDetail(id);
      if (restaurant.error){
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'empty data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _detailResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error -> Something Went Wrong';
    }
  }

  late PostReview _postReview;
  PostReview get postReview => _postReview;
  Future<dynamic> addReview(String id, String name, String review) async {
    try{
      _state = ResultState.loading;
      notifyListeners();
      final post = await apiService.postReview(id, name, review);
      if (post.error){
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'empty data';
      } else {
        final updatedDetails = await apiService.fetchDetail(id);
        _state = ResultState.hasData;
        notifyListeners();

        updateReview(updatedDetails.restaurant.customerReviews);

        return updatedDetails;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error -> Something Went Wrong';
    }
  }

  void updateReview(List<CustomerReview> reviews) {
    _detailResult.restaurant.customerReviews = reviews;
    notifyListeners();
  }
}