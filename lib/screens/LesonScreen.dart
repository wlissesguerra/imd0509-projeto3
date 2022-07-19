import 'package:alcanceaulas/component/aula_anotacoes.dart';
import 'package:alcanceaulas/model/Anotacao.dart';
import 'package:alcanceaulas/model/SelectedLesson.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:io';

import '../component/anotacaoForm.dart';

class LesonScreen extends StatefulWidget {
  @override
  State<LesonScreen> createState() => _LesonScreenState();
}

class _LesonScreenState extends State<LesonScreen> {
  List<Anotacao> anotacoes = [];
  void _openAnotacaoForm() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(32),
          height: 600,
          color: Colors.white,
          child: AnotacaoForm(_salvarAnotacao),
        );
      },
    );
  }

  _salvarAnotacao(String anotacao, List<File> images) {
    setState(() {
      anotacoes.add(Anotacao(text: anotacao, images: images));
    });
  }

  _deletarAnotacao(String anotacao) {
    setState(() {
      anotacoes.removeWhere((element) => element.text == anotacao);
    });
  }

  Widget build(BuildContext context) {
    final leson = context.watch<SelectedLeson>().leson;
    anotacoes = leson.anotacoes;
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: leson.video,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(leson.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                leson.description,
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.bodyText1),
              ),
            ),
            YoutubePlayer(
              controller: _controller,
              bottomActions: [
                CurrentPosition(),
                ProgressBar(isExpanded: true),
              ],
            ),
            AulaAnotacoes(anotacoes, _deletarAnotacao)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          _openAnotacaoForm();
        },
      ),
    );
  }
}
