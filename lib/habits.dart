import 'package:easy_localization/easy_localization.dart';
import 'package:habits_grid/widgets/cuadricula.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:habits_grid/login.dart';
import 'package:url_launcher/url_launcher.dart';



final supabase = Supabase.instance.client;

class Habits extends StatefulWidget {
  const Habits({Key? key}) : super(key: key);

  @override
  State<Habits> createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {
  // Persisting the future as local variable to prevent refetching upon rebuilds.
   Future<dynamic> _future = supabase
      .from('habitos')
      .select('id,nombre,icono,id_externo,descripcion,color')
      .order('nombre', ascending: true);

  @override
  Widget build(BuildContext context) {

    //create a variable of string and localize it


    return Scaffold(
      appBar: AppBar(
        //disable back button
        automaticallyImplyLeading: false,
        title: Row(
          children:const [
             Text('Habits'),
            Text('Grid', style: TextStyle(color: Colors.blue),),
          ],
        ),
        //put a dropdown menu at the end of the appbar
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [

              PopupMenuItem(
                value: 4,
                child: Row(
                  children:  [
                    // ignore: prefer_const_constructors
                    Icon(Icons.refresh),
                    SizedBox(width: 5),
                    Text(tr("habits_menu_refresh"), style: TextStyle(fontSize: 16),),
                  ],
                ),

              ),
               PopupMenuItem(
                value: 1,
                child: Row(
                  // ignore: prefer_const_constructors
                  children:  [
                    Icon(Icons.add),
                    SizedBox(width: 5),
                    Text(tr("habits_menu_add"), style: TextStyle(fontSize: 16),),
                  ],
                ),

              ),
              PopupMenuItem(
                value: 6,
                child: Row(
                  // ignore: prefer_const_constructors
                  children:  [
                    Icon(Icons.analytics_outlined),
                    SizedBox(width: 5),
                    Text(tr("habits_menu_stats"), style: TextStyle(fontSize: 16),),
                  ],
                ),

              ),
              PopupMenuItem(
                value: 2,
                child:  Row(
                  children:  [
                    Icon(Icons.chat_bubble_outline),
                    //put 5 pixels between the icon and the text
                    SizedBox(width: 5),
                    Text(tr("habits_menu_contact"), style: TextStyle(fontSize: 16),),
                  ],
                ),

              ),
               //put a divider between the options

               PopupMenuItem(
                value: 3,
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 5),
                    Text(tr("habits_menu_logout"), style: TextStyle(fontSize: 16),),
                  ],
                ),

              ),
            ],
            onSelected: (value) async {
              //
              if (value == 4) {
                //refesh the future
                _future = supabase
                    .from('habitos')
                    .select('id, nombre, icono, id_externo,descripcion,color')
                    .order('nombre', ascending: true);

                setState(() {
                  //refresh only this widget

                });

              }
              //if value is 1, show an alert
              if (value == 1) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(tr("habits_menu_add")),
                        content: Text(tr("habits_menu_alert")),
                        actions: [
                          TextButton(
                            child:  Text(tr("habits_menu_alert_close")),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text(tr("habits_menu_alert_goto")),
                            onPressed: () async {
                              //open browser
                              Uri url = Uri.parse('https://www.habitsopensource.com/');
                              if (!await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication

                              )) {
                                throw Exception('Could not launch $url');
                              }
                            },
                          )
                        ],
                      );
                    });
              }
              //if value is 2, log out
              if (value == 6) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(tr("habits_menu_stats")),
                        content: Text(tr("habits_menu_alert_stats")),
                        actions: [
                          TextButton(
                            child: Text(tr("habits_menu_alert_close")),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          //go to web
                          TextButton(
                            child: Text(tr("habits_menu_alert_goto")),
                            onPressed: () async {
                              //open browser
                              Uri url = Uri.parse('https://www.habitsopensource.com/');
                              if (!await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication
                              )) {
                                throw Exception('Could not launch $url');
                              }
                            },
                          )
                        ],
                      );
                    });

              }

              //if value is 2, log out
              if (value == 2) {
               //open browser
                Uri url = Uri.parse('https://www.habitsopensource.com/contact');
                if (!await launchUrl(
                  url,
                  mode: LaunchMode.inAppWebView,
                  webViewConfiguration: const WebViewConfiguration(
                      headers: <String, String>{'my_header_key': 'my_header_value'}),
                )) {
                  throw Exception('Could not launch $url');
                }
              }
              if (value == 3)  {
                await supabase.auth.signOut();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login(title: 'habitsopensource')));
              }

            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          // return your widget with the data from snapshot
          //return null;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //return a list of widgets
          return RefreshIndicator(
            onRefresh: () async {
              //refresh the future
              _future = supabase
                  .from('habitos')
                  .select('id, nombre, icono, id_externo,descripcion,color')
                  .order('nombre', ascending: true);
              setState(() {
                //refresh only this widget

              });
            },
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),


                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text(snapshot.data![index]['nombre'] +" "+   snapshot.data![index]['icono'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            //put a icon at the end of the list

                            InkWell(
                              //ontap print the name of the habit
                                onTap: () async {
                                  //check if the habit is already done



                                  final userId = supabase.auth.currentUser!.id;
                                  Future<dynamic> future1 = supabase
                                      .from('habitoslog')
                                      .select('id,dia,habito_id')
                                      .eq('habito_id', snapshot.data![index]['id'])
                                      .eq('user_id', supabase.auth.currentUser!.id)
                                      .eq('dia', DateTime.now().toString())
                                      .limit(1);
                                  //return a futurebuilder
                                  var snapshot1 = await future1;
                                  if (snapshot1.length > 0) {
                                    //delete the habit
                                    await supabase.from('habitoslog').delete().eq('habito_id', snapshot.data![index]['id']).eq('user_id', supabase.auth.currentUser!.id).eq('dia', DateTime.now().toString());

                                  }else {
                                    await supabase.from('habitoslog').insert([
                                      {
                                        'habito_id': snapshot.data![index]['id'],
                                        'dia': DateTime.now().toString(),
                                        'user_id': userId
                                      }
                                    ]);
                                  }
                                  setState(() {
                                    //refresh only this widget

                                  });
                                },

                                child:  SizedBox(
                                    height: 30,
                                    width: 40,
                                    child: habitCheck(snapshot.data![index]['id'],colorFromText(snapshot.data![index]['color'])))),
                          ],
                        ),
                        (snapshot.data![index]['descripcion'] == "") ? Container(height:1) : Text(snapshot.data![index]['descripcion'], style: const TextStyle(fontSize: 15, ),),

                        Cuadricula(idexterno: snapshot.data![index]['id_externo'],color: colorFromText(snapshot.data![index]['color'])),

                      ],
                    ),
                  ),
                );
              },
            ),
          );

        },
      ),
    );
  }

  Color colorFromText(String text) {
   /*const colors = [
  { name: 'red', color: 'bg-red-500' },
  { name: 'orange', color: 'bg-orange-500' },
  { name: 'amber', color: 'bg-amber-500' },
  { name: 'yellow', color: 'bg-yellow-500' },
  { name: 'lime', color: 'bg-lime-500' },
  { name: 'green', color: 'bg-green-500' },
  { name: 'emerald', color: 'bg-emerald-500' },
  { name: 'teal', color: 'bg-teal-500' },
  { name: 'cyan', color: 'bg-cyan-500' },
  { name: 'sky', color: 'bg-sky-500' },
  { name: 'blue', color: 'bg-blue-500' },
  { name: 'indigo', color: 'bg-indigo-500' },
  { name: 'violet', color: 'bg-violet-500' },
  { name: 'purple', color: 'bg-purple-500' },
  { name: 'fuchsia', color: 'bg-fuchsia-500' },
  { name: 'pink', color: 'bg-pink-500' },
  { name: 'rose', color: 'bg-rose-500' },
*/
   //the text could be bg-red-500 and i need to return color.red
    //split the text
    var split = text.split("-");
    //return the color
    switch (split[1]) {
      case "red":
        return Colors.red;
      case "orange":
        return Colors.orange;
      case "amber":
        return Colors.amber;
      case "yellow":
        return Colors.yellow;
      case "lime":
        return Colors.lime;
      case "green":
        return Colors.green;
      case "emerald":
        return Colors.teal;
      case "teal":
        return Colors.teal;
      case "cyan":
        return Colors.cyan;
      case "sky":
        return Colors.blue;
      case "blue":
        return Colors.blue;
      case "indigo":
        return Colors.indigo;
      case "violet":
        return Colors.purple;
      case "purple":
        return Colors.purple;
      case "fuchsia":
        return Colors.pink;
      case "pink":
        return Colors.pink;
      case "rose":
        return Colors.pink;
      default:
        return Colors.green;
    }


  }


  Widget habitCheck(int habitId, Color color) {
    //get a future about habitoslog
    //if the habit is done, return a check icon
    //if not, return nothing



    Future<dynamic> future1 = supabase
        .from('habitoslog')
        .select()
        .eq('habito_id', habitId)
        .eq('user_id', supabase.auth.currentUser!.id)
        .eq('dia', DateTime.now().toString());
    //return a futurebuilder
    return  FutureBuilder(
      future: future1,

      builder: (context, snapshot) {

        // return your widget with the data from snapshot
        //return null;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Container();
        }
        //return a list of widgets
        if (snapshot.data!.length > 0) {
          return  Icon(Icons.check_box_rounded, color: color,size: 33,);
        }
        else {
          return const Icon(Icons.check_box_outlined, color: Colors.grey,size: 33,);
        }
      },
    );

  }



}