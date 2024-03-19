
import 'package:flutter/material.dart';

class MyDialog extends StatefulWidget {
  MyDialog({
    required this.cities,
    required this.selectedCities,
    required this.onSelectedCitiesListChanged,
  });

  final List<String> cities;
  final List<String> selectedCities;
  final ValueChanged<List<String>> onSelectedCitiesListChanged;

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  List<String> _tempSelectedCities = [];

  @override
  void initState() {
    _tempSelectedCities = widget.selectedCities;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 380,
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 30, bottom: 20, left: 20),
                child: Text(
                  'Select Services linked to the stand',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'opensans',
                      color: Color(0xff626A76)),
                )),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  itemCount: widget.cities.length,
                  itemBuilder: (BuildContext context, int index) {
                    final cityName = widget.cities[index];
                    return Container(
                      child: CheckboxListTile(
                          title: Text(
                            cityName,
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff626A76),
                                fontFamily: ('opensans')),
                          ),
                          activeColor: Color(0xffde626c),
                          value: _tempSelectedCities.contains(cityName),
                          onChanged: (bool? value) {
                            if (value ?? false) {
                              print(value);
                              print('data');
                              print(value);
                              if (!_tempSelectedCities.contains(cityName)) {
                                setState(() {
                                  print('data22');
                                  _tempSelectedCities.add(cityName);
                                });

                                if (_tempSelectedCities.contains('None')) {
                                  setState(() {
                                    print('data23');
                                    _tempSelectedCities.clear();
                                    _tempSelectedCities.add('None');
                                    _tempSelectedCities.add(cityName);
                                    _tempSelectedCities.remove('None');
                                  });
                                }
                              }
                            } else {
                              if (_tempSelectedCities.contains(cityName)) {
                                setState(() {
                                  _tempSelectedCities.removeWhere(
                                          (String city) => city == cityName);
                                });
                                if (_tempSelectedCities.contains('None')) {
                                  setState(() {
                                    print(_tempSelectedCities);
                                    _tempSelectedCities.clear();
                                    _tempSelectedCities.add('None');
                                  });
                                }
                              }
                            }
                            widget.onSelectedCitiesListChanged(
                                _tempSelectedCities);
                          }),
                    );
                  }),
            ),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.pop(context);
//                        _tempSelectedCities.clear();
//                        _tempSelectedCities.add('None');
                      });
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Color(0xffde626c),
                          fontFamily: 'opensans'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}