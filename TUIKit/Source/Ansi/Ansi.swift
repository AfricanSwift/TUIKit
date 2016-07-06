//
//          File:   Ansi.swift
//    Created by:   African Swift

import Darwin

public struct Ansi
{
  /// Internal storage
  private var value: String
  
  /// Indicates if tags are compressed
  /// Note: reset to false when a new tag is added
  private var isCompressed: Bool = false
  
  public init(_ value: String)
  {
    self.value = value
  }
  
  /// Converts Ansi to String
  ///
  /// - returns: String
  public func toString() -> String
  {
    return self.value
  }
  
  public func stdout()
  {
    fputs(self.value, Darwin.stdout)
  }
  
  public static func flush()
  {
    fflush(__stdoutp)
  }
  
  /// Reset Attributes, Foreground and Background Colors
  ///
  /// - returns: Ansi
  public static func resetAll() -> Ansi
  {
    return Ansi.Attribute.reset() + Ansi.Color.Foreground.reset() +
      Ansi.Color.Background.reset()
  }
  
  // MARK: -
  // MARK: Ansi.Color Type -
  
  /// Ansi.Color
  public struct Color
  {
    /// RGB Colorspace
    public struct RGBComponents
    {
      public var red: Double
      public var green: Double
      public var blue: Double
    }
    
    /// HSB Colorspace
    public struct HSLComponents
    {
      public var hue: Double
      public var saturation: Double
      public var lightness: Double
    }
    
    /// Cie LAB Colorspace
    public struct LABComponents
    {
      public var lightness: Double
      public var a: Double
      public var b: Double
    }
    
    /// XYZ Colorspace
    internal struct XYZComponents
    {
      internal var X: Double
      internal var Y: Double
      internal var Z: Double
    }
    
    /// CMYK Colorspace
    public struct CMYKComponents
    {
      public var cyan: Double
      public var magenta: Double
      public var yellow: Double
      public var key: Double
    }
    
    /// RGB Colorspace
    public private(set) var RGB: RGBComponents
    
    /// HSB Colorspace
    public private(set) var HSL: HSLComponents
    
    /// LAB Colorspace
    public lazy var LAB: LABComponents = {
      // Convert RGB to LAB
      return Ansi.Color.convertRGBtoLAB(rgb: self.RGB)
    }()
    
    /// CMYK Colorspace
    public lazy var CMYK: CMYKComponents = {
      // Convert RGB to CMYK
      return Ansi.Color.convertRGBtoCMYK(rgb: self.RGB)
    }()
    
    /// Alpha - Common for all colorspaces
    public private(set) var alpha: Double
    
    /// Default initializer
    ///
    /// - parameters:
    ///   - red: Double
    ///   - green: Double
    ///   - blue: Double
    ///   - alpha: Double
    public init(red: Double, green: Double, blue: Double, alpha: Double)
    {
      precondition(
        red >= 0.0 && red <= 1.0 &&
          green >= 0.0 && green <= 1.0 &&
          blue >= 0.0 && blue <= 1.0 &&
          alpha >= 0.0 && alpha <= 1.0,
        "0 >= red, green, green, blue, alpha <= 1")
      
      self.RGB = RGBComponents(
        red: red,
        green: green,
        blue: blue)
      
      // Convert RGB to HSL
      self.HSL = Ansi.Color.convertRGBtoHSL(rgb: self.RGB)
      self.alpha = alpha
    }
    
    /// Default initializer
    ///
    /// - parameters:
    ///   - hue: Double
    ///   - saturation: Double
    ///   - lightness: Double
    ///   - alpha: Double
    public init(hue: Double, saturation: Double, lightness: Double, alpha: Double)
    {
      precondition(
        hue >= 0.0 && hue <= 1.0 ||
          saturation >= 0.0 && saturation <= 1.0 ||
          lightness >= 0.0 && lightness <= 1.0 ||
          0.0 >= alpha && alpha <= 1.0,
        "0 >= hue, saturation, brightness, alpha <= 1")
      
      self.HSL = HSLComponents(
        hue: hue,
        saturation: saturation,
        lightness: lightness)
      
      // Convert HSL to RGB
      self.RGB = Ansi.Color.convertHSLtoRGB(hsl: self.HSL)
      self.alpha = alpha
    }
  }
}

// MARK: -
// MARK: Ansi CustomStringConvertible -
extension Ansi: CustomStringConvertible
{
  public var description: String
  {
    return self.value
  }
}

// MARK: -
// MARK: Ansi StringLiteralConvertible -
extension Ansi: StringLiteralConvertible
{
  
  /// Create an instance initialized to `value`
  ///
  /// - parameters:
  ///   - stringLiteral: String
  public init(stringLiteral value: String)
  {
    self.value = value
  }
  
  /// Create an instance initialized to `value`
  ///
  /// - parameters:
  ///   -  extendedGraphemeClusterLiteral: String
  public init(extendedGraphemeClusterLiteral value: String)
  {
    self.value = value
  }
  
  /// Create an instance initialized to `value`
  ///
  /// - parameters:
  ///   -  unicodeScalarLiteral: String
  public init(unicodeScalarLiteral value: String)
  {
    self.value = value
  }
}

// MARK: -
// MARK: String Ansi -
public extension String
{
  /// Ansi Reset All
  ///
  /// - returns: String (with appended Ansi Attributes + Color Reset Codes)
  public var resetall: String
  {
    return self + Ansi.resetAll().toString()
  }
}

// MARK: -
// MARK: Ansi Equatable -
extension Ansi: Equatable {}

public func == (lhs: Ansi, rhs: Ansi) -> Bool
{
  return lhs.value == rhs.value
}

// MARK: -
// MARK: Ansi Operators -
public func + (lhs: Ansi, rhs: Ansi) -> Ansi
{
  var result = Ansi(lhs.value + rhs.value)
  result.isCompressed = false
  return result
}

public func + (lhs: Ansi, rhs: String) -> Ansi
{
  var result = Ansi(lhs.value + rhs)
  result.isCompressed = false
  return result
}

public func + (lhs: String, rhs: Ansi) -> Ansi
{
  var result = Ansi(lhs + rhs.value)
  result.isCompressed = false
  return result
}

public func + (lhs: Ansi, rhs: Character) -> Ansi
{
  var result = lhs + rhs.toAnsi()
  result.isCompressed = false
  return result
}

public func += (lhs: inout Ansi, rhs: String)
{
  lhs = Ansi(lhs.value + rhs)
  lhs.isCompressed = false
}

public func += (lhs: inout Ansi, rhs: Ansi)
{
  lhs = Ansi(lhs.value + rhs.value)
  lhs.isCompressed = false
}
