import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gonews/firebase_options.dart';
import 'package:gonews/screens/homeScreen.dart';
import 'package:gonews/screens/loginScreen.dart';
import 'package:gonews/utils/config/routes.dart';
import 'package:gonews/utils//config/palette.dart' as palette;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GoNews',
          theme: ThemeData(
            primarySwatch: const MaterialColor(
                palette.primaryColorInt, palette.persianColorMap),
          ),
          //set routes
          routes: getRoutes(),
          home: const CheckAuth(),
        );
      },
    );
  }
}

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});
  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  late User? _user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    //get user from firebase auth for further validation
    final FirebaseAuth auth = FirebaseAuth.instance;
    _user = auth.currentUser;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    //when checking auth show circularLoadingWidget
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _user == null
            ? const LoginScreen() // if user is empty redirect to AppInfoScreen
            : const HomeScreen(); // if user is not empty redirect to HomeScreen
  }
}
