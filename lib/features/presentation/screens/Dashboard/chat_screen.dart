import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/config/theme/spaces.dart';
import 'package:palmmessenger/core/constants/images.dart';
import 'package:palmmessenger/features/presentation/widgets/textfeild.dart';

import '../../../../config/theme/textstyles.dart';
import '../../utility/gradient_text.dart';
import 'chats/contactListScreen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
                              Get.to(ContactListScreen());
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
                child: ListView(
                  children: [
                    _chatTile("Emma", "Encrypting thoughts....", "9:15", vector, unread: 3),
                    _chatTile("Rachel", "And then you can ask him", "7:08", vector, unread: 5),
                    _chatTile("Emily", "Yea sure working on it", "15:03", vector),
                    _chatTile("James", "I'll send it and you just need", "12:01",vector),
                    _chatTile("Alice", "Will see you tommorow!!", "1:03", vector),
                  ],
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
}
