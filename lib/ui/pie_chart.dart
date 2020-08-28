import 'package:flutter/material.dart';
import 'package:transactionanalysis/resources/light_color.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartView extends StatefulWidget {
  Map<String, double> dataMap = new Map();
  PieChartView(this.dataMap,{Key key}):super(key:key);
  @override
  _PieChartViewState createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag:"pie",
      child: Material(
        color: Colors.transparent,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          child: Container(
            width: MediaQuery.of(context).size.width/1.4,
            height: MediaQuery.of(context).size.width/1.4,
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: PieChart(
              dataMap: widget.dataMap,
              animationDuration: Duration(seconds: 2),
              chartLegendSpacing: 35.0,
              chartRadius: MediaQuery.of(context).size.width*.5,
              showChartValuesInPercentage: true,
              showChartValues: true,
              showChartValuesOutside: true,
              chartValueBackgroundColor: Colors.grey[200],
              colorList: [LightColor.black,LightColor.orange],
              showLegends: true,
              legendPosition: LegendPosition.top,
              decimalPlaces: 0,
              showChartValueLabel: true,
              initialAngle: 0,
              chartValueStyle: defaultChartValueStyle.copyWith(
                color: Colors.blueGrey[900].withOpacity(0.9),
              ),
              chartType: ChartType.disc,
            ),
          ),
        ),
      ),
    );
  }
}
