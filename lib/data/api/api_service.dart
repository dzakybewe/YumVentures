import 'dart:convert';
import 'package:yum_ventures/data/model/detail_result.dart';
import 'package:yum_ventures/data/model/list_result.dart';
import 'package:http/http.dart' as http;
import 'package:yum_ventures/data/model/search_result.dart';

class ApiService{
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  static const String _listEndPoint = '/list';
  static const String _detailEndPoint = '/detail/';
  static const String _searchEndPoint = '/search?q=';
  static const String _reviewEndPoint = '/review';

  Future<ListResult> fetchList() async {
    final response = await http.get(Uri.parse(_baseUrl+_listEndPoint));
    if (response.statusCode == 200) {
      return ListResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error on api service');
    }
  }

  Future<DetailResult> fetchDetail(String id) async {
    final response = await http.get(Uri.parse(_baseUrl+_detailEndPoint+id));
    if (response.statusCode == 200) {
      return DetailResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error on api service');
    }
  }

  Future<SearchResult> fetchSearch(String query) async {
    final response = await http.get(Uri.parse(_baseUrl+_searchEndPoint+query));
    if (response.statusCode == 200) {
      return SearchResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error on api service');
    }
  }

  Future<PostReview> postReview(String id, String name, String review) async {
    final response = await http.post(
      Uri.parse(_baseUrl+_reviewEndPoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id': id,
        'name': name,
        'review': review,
      })
    );

    if (response.statusCode == 201) {
      return PostReview.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error on api service');
    }
  }
}