// // package com.celo.flutter_celo_composer; // Replace with your package name

// // import android.os.Bundle;
// // import io.flutter.embedding.android.FlutterActivity;
// // import io.flutter.embedding.engine.FlutterEngine;
// // import io.flutter.plugins.GeneratedPluginRegistrant;
// // import com.celo.flutter_celo_composer.CeloPlugin; // Import the CeloPlugin class

// // public class MainActivity extends FlutterActivity {
// //     @Override
// //     public void configureFlutterEngine(FlutterEngine flutterEngine) {
// //         super.configureFlutterEngine(flutterEngine);
// //         GeneratedPluginRegistrant.registerWith(flutterEngine); // Register any Flutter plugins used in your project
// //     }
    
// //     @Override
// //     protected void onCreate(Bundle savedInstanceState) {
// //         super.onCreate(savedInstanceState);
// //         CeloPlugin.registerWith(getFlutterEngine().getDartExecutor().getBinaryMessenger()); // Register the CeloPlugin
// //     }
// // }


// package com.celo.flutter_celo_composer; // Replace with your package name

// import android.os.Bundle;
// import io.flutter.embedding.android.FlutterActivity;
// import io.flutter.embedding.engine.FlutterEngine;
// import io.flutter.plugin.common.MethodCall;
// import io.flutter.plugin.common.MethodChannel;
// import io.flutter.plugins.GeneratedPluginRegistrant;

// public class MainActivity extends FlutterActivity {
//     private static final String CHANNEL = "celo_plugin";

//     @Override
//     public void configureFlutterEngine(FlutterEngine flutterEngine) {
//         super.configureFlutterEngine(flutterEngine);
//         GeneratedPluginRegistrant.registerWith(flutterEngine); // Register any Flutter plugins used in your project

//         MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
//         CeloSdkManager sdkManager = new CeloSdkManager();
//         channel.setMethodCallHandler((call, result) -> sdkManager.handleMethodCall(call, result));
//     }
// }