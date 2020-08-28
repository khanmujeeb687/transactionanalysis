import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transactionanalysis/logic/sms_manager.dart';
import 'package:transactionanalysis/resources/light_color.dart';
import 'package:transactionanalysis/ui/pie_chart.dart';
import 'package:transactionanalysis/ui/sms_page.dart';


import 'transaction_stats.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SmsManager _smsManager=new SmsManager();
  List<Transactiondata> _transactionalsms;
  Map<String, double> dataMap = new Map();
  ScrollController _scrollController=new ScrollController();
  int _btnindex=1;
  int _listlength=10;
  double _fabopacity=0;

  @override
  void initState() {
    _getdata();
    _scrollController.addListener(() async{
      if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
        _laodmore();
        if(_fabopacity==0){
          setState(() {
            _fabopacity=1;
          });
        }
      }
      if(_scrollController.position.pixels==0){
        await Future.delayed(Duration(milliseconds: 200));
        setState(() {
          _fabopacity=0;
        });
      }
    });
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColor.lightGrey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: LightColor.black,
        title: Text("transactionanalysis",),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10,0,10,0),
        alignment: Alignment.center,
        child:_transactionalsms==null?CircularProgressIndicator():_datadisply(),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _fabopacity,
        duration: Duration(milliseconds: 500),
        child: FloatingActionButton(
          backgroundColor: LightColor.black,
            child:Icon(Icons.arrow_upward,color: LightColor.background,),
          onPressed: (){
            _scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
          },
        ),
      ),
    );
  }


  //load piechart
  _datadisply(){
    return SingleChildScrollView(
      controller: _scrollController,
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          margin: const EdgeInsets.only(top:10,bottom: 10),
          child: Stack(
            fit: StackFit.loose,
            overflow: Overflow.visible,
            children: [
              PieChartView(dataMap),

              Positioned(
                  bottom: 20.0,
                  right:-15.0,
                  child: ClipOval (
                    child: Container(
                      color: Colors.deepOrange,
                      height: 50.0, // height of the button
                      width: 50.0, // width of the button
                      child: Center(child: IconButton(
                        icon: Icon(Icons.list,color: LightColor.background,),
                        onPressed: ()async{
                        await  Navigator.push(context, MaterialPageRoute(
                            builder: (context){
                              return TransactionStats(this._smsManager,this.dataMap);
                            }
                          ));
                          setState(() {
                            dataMap.clear();
                            dataMap.putIfAbsent("Total Expenses", () => _smsManager.getexpenses);
                            dataMap.putIfAbsent("Total Income", () => _smsManager.getearning);
                          });
                        },
                      )),
                    ),
                  )
              )
            ],
          ),
        ),
        _getbuttons(),
        SmsPage(_btnindex==0?_smsManager.debits:_btnindex==1?_transactionalsms:_smsManager.credits,_listlength)
      ],
    ));
  }
  _getbuttons(){
    return Container(
      margin: EdgeInsets.fromLTRB(0,15,0,15),
      width: MediaQuery.of(context).size.width*.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            color: _btnindex==0?LightColor.orange:LightColor.lightblack,
            child: Text("Expenses",style: TextStyle(
              color: LightColor.background,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.3
            ),),
            onPressed: (){
              setState(() {
                _btnindex=0;
                _listlength=10;
              });
            },
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            color: _btnindex==1?LightColor.orange:LightColor.lightblack,
            child: Text("All",style: TextStyle(
              color: LightColor.background,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.3
            ),),
            onPressed: (){
              setState(() {
                _btnindex=1;
                _listlength=10;
              });
            },
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            color: _btnindex==2?LightColor.orange:LightColor.lightblack,
            child: Text("Income",style: TextStyle(
                color: LightColor.background,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.3
            )),
            onPressed: (){
              setState(() {
                _btnindex=2;
                _listlength=10;
              });
            },
          ),

        ],
      ),
    );
  }

  //load data
  _getdata()async{
  _transactionalsms=await _smsManager.getAll();
  setState(() {
    _transactionalsms=_transactionalsms;
    dataMap.putIfAbsent("Total Expenses", () => _smsManager.getexpenses);
    dataMap.putIfAbsent("Total Income", () => _smsManager.getearning);
  });
  _smsManager.loadMoreInfo();
  }

  void _laodmore() {
    switch(_btnindex){
      case 0:{
        if(_listlength==_smsManager.debits.length) return;
       if(_listlength+10<=_smsManager.debits.length){
         setState(() {
           _listlength+=10;
         });
       }else{
         setState(() {
           _listlength=_smsManager.debits.length;
         });
       }
        break;
      }
      case 1:{
        if(_listlength==_transactionalsms.length) return;
        if(_listlength+10<=_transactionalsms.length){
          setState(() {
            _listlength+=10;
          });
        }else{
          setState(() {
            _listlength=_transactionalsms.length;
          });
        }
        break;
      }
      case 2:{
        if(_listlength==_smsManager.credits.length) return;
        if(_listlength+10<=_smsManager.credits.length){
          setState(() {
            _listlength+=10;
          });
        }else{
          _listlength=_smsManager.credits.length;
        }
        break;
      }
      default:{
      }
    }
  }

}

