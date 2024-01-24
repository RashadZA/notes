import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/database/database_handler.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/utils/utility.dart';
import 'package:notes/widgets/button_widget.dart';
import 'package:notes/widgets/dialog_box_widget.dart';
import 'package:notes/widgets/form_widget.dart';

class EditNoteScreen extends StatefulWidget {
  final NoteModel noteModel;
  const EditNoteScreen({Key? key, required this.noteModel}) : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNoteScreen> {
  TextEditingController? _titleController;
  TextEditingController? _bodyController;
  int selectedColor = 4294967295;

  bool _isNoteEditing = false;


  @override
  void initState() {
    _titleController = TextEditingController(text: widget.noteModel.title);
    _bodyController = TextEditingController(text: widget.noteModel.body);
    selectedColor = widget.noteModel.color!;
    super.initState();
  }

  @override
  void dispose() {
    _titleController!.dispose();
    _bodyController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isNoteEditing == true? lightGreyColor : darkBackgroundColor,
      body: AbsorbPointer(
        absorbing: _isNoteEditing,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: [
                _isNoteEditing == true ? Image.asset("assets/ios_loading.gif", width: 50, height: 50,) : Container(),
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
                          const Text("Update",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                          ButtonWidget(icon: Icons.save_outlined, onTap: () {
                            showDialogBoxWidget(
                              context,
                              height: 200,
                              title: "Save Changes ?",
                              onTapYes: () {
                                _editNote();
                                Navigator.pop(context);
                              },
                            );
                          }),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FormWidget(
                        fontSize: 30,
                        controller: _titleController!,
                        hintText: "Title",
                      ),
                      const SizedBox(height: 10),
                      FormWidget(
                        maxLines: 15,
                        fontSize: 20,
                        controller: _bodyController!,
                        hintText: "Start typing...",
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 80,
                        width: double.infinity,
                        alignment: Alignment.center,
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

  _editNote() {
    setState(() => _isNoteEditing = true);
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      if(_titleController!.text.isEmpty) {
        toast(message: 'Enter Title');
        setState(() => _isNoteEditing = false);
        return;
      }
      if(_bodyController!.text.isEmpty) {
        toast(message: 'Type something in the body');
        setState(() => _isNoteEditing = false);
        return;
      }
      DatabaseHandler.updateNote(NoteModel(
          id: widget.noteModel.id,
          title: _titleController!.text,
          body: _bodyController!.text,
          color: selectedColor,
          creationTime: Timestamp.now()
      )).then((value) {
        _isNoteEditing = false;
        Navigator.pop(context);
      });
    });
  }
}