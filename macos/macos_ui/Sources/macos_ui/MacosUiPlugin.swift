import Cocoa
import FlutterMacOS

public class MacOSUiPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private let colorPanelProvider: ColorPanelProvider
  private var eventSink: FlutterEventSink?
  
  init(colorPanelProvider: ColorPanelProvider) {
    self.colorPanelProvider = colorPanelProvider
    super.init()
  }
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "dev.groovinchip.macos_ui",
      binaryMessenger: registrar.messenger)
    
    let colorSelectionChannel = FlutterEventChannel(
      name: "dev.groovinchip.macos_ui/color_panel",
      binaryMessenger: registrar.messenger)
    
    let colorPanelProvider = ColorPanelProvider()
    
    let instance = MacOSUiPlugin(colorPanelProvider: colorPanelProvider)
    colorSelectionChannel.setStreamHandler(colorPanelProvider)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "color_panel":
      guard
        let arguments = call.arguments as? Dictionary<String, Any>,
        let mode = arguments["mode"] as? String
      else {
        result(FlutterError(
          code: "invalid_arguments",
          message: "color_panel requires a string mode.",
          details: nil))
        return
      }
      colorPanelProvider.openPanel(pickerMode: mode)
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}
