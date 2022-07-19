import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnotacaoForm extends StatefulWidget {
  void Function(String anotacao, List<File> images) onSubmit;

  AnotacaoForm(this.onSubmit);

  @override
  State<AnotacaoForm> createState() => _AnotacaoFormState();
}

class _AnotacaoFormState extends State<AnotacaoForm> {
  final anotacaoController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<File> _imageFileList = [];
  void _onSubmit() {
    widget.onSubmit(anotacaoController.text, _imageFileList);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: anotacaoController,
          decoration: const InputDecoration(
            label: Text("Escreva aqui sua anotação..."),
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 16)),
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                XFile imageFile = await _picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 600,
                  imageQuality: 80,
                ) as XFile;
                if (imageFile == null) return;
                setState(() {
                  _imageFileList.add(File(imageFile.path));
                });
                print("Imagens:" + _imageFileList.toString());
              },
              child: const Icon(Icons.library_add),
            ),
            SizedBox(
              width: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                XFile imageFile = await _picker.pickImage(
                  source: ImageSource.camera,
                  maxWidth: 600,
                  imageQuality: 80,
                ) as XFile;
                if (imageFile == null) return;
                setState(() {
                  _imageFileList.add(File(imageFile.path));
                });
                print("Imagens:" + _imageFileList.length.toString());
              },
              child: const Icon(Icons.camera_alt),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.only(bottom: 16)),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _imageFileList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(right: 16),
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              child: Image.file(_imageFileList[index]),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    _imageFileList.removeAt(index);
                                  });
                                },
                                icon: Icon(Icons.delete))
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            _onSubmit();
          },
          child: const Text("Salvar"),
        )
      ],
    );
  }
}
