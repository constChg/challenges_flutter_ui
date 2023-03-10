import 'package:flutter/material.dart';
import 'package:ui_challenge/answers/dynamic_form_answer_preview.dart';
import 'package:ui_challenge/cubit/survey_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_challenge/model/dynamic_form_question_model.dart';
import 'package:ui_challenge/widget/feedback.dart';

//TODO: challenge

//

typedef void QuestionCallBack(dynamic question, dynamic answers);
typedef void SCallBack(dynamic value);

class DynamicFormAnswerPage extends StatefulWidget {
  const DynamicFormAnswerPage({super.key});

  static const title = 'Dynamic Form';

  @override
  State<DynamicFormAnswerPage> createState() => _DynamicFormAnswerPageState();
}

class _DynamicFormAnswerPageState extends State<DynamicFormAnswerPage> {
  late GlobalKey<FormState> _surveyFormKey;

  List<QuestionType> displayQuestion = [QuestionType.title];
  List<Questions> surveyQuestions = [];
  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _surveyFormKey = GlobalKey();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // titleTextController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150), curve: Curves.linear);
    });
  }

  TextStyle kTitleStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    // double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    // SurveyCubit surveyBloc = BlocProvider.of<SurveyCubit>(context);
    return BlocBuilder<SurveyCubit, SurveyInitial>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal.shade300),
                      borderRadius: BorderRadius.circular(6)),
                  child: ListView(
                    controller: _scrollController,
                    // reverse: true,
                    children: [
                      const SizedBox(height: 10),
                      Form(
                        key: _surveyFormKey,
                        child: Column(
                          children: [
                            //TODO: List of question as QuestionDisplay Widget
                            ...List.generate(
                              state.survey.length,
                              ((index) => _displayQuestion(
                                  state.survey[index], index)!),
                            ),
                            //TODO: List of add questions options
                            const SizedBox(height: 10),
                            _submitButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _bottomBar(),
            const SizedBox(height: 25),
          ],
        );
      },
    );
  }

  Widget _submitButton() {
    return TextButton.icon(
      icon: const Icon(Icons.send_outlined),
      label: const Text('submit'),
      onPressed: () {
        bool result = _surveyFormKey.currentState!.validate();

        if (result) {
          _surveyFormKey.currentState!.save();
          bool noQuestionAdded =
              context.read<SurveyCubit>().state.survey.length == 1;
          if (noQuestionAdded) {
            EUFeedback.showSnackBar('Please add some questions', context);
            return;
          } else {
            EUFeedback.showSnackBar('Survey Added', context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<SurveyCubit>(context),
                      child: const DynamicFormPreviewPage(),
                    )));
          }
        }
      },
    );
  }

  Widget _bottomBar() {
    int surveylength = context.read<SurveyCubit>().state.survey.length;

    return IntrinsicHeight(
        child: Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                var id = DateTime.now().millisecond.toInt();
                var newQuestion = Questions(id, QuestionType.radio, '', []);
                context.read<SurveyCubit>().addQuestion(newQuestion);
                if (surveylength > 3) {
                  _scrollToBottom();
                }
              },
              icon: const Icon(Icons.radio_button_checked_outlined),
            ),
            IconButton(
              onPressed: () {
                var id = DateTime.now().millisecond.toInt();
                var newQuestion = Questions(id, QuestionType.text, '', []);
                context.read<SurveyCubit>().addQuestion(newQuestion);
                if (surveylength > 3) {
                  _scrollToBottom();
                }
              },
              icon: const Icon(Icons.text_fields_outlined),
            ),
            IconButton(
              onPressed: () {
                var id = DateTime.now().millisecond.toInt();
                var newQuestion = Questions(id, QuestionType.checkbox, '', []);
                context.read<SurveyCubit>().addQuestion(newQuestion);
                if (surveylength > 3) {
                  _scrollToBottom();
                }
              },
              icon: const Icon(Icons.check_box_outlined),
            ),
          ],
        ),
      ]),
    ));
  }

  Widget? _displayQuestion(Questions question, int itemIndex) {
    int id = DateTime.now().microsecond + DateTime.now().millisecond;
    // SurveyCubit cubit =  BlocProvider.of<SurveyCubit>(context);

    switch (question.type) {
      case QuestionType.title:
        return QuestionField(
          // key: ValueKey(question.id),
          question: question,
          textCallBack: (question, answer) {
            // Question
            // cubit.addQuestion(question)
            // surveyQuestions.add(Questions(id, question.type, question, answer));
          },
          itemIndex: itemIndex,
        );
      case QuestionType.text:
        return QuestionField(
          // key: ValueKey(question.id),
          question: question,
          textCallBack: (question, answer) {
            // surveyQuestions.add(Questions(id, question.type, question, null));
          },
          itemIndex: itemIndex,
        );
      case QuestionType.radio:
        return QuestionField(
          // key: ValueKey(question.id),
          question: question,
          textCallBack: (question, answer) {
            // storedQuestions.add(RadioQuestion(id, type, question, answer));
            if (answer != null) {
              // surveyQuestions
              //     .add(Questions(id, question.type, question, answer));
            }
          },
          itemIndex: itemIndex,
        );
      case QuestionType.checkbox:
        return QuestionField(
          // key: ValueKey(question.id),
          question: question,
          textCallBack: (question, answer) {
            if (answer != null) {
              // surveyQuestions.add(Questions(id, type, question, answer));
            }
          },
          itemIndex: itemIndex,
        );
      default:
        return null;
    }
  }
}

