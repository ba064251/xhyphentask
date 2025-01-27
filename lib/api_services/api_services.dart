import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskbyxhyphen/api_services/surah_model.dart';

class ApiService{


  Future<List<SurahModel>> getSurahAndAyahs()async{
    var request = http.Request('GET', Uri.parse('https://api.alquran.cloud/v1/quran/ur.jhaladhry'));


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();

      Map<String, dynamic> data = jsonDecode(res);
      List<dynamic> surahData = data["data"]["surahs"];

      List<SurahModel> surahsData = surahData.map((data){
        return SurahModel(
            number: data['number'],
            name: data['name'],
            englishName: data['englishName'],
            englishNameTranslation: data['englishNameTranslation'],
            revelationType: data['revelationType'],
            ayahs: data['ayahs']);
      }).toList();
      return surahsData;
    }
    else {
      var error = response.reasonPhrase;
      return [];
    }

  }


}