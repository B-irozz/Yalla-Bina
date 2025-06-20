import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/data/models/responses/authResponse/login_response.dart';
import '../../../../core/data/repos/exam/questions_repo.dart';
import '../../../../core/data/utils/shared_pref_utils.dart';
import '../../../../core/service/socket.dart';
import '../../../../core/voice_calls/agora_controller.dart';
import '../../../home/screens/main_screen.dart';

class ExamController extends GetxController {
  // Dependencies
  final QuestionsRepository questionsRepository = QuestionsRepository();
  final SocketService socketService = Get.find<SocketService>();
  final SharedPrefUtils sharedPrefUtils = Get.find<SharedPrefUtils>();

  // Observables
  final isWaitingForMatch = true.obs;
  final hasExamStarted = false.obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final showCorrectAnimation = false.obs;
  final currentQuestionIndex = 0.obs;
  final questions = <Question>[].obs;
  final myPoints = 0.obs;
  final opponentName = ''.obs; // Removed static "أحمد علي"
  final timeLeft = 0.obs;
  final isMuted = false.obs;
  final selectedAnswerIndex = Rx<int?>(null);
  final isSubmitting = false.obs;
  final answerFeedback = RxString('');
  final userEmail = ''.obs;
  String examId = "";
  final userAnswers = <UserAnswer>[].obs;

  // Observables for opponent data
  final opponentId = ''.obs;   // Opponent ID
  final opponentProfilePic = ''.obs; // Opponent profile picture
  final opponentRank = 0.obs;  // Opponent rank

  final AgoraController agoraController = Get.put(AgoraController());
  String? matchedUserId;

  void onMatchFound(String userId) {
    matchedUserId = userId;
    Future.delayed(const Duration(seconds: 1), () async {
      UserDM? user = await Get.find<SharedPrefUtils>().getUser();
      agoraController.callUser(user!.id!, userId);
    });
  }

