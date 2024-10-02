import 'package:book_forest/api/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<dynamic> request(String endPoint, Object json) async {
  var url = BASE_URL + endPoint;

  try {
    var response = await http.post(
        Uri.parse(url),
        body: convert.jsonEncode(json)
    );

    if(response.statusCode != 200) {
      return {'result': -1, 'message': "에러가 발생했습니다 다시 시도해주세요."};
    }

    var data = convert.jsonDecode(response.body);
    var result = data['result'];
    var message = data['message'];

    if(result != 0) {
      return {'result': result, 'message': message};
    }

    return {'result': result, 'json': data};
  } catch(e) {
    return {'result': -1, 'message': "에러가 발생했습니다 다시 시도해주세요."};
  }

}
