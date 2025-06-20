// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../voice_calls/agora_controller.dart';
//
// class AgoraVoiceCallView extends StatelessWidget {
//   final AgoraController _controller = Get.put(AgoraController());
//   final String targetUserName; // Name of the person being called
//   final bool isIncomingCall; // Whether this is an incoming call
//   final String channelName; // Channel name for the call
//
//   AgoraVoiceCallView({
//     super.key,
//     required this.targetUserName,
//     required this.isIncomingCall,
//     required this.channelName,
//   }) {
//     // Automatically initiate call if it's outgoing
//     if (!isIncomingCall) {
//       // _controller.callUser(channelName);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Obx(() {
//           switch (_controller.callStatus.value) {
//             case 'calling':
//               return const Text('Calling...');
//             case 'ringing':
//               return const Text('Incoming Call');
//             case 'in_call':
//               return const Text('Ongoing Call');
//             case 'ended':
//               return const Text('Call Ended');
//             default:
//               return const Text('Voice Call');
//           }
//         }),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           child: Obx(() {
//             switch (_controller.callStatus.value) {
//               case 'calling':
//                 return _buildCallingView();
//               case 'ringing':
//                 return _buildIncomingCallView();
//               case 'in_call':
//                 return _buildActiveCallView();
//               case 'ended':
//                 return _buildCallEndedView();
//               default:
//                 return _buildReadyView();
//             }
//           }),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCallingView() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // User avatar
//         CircleAvatar(
//           radius: 60,
//           backgroundColor: Colors.blue[100],
//           child: const Icon(Icons.person, size: 60, color: Colors.blue),
//         ),
//         const SizedBox(height: 20),
//         // User name
//         Text(
//           'Calling $targetUserName...',
//           style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         // Status text
//         const Text(
//           'Waiting for response',
//           style: TextStyle(color: Colors.grey),
//         ),
//         const SizedBox(height: 40),
//         // Cancel call button
//         FloatingActionButton(
//           backgroundColor: Colors.red,
//           onPressed: _controller.endCall,
//           child: const Icon(Icons.call_end, color: Colors.white),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildIncomingCallView() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // User avatar
//         CircleAvatar(
//           radius: 60,
//           backgroundColor: Colors.blue[100],
//           child: const Icon(Icons.person, size: 60, color: Colors.blue),
//         ),
//         const SizedBox(height: 20),
//         // User name
//         Text(
//           '$targetUserName is calling...',
//           style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 40),
//         // Accept/Reject buttons
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Reject button
//             FloatingActionButton(
//               backgroundColor: Colors.red,
//               onPressed: _controller.endCall,
//               child: const Icon(Icons.call_end, color: Colors.white),
//             ),
//             const SizedBox(width: 40),
//             // Accept button
//             FloatingActionButton(
//               backgroundColor: Colors.green,
//               onPressed: () => _controller.acceptCall(channelName),
//               child: const Icon(Icons.call, color: Colors.white),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActiveCallView() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // User avatar
//         CircleAvatar(
//           radius: 60,
//           backgroundColor: Colors.blue[100],
//           child: const Icon(Icons.person, size: 60, color: Colors.blue),
//         ),
//         const SizedBox(height: 20),
//         // User name
//         Text(
//           targetUserName,
//           style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         // Call duration (you would implement this separately)
//         const Text(
//           '00:45',
//           style: TextStyle(fontSize: 16, color: Colors.grey),
//         ),
//         const SizedBox(height: 40),
//         // Call controls
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Mute button
//             CircleAvatar(
//               radius: 30,
//               backgroundColor:
//                   _controller.isMuted.value ? Colors.red : Colors.blue,
//               child: IconButton(
//                 icon: Icon(
//                   _controller.isMuted.value ? Icons.mic_off : Icons.mic,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//                 onPressed: _controller.toggleMute,
//               ),
//             ),
//             const SizedBox(width: 30),
//             // End call button
//             CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.red,
//               child: IconButton(
//                 icon: const Icon(
//                   Icons.call_end,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//                 onPressed: _controller.endCall,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCallEndedView() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // Call ended icon
//         const Icon(Icons.call_end, size: 80, color: Colors.red),
//         const SizedBox(height: 20),
//         // Call ended text
//         const Text(
//           'Call Ended',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         // Duration (if you tracked it)
//         const Text(
//           'Duration: 01:23',
//           style: TextStyle(fontSize: 16, color: Colors.grey),
//         ),
//         const SizedBox(height: 40),
//         // Close button
//         ElevatedButton(
//           onPressed: () => Get.back(),
//           child: const Text('Close'),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildReadyView() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Icon(Icons.phone, size: 80, color: Colors.blue),
//         const SizedBox(height: 20),
//         const Text(
//           'Ready to Call',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 40),
//         // ElevatedButton(
//         //   onPressed: () => _controller.callUser(channelName,use),
//         //   child: const Text('Start Call'),
//         // ),
//       ],
//     );
//   }
// }
