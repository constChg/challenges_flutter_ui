import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ui_challenge/cubit/status_mixin.dart';
import 'package:ui_challenge/model/dynamic_form_question_model.dart';

part 'survey_state.dart';

class SurveyCubit extends Cubit<SurveyInitial> {
  SurveyCubit()
      : super(
            SurveyInitial([Questions(0, QuestionType.title, '', [])])..empty());

  void addQuestion(Questions question) {
    try {
      emit(state..loading());
      var result = state.survey..add(question);
      emit(SurveyInitial(result)..success());
    } catch (e) {
      emit(state..fail(e.toString()));
    }
  }

  void removeQuestion(Questions question) {
    try {
      emit(state..loading());
      int removeIndex = state.survey.indexOf(question);
      var result = state.survey..removeAt(removeIndex);
      emit(SurveyInitial(result)..success());
    } catch (e) {
      emit(state..fail(e.toString()));
    }
  }

  void resetSurvey() {
    try {
      emit(state..loading());
      emit(SurveyInitial([Questions(0, QuestionType.title, '', [])]));
    } catch (e) {
      emit(state..fail(e.toString()));
    }
  }
}
