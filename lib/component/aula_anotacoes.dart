import 'package:alcanceaulas/model/Anotacao.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AulaAnotacoes extends StatefulWidget {
  void Function(String) onDelete;
  List<Anotacao> anotacoes;
  AulaAnotacoes(this.anotacoes, this.onDelete);

  @override
  State<AulaAnotacoes> createState() => _AulaAnotacoesState();
}

class _AulaAnotacoesState extends State<AulaAnotacoes> {
  _deletarAnotacao(String anotacao) {
    widget.onDelete(anotacao);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.all(16),
      color: Colors.yellowAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Anotações",
              style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.headline4,
              )),
          const Padding(padding: EdgeInsets.only(bottom: 16)),
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.anotacoes.length,
              itemBuilder: (context, index) {
                final anotacao = widget.anotacoes[index];
                return Column(
                  children: [
                    ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.check_box),
                        onPressed: () {
                          _deletarAnotacao(anotacao.text);
                        },
                      ),
                      title: Text(
                        "- ${anotacao.text}",
                        style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.bodyText1),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 200,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: anotacao.images.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 70,
                                          child: Image.file(
                                              anotacao.images[index]),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
