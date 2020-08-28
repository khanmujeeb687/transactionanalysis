import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transactionanalysis/logic/sms_manager.dart';
import 'package:transactionanalysis/resources/light_color.dart';

class SmsPage extends StatefulWidget {
  List<Transactiondata> messages;
  int length;
  SmsPage(this.messages,this.length);
  @override
  _SmsPageState createState() => _SmsPageState();
}

class _SmsPageState extends State<SmsPage> {
  @override
  Widget build(BuildContext context) {
    if(widget.messages==null) return CircularProgressIndicator();
    if(widget.messages.isEmpty) return Center(child:Text("No sms"));
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child:ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: widget.length,
        itemBuilder: (context,index){
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            elevation: 6,
            child: Container(
              margin: EdgeInsets.all(6),
              child: ListTile(
                title: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.messages[index].message.sender),
                        Text("Rs. ${widget.messages[index].amount}",
                          style: TextStyle(color: widget.messages[index].isEarned?LightColor.lightBlue:LightColor.orange),)
                      ],
                    ),
                    Divider()
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.messages[index].message.body,style: TextStyle(
                      color: LightColor.darkgrey
                    ),),
                    Divider(),
                    Text("Recieved on ${widget.messages[index].message.dateSent}"),
                  ],
                ),
              ),
            ),
          );
        },
      )
    );
  }
}
