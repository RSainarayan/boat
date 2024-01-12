import UIKit
import Flutter
import GoogleMaps  // Add this import

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAMSseHnUykcW7vJB4ZFB90QZ4MSTiA9kk")
    GeneratedPluginRegistrant.register(with: self)

    // TODO: Add your Google Maps API key
    

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
