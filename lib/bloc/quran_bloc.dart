import 'package:bloc/bloc.dart';
import 'package:taskbyxhyphen/bloc/quran_event.dart';
import 'package:taskbyxhyphen/bloc/quran_state.dart';

import '../api_services/api_services.dart';


class QuranBloc extends Bloc<QuranEvent, QuranState> {
  ApiService apiServices;
  QuranBloc(this.apiServices) : super(QuranInitial()) {
    on<LoadSurahEvent>(_onQuranSurahGet);
  }

  void _onQuranSurahGet(LoadSurahEvent event, Emitter<QuranState> emit)async{
    try{
      emit(LoadingState());
      final data = await apiServices.getSurahAndAyahs();
      emit(LoadQuranState(data));
    } catch(e){
      emit(ErrorState(e.toString()));
    }
  }
}
