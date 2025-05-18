import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';

class CustomeTodoCard extends StatefulWidget {
  final String cardtitle;
  final bool btnvisible; //Boolean value
  final bool isTaskCompleted;
  const CustomeTodoCard({super.key, required this.cardtitle, required this.btnvisible, required this.isTaskCompleted});

  @override
  State<CustomeTodoCard> createState() => _CustomeTodoCardState();
}

class _CustomeTodoCardState extends State<CustomeTodoCard> {
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenwidth,
      height: 70,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.accentColor.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Radio(value:widget.isTaskCompleted?1: 0, groupValue: (), onChanged: (value) {}),
          Text(
            widget.cardtitle,
            style: TextStyle(
              fontFamily: "poppins",
              color:widget.isTaskCompleted?AppColor.fontcolor: AppColor.accentColor,//If the task is completed according to that app color is shown
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          Spacer(),
          widget.isTaskCompleted
              ? SizedBox(width: 10)//We use this to if btnvisble is true these icons should be visible other wise they are not visible
              //It is passed from the database and checked if it is true or not
             : Column(
                children: [
                  Spacer(),
                  Icon(Icons.edit),
                  SizedBox(height: 5),
                  Icon(Icons.delete, color: Colors.red),
                  Spacer(),
                ],
              )
              
        ],
      ),
    );
  }
}
