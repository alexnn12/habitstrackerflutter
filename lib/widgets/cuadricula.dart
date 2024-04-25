
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


//create a widget that will be used to display the grid of habits
//it should be a stateful widget because it will be changing

class Cuadricula extends StatefulWidget {
  final String idexterno;
  final Color color;
  //add a parameter name description

  // Constructor with named parameters
  const Cuadricula({Key? key, required this.idexterno, required this.color}) : super(key: key);

  @override
  CuadriculaState createState() => CuadriculaState();
}

class CuadriculaState extends State<Cuadricula> {

  
  Future fetchData() async {
    var url = 'https://cache.habitsopensource.com/habit_id/' + widget.idexterno;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      var habitoslog= data['habitoslog'];
      //habitoslog is an array of objects.
      //do a for
      for (var i = 0; i < habitoslog.length; i++) {
        var formattedDate = habitoslog[i]['dia'].split('T')[0];
        habitoslog[i]['dia'] = formattedDate;
      }

      return habitoslog;

    } else {
      throw Exception('Failed to load data');
    }
  }

  //call the fetchData() method in the initState() method

  @override
  void initState() {
    super.initState();
  }

  Widget cuadricula( [data]) {

    //create an array of 365 elements with a date
    List<String> days365 = [];
    for (int i = 155; i > -1; i--) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      days365.add(formattedDate);
    }
    var diacero;
    diacero='2021-01-01';
    if (data!=null) diacero=data[0]['dia'];






    return SizedBox(
      height: 120,
      child: GridView.count(
        crossAxisCount: 8,
        scrollDirection: Axis.horizontal,

        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: //list from days365
        List.generate(days365.length, (index) {

          //check if data
     //     print ("aa"+data.toString());


          return Center(
            child:
              //create a box in grey
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    //round the corners
                    borderRadius: BorderRadius.circular(2),


                    //change opacity if the date is in the future

                  ),
                  height: 50,
                  width: 100,
                  //check if the date in days365.index is in data
                  //if it is, color it green


                  child:
                  (data==null)?Container():
                  Opacity(
                    opacity: ((data!=null && data.where((element) => element['dia'] == days365[index]).length==0) && DateTime.parse(diacero).isBefore(DateTime.parse(days365[index])))? 0.2:1,
                    child: Container(
                      color:(data!=null && data.where((element) => element['dia'] == days365[index]).length>0)? widget.color :

                      //convert diacero to date and check if it is less than days365[index]
                      (diacero!=null && DateTime.parse(diacero).isBefore(DateTime.parse(days365[index])))? widget.color:

                      Colors.transparent,

                    ),
                  )
                ),
              ),

          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return cuadricula(snapshot.data);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return  cuadricula();
          },
        ),
      ],
    );
  }
}
