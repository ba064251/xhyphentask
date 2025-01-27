import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbyxhyphen/api_services/api_services.dart';
import 'package:taskbyxhyphen/bloc/quran_bloc.dart';
import 'package:taskbyxhyphen/bloc/quran_event.dart';
import 'package:taskbyxhyphen/bloc/quran_state.dart';

import 'api_services/surah_model.dart';
import 'contants/size_config.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiBlocProvider(providers: [
      BlocProvider<QuranBloc>(create: (context) => QuranBloc(ApiService()),),
    ], child: const MaterialApp(
      home: SurahViewer(),
      debugShowCheckedModeBanner: false,
    ));
  }
}

class SurahViewer extends StatefulWidget {
  const SurahViewer({super.key});

  @override
  State<SurahViewer> createState() => _SurahViewerState();
}

class _SurahViewerState extends State<SurahViewer> {

  SurahModel? selectedSurah; // To store the selected value
  int currentPage = 0;


  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<QuranBloc>(context).add(LoadSurahEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List currentAyahs = selectedSurah != null
        ? selectedSurah!.ayahs.skip(currentPage * 8).take(8).toList()
        : [];
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<QuranBloc, QuranState>(builder: (context, state) {
      
          if(state is LoadQuranState){
            final surah = state.surah;
            return Column(
              children: [

                SizedBox(height: SizeConfig.heightMultiplier * 2,),

                DropdownButton<SurahModel>(
                  value: selectedSurah,
                  hint: const Text("Select a Surah"),
                  items: surah.map((surah) {
                    return DropdownMenuItem<SurahModel>(
                      value: surah,
                      child: Text(surah.englishName),
                    );
                  }).toList(),
                  onChanged: (SurahModel? value) {
                    setState(() {
                      selectedSurah = value;
                      currentPage = 0;// Update the selected Surah
                    });
                  },
                ),

                SizedBox(height: SizeConfig.heightMultiplier * 2,),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: SizeConfig.screenWidth * 1,
                  height: SizeConfig.screenHeight * 0.6,
                  child: selectedSurah?.ayahs.length != null ?  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    itemCount: currentAyahs.length,
                    itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Text("${currentAyahs[index]["number"]}",textAlign: TextAlign.right,),
                        const Text("------------",textAlign: TextAlign.right,),
                        Text(currentAyahs[index]["text"],textAlign: TextAlign.right,),
                      ],
                    );
                  },) :  const Text("Select Surah"),
                ),

                SizedBox(height: SizeConfig.heightMultiplier * 2,),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: currentPage > 0
                            ? () {
                          setState(() {
                            currentPage--; // Go to the previous page
                          });
                        }
                            : null, // Disable button if on the first page
                        child: const Text("Previous"),
                      ),
                      selectedSurah?.ayahs.length != null ? ElevatedButton(
                          onPressed: (currentPage + 1) * 8 < selectedSurah!.ayahs.length
                            ? () {
                            setState(() {
                              currentPage++; // Go to the next page
                            });
                          }
                          : () {
                          // If no more ayahs, move to the next Surah
                       int currentSurahIndex = surah.indexOf(selectedSurah!);
                        if (currentSurahIndex + 1 < surah.length) {
                          setState(() {
                            selectedSurah = surah[currentSurahIndex + 1];
                            currentPage = 0; // Reset page for the new Surah
                          });
                        }
                       },
                  child: Text("Next"),
                       )  : const SizedBox(),
                    ],
                  ),
                ),
      
      
              ],
            );
          }
      
          else if(state is LoadingState){
            return const Center(child: CircularProgressIndicator());
          }
      
          else if (state is ErrorState){
            return Center(child: Text(state.error),);
          }
      
          else{
            return const Center(child: Text("Loading State"),);
          }
        },),
      ),
    );
  }
}
