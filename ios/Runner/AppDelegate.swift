import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Disable all logging for UIKit
    UserDefaults.standard.set(false, forKey: "UIKit.logging.enabled")
    
    // Only log errors and above
    setenv("CFNETWORK_DIAGNOSTICS", "3", 1)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
