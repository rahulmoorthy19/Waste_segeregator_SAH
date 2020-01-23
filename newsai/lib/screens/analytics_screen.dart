import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';


class AnimatedChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.1,
                      0.7,
                    ],
                    colors: [
                      Color(0xFF0BA360),
                      Color(0xFF3CBA92),
                    ],
                  ),
                ),
      child: FractionallySizedBox(
        
      widthFactor: 0.9,
      heightFactor: 0.8,
      child: Container(
        child: Card( elevation: 5.0,

         child: Padding(
           padding: const EdgeInsets.all(12.0),
           child: VerticalBarLabelChart(),
         )),
      ),
  ),
    );
  }
}



class VerticalBarLabelChart extends StatefulWidget {
  @override
  _VerticalBarLabelChartState createState() => _VerticalBarLabelChartState();
}

class _VerticalBarLabelChartState extends State<VerticalBarLabelChart> {
   List <charts.Series> seriesList;
   List <OrdinalSales> data =[];
  
   @override
  void initState() {
    _loadData();
   
  
    super.initState();
  }

  _loadData() async {
      const url="http://192.168.43.111:8658/get_all";
   
    List<OrdinalSales> tempdata = [
    ];
    
    await http.get(url).then((response){
      var output = jsonDecode(response.body);

      tempdata.add(new OrdinalSales('Organic',output["organic"] as int));
      tempdata.add(new OrdinalSales('Recyclable',output["recyclable"] as int));
      tempdata.add(new OrdinalSales('Solid',output["solid"] as int));
    });

     setState(() {
      data=tempdata;
    });
   
  }

  /// Creates a [BarChart] with sample data and no transition.
  

  // [BarLabelDecorator] will automatically position the label
  // inside the bar if the label will fit. If the label will not fit,
  // it will draw outside of the bar.
  // Labels can always display inside or outside using [LabelPosition].
  //
  // Text style for inside / outside can be controlled independently by setting
  // [insideLabelStyleSpec] and [outsideLabelStyleSpec].
  @override
  Widget build(BuildContext context) {
    print(data);
    return new charts.BarChart(
      this.createSampleData(),
      animate: false,
      // Set a bar label decorator.
      // Example configuring different styles for inside/outside:
      //       barRendererDecorator: new charts.BarLabelDecorator(
      //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
      //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(),
    );
  }

  /// Create one series with sample hard coded data.
   List<charts.Series<OrdinalSales, String>> createSampleData() {

    return [
      new charts.Series<OrdinalSales, String>(
          id: 'Sales',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: data,
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (OrdinalSales sales, _) =>
              '${sales.sales.toString()}')
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}