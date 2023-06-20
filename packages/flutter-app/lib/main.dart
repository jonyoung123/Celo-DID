import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_celo_composer/configs/themes.dart';
import 'package:flutter_celo_composer/module/services/secure_storage.dart';
import 'package:flutter_celo_composer/module/view/screens/authentication_screen.dart';
import 'package:flutter_celo_composer/module/view/screens/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildDefaultTheme(context),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? isCreated;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      isCreated = await UserSecureStorage().getCreatedBoolean();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return isCreated != null && isCreated == 'true'
        ? const HomePage()
        : const AuthenticationScreen();
  }
}
