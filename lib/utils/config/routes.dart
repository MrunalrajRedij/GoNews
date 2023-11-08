import 'package:gonews/Screens/loginScreen.dart';
import 'package:gonews/screens/homeScreen.dart';

/*implemented routes which doesn't need pass any data between them
(Not all screens are present here)
Also recognises which screen is currently active for menuWidget*/
getRoutes() {
  return {
    "/LoginScreen": (context) => const LoginScreen(),
    "/HomeScreen": (context) =>  HomeScreen(),
  };
}
