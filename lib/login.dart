import 'package:flutter/material.dart';
import 'package:habits_grid/habits.dart'; 
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:easy_localization/easy_localization.dart';


class Login extends StatefulWidget {
  const Login({super.key, required this.title});
  final String title;

  @override
  State<Login> createState() => _LoginState();
}
String loginresult = 'not logged in';

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {

    //create a variable of string

    return Scaffold(

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          //stretch

          children: <Widget>[
             Row(
               //center
                mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 //add image
                  Image.asset('assets/images/logo.png', width: 40, height: 40,),
                 const Text("Habits", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
                 const Text("Grid", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue),),
               ],
             ),
            //seprate by 200

            Text(tr("login_frase"), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            const SizedBox(height: 50,),


            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SupaSocialsAuth(
                socialProviders: const [SocialProviders.google],
                colored: true,

                //
                //
                redirectUrl:
                'io.supabase.flutterquickstart://login-callback',


                onSuccess: (Session response) {
                  // do something, for example: navigate('home');
                  //show in console
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Habits()),

                  );


                  setState(() {
                    loginresult = 'logged in';
                  });

                  //print(loginresult);
                  //print (response.user.id);

                },
                onError: (error) {
                  //show error in production
                  //print(error);
                  // do something, for example: navigate("wait_for_email");
                  loginresult =  error.toString();
                  setState(() {

                  });


                },
              ),
            ),

          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
