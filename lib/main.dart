import 'package:basicobdatos/firebase_options.dart';
import 'package:basicobdatos/pages/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options : DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget{
  //const MyApp ({Super.key});

  @override //Se sobreescribe un metodo de la clase padre.
  Widget build(BuildContext context){ //El metodo
    return MaterialApp(
        debugShowCheckedModeBanner: false, //Oculta el banner feo
        theme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme).copyWith(
              titleLarge: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.titleLarge,
                  fontSize: 32,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold
              ),
              bodyLarge: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              bodyMedium: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: 18,
                color: Colors.black87,
                fontStyle: FontStyle.italic,
              ),
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.cyan.shade200,
              brightness: Brightness.light,

            ),
            iconTheme: IconThemeData(
                color: Colors.cyan.shade300
            ),
            scaffoldBackgroundColor: Colors.green[50],
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.cyan.shade300,
                titleTextStyle: GoogleFonts.lato(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                )
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan.shade300,
                    textStyle: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    )
                )
            )
        ),
        home: SplashScreen()
      //LLama a la pantalla principal
    );
  }

}