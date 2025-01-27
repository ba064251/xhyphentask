
import '../api_services/surah_model.dart';

abstract class QuranState {}

class QuranInitial extends QuranState {}

class LoadingState extends QuranState{}

class LoadQuranState extends QuranState{
  final List<SurahModel> surah;

  LoadQuranState(this.surah);
}

class ErrorState extends QuranState{
  final String error;

  ErrorState(this.error);
}

class SuccessState extends QuranState{
  final String success;

  SuccessState(this.success);
}
