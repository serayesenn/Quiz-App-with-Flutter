import 'package:app5/question.dart';
import 'package:flutter/material.dart';
import 'quizbrain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';

QuizBrain quizBrain=QuizBrain();

class UserInterface extends StatefulWidget {
  const UserInterface({super.key});

  @override
  State<UserInterface> createState() => _UserInterfaceState();
}

class _UserInterfaceState extends State<UserInterface> {
  List <Icon> myIcons =[Icon(Icons.check, color: Colors.green, size: 30,), Icon(Icons.close, color: Colors.red, size: 30,)];
  
int dogrusayisi=0;
int yanlissayisi=0;

  void checkAnswer(bool answer){
    setState(() {
      if(quizBrain.isFinished()){
        
         if(dogrusayisi>yanlissayisi){
          dogrusayisi++;
        }
        else{
          yanlissayisi++;
        } 
        quizBrain.reset();
        Alert(
  style: AlertStyle(
    animationType: AnimationType.fromBottom,
    animationDuration: Duration(
      milliseconds: 1000,
    ),
    backgroundColor: Color.fromARGB(255, 100, 231, 77),
  ),
  context: context,
  title: "Game Over",
  desc: getResult(),
  buttons: [
    DialogButton(
      color: Colors.grey.shade900,
      child: Text(
        "Play again",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: () {
        setState(() {
          quizBrain.reset();
          time=20;
          dogrusayisi=0;
        yanlissayisi=0;
          
        });
        Navigator.pop(context);
      },
      width: 120,
    ),
    DialogButton(
      color: Colors.grey.shade900,
      child: Text("Show the Score",style: TextStyle(color: Colors.white, fontSize: 15)),
       onPressed:
        (){
           Alert(
  style: AlertStyle(
    animationType: AnimationType.fromBottom,
    animationDuration: Duration(
      milliseconds: 1000,
    ),
    backgroundColor: Color.fromARGB(255, 45, 0, 149),
  ),
  context: context,
  title: "Sonuçlar",
  desc: showResult() ,
).show();
        } //onpressed bitimi
        )
  ],
).show();
      }
      else{
        if(quizBrain.getAnswer() == answer){
          
          dogrusayisi++;
          time=20;
        }
        else{
         
          yanlissayisi++;
          time=20;
        }
        quizBrain.nextQuestion();

      }
    });
}


String getResult(){
  if (dogrusayisi>yanlissayisi){
    return "Harika";
  }
  else if(dogrusayisi==yanlissayisi){
return "İdare eder";
  }
  else{
    return "Berbat";
  }
}

String showResult(){
return "Doğru: $dogrusayisi  Yanlış: $yanlissayisi";
}

@override
int time=20;
void initState(){
  // programı açtığından itibaren çekilen veriler için kullandığımız fonksiyon
  Timer.periodic(Duration(seconds: 1), (timer) { 
    if(time>0){
      setState(() {
        time--;
      });

    }

    else if(time==0){
     // durum güncellemesinin uida gözükmesi için
      setState(() {
        time=20;
        yanlissayisi++;
        quizBrain.nextQuestion();
      });
    }

  });
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
      body: SafeArea(child: Center(
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Column(
                children: [
                  Icon(Icons.check,size: 40, color: Colors.green,),
                  Text("$dogrusayisi",style: TextStyle(color: Colors.white, fontSize: 40)),
                ],

              ),
              CircularPercentIndicator(
                radius: 40,
              lineWidth: 8,
              percent: (20-time)/20,
              progressColor: Colors.red,
              backgroundColor: Colors.red.shade100,
              center: Text("$time", style: TextStyle(color: Colors.white),),
              ),
              Column(
                children: [
                  Icon(Icons.close, size: 40, color: Colors.red,),
                  Text("$yanlissayisi",style: TextStyle(color: Colors.white, fontSize: 40),)
                ],
              )
              ],
            )),
            Expanded(
              flex: 4,
              child: Container(
                
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(8),
                color: Colors.grey.shade900,
                child: Center(child: Text(quizBrain.getText(), style: TextStyle(color: Colors.white, fontSize: 48),textAlign: TextAlign.center,)),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8),
                //color: Colors.green,
                child: ElevatedButton(onPressed: () {
                 setState(() {
                  
                  checkAnswer(true);
                  
                   
                 });

                }, 
                child: Text("Doğru", style: TextStyle(fontSize: 30, color: Colors.black),),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),),
              ),
            ),
            Expanded(
            
              flex: 1,
              child: Container(
                
                padding: EdgeInsets.all(8),
                child: ElevatedButton(onPressed: () {
                  setState(() {
                 
                   checkAnswer(false);
                   
                 });
                }, child: Text("Yanlış", style: TextStyle(fontSize: 30, color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
            ),
            
          ],
        ),
      )),
      ),
    );
  }
}