  void acceptCall() async {
    UserDM? user = await Get.find<SharedPrefUtils>().getUser();
    if (matchedUserId != null) {
      agoraController.joinCall(user!.id!, matchedUserId!);
    }
  }

  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    _listenToSocketMessages();
  }

  void _listenToSocketMessages() {
  socketService.messages.listen((message) {
    print('Received socket message: $message');
    try {
      final data = jsonDecode(message);
      final msg = data['message'];
      final type = data['type'];

      if (msg == '🔍 Waiting for match...') {
        _setMatchWaitingState();
      } else if (type == 'exam_started') {
        _setExamStartedState(data);
      } else if (msg == '❌ Failed to start exam') {
        errorMessage.value = data['error'] ?? 'Failed to start exam';
        isWaitingForMatch.value = false;
        hasExamStarted.value = false;
        Get.snackbar('خطأ', errorMessage.value, duration: Duration(seconds: 3));
      }
    } catch (e) {
      print('Error parsing socket message: $e');
      errorMessage.value = 'خطأ في الاتصال، حاول مرة أخرى';
      Get.snackbar('خطأ', errorMessage.value, duration: Duration(seconds: 3));
    }
  }, onError: (e) {
    print('Socket error: $e');
    errorMessage.value = 'خطأ في الاتصال بالخادم';
    Get.snackbar('خطأ', errorMessage.value, duration: Duration(seconds: 3));
  });
}

  void _setMatchWaitingState() {
    isWaitingForMatch.value = true;
    hasExamStarted.value = false;
  }

  Future<void> _setExamStartedState(Map<String, dynamic> examData) async {
  UserDM? user = await sharedPrefUtils.getUser();
  if (examData['examId'] == null) {
    errorMessage.value = 'Invalid exam data';
    Get.snackbar('خطأ', errorMessage.value, duration: Duration(seconds: 3));
    return;
  }
  examId = examData["examId"];
  isWaitingForMatch.value = false;
  hasExamStarted.value = true;

  final matchedUser = examData['matchedUser'];
  if (matchedUser == null) {
    errorMessage.value = 'No matched user data';
    Get.snackbar('خطأ', errorMessage.value, duration: Duration(seconds: 3));
    return;
  }

  opponentName.value = matchedUser['name'] ?? 'Unknown';
  opponentId.value = matchedUser['studentId']?.toString() ?? 'N/A';
  opponentProfilePic.value = matchedUser['profilePic'] ?? '';
  opponentRank.value = matchedUser['rank'] ?? 0;

  _handleExamStarted(examData);
  onMatchFound(user!.id!);
}

  void _handleExamStarted(Map<String, dynamic> data) {
    timeLeft.value = 300;

    final receivedQuestions = (data['questions'] as List)
        .map((q) => Question(
              id: q['questionId'],
              title: q['questionText'],
              options: List<String>.from(q['options']),
              marks: q['marks'],
            ))
        .toList();

    questions.assignAll(receivedQuestions);
    isLoading.value = false;

    startTimer();
  }

  void startTimer() {
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (timeLeft.value > 0) {
      timeLeft.value--;
    } else {
      _timer.cancel();
      if (!Get.isSnackbarOpen) {
        Get.snackbar("انتهى الوقت", "انتهى وقت الامتحان!", duration: Duration(seconds: 2));
        finishExam();
      }
    }
  });
}

  Future<void> submitAnswerAndProceed() async {
    final currentQuestion = questions[currentQuestionIndex.value];

    userAnswers.add(UserAnswer(
      questionId: currentQuestion.id,
      selectedAnswer: currentQuestion.options[selectedAnswerIndex.value! - 1],
    ));
    await Future.delayed(const Duration(milliseconds: 500));

    if (currentQuestionIndex.value < questions.length - 1) {
      selectedAnswerIndex.value = 0;
      moveToNextQuestion();
    } else {
      finishExam();
    }
  }

  void moveToNextQuestion() {
    currentQuestionIndex.value++;
    selectedAnswerIndex.value = null;
  }

  Future<void> finishExam() async {
  UserDM? user = await sharedPrefUtils.getUser();
  final answersToSubmit = userAnswers.map((answer) => answer.toMap()).toList();

  SocketService.to.submitAnswers(
    examId: examId,
    studentId: user!.randomId!,
    email: user.email!,
    answers: answersToSubmit,
  );

  StreamSubscription? subscription;
  subscription = SocketService.to.messages.listen((message) {
    try {
      final decoded = jsonDecode(message);
      if (decoded['type'] == 'exam_results') {
        if (!(Get.isDialogOpen ?? false)) { // تحقق مع قيمة افتراضية لو كان null
          showDialog(
            context: Get.context!,
            builder: (context) => AlertDialog(
              title: Text(
                'نتيجة الاختبار',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الدرجة: ${decoded['score'] ?? 0}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(decoded['message'] ?? 'انتهى الوقت وحسبت درجتك'),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: (decoded['questions'] as List?)?.length ?? 0,
                        itemBuilder: (context, index) {
                          final question = decoded['questions'][index];
                          final isCorrect = question['isCorrect'] as bool? ?? false;
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(
                                question['questionText'] ?? 'No question',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('إجابتك: ${question['selectedAnswer'] ?? 'N/A'}'),
                                  Text(
                                    'الإجابة الصحيحة: ${question['correctAnswer'] ?? 'N/A'}',
                                    style: TextStyle(
                                      color: isCorrect ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: isCorrect ? Colors.green : Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.offAll(() => MainScreen()); // توجيه لـ Home
                    subscription?.cancel(); // إلغاء الاشتراك بعد الخروج
                  },
                  child: Text('حسناً'),
                ),
              ],
            ),
          );
        }
        subscription?.cancel(); // إلغاء الاشتراك بعد عرض الـ Dialog
      }
    } catch (e) {
      print('Error parsing exam_results: $e');
      Get.snackbar('خطأ', 'فشل في عرض النتيجة، حاول مرة أخرى');
    }
  }, onDone: () {
    subscription?.cancel(); // إلغاء عند انتهاء الـ Stream
  }, onError: (e) {
    print('Socket error in results: $e');
    subscription?.cancel();
  });

  _timer.cancel(); // إلغاء الـ Timer فوراً
  Get.snackbar('تم الإرسال', 'جاري تحميل نتيجتك...', duration: const Duration(seconds: 2));
}
  void toggleMute() {
    isMuted.value = !isMuted.value;
  }

  void endExam() {
    _timer.cancel();
    Get.snackbar("انتهى الامتحان", "لقد أنهيت الامتحان بنقاط: ${myPoints.value}");
  }
}

class UserAnswer {
  final String questionId;
  final String selectedAnswer;

  UserAnswer({required this.questionId, required this.selectedAnswer});

  Map<String, String> toMap() {
    return {
      'questionId': questionId,
      'selectedAnswer': selectedAnswer,
    };
  }
}

class Question {
  final String id;
  final String title;
  final List<String> options;
  final int marks;

  Question({
    required this.id,
    required this.title,
    required this.options,
    required this.marks,
  });
}