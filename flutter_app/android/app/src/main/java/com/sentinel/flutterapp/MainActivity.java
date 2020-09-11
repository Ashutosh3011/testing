package com.sentinel.flutterapp;

// import android.os.Bundle;
// import io.flutter.app.FlutterActivity;
// import io.flutter.plugins.GeneratedPluginRegistrant;
// import io.flutter.embedding.android.FlutterActivity;

// public class MainActivity extends FlutterActivity {
//   // @Override
//   // protected void onCreate(Bundle savedInstanceState) {
//   //   super.onCreate(savedInstanceState);
//   //   GeneratedPluginRegistrant.registerWith(this);
//   // }
// }
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterFragmentActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}