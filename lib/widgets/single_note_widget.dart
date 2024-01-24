import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleNoteWidget extends StatelessWidget {
  final String? title;
  final String? body;
  final int? color;
  final Timestamp? creationTime;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  const SingleNoteWidget({Key? key, this.title, this.body, this.color, this.onTap, this.onLongPress, this.creationTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(color!),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat.yMEd().add_jms().format(creationTime!.toDate()), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),),
            const SizedBox(height: 5,),
            Text(title!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),),
            const SizedBox(height: 5,),

            Text(body!, style: const TextStyle(color: Colors.black, fontSize: 16),),
          ],
        ),
      ),
    );
  }
}