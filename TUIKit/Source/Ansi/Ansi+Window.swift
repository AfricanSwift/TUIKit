//
//          File:   Ansi+Window.swift
//    Created by:   African Swift

import Darwin

// MARK: -
// MARK: Window manipulation (from dtterm, as well as extensions) -
public extension Ansi
{
  /// Window manipulation (from dtterm, as well as extensions).
  public struct Window
  {
    /// Move window to x,y
    ///
    /// - parameters:
    ///   - x: Int
    ///   - y: Int
    /// - returns: Ansi
    public static func move(x: Int, y: Int) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)3;\(x);\(y)t")
    }
    
    /// Resize window to pixel: height/width
    ///
    /// - parameters:
    ///   - width: Int
    ///   - height: Int
    /// - returns: Ansi
    public static func resize(width: Int, height: Int) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)4;\(height);\(width)t")
    }
    
    /// Resize text area to character: width/height
    ///
    /// - parameters:
    ///   - width: Int
    ///   - height: Int
    /// - returns: Ansi
    public static func resizeTextArea(width: Int, height: Int) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)8;\(height);\(width)t")
    }
    
    /// De-iconify window
    ///
    /// - returns: Ansi
    public static func deIconify() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)1t")
    }
    
    /// Iconify window
    ///
    /// - returns: Ansi
    public static func iconify() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)2t")
    }
    
    /// Raise window to front of stacking order
    ///
    /// - returns: Ansi
    public static func raise() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)5t")
    }
    
    /// Lower window to bottom of stacking order
    ///
    /// - returns: Ansi
    public static func lower() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)6t")
    }
    
    /// Refresh the xterm window
    ///
    /// - returns: Ansi
    public static func refresh() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)7t")
    }
    
    /// Restore maximized window
    ///
    /// - returns: Ansi
    public static func restore() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)9;0t")
    }
    
    /// Maximize window
    ///
    /// - returns: Ansi
    public static func maximize() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)9;1t")
    }
  }
}

// MARK: -
// MARK: Window Report -
public extension Ansi.Window
{
  /// Window Reports: state, position, pixelSize, ...
  public struct Report
  {
    
    public enum State
    {
      case open, iconified, none
    }
    
    private static let state1 = Ansi.Terminal.Command(
      request: Ansi("\(Ansi.C1.CSI)11t"),
      response: "\u{1B}[#t")
    
    public static func state2() -> State?
    {
      guard let response = Ansi.Terminal.responseTTY(command: state1)
        else { return nil }
      let value = response
        .replacingOccurrences(of: Ansi.C1.CSI, with: "")
        .replacingOccurrences(of: "t", with: "")
      switch value
      {
        case "1":
          return State.open
        case "2":
          return State.iconified
        default:
          return State.none
      }
    }
    
    /// Report xterm window state  
    /// If window is open (non-iconified), it returns CSI 1 t .
    /// If window is iconified, it returns CSI 2 t
    ///
    /// - returns: Ansi
    public static func state() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)11t")
    }
    
    /// Report window position
    /// Result is CSI 3 ; x ; y t
    ///
    /// - returns: Ansi
    public static func position() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)13t")
    }
    
    /// Report window in pixels
    /// Result is CSI  4 ; height ; width t
    ///
    /// - returns: Ansi
    public static func pixelSize() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)14t")
    }
    
    /// Report the size of the text area in characters.
    /// Result is CSI  8  ;  height ;  width t
    ///
    /// - returns: Ansi
    public static func characterTextAreaSize() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)18t")
    }
    
    /// Report screen size in characters
    /// Result is CSI  9  ;  height ;  width t
    ///
    /// - returns: Ansi
    public static func characterScreenSize() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)19t")
    }
    
    /// Report xterm window's icon label
    /// Result is OSC  L  label ST
    ///
    /// - returns: Ansi
    public static func iconLabel() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)20t")
    }
  }
}

// MARK: -
// MARK: Operating System Controls -
public extension Ansi.Window
{
  public struct OSC
  {
    /// Change Icon Name and Window Title
    ///
    /// - parameters:
    ///   - name: String
    /// - returns: Ansi
    public static func iconNameAndTitle(name: String) -> Ansi
    {
      return Ansi("\(Ansi.C1.OSC)0;\(name)\(Ansi.C0.BEL)")
    }
    
    /// Change Icon Name
    ///
    /// - parameters:
    ///   - name: String
    /// - returns: Ansi
    public static func iconName(name: String) -> Ansi
    {
      return Ansi("\(Ansi.C1.OSC)1;\(name)\(Ansi.C0.BEL)")
    }
    
    /// Change Window Title
    ///
    /// - parameters:
    ///   - title: String
    /// - returns: Ansi
    public static func windowTitle(title: String) -> Ansi
    {
      return Ansi("\(Ansi.C1.OSC)2;\(title)\(Ansi.C0.BEL)")
    }
  }
}
