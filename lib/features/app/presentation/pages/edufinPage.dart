

import 'package:contact_art/controllers/EdufinProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EdufinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preguntas Frecuentes'),
      ),
      body: Consumer<EdufinProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: provider.questions.map<Widget>((question) {
              int index = provider.questions.indexOf(question);
              return ExpansionPanelList(
                expansionCallback: (int panelIndex, bool isExpanded) {
                  provider.togglePanel(index);
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(question.question),
                      );
                    },
                    body: ListTile(
                      title: Text(question.answer),
                    ),
                    isExpanded: provider.selectedIndex == index,
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
