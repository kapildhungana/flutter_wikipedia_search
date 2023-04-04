import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../logic/cubit/search_result_cubit.dart';
import '../models/search_data.dart';
import '../myweb_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // bool _searchBoolean = false;
  // bool _isFetching = false;

  // late List<SearchData> _list = [];
  late TextEditingController textEditingController = TextEditingController();

  // void emptyList() {
  //   setState(() {
  //     textEditingController.text = '';
  //     _list = [];
  //   });
  // }

  Widget _searchListView(List<SearchData> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => MyWebView(
                          title: list[index].title,
                          selectedUrl: list[index].url,
                        )));
                // .then((value) => emptyList());
              },
              child: Card(child: ListTile(title: Text(list[index].title))));
        });
  }

  Widget _defaultView() {
    return const Center(
      child: Text("Nothing to show"),
    );
  }

  // Future<void> fetchData(String str) async {
  //   if (str == "") {
  //     emptyList();
  //   } else {
  //     final queryParameters = {
  //       'action': 'opensearch',
  //       'format': 'json',
  //       'search': str,
  //       'namespace': '0',
  //       'limit': '10',
  //       'formatversion': '2',
  //     };
  //     // final uri =
  //     //     Uri.https('en.wikipedia.org/w/api.php?', queryParameters as String);

  //     // final url = Uri.https('en.wikipedia.org',
  //     //     '/w/api.php?action=opensearch&format=json&search=Ham&namespace=0&limit=10&formatversion=2');

  //     final url = Uri.https('en.wikipedia.org', '/w/api.php', queryParameters);
  //     try {
  //       final response = await http.get(url);
  //       if (response.statusCode == 200) {
  //         final extractedData = json.decode(response.body) as List<dynamic>;
  //         setState(() {
  //           // _list = [...extractedData[1]];
  //           List<SearchData> tempList = [];
  //           for (int i = 0; i < extractedData[1].length; i++) {
  //             tempList.add(SearchData(
  //                 title: extractedData[1][i],
  //                 description: extractedData[2][i],
  //                 url: extractedData[3][i]));
  //           }
  //           _list = [...tempList];
  //         });

  //         debugPrint(extractedData[0]);
  //       } else {
  //         debugPrint('Some error occured: {$response.statusCode}');
  //       }
  //     } catch (err) {
  //       debugPrint('some error occured');
  //     }
  //   }
  //   _isFetching = false;
  // }

  Widget _searchTextField() {
    return TextField(
      onChanged: (String s) {
        // _isFetching = true;
        // fetchData(textEditingController.text);
        BlocProvider.of<SearchResultCubit>(context)
            .fetchSearchData(textEditingController.text);
        // setState(() {
        //   _searchBoolean = true;
        // });
      },
      controller: textEditingController,
      autofocus: false,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      // textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: _searchTextField(), actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                context
                    .read<SearchResultCubit>()
                    .fetchSearchData(textEditingController.text);
                // _isFetching = true;
                // if (textEditingController.text != '') {
                //   fetchData(textEditingController.text);
                //   setState(() {
                //     _searchBoolean = true;
                //     textEditingController.text = '';
                //   });
                // }
              })
        ]),
        body: BlocBuilder<SearchResultCubit, SearchResultState>(
            builder: (context, state) {
          if (state is SearchResultLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else if (state is SearchResultInitial) {
            return _defaultView();
          } else if (state is SearchResultFetched) {
            // return const Center(
            //   child: Text('List of items'),
            // );
            return _searchListView(state.listItem);
          } else {
            return const Center(
              child: Text("No results found"),
            );
          }
        }));
  }
}
