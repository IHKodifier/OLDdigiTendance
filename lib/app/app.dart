import 'package:digitendance/ui/startup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DigiTendance',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.purple,
        ),
        // .useMaterial3,
        // home: const AppHomePage(title: 'DigiTendance'),
        // themeMode: ThemeMode.dark,
        // darkTheme: ThemeData.dark().copyWith(
        //   scaffoldBackgroundColor: Colors.black87,
        //   colorScheme:
        //       ColorScheme.fromSwatch().copyWith(secondary: Colors.purple),
        // ),
        home: StartupView(),
      ),
    );
  }
}
