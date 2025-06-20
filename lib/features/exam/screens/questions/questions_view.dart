import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yallabina/core/constant/colors.dart';
import 'package:yallabina/core/data/models/responses/authResponse/login_response.dart';
import 'package:yallabina/core/data/utils/shared_pref_utils.dart';
import 'package:yallabina/features/exam/screens/questions/questions_controller.dart';
import '../../../../core/service/socket.dart';
import '../../../../core/voice_calls/agora_controller.dart';

class ExamScreen extends StatefulWidget {
  final String classId;
  final String subjectId;
  final String gender;
  final int scientificTrack; // كـ int
  final int totalPoints;    // إضافة totalPoints

  const ExamScreen({
    super.key,
    required this.classId,
    required this.subjectId,
    required this.gender,
    required this.scientificTrack,
    required this.totalPoints, // إضافة هنا
  });

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final ExamController controller = Get.put(ExamController());
  final SocketService socketService = Get.find<SocketService>();
  final SharedPrefUtils sharedPrefUtils = Get.find<SharedPrefUtils>();
  final AgoraController agoraController = Get.put(AgoraController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSocketConnection();
    });
  }

  void _startSocketConnection() async {
    UserDM? userDM = await sharedPrefUtils.getUser();
    socketService.sendMatchRequest(
      email: userDM!.email!,
      subjectId: widget.subjectId.toString(),
      preferredGenderId: widget.gender,
      gradeLevelId: widget.classId.toString(),
      scientificTrackId: widget.scientificTrack, // int
      totalPoints: widget.totalPoints,          // استخدام totalPoints
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: SafeArea(
              child: Obx(() {
                if (controller.isWaitingForMatch.value) {
                  return _buildWaitingForMatch();
                }
                if (controller.isLoading.value && controller.hasExamStarted.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                }
                if (controller.hasExamStarted.value && controller.questions.isNotEmpty) {
                  return _buildExamContent();
                }
                return const Center(child: Text("حدث خطأ غير متوقع"));
              }),
            ),
          ),
          Obx(() {
            if (agoraController.callStatus.value == 'ringing') {
              return _buildIncomingCallOverlay();
            }
            if (agoraController.callStatus.value == 'in_call') {
              return _buildActiveCallOverlay();
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Widget _buildIncomingCallOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Incoming Call",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () => controller.acceptCall(),
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.call),
                ),
                const SizedBox(width: 40),
                FloatingActionButton(
                  onPressed: agoraController.endCall,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.call_end),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveCallOverlay() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Obx(() => Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.call, color: Colors.green),
            const SizedBox(width: 10),
            const Text("In Call", style: TextStyle(color: Colors.white)),
            const Spacer(),
            IconButton(
              icon: Icon(
                agoraController.isMuted.value ? Icons.mic_off : Icons.mic,
                color: Colors.white,
              ),
              onPressed: agoraController.toggleMute,
            ),
            IconButton(
              icon: const Icon(Icons.call_end, color: Colors.red),
              onPressed: agoraController.endCall,
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildExamContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildQuestionCard(),
              const SizedBox(height: 20),
              _buildAnswersList(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWaitingForMatch() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          const Text(
            '🔍 Waiting for match...',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Searching for an opponent with similar skills',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.text.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // تعديل للتوزيع المتساوي
    children: [
      Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: Obx(() => CircleAvatar(
              radius: 25, // تقليل الحجم
              backgroundColor: AppColors.primary.withOpacity(0.3),
              child: ClipOval(
                child: controller.opponentProfilePic.value.isNotEmpty
                    ? Image.network(
                        controller.opponentProfilePic.value,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/images/3d-cartoon-character (1).png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/images/3d-cartoon-character (1).png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
              ),
            )),
          ),
          const SizedBox(height: 5),
          Obx(() => Text(
            "${controller.opponentName.value} (ID: ${controller.opponentId.value})",
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.text,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          )),
        ],
      ),
      Column(
        children: [
          const Text(
            "الوقت المتبقي",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.text,
              fontFamily: 'Cairo',
            ),
          ),
          Obx(() => Text(
            "${controller.timeLeft.value} ث",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
              fontFamily: 'Cairo',
            ),
          )),
        ],
      ),
      Column(
        children: [
          const Text(
            "ترتيب الخصم",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
              fontFamily: 'Cairo',
            ),
          ),
          Obx(() => Text(
            "${controller.opponentRank.value}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
              fontFamily: 'Cairo',
            ),
          )),
        ],
      ),
    ],
  );
}

  Widget _buildQuestionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Obx(() => Text(
        controller.questions.isNotEmpty
            ? controller.questions[controller.currentQuestionIndex.value].title
            : "جارٍ تحميل الأسئلة...",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.text,
          fontFamily: 'Cairo',
        ),
      )),
    );
  }

  Widget _buildAnswersList(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 200,
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: Obx(() {
        final currentIndex = controller.currentQuestionIndex.value;
        final selectedIndex = controller.selectedAnswerIndex.value;
        final isSubmitting = controller.isSubmitting.value;

        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: controller.questions.isNotEmpty
              ? controller.questions[currentIndex].options.length
              : 0,
          itemBuilder: (context, index) {
            final option = controller.questions[currentIndex].options[index];
            bool isSelected = selectedIndex == index + 1;
            Color cardColor = isSelected ? Colors.green : Colors.white.withOpacity(0.8);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: () {
                  controller.selectedAnswerIndex.value = index + 1;
                  controller.submitAnswerAndProceed();
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Text(
                        option,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: isSelected ? Colors.white : AppColors.text,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      if (isSelected && isSubmitting)
                        const Positioned(
                          right: 0,
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}