import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/utils/shared_pref_utils.dart';

class AgoraController extends GetxController {
  late final RtcEngine _engine;
  var isJoined = false.obs;
  var remoteUid = Rx<int?>(null);
  var isMuted = false.obs;
  var isCallActive = false.obs;
  var callStatus = Rx<String>(''); // Can be 'calling', 'ringing', 'in_call', 'ended'
  final SharedPrefUtils sharedPrefUtils = Get.find<SharedPrefUtils>();

  @override
  void onInit() {
    super.onInit();
    initAgora();
  }

  Future<void> initAgora() async {
    print('[Agora] Requesting microphone permission...');
    await [Permission.microphone].request();

    print('[Agora] Initializing Agora engine...');
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: 'd355dc9df1824d32bd425540f35dd433',
    ));

    print('[Agora] Registering event handlers...');
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print('[Agora] Successfully joined channel: ${connection.channelId}, elapsed: $elapsed ms');
          isJoined.value = true;
          if (callStatus.value == 'ringing') {
            callStatus.value = 'in_call';
          }
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print('[Agora] Remote user joined: $remoteUid, elapsed: $elapsed ms');
          this.remoteUid.value = remoteUid;
          isCallActive.value = true;
          callStatus.value = 'in_call';
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          print('[Agora] Remote user went offline: $remoteUid, reason: $reason');
          this.remoteUid.value = null;
          endCall();
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          print('[Agora] Left the channel');
          isJoined.value = false;
          remoteUid.value = null;
          isCallActive.value = false;
        },
        onError: (ErrorCodeType err, String msg) {
          print('[Agora] Error: $err, message: $msg');
          callStatus.value = 'error';
        },
      ),
    );

    await _engine.enableAudio();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    print('[Agora] Audio enabled and role set to broadcaster');
  }

  // Call a specific user with a unique channel name
  // Future<void> callUser(String targetUserId) async {
  //   UserDM? user=await sharedPrefUtils.getUser();
  //
  //   if (isCallActive.value) return;
  //
  //   callStatus.value = 'calling';
  //
  //   // Generate a unique channel name based on both users' IDs
  //   // You might want to implement your own logic here
  //   String channelName = _generateChannelName(user!.id!, targetUserId);
  //
  //   print('[Agora] Initiating call to $targetUserId in channel $channelName');
  //
  //   // In a real app, you would:
  //   // 1. Send a notification to the target user (via Firebase, Socket, etc.)
  //   // 2. Wait for them to accept the call
  //   // 3. Then join the channel
  //
  //   // For demo purposes, we'll just join the channel directly
  //   await joinChannel(channelName);
  // }

  // Accept an incoming call
  // Future<void> acceptCall(String channelName) async {
  //   callStatus.value = 'ringing';
  //   await joinChannel(channelName);
  // }

  // Join a channel
  Future<void> joinChannel(String channelName) async {
    if (isJoined.value) return;

    print('[Agora] Joining channel $channelName...');
    await _engine.joinChannel(
      channelId: 'yallabena',
      uid: 0, // Let Agora assign a UID
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
      token: '',
    );
  }

  // End the current call
  Future<void> endCall() async {
    if (!isJoined.value) return;

    print('[Agora] Ending call...');
    await _engine.leaveChannel();
    isCallActive.value = false;
    callStatus.value = 'ended';

    // In a real app, you would notify the other user that the call has ended
  }

  Future<void> toggleMute() async {
    await _engine.muteLocalAudioStream(!isMuted.value);
    isMuted.toggle();
  }

  String _generateChannelName(String user1Id, String user2Id) {
    // Create a consistent channel name regardless of caller/callee order
    List<String> ids = [user1Id, user2Id]..sort();
    return 'call_${ids[0]}_${ids[1]}';
  }


  // Add this method to generate a consistent channel name
  String generateChannelName(String user1Id, String user2Id) {
    // Sort IDs to ensure both users generate the same channel name
    var ids = [user1Id, user2Id]..sort();
    return 'exam_call_${ids[0]}_${ids[1]}';
  }

  // Modify the callUser method
  Future<void> callUser(String myUserId, String otherUserId) async {
    if (isCallActive.value) return;

    callStatus.value = 'calling';
    String channelName = generateChannelName(myUserId, otherUserId);
    await joinChannel(channelName);
  }

  // Add this method for the other user to join
  Future<void> joinCall(String myUserId, String otherUserId) async {
    callStatus.value = 'ringing';
    String channelName = generateChannelName(myUserId, otherUserId);
    await joinChannel(channelName);
  }


  @override
  void onClose() {
    print('[Agora] Disposing Agora engine...');
    _engine.leaveChannel();
    _engine.release();
    super.onClose();
  }
}