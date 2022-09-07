import 'package:flutter/material.dart';
import 'package:barcode_keyboard_listener/barcode_keyboard_listener.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BarcodeListener _barcodeListener;
  final _tecScanKeyCode = TextEditingController();
  int _scanButtonKeyCode;
  String _scanResult = '';

  @override
  void initState() {
    super.initState();
    _barcodeListener = BarcodeListener(null, null, _onKeyPress);
  }

  void _onScan(String barcode) async {
    setState(() {
      _scanResult = barcode;
    });
  }

  void _onKeyPress(int keyCode) async {
    setState(() {
      _tecScanKeyCode.text = keyCode.toString();
    });
  }

  void _setScanButtonKeyCode(){
    setState(() {
      if (_barcodeListener != null) {
        _barcodeListener.dispose();
        _barcodeListener = null;
      }

      _scanButtonKeyCode = int.parse(_tecScanKeyCode.text);
      _barcodeListener = BarcodeListener(_onScan, _scanButtonKeyCode, _onKeyPress);
    });
  }

  @override
  Widget build(BuildContext context) {
    final widgetList = List<Widget>();

    widgetList.addAll([
      Text('Press the scan button, its code will appear in the text field below'),
      TextField(
        controller: _tecScanKeyCode,
        decoration: InputDecoration( suffix: IconButton(
            icon: Icon(Icons.check),
            onPressed: _setScanButtonKeyCode
        )),
      )
    ]);

    if (_tecScanKeyCode.text.isNotEmpty){
      widgetList.add(Text('press "✓" to confirm the selected code'));
    }

    if (_scanButtonKeyCode != null){
      widgetList.addAll([
        Text('Scan button key code: $_scanButtonKeyCode'),
        Text('Place the scanner on the barcode and press the scan button'),
      ]);
    }

    if (_scanResult.isNotEmpty) {
      widgetList.add(Text('Barcode: $_scanResult'));
    }

    return Scaffold(
      appBar: AppBar( title: Text('Barcode keyboard listener test')),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgetList
      ),
    );
  }
}