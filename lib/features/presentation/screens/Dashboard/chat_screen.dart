// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:palmmessenger/config/theme/app_themes.dart';
// import 'package:palmmessenger/config/theme/spaces.dart';
// import 'package:palmmessenger/core/constants/images.dart';
// import 'package:palmmessenger/features/presentation/widgets/textfeild.dart';
//
// import '../../../../config/theme/textstyles.dart';
// import '../../utility/gradient_text.dart';
// import 'chats/contactListScreen.dart';
//
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   int selectedFilter = 0;
//   TextEditingController searchCtrl =TextEditingController();
//   List<String> filters = ['All', 'Unread', 'Groups', 'Calls'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric( vertical: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                   GradientText('Chats',style: Styles.boldTextStyle(size: 40)),
//                     Row(
//                       children: [
//                         Image.asset(chat_people,width:35,height: 25,fit: BoxFit.cover,),
//                         wSpace(10),
//                         InkWell(
//                             onTap: (){
//                               Get.to(ContactListScreen());
//                             },
//                             child: Image.asset(add,width:40,fit: BoxFit.cover)),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//               hSpace(20),
//               buildTextField(searchCtrl, 'search', MediaQuery.sizeOf(context).width, 45, TextInputType.text,prefixIcon: Icon(Icons.search,color: ColorResources.whiteColor),postfixIcon: Icon(Icons.mic,color: ColorResources.whiteColor),radius:40, ),
//              hSpace(20),
//               SizedBox(
//                 height: 30,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: filters.length,
//                   itemBuilder: (context, index) {
//                     bool isSelected = index == selectedFilter;
//                     return GestureDetector(
//                       onTap: () => setState(() => selectedFilter = index),
//                       child: Container(
//                         decoration: BoxDecoration(
//                          gradient:isSelected? GradientColor.gradient1:null,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         margin: const EdgeInsets.symmetric(horizontal: 8),
//                         child: Container(
//                           alignment: Alignment.center,
//                           margin: const EdgeInsets.symmetric(horizontal: 2,vertical: 2),
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           decoration: BoxDecoration(
//                             color: isSelected
//                                 ? ColorResources.blackColor
//                                 : ColorResources.secondaryColor,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             filters[index],
//                             style:Styles.semiBoldTextStyle(color:ColorResources.whiteColor,size: 14)
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               hSpace(15),
//               Expanded(
//                 child: ListView(
//                   children: [
//                     _chatTile("Emma", "Encrypting thoughts....", "9:15", vector, unread: 3),
//                     _chatTile("Rachel", "And then you can ask him", "7:08", vector, unread: 5),
//                     _chatTile("Emily", "Yea sure working on it", "15:03", vector),
//                     _chatTile("James", "I'll send it and you just need", "12:01",vector),
//                     _chatTile("Alice", "Will see you tommorow!!", "1:03", vector),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _chatTile(String name, String message, String time, String avatarPath, {int unread = 0}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: ColorResources.secondaryColor,
//             backgroundImage: AssetImage(avatarPath),
//             radius: 25,
//           ),
//           wSpace(10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name,
//                     style: Styles.semiBoldTextStyle(size: 15,color: ColorResources.whiteColor)),
//               hSpace(4),
//                 Text(message,
//                     overflow: TextOverflow.ellipsis,
//                     style:  Styles.mediumTextStyle(color: ColorResources.whiteColor.withOpacity(0.7),size: 15)),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(time,
//                   style: Styles.mediumTextStyle(color: ColorResources.whiteColor.withOpacity(0.9))),
//              hSpace(4),
//               if (unread > 0)
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: GradientColor.gradient1,
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Container(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     margin: EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       color: ColorResources.blackColor,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       unread.toString(),
//                       style: const TextStyle(color: Colors.white, fontSize: 12),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_themes.dart';
import '../../../../config/theme/spaces.dart';
import '../../../../config/theme/textstyles.dart';
import '../../../../core/constants/images.dart';
import '../../../data/encryption/rsa_helper.dart';
import '../../../data/model/message_model.dart';
import '../../../data/model/user_model.dart';
import '../../../helper/database_service.dart';
import '../../../helper/websocket_service.dart';
import '../../utility/gradient_text.dart';
import '../../widgets/textfeild.dart';
import 'chats/chat_screen.dart';
import 'chats/contactListScreen.dart';

class ChatListScreen extends StatefulWidget {
  String? localUserId;
  RSAHelper? rsaHelper;
  String? privateKeyPem;
  DBService? db;
  WebSocketService? socket;

  ChatListScreen({
    required this.localUserId,
    required this.rsaHelper,
    required this.privateKeyPem,
    required this.db,
    required this.socket,
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<LatestChatModel> _latestChats = [];


  @override
  void initState() {
    loadLatestMessages();
    super.initState();
  }

  Future<void> loadLatestMessages() async {
    final messages = await widget.db?.getLatestMessagesGroupedByPeer(widget.localUserId!);

    List<LatestChatModel> chats = [];

    for (var msg in messages ?? []) {
      final peerId = msg.senderId == widget.localUserId ? msg.receiverId : msg.senderId;
      final peerUser = await widget.db?.getUser(peerId);
      if (peerUser != null) {
        chats.add(LatestChatModel(message: msg, peerUser: peerUser));
      }
    }

    setState(() {
      _latestChats = chats;
    });
  }

  int selectedFilter = 0;
  TextEditingController searchCtrl =TextEditingController();
  List<String> filters = ['All', 'Unread', 'Groups', 'Calls'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric( vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientText('Chats',style: Styles.boldTextStyle(size: 40)),
                    Row(
                      children: [
                        Image.asset(chat_people,width:35,height: 25,fit: BoxFit.cover,),
                        wSpace(10),
                        InkWell(
                            onTap: (){
                              Get.to(ContactListScreen(
                                localUserId: widget.localUserId.toString(),
                                rsaHelper: widget.rsaHelper,
                                privateKeyPem: widget.privateKeyPem,
                                db: widget.db,
                                socket: widget.socket,
                              ));
                            },
                            child: Image.asset(add,width:40,fit: BoxFit.cover)),
                      ],
                    )
                  ],
                ),
              ),
              hSpace(20),
              buildTextField(searchCtrl, 'search', MediaQuery.sizeOf(context).width, 45, TextInputType.text,prefixIcon: Icon(Icons.search,color: ColorResources.whiteColor),postfixIcon: Icon(Icons.mic,color: ColorResources.whiteColor),radius:40, ),
              hSpace(20),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    bool isSelected = index == selectedFilter;
                    return GestureDetector(
                      onTap: () => setState(() => selectedFilter = index),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient:isSelected? GradientColor.gradient1:null,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 2,vertical: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ColorResources.blackColor
                                : ColorResources.secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                              filters[index],
                              style:Styles.semiBoldTextStyle(color:ColorResources.whiteColor,size: 14)
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              hSpace(15),
              Expanded(
                child: ListView.builder(
                  itemCount: _latestChats.length,
                  itemBuilder: (context, index) {
                    final chat = _latestChats[index];
                    final msg = chat.message;
                    final peer = chat.peerUser;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              peer: peer,
                              localUserId: widget.localUserId!,
                              rsaHelper: widget.rsaHelper,
                              privateKeyPem: widget.privateKeyPem,
                              db: widget.db,
                              socket: widget.socket,
                            ),
                          ),
                        );
                      },
                      child: _chatTile(
                        peer.name, // 👈 display actual name
                        msg.content,
                        '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                        vector, // You can replace this with peer.avatarPath if available
                        unread: 3,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatTile(String name, String message, String time, String avatarPath, {int unread = 0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorResources.secondaryColor,
            backgroundImage: AssetImage(avatarPath),
            radius: 25,
          ),
          wSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: Styles.semiBoldTextStyle(size: 15,color: ColorResources.whiteColor)),
                hSpace(4),
                Text(message,
                    overflow: TextOverflow.ellipsis,
                    style:  Styles.mediumTextStyle(color: ColorResources.whiteColor.withOpacity(0.7),size: 15)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time,
                  style: Styles.mediumTextStyle(color: ColorResources.whiteColor.withOpacity(0.9))),
              hSpace(4),
              if (unread > 0)
                Container(
                  decoration: BoxDecoration(
                    gradient: GradientColor.gradient1,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: ColorResources.blackColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      unread.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text('Chats')),
  //     body: ListView.builder(
  //       itemCount: _latestMessages.length,
  //       itemBuilder: (context, index) {
  //         final msg = _latestMessages[index];
  //         final peerId = msg.senderId == widget.localUserId ? msg.receiverId : msg.senderId;
  //         return ListTile(
  //           title: Text(peerId),
  //           subtitle: Text(msg.content),
  //           trailing: Text(
  //             '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
  //           ),
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (_) => ChatScreen(
  //                   localUserId: widget.localUserId,
  //                   peerUserId: peerId,
  //                   peerName: peerId,
  //                   signalService: widget.signalService,
  //                   webSocketService: widget.webSocketService,
  //                   db: widget.db,
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }
}
class LatestChatModel {
  final MessageModel message;
  final UserModel peerUser;

  LatestChatModel({required this.message, required this.peerUser});
}
