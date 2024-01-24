import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/database/database_handler.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/utils/utility.dart';
import 'package:notes/widgets/button_widget.dart';
import 'package:notes/widgets/form_widget.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({Key? key}) : super(key: key);

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  bool _isNoteCreating = false;


  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  int selectedColor = 4294967295;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isNoteCreating == true? lightGreyColor : darkBackgroundColor,
      body: AbsorbPointer(
        absorbing: _isNoteCreating,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: [
                _isNoteCreating == true ? Image.asset("assets/ios_loading.gif", width: 50, height: 50,) : Container(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 50),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ButtonWidget(
                            icon: Icons.arrow_back,
                            onTap: () => Navigator.pop(context),
                          ),
                          const Text("Create",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                          ButtonWidget(icon: Icons.done, onTap: _createNote),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FormWidget(
                        fontSize: 30,
                        controller: _titleController,
                        hintText: "Title",
                      ),
                      const SizedBox(height: 10),
                      FormWidget(
                        maxLines: 15,
                        fontSize: 20,
                        controller: _bodyController,
                        hintText: "Start typing...",
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          itemCount: predefinedColors.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final singleColor = predefinedColors[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColor = singleColor.value;
                                });
                              },
                              child: Container(
                                width: 60,
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                height: 60,
                                decoration: BoxDecoration(
                                    color: singleColor,
                                    border: Border.all(width: 3, color: selectedColor == singleColor.value? Colors.white : Colors.transparent),
                                    shape: BoxShape.circle),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _createNote() {
    setState(() => _isNoteCreating = true);
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      if(_titleController.text.isEmpty) {
        toast(message: 'Enter Title');
        setState(() => _isNoteCreating = false);
        return;
      }
      if(_bodyController.text.isEmpty) {
        toast(message: 'Type something in the body');
        setState(() => _isNoteCreating = false);
        return;
      }
      DatabaseHandler.createNote(NoteModel(
          title: _titleController.text,
          body: _bodyController.text,
          color: selectedColor,
        creationTime: Timestamp.now()
      )).then((value) {
        _isNoteCreating = false;
        Navigator.pop(context);
      });
    });
  }
}