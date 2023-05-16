import 'package:flutter/material.dart';
import 'package:my_crud_app/model.dart';
import 'database.dart';
import 'itemCardWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DbManager dbManager = new DbManager();

  Model model;
  List<Model> modelList;
  TextEditingController input1 = TextEditingController();
  TextEditingController input2 = TextEditingController();
  FocusNode input1FocusNode;
  FocusNode input2FocusNode;

  @override
  void initState() {
    input1FocusNode = FocusNode();
    input2FocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    input1FocusNode.dispose();
    input2FocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite CRUD Demo'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return DialogBox().dialog(
                  context: context,
                  onPressed: () {
                    Model model = new Model(
                        firstName: input1.text, lastName: input2.text);
                    dbManager.insertModel(model);
                    setState(() {
                      input1.text = "";
                      input2.text = "";
                    });
                    Navigator.of(context).pop();
                  },
                  textEditingController1: input1,
                  textEditingController2: input2,
                  input1FocusNode: input1FocusNode,
                  input2FocusNode: input2FocusNode,
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
        future: dbManager.getModelList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            modelList = snapshot.data;
            return ListView.builder(
              itemCount: modelList.length,
              itemBuilder: (context, index) {
                Model _model = modelList[index];
                return ItemCard(
                    model: _model,
                    input1: input1,
                    input2: input2,
                    onDeletePress: () {
                      dbManager.deleteModel(_model);
                      setState(() {});
                    },
                  onEditPress: () {
                    input1.text = _model.firstName;
                    input2.text = _model.lastName;
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogBox().dialog(
                              context: context,
                              onPressed: () {
                                Model __model = Model(
                                    id: _model.id,
                                    firstName: input1.text,
                                    lastName: input2.text);
                                dbManager.updateModel(__model);

                                setState(() {
                                  input1.text = "";
                                  input2.text = "";
                                });
                                Navigator.of(context).pop();
                              },
                              textEditingController2: input2,
                              textEditingController1: input1);
                        });
                  },
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

