import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:passwordreminderrd/saveDuc.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var now = 10;
  var ss = new DateTime.now().hour;
  var isSwitched = true;
  final name = TextEditingController();
  final pass = TextEditingController();
  String write;
  List<String> alreadyWritin = [];
  List<String> saveList = [];

  @override
  initState() {
    if (ss > 4 && ss < 16) {
      isSwitched = true;
    } else {
      isSwitched = false;
    }
    renew();
  }

  Future<void> deleteall() async {
    var s = SaveDuc();
    await s.deleteFile();
    setState(() {
      saveList.clear();
      alreadyWritin.clear();
    });
  }

  void renew() {
    saveList.clear();
    alreadyWritin.clear();
    var s = SaveDuc();
    s.readCounter().then((List<String> value) {
      setState(() {
        print(value);
        saveList.addAll(value);
        alreadyWritin.addAll(value);
      });
    });
  }

  void _saveData(name, pass) {
    print(ss.toString());
    write = "${name}" + "|" + "${pass}" + "|" + "png" + "\n";
    var s = SaveDuc();
    alreadyWritin.clear();
    alreadyWritin.add(write);
    s.writeCounter(alreadyWritin).then((value) {
      renew();
    });
  }

  Future<void> _deleteRecord(index) async {
    saveList.removeAt(index);
    if (saveList.isNotEmpty) {
      var s = SaveDuc();
      await s.writeFromScratch(saveList).then((value) {
        renew();
      });
    } else {
      deleteall();
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: isSwitched ? Colors.white : Colors.black,
        body: Container(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 45),
              ),
              Container(
                width: width - 20,
                height: height / 6,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  image: ss > 4 && ss < 16
                      ? DecorationImage(
                          image: AssetImage('assets/morning.jpg'),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: AssetImage('assets/evning.jpg'),
                          fit: BoxFit.cover,
                        ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ss > 4 && ss < 16
                        ? Text(
                            "Good Morning",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          )
                        : Text(
                            "Good Evning",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                    Padding(
                      padding: EdgeInsets.all(6),
                    )
                  ],
                ),
              ),
              TextButton(
                child: Text(
                  "Delete All",
                  style: TextStyle(
                      color: isSwitched ? Colors.black : Colors.white),
                ),
                onPressed: () async {
                  await Permission.storage.request();
                  var status = await Permission.storage.status;
                  if (status.isGranted) {
                    deleteall();
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text('Storage Permission'),
                              content: Text(
                                  'This app needs storage permission to store passowrds on local storage.'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Deny'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                TextButton(
                                  child: Text('Settings'),
                                  onPressed: () => openAppSettings(),
                                ),
                              ],
                            ));
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSwitched ? Colors.black : Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                          child: Icon(
                            Icons.add,
                            color: isSwitched ? Colors.white : Colors.black,
                            size: 40,
                          ),
                        ),
                        onPressed: () {
                          _showMyDialog();
                        },
                      ),
                      Text(
                        "Add Password",
                        style: TextStyle(
                            color: isSwitched ? Colors.black : Colors.white),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                        },
                        activeTrackColor: Colors.black,
                        activeColor: Colors.black,
                        inactiveTrackColor: Colors.white,
                        inactiveThumbColor: Colors.white,
                      ),
                      isSwitched
                          ? Text("Dark Mode")
                          : Text(
                              "Light Mode",
                              style: TextStyle(color: Colors.white),
                            )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: height / 1.7 - 25,
                width: width,
                child: saveList.length > 0
                    ? ListView.builder(
                        itemCount: saveList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var n = saveList[index].split("|");
                          return Container(
                            child: ListTile(
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Text("#" + n[0][0]),
                                    ),
                                  ),
                                  Text(
                                    n[0],
                                    style: TextStyle(
                                        color: isSwitched
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                  Container(
                                    width: width / 2.75,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.copy),
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onPressed: () {
                                            Clipboard.setData(new ClipboardData(
                                                text: '${n[1]}'));
                                            ScaffoldMessenger.of(context)
                                                .removeCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content:
                                                    Text('${n[0]} copied !'),
                                                duration: Duration(
                                                    milliseconds: 1800),
                                                action: SnackBarAction(
                                                  onPressed:
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .hideCurrentSnackBar,
                                                  label: "Hide",
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red[400],
                                          ),
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onPressed: () =>
                                              {_deleteRecord(index)},
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.blue,
                                          ),
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .removeCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text('${n[1]}'),
                                                duration: Duration(seconds: 30),
                                                action: SnackBarAction(
                                                  onPressed:
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .hideCurrentSnackBar,
                                                  label: "Hide",
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onLongPress: () {},
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                        'No items',
                        style: TextStyle(
                            color: isSwitched ? Colors.black : Colors.white),
                      )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add new Password'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: "Name"),
                  controller: name,
                ),
                TextField(
                  decoration: InputDecoration(hintText: "password"),
                  controller: pass,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                name.clear();
                pass.clear();
              },
            ),
            TextButton(
              child: Text('save'),
              onPressed: () async {
                await Permission.storage.request();
                var status = await Permission.storage.status;
                if (status.isGranted) {
                  _saveData(name.text, pass.text);
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text('Storage Permission'),
                            content: Text(
                                'This app needs storage permission to store passowrds on local storage.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Deny'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: Text('Settings'),
                                onPressed: () => openAppSettings(),
                              ),
                            ],
                          ));
                }

                name.clear();
                pass.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
