import 'package:transactionanalysis/logic/bankids.dart';
import 'package:sms/sms.dart';
import 'package:permission_handler/permission_handler.dart';


class SmsManager{

  //declare datatypes
  SmsQuery _query=new SmsQuery();
  List<SmsMessage> _messages=new List();
  List<Transactiondata> _creditsms=new List();
  List<Transactiondata> _debitsms=new List();
  List<Transactiondata> _finalsms=List();

  //regular expression to found money from message body
   RegExp _reg=new RegExp(r'(?:Rs\.?|INR)\s*(\d+(?:[.,]\d+)*)|(\d+(?:[.,]\d+)*)\s*(?:Rs\.?|INR)');
   int _expense=0;
   int _earning=0;
   double expensetoday=0;
   double earningtoday=0;
   double expensethismonth=0;
   double earningthismonth=0;
   double expensethisyear=0;
   double earningthisyear=0;



  double get getexpenses=>double.parse(_expense.toString());
  double get getearning=>double.parse(_earning.toString());



   List<Transactiondata> get credits=>_creditsms;
   List<Transactiondata> get debits=>_debitsms;
   List<Transactiondata> get transactional=>_finalsms;


   //fetch all the transactional sms and put them in separate lists
  Future<List<Transactiondata>> getAll()async{

        bool a=await _checkpermission();
        if(!a) return null;
       _messages= await _query.querySms(kinds:[SmsQueryKind.Inbox]);
       for(int i=0;i<_messages.length;i++){
         if(IsaTransaction(_messages[i].body,_messages[i].sender,_messages[i].address)){
           if(IsEarned(_messages[i].body)){
             _earning+=int.parse(getamount(_reg.firstMatch(_messages[i].body).group(0)));
             _creditsms.add(Transactiondata(true,_messages[i],getamount(_reg.firstMatch(_messages[i].body).group(0))));
           }else{
             _expense+=int.parse(getamount(_reg.firstMatch(_messages[i].body).group(0)));
             _debitsms.add(Transactiondata(false,_messages[i],getamount(_reg.firstMatch(_messages[i].body).group(0))));
           }
           _finalsms.add(Transactiondata(IsEarned(_messages[i].body),_messages[i], getamount(_reg.firstMatch(_messages[i].body).group(0))));
         }
       }
       return _finalsms;
  }

  //check permission
 static Future<bool> _checkpermission()async{
   if (await Permission.sms.request().isGranted) {
     return true;
   }

   return false;
  }

  //check if message is transactional
 bool IsaTransaction(String body,String id,String address){
    return _reg.hasMatch(body) && (BankData.IsStrictlyATransaction(id) || BankData.IsStrictlyATransaction(address));
  }

  //get amount from sms body
  String getamount(String amt){
    amt=amt.toLowerCase();
    amt=amt.replaceAll(" ", "");
    amt=amt.replaceAll("inr", "");
    amt=amt.replaceAll("re", "");
    amt=amt.replaceAll("re.", "");
    amt=amt.replaceAll("rs.", "");
    amt=amt.replaceAll("rs", "");
    amt=amt.replaceAll(",", "");
    return amt.split(".")[0];
  }

  //check if money id credited or debited
  bool IsEarned(String body){
    body=body.toLowerCase();
    return !(body.contains('debit') || body.contains('withdrawn'));
  }


  loadMoreInfo(){
    int year=DateTime.now().year;
    int month=DateTime.now().month;
    int day=DateTime.now().day;
    List<Transactiondata> _messages=_finalsms;
    for(int i=0;i<_finalsms.length;i++){
      if(IsEarned(_messages[i].message.body)){
        if(_messages[i].message.dateSent.year==year){
          earningthisyear+=int.parse(getamount(_reg.firstMatch(_messages[i].message.body).group(0)));
          if(_messages[i].message.dateSent.month==month){
            earningthismonth+=int.parse(getamount(_reg.firstMatch(_messages[i].message.body).group(0)));
            if(_messages[i].message.dateSent.day==day){
              earningtoday+=int.parse(getamount(_reg.firstMatch(_messages[i].message.body).group(0)));
            }
          }
        }
      }else{
        if(_messages[i].message.dateSent.year==year){
          expensethisyear+=int.parse(getamount(_reg.firstMatch(_messages[i].message.body).group(0)));
          if(_messages[i].message.dateSent.month==month){
            expensethismonth+=int.parse(getamount(_reg.firstMatch(_messages[i].message.body).group(0)));
            if(_messages[i].message.dateSent.day==day){
              expensetoday+=int.parse(getamount(_reg.firstMatch(_messages[i].message.body).group(0)));
            }
          }
        }
      }
    }

  }


}


class Transactiondata{
  SmsMessage message;
  String amount;
  bool isEarned;
  Transactiondata(this.isEarned,this.message,this.amount);
}