class QuestionField extends StatefulWidget {
  Questions question;
  QuestionCallBack textCallBack;
  List<Widget>? optionField;
  int itemIndex;

  QuestionField(
      {required this.textCallBack,
      required this.question,
      required this.itemIndex,
      super.key});

  @override
  State<QuestionField> createState() => _QuestionFieldState();
}

class _QuestionFieldState extends State<QuestionField> {
  final List<String> _answers = [];
  int counter = 2;

  @override
  Widget build(BuildContext context) {
    String title = _getQuestionTitle(widget.question.type);
    bool hasAnswersOptions = (widget.question.type != QuestionType.title &&
        widget.question.type != QuestionType.text);
    bool isNotTitle = widget.question.type != QuestionType.title;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isNotTitle)
                InkWell(
                    onTap: () {
                      context
                          .read<SurveyCubit>()
                          .removeQuestion(widget.question);
                    },
                    child: const Icon(Icons.highlight_remove_outlined))
            ],
          ),
          TextFormField(
            textAlignVertical: TextAlignVertical.center,
            // key: _answerFormKey,
            // controller: textController,

            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'please enter some text',
              prefixIcon: Icon(
                Icons.lightbulb,
                color: Colors.amber,
              ),
            ),
            initialValue: null,
            maxLines: 1,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              RegExp nonNum = RegExp(r'[0-9]');
              bool hasNum = nonNum.hasMatch(value);
              if (hasNum) {
                return 'Please enter text only';
              }
              return null;
            },
            onSaved: (newValue) {
              widget.question.question = newValue;
            },
          ),
          if (hasAnswersOptions)
            Column(
              children: [
                ...List.generate(
                  counter,
                  (index) {
                    bool isLast = counter == index + 1;
                    return _buildAnswerField(index, isLast);
                  },
                ),
              ],
            ),
          const SizedBox(height: 10),
          const Divider(color: Colors.teal, height: 15, thickness: 1),
        ],
      ),
    );
  }

  Widget _buildAnswerField(int index, bool isLast) {
    bool atLeastTwo = index != 0;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _answerField(index),
          if (isLast) ...[
            if (atLeastTwo)
              IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tight(const Size.square(24)),
                  onPressed: () {
                    counter--;
                    setState(() {});
                  },
                  icon: const Icon(Icons.remove_done_outlined
                      // size: 15,
                      )),
            IconButton(
                constraints: BoxConstraints.tight(const Size.square(24)),
                padding: EdgeInsets.zero,
                onPressed: () {
                  counter++;
                  setState(() {});
                },
                icon: const Icon(
                  Icons.add_task_outlined,
                  // size: 15,
                )),
          ],
        ],
      ),
    );
  }

  Widget _answerField(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text(
        //   'Option ${index + 1}',
        //   style: const TextStyle(),
        // ),
        Container(
          height: 30,
          width: 250,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15),
          child: TextFormField(
            // cursorHeight: 25,
            // textAlign: TextAlign.center,

            textAlignVertical: TextAlignVertical.bottom,
            // expands: false,
            // controller: textController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration.collapsed(
              // contentPadding: EdgeInsets.only(),
              // border: InputBorder.none,
              hintText: 'answer options ${index + 1}',
              // prefixIcon: const Icon(
              //   Icons.arrow_circle_right,
              //   color: Colors.blue,
              //   size: 15,
              // ),
            ),
            initialValue: null,
            // maxLength: 20,
            maxLines: 1,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              RegExp nonNum = RegExp(r'[0-9]');
              bool hasNum = nonNum.hasMatch(value);
              if (hasNum) {
                return 'Please enter text only';
              }
              return null;
            },
            onSaved: (newValue) {
              if (widget.question.answerOptions!.contains(newValue)) {
                return;
              }

              widget.question.answerOptions!.add(newValue!);
            },
          ),
        ),
      ],
    );
  }

  String _getQuestionTitle(QuestionType type) {
    switch (type) {
      case QuestionType.title:
        return 'Survey Name';
      case QuestionType.text:
        return 'Text Question';
      case QuestionType.checkbox:
        return 'Multiple Choice Question';
      case QuestionType.radio:
        return 'Single Select Question';
      default:
        return '';
    }
  }
}

// MainBody... state.survey (QuestionField)
// QuestionField class... AnswerField class
// AnswerField class --> contex.read<SurveyCubit>().add(Question())

// Main submit --> onSaved CallBack
//
