import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unitconverter/converter_screen.dart';
import 'package:unitconverter/unit.dart';

import 'backdrop.dart';
import 'category.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
//  final Map<String, IconData> _categories = {
//    'Length': Icons.cake,
//    'Area': Icons.cake,
//    'Volume': Icons.cake,
//    'Mass': Icons.cake,
//    'Time': Icons.cake,
//    'Digital Storage': Icons.cake,
//    'Energy': Icons.cake,
//    'Currency': Icons.cake,
//  };

  static const _icons = <String>[
    'assets/images/length.png',
    'assets/images/area.png',
    'assets/images/volume.png',
    'assets/images/mass.png',
    'assets/images/time.png',
    'assets/images/digital_storage.png',
    'assets/images/power.png',
    'assets/images/currency.png',
  ];

  static const _baseColors = <ColorSwatch>[
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
  ];

  final List<Category> _categoryList = [];
  final Color _backgroundColor = Colors.lightBlue[100];
  Category _currentCategory;

//  @override
//  void initState() {
//    super.initState();
//    for (String category in _categories.keys) {
//      _categoryList.add(Category(
//        category,
//        _categories[category],
//        _baseColors[_categoryList.length % _baseColors.length],
//        _retrieveUnitList(category),
//        _changeCurrentCategory,
//      ));
//    }
//  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (_categoryList.isEmpty) {
      await _retrieveLocalCategories();
    }
  }

  Future<void> _retrieveLocalCategories() async {
    final json = DefaultAssetBundle.of(context)
        .loadString('assets/data/regular_units.json');
    final data = JsonDecoder().convert(await json);
    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }

    for (String category in data.keys) {
      List<Unit> units = data[category]
          .map<Unit>((dynamic unitData) => Unit.fromJson(unitData))
          .toList();

      setState(() {
        _categoryList.add(Category(
          category,
          _icons[_categoryList.length],
          _baseColors[_categoryList.length % _baseColors.length],
          units,
          _changeCurrentCategory,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentCategory == null) {
      return _buildInitialScreen();
    } else {
      return _buildBackDrop();
    }
  }

  void _changeCurrentCategory(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  Widget _buildBackDrop() {
    return Backdrop(
      currentCategory: _currentCategory,
      backTitle: Text('Select a Category'),
      frontTitle: Text(_currentCategory.name),
      backPanel: _buildBackPanel(),
      frontPanel: ConverterScreen(
        units: _currentCategory.units,
        color: _currentCategory.color,
      ),
    );
  }

  Widget _buildInitialScreen() {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        title: Center(
          child: Text(
            'Select a Category',
          ),
        ),
      ),
      body: _buildBackPanel(),
    );
  }

  Widget _buildBackPanel() {
    return OrientationBuilder(
      builder: (_, orientation) {
        return orientation == Orientation.portrait
            ? _buildListView(true)
            : _buildListView(false);
      },
    );
  }

  Widget _buildListView(bool portrait) {
    if (portrait) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) => _categoryList[index],
        itemCount: _categoryList.length,
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3,
        children: _categoryList,
      );
    }
  }

//  List<Unit> _retrieveUnitList(String categoryName) {
//    return List.generate(10, (index) {
//      index += 1;
//      return Unit(
//        name: '$categoryName Unit $index',
//        conversion: index.toDouble(),
//      );
//    });
//  }
}
