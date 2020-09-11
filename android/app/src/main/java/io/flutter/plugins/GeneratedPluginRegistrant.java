package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import net.goderbauer.flutter.contactpicker.ContactPickerPlugin;
import com.pichillilorenzo.flutter_appavailability.AppAvailability;
import io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin;
import flutter.moum.hardware_buttons.HardwareButtonsPlugin;
import vn.hunghd.flutter.plugins.imagecropper.ImageCropperPlugin;
import io.flutter.plugins.imagepicker.ImagePickerPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import com.lykhonis.simpleimagecrop.SimpleImageCropPlugin;
import io.flutter.plugins.urllauncher.UrlLauncherPlugin;
import com.sentinel.foreground_plugin.FlutterForegroundPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    ContactPickerPlugin.registerWith(registry.registrarFor("net.goderbauer.flutter.contactpicker.ContactPickerPlugin"));
    AppAvailability.registerWith(registry.registrarFor("com.pichillilorenzo.flutter_appavailability.AppAvailability"));
    FlutterAndroidLifecyclePlugin.registerWith(registry.registrarFor("io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin"));
    HardwareButtonsPlugin.registerWith(registry.registrarFor("flutter.moum.hardware_buttons.HardwareButtonsPlugin"));
    ImageCropperPlugin.registerWith(registry.registrarFor("vn.hunghd.flutter.plugins.imagecropper.ImageCropperPlugin"));
    ImagePickerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.imagepicker.ImagePickerPlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    SimpleImageCropPlugin.registerWith(registry.registrarFor("com.lykhonis.simpleimagecrop.SimpleImageCropPlugin"));
    UrlLauncherPlugin.registerWith(registry.registrarFor("io.flutter.plugins.urllauncher.UrlLauncherPlugin"));
    FlutterForegroundPlugin.registerWith(registry.registrarFor("com.sentinel.foreground_plugin.FlutterForegroundPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
