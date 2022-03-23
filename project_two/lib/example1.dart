import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

String address2 = "";

class Example1 extends StatefulWidget {
  @override
  _Example1State createState() => _Example1State();
}

class _Example1State extends State<Example1> {
  //나중에 주 넣을때 여기
  final List<String> _suggestions = [
    '델라웨어',
    '펜실베니아',
    '뉴저지',
    '조지아',
    '코네티컷',
    '메사추세츠',
    '메릴랜드',
    '사우스캐롤라이나',
    '뉴햄프셔',
    '버지니아',
    '뉴욕',
    '노스캐롤라이나',
    '로드아일랜드',
    '버몬트',
    '켄터키',
    '테네시',
    '오하이오',
    '루이지애나',
    '인디애나',
    '미시시피',
    '일리노이',
    '앨라배마',
    '메인',
    '미주리',
    '아칸소',
    '미시간',
    '플로리다',
    '텍사스',
    '아이오와',
    '위스콘신',
    '캘리포니아',
    '새크라멘토',
    '미네소타',
    '오리건',
    '캔자스',
    '웨스트버지니아',
    '네바다',
    '네브래스카',
    '콜로라도',
    '노스다코타',
    '사우스다코타',
    '몬태나',
    '워싱턴',
    '아이다호',
    '와이오밍',
    '유타주',
    '오클라호마',
    '뉴멕시코',
    '애리조나',
    '알래스카',
    '하와이'
  ];

  final _formKey = GlobalKey<FormState>();

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchField(
              suggestionState: Suggestion.expand,
              suggestionAction: SuggestionAction.next,
              suggestions:
                  _suggestions.map((e) => SearchFieldListItem(e)).toList(),
              textInputAction: TextInputAction.next,
              controller: _searchController,
              hint: 'search state',
              // initialValue: SearchFieldListItem(_suggestions[2], SizedBox()),
              maxSuggestionsInViewPort: 5,
              itemHeight: 45,
              onTap: (x) {},
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.3,
                vertical: 10),
            child: ElevatedButton(
                onPressed: () {
                  address2 = _searchController.text;
                  print(address2);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('주소 입력'),
                )),
          )
        ],
      ),
    );
  }
}

extension FurdleTitle on String {
  Widget toTitle({double boxSize = 25}) {
    return Material(
      color: Colors.transparent,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        for (int i = 0; i < length; i++)
          Container(
              height: boxSize,
              width: boxSize,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(
                    horizontal: 2,
                  ) +
                  EdgeInsets.only(bottom: i.isOdd ? 8 : 0),
              child: Text(
                this[i].toUpperCase(),
                style: const TextStyle(
                    height: 1.1,
                    letterSpacing: 2,
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              decoration: this[i] == ' '
                  ? null
                  : BoxDecoration(boxShadow: [
                      BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 5,
                          color: Colors.black,
                          offset: Offset(0, 1)),
                      BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 5,
                          color: Colors.black,
                          offset: Offset(2, -1)),
                    ], color: Colors.blueAccent))
      ]),
    );
  }
}



/*class Example1 extends StatefulWidget {
  @override
  _Example1State createState() => _Example1State();
}

class _Example1State extends State<Example1> {
  final List<String> _suggestions = [
    'United States',
    'Germany',
    'Washington',
    'Paris',
    'Jakarta',
    'Australia',
    'India',
    'Czech Republic',
    'Lorem Ipsum',
  ];

  final _formKey = GlobalKey<FormState>();

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchField(
              suggestionState: Suggestion.expand,
              suggestionAction: SuggestionAction.next,
              suggestions:
                  _suggestions.map((e) => SearchFieldListItem(e)).toList(),
              textInputAction: TextInputAction.next,
              controller: _searchController,
              hint: 'search state plz ^^',
              // initialValue: SearchFieldListItem(_suggestions[2], SizedBox()),
              maxSuggestionsInViewPort: 13,
              itemHeight: 45,
              onTap: (x) {},
            ),
          ),
        ],
      ),
    );
  }
}

extension FurdleTitle on String {
  Widget toTitle({double boxSize = 25}) {
    return Material(
      color: Colors.transparent,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        for (int i = 0; i < length; i++)
          Container(
              height: boxSize,
              width: boxSize,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(
                    horizontal: 2,
                  ) +
                  EdgeInsets.only(bottom: i.isOdd ? 8 : 0),
              child: Text(
                this[i].toUpperCase(),
                style: const TextStyle(
                    height: 1.1,
                    letterSpacing: 2,
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              decoration: this[i] == ' '
                  ? null
                  : BoxDecoration(boxShadow: [
                      BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 5,
                          color: Colors.black,
                          offset: Offset(0, 1)),
                      BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 5,
                          color: Colors.black,
                          offset: Offset(2, -1)),
                    ], color: Colors.blueAccent))
      ]),
    );
  }
}
*/