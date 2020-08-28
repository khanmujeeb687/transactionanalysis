import 'package:flutter/material.dart';
import 'package:transactionanalysis/logic/sms_manager.dart';
import 'package:transactionanalysis/resources/light_color.dart';
import 'package:transactionanalysis/ui/pie_chart.dart';

class TransactionStats extends StatefulWidget {
  SmsManager smsManager;
  Map<String, double> dataMap;
  TransactionStats(this.smsManager,this.dataMap);
  @override
  _TransactionStatsState createState() => _TransactionStatsState();
}

class _TransactionStatsState extends State<TransactionStats> {
  Map<String, double> dataMap = new Map();
  double earning;
  double expense;
  double result;
  String text="Statistics till now";
  int _btnindex=0;

  @override
  void initState() {
    this.dataMap=widget.dataMap;
    earning=widget.smsManager.getearning;
    expense=widget.smsManager.getexpenses;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    result=earning-expense;
    return Scaffold(
      backgroundColor: LightColor.lightGrey,
      appBar: AppBar(
        title: Text("Statistics",style: TextStyle(fontWeight: FontWeight.w300),),
        backgroundColor: LightColor.black,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _Banner(),
              _cards(text:"Income",trailvlue: this.earning.toString(),trailcolor:Colors.lightGreen,iconData: Icons.money),
              _cards(text:"Expenses",trailvlue:this.expense.toString(),trailcolor:Colors.redAccent,iconData: Icons.money),
              _cards(text:"Overall",trailvlue: this.result.toString(),trailcolor:result<0?Colors.redAccent:Colors.lightGreen,iconData: Icons.equalizer),
              PieChartView(this.dataMap,key: UniqueKey(),),
              _getbuttons()
            ],
          ),
        ),
      ),
    );
  }


  _cards({IconData iconData,String text,Color trailcolor,String trailvlue}){
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      elevation: 7,
      child: Container(
          padding: EdgeInsets.all(5),
          child:ListTile(
            leading: Icon(iconData),
            title: Text(text,style: TextStyle(
                fontWeight: FontWeight.bold,
                color: LightColor.black
            ),),
            trailing: Text("Rs. ${trailvlue}",style: TextStyle(
                color: trailcolor
            ),),
          )
      ),
    );
  }

  _Banner(){
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      elevation: 7,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          color: LightColor.orange,
        ),
          padding: EdgeInsets.all(5),
          child:ListTile(
            leading: Icon(Icons.equalizer,color: LightColor.background,),
            title: Text( text,style: TextStyle(
                fontWeight: FontWeight.bold,
                color: LightColor.background
            ),),
          )
      ),
    );
  }

  _getbuttons(){
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(0,15,0,15),
      width: MediaQuery.of(context).size.width*.9,
      child: Wrap(
        spacing: 10,
        runSpacing: 5,
        runAlignment: WrapAlignment.spaceEvenly,
        children: [
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            color: _btnindex==0?LightColor.orange:LightColor.lightblack,
            child: Text("OverAll",style: TextStyle(
                color: LightColor.background,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.3
            ),),
            onPressed: (){
              setState(() {
                if(_btnindex==0) return;
                text="Statistics till now";
                earning=widget.smsManager.getearning;
                expense=widget.smsManager.getexpenses;
                this.dataMap.clear();
                this.dataMap.putIfAbsent("Total Expense", () => expense);
                this.dataMap.putIfAbsent("Total Income", () => earning);
                _btnindex=0;
              });
            },
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            color: _btnindex==1?LightColor.orange:LightColor.lightblack,
            child: Text("Today",style: TextStyle(
                color: LightColor.background,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.3
            ),),
            onPressed: (){
              setState(() {
                if(_btnindex==1) return;
                text="Statistics for today";
                earning=widget.smsManager.earningtoday;
                expense=widget.smsManager.expensetoday;
                this.dataMap.clear();
                this.dataMap.putIfAbsent("Total Expense", () => expense);
                this.dataMap.putIfAbsent("Total Income", () => earning);
                _btnindex=1;
              });
            },
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            color: _btnindex==2?LightColor.orange:LightColor.lightblack,
            child: Text("This month",style: TextStyle(
                color: LightColor.background,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.3
            )),
            onPressed: (){
              setState(() {
                if(_btnindex==2) return;
                text="Statistics for this month";
                earning=widget.smsManager.earningthismonth;
                expense=widget.smsManager.expensethismonth;
                this.dataMap.clear();
                this.dataMap.putIfAbsent("Total Expense", () => expense);
                this.dataMap.putIfAbsent("Total Income", () => earning);
                _btnindex=2;
              });
            },
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            color: _btnindex==3?LightColor.orange:LightColor.lightblack,
            child: Text("This year",style: TextStyle(
                color: LightColor.background,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.3
            )),
            onPressed: (){
              setState(() {
                if(_btnindex==3) return;
                text="Statistics for this year";
                earning=widget.smsManager.earningthisyear;
                expense=widget.smsManager.expensethisyear;
                this.dataMap.clear();
                this.dataMap.putIfAbsent("Total Expense", () => expense);
                this.dataMap.putIfAbsent("Total Income", () => earning);
                _btnindex=3;
              });
            },
          ),

        ],
      ),
    );
  }
}
