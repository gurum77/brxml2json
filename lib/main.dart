import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml2json/xml2json.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XML2JSON',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'XML2JSON'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static List<TextEditingController> controllers = [];
  runXml2Json() {
    var xmlText = controllers[0].text;
    final xml2json = Xml2Json();
    xml2json.parse(xmlText);
    controllers[1].text = xml2json.toGData();
  }

  runJson2Xml() {
    var jsonText = controllers[1].text;

    controllers[0].text = jsonText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InputForm('XML', runXml2Json),
            SizedBox(
              width: 30,
            ),
            InputForm('JSON', runJson2Xml)
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class InputForm extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();
  String name;
  Function run;
  bool isXML = true;
  InputForm(
    this.name,
    this.run, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_MyHomePageState.controllers.length < 2) {
      isXML = name == "XML";
      textEditingController.text = isXML
          ? '<note>\n  <to>Tove</to>\n  <from>Jani</from>\n  <heading>Reminder</heading>\n  <body>Do not forget me this weekend</body>\n</note>'
          : "";
      _MyHomePageState.controllers.add(textEditingController);
    }

    double boxWidth = MediaQuery.of(context).size.width * 0.4;

    return Column(
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(height: 30),
        // 아이콘들
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // web에서 clipboard button이 동작하지 않아서 주석처리함.
            // ClipboardButton(isXML: isXML, textEditingController: textEditingController)
          ],
        ),
        Container(
          width: boxWidth,
          height: 300,
          child: TextFormField(
            controller: textEditingController,
            onChanged: (text) {
              print(text);
            },
            maxLines: 20,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
        ),
        SizedBox(height: 20),
        isXML
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15)),
                onPressed: () {
                  run();
                },
                child: isXML
                    ? Text(
                        '-> JSON',
                        style: TextStyle(fontSize: 30),
                      )
                    : Text('<- XML'),
              )
            : SizedBox(
                height: 1,
              )
      ],
    );
  }
}

class ClipboardButton extends StatelessWidget {
  const ClipboardButton({
    Key? key,
    required this.isXML,
    required this.textEditingController,
  }) : super(key: key);

  final bool isXML;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isXML ? 'Paste text from clipboard' : 'Copy text to clipboard',
      child: IconButton(
          onPressed: () {
            if (isXML) {
              Clipboard.getData(Clipboard.kTextPlain)
                  .then((value) => textEditingController.text = value!.text!);
            } else {
              Clipboard.setData(
                  ClipboardData(text: textEditingController.text));
            }
          },
          icon: Icon(isXML ? Icons.paste : Icons.copy)),
    );
  }
}
