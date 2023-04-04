import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/search_data.dart';

class SearchRepository {
  Future<List<SearchData>> fetchData(String str) async {
    // debugPrint('****************************');
    // if (str == "") {
    //   emptyList();
    // } else {
    final queryParameters = {
      'action': 'opensearch',
      'format': 'json',
      'search': str,
      'namespace': '0',
      'limit': '10',
      'formatversion': '2',
    };
    // final uri =
    //     Uri.https('en.wikipedia.org/w/api.php?', queryParameters as String);

    // final url = Uri.https('en.wikipedia.org',
    //     '/w/api.php?action=opensearch&format=json&search=Ham&namespace=0&limit=10&formatversion=2');

    final url = Uri.https('en.wikipedia.org', '/w/api.php', queryParameters);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List<dynamic>;
        // setState(() {
        // _list = [...extractedData[1]];
        List<SearchData> tempList = [];
        for (int i = 0; i < extractedData[1].length; i++) {
          tempList.add(SearchData(
              title: extractedData[1][i],
              description: extractedData[2][i],
              url: extractedData[3][i]));
        }
        // _list = [...tempList];
        // });
        return tempList;
        // debugPrint(extractedData[0]);
      } else {
        debugPrint('Some error occured: {$response.statusCode}');
        // return
        return [];
      }
    } catch (err) {
      debugPrint('some error occured');
      // return [];
      throw Error();
    }
  }
  // _isFetching = false;
  // }
}
