import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unitconverter/unit.dart';

class Category extends StatelessWidget {
  final String icon;
  final String name;
  final ColorSwatch color;
  List<Unit> units;
  final ValueChanged<Category> onTap;

  Category(this.name, this.icon, this.color, this.units, this.onTap)
      : assert(name != null),
        assert(icon != null),
        assert(color != null),
        assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        height: 100.0,
        child: InkWell(
          splashColor: color['splash'],
          highlightColor: color['highlight'],
          borderRadius: BorderRadius.circular(50.0),
          onTap: () => onTap(this),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Image.asset(
                      icon,
                      width: 60,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//  void _navigateToConverter(BuildContext context) {
//    if (Navigator.of(context).canPop()) {
//      Navigator.of(context).pop();
//    }
//    Navigator.of(context)
//        .push(MaterialPageRoute(builder: (BuildContext context) {
//      return Scaffold(
////        resizeToAvoidBottomPadding: false,
//        appBar: AppBar(
//          backgroundColor: color,
//          centerTitle: true,
//          title: Text(
//            name,
//            style: Theme.of(context).textTheme.headline4,
//          ),
//        ),
//        body: SingleChildScrollView(
//          child: ConverterScreen(
//            units: units,
//            color: color,
//          ),
//        ),
//      );
//    }));
//  }
}
