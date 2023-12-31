import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:scoreboard/views/home.dart';
import 'package:scoreboard/webview/webview.dart';
import 'package:scoreboard/widgets/button_resetwifi.dart';
import 'package:scoreboard/widgets/bar.dart';
import 'package:sizer/sizer.dart';

import '../views/setting.dart';

class ConnectDatabase extends StatefulWidget {
  const ConnectDatabase({super.key});

  @override
  State<ConnectDatabase> createState() => _ConnectDatabaseState();
}

class _ConnectDatabaseState extends State<ConnectDatabase> {
  final TextEditingController firebase = TextEditingController();
  String getTokenWebView = '';
  String getFirebasePath = '';
  final getToken = const FlutterSecureStorage();
  final firebasePath = const FlutterSecureStorage();

  @override
  void initState() {
    checkToken();
    firebasePath.read(key: 'Path').then(
      (value) {
        setState(() {
          if (value != '') {
            getFirebasePath = value.toString();
            print(getFirebasePath);
          } else {
            getFirebasePath = 'No path';
          }
        });
      },
    );
    print('Show read' + getFirebasePath);
    super.initState();
  }

  void checkToken() {
    getToken
        .read(key: 'Token')
        .then((value) => setState(() => getTokenWebView = value ?? ''));
  }

  void checkFirebasePath(String path) {
    setState(() {
      firebasePath.write(key: 'Path', value: path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: <Widget>[
        Text(
          "Setting Scoreboard",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: <Widget>[
            Text(
              'Line Token : ${getTokenWebView == '' ? 'NoToken' : getTokenWebView}',
              style: TextStyle(fontSize: 14.sp),
            )
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                'DataBase : ',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
            Expanded(
              flex: 5,
              child: TextFormField(
                controller: firebase,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  labelText: getFirebasePath,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 1.5.h,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: const Color.fromARGB(255, 23, 36, 113),
                minimumSize: const Size(75, 40),
              ),
              onPressed: () {
                checkFirebasePath(firebase.text);
                print('Show ' + firebase.text);
                showToastSave(context);
                FocusScope.of(context).unfocus();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingPage(),
                  ),
                );
              },
              child: Row(
                children: [
                  const Icon(Icons.save),
                  SizedBox(
                    width: 1.w,
                  ),
                  Text("Save",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold))
                ],
              )),
          SizedBox(
            width: 2.w,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: const Color.fromARGB(255, 23, 36, 113),
                minimumSize: const Size(75, 40),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage()));
              },
              child: const Icon(Icons.keyboard_double_arrow_right)),
        ]),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Colors.green,
              minimumSize: const Size(75, 40),
            ),
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WebViewLine()))
                  .whenComplete(() => checkToken());
            },
            child: Text(getTokenWebView == '' ? 'GET TOKEN' : 'CHANGE TOKEN',
                style:
                    TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold))),
        if (getTokenWebView != '')
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.red,
                minimumSize: const Size(75, 40),
              ),
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('Clear Data'),
                        content: Text(
                          'Do you want to clear the data?',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                getToken.delete(key: 'Token');
                                checkToken();
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK')),
                        ],
                      )),
              child: Text('Clear Data',
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold))),
        const ButtonWiFi(),
        Image.asset("image/connectesp.png", width: 80.w, height: 15.h),
      ]),
    );
  }
}
