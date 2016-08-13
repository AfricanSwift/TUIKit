//
//          File:   Ansi+Color2.swift
//    Created by:   African Swift

import Darwin

public extension Ansi
{
  public class Color2
  {
    private var rgb: RGB
    private var alpha: Double
    public var red: Double { return self.rgb.red }
    public var green: Double { return self.rgb.green }
    public var blue: Double { return self.rgb.blue }
    public var hsl: HSL { return self.toHSL() }
    public var lab: LAB { return self.toLAB() }
    public var cmyb: CMYB { return self.toCMYB() }
    
    private static func clip(value: Double, min: Double, max: Double) -> Double
    {
      return value > max ? max : value < min ? min : value
    }
    
    private init(rgb: RGB, alpha: Double)
    {
      self.rgb = rgb
      self.alpha = Ansi.Color2.clip(value: alpha, min: 0, max: 1)
    }
    
    public convenience init(red: Double, green: Double, blue: Double, alpha: Double)
    {
      let rgb = RGB(red: red, green: green, blue: blue)
      self.init(rgb: rgb, alpha: alpha)
    }
    
    public convenience init(cyan: Double, yellow: Double,
                            magenta: Double, black: Double, alpha: Double)
    {
      let cmyb = CMYB(cyan: cyan, magenta: magenta, yellow: yellow, black: black)
      self.init(rgb: cmyb.toRGB(), alpha: alpha)
    }
    
    public convenience init(l: Double, a: Double, b: Double, alpha: Double)
    {
      let lab = LAB(l: l, a: a, b: b)
      self.init(rgb: lab.toRGB(), alpha: alpha)
    }
    
    public convenience init(hue: Double, saturation: Double, lightness: Double, alpha: Double)
    {
      let h = hue.truncatingRemainder(dividingBy: 360)
      let hsl = HSL(hue: h, saturation: saturation, lightness: lightness)
      self.init(rgb: hsl.toRGB(), alpha: alpha)
    }
  }
}

public extension Ansi.Color2
{
  public func toAnsiColor() -> Ansi.Color
  {
    return Ansi.Color(red: self.red, green: self.green, blue: self.blue, alpha: self.alpha)
  }
  
  /// Returns a color with the hue rotated along the color wheel by the given amount.
  ///
  /// - Parameters:
  ///   - amount: A double representing the number of degrees as ratio (between -360.0 degree and 360.0 degree).
  public func alterHue(by amount: Double) -> Ansi.Color2
  {
    let hsl = self.hsl
    return Ansi.Color2(hue: hsl.hue + amount,
                       saturation: hsl.saturation,
                       lightness: hsl.lightness, alpha: self.alpha)
  }
  
  /// Creates and returns the complement of the color object.
  /// This is identical to adjustedHue(180).
  public func complementary() -> Ansi.Color2
  {
    return alterHue(by: 180)
  }
  
  /// Returns a color with the lightness increased by the given amount.
  ///
  /// - Parameters:
  ///   - amount: Double between 0.0 and 1.0.
  public func lighten(by amount: Double = 0.2) -> Ansi.Color2
  {
    let hsl = self.hsl
    return Ansi.Color2(hue: hsl.hue,
                       saturation: hsl.saturation,
                       lightness: hsl.lightness + amount, alpha: self.alpha)
  }
  
  /// Returns a color with the lightness decreased by the given amount.
  ///
  /// - Parameters:
  ///   - amount: Double between 0.0 and 1.0.
  public func darken(by amount: Double = 0.2) -> Ansi.Color2
  {
    return lighten(by: amount * -1)
  }
  
  /// Returns a color with the saturation increased by the given amount.
  ///
  /// - Parameters:
  ///   - amount: Double between 0.0 and 1.0.
  public func saturate(by amount: Double = 0.2) -> Ansi.Color2
  {
    let hsl = self.hsl
    return Ansi.Color2(hue: hsl.hue,
                       saturation: hsl.saturation + amount,
                       lightness: hsl.lightness, alpha: self.alpha)
  }
  
  /// Returns a color with the saturation decreased by the given amount.
  ///
  /// - Parameters:
  ///   - amount: Double between 0.0 and 1.0.
  public func desaturate(by amount: Double = 0.2) -> Ansi.Color2
  {
    return saturate(by: amount * -1)
  }
  
  /// Creates and returns a color object converted to grayscale.
  /// This is identical to desaturateColor(1).
  public func grayscale() -> Ansi.Color2
  {
    return Ansi.Color2(red: self.red, green: self.red, blue: self.red, alpha: self.alpha)
  }
  
  /// Creates and return a color object where the red, green, and blue values are inverted, 
  /// while the alpha channel is left alone.
  public func invert() -> Ansi.Color2
  {
    return Ansi.Color2(red: 1 - self.red, green: 1 - self.green,
                       blue: 1 - self.blue, alpha: self.alpha)
  }
  
  
  /// Mixes the given color object with the receiver.
  /// Specifically, takes the average of each of the RGB components, optionally weighted by the given percentage. 
  /// The opacity of the colors object is also considered when weighting the components.
  ///
  /// - Parameters:
  ///   - color:  A color object to mix with the receiver.
  ///   - weight: The weight specifies the amount of the given color object (between 0 and 1). The default 
  ///             value is 0.5, which means that half the given color and half the receiver color object 
  ///             should be used. 0.25 means that a quarter of the given color object and three quarters 
  ///             of the receiver color object should be used.
  public func mix(with: Ansi.Color2, by weight: Double = 0.5) -> Ansi.Color2
  {
    let clippedWeight = Ansi.Color2.clip(value: weight, min: 0, max: 1)
    let red   = self.red + clippedWeight * (with.red - self.red)
    let green = self.green + clippedWeight * (with.green - self.green)
    let blue  = self.blue + clippedWeight * (with.blue - self.blue)
    let alpha = self.alpha + clippedWeight * (with.alpha - self.alpha)
    return Ansi.Color2(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  /// Creates and returns a color object corresponding to the mix of the receiver and an amount 
  /// of white color, which increases lightness.
  ///
  /// - Parameters:
  ///   - amount: Double between 0.0 and 1.0. The default amount is equal to 0.2.
  public func tint(by weight: Double = 0.2) -> Ansi.Color2
  {
    let white = Ansi.Color2(red: 1, green: 1, blue: 1, alpha: 1)
    return mix(with: white, by: weight)
  }
  
  /// Creates and returns a color object corresponding to the mix of the receiver and an amount 
  /// of black color, which reduces lightness.
  ///
  /// - Parameters:
  ///   - amount: Double between 0.0 and 1.0. The default amount is equal to 0.2.
  public func shade(by weight: Double = 0.2) -> Ansi.Color2
  {
    let black = Ansi.Color2(red: 0, green: 0, blue: 0, alpha: 1)
    return mix(with: black, by: weight)
  }
  
  /// Creates and returns a color object with the alpha increased by the given amount.
  ///
  /// - Parameters:
  ///   - amount: Double between 0.0 and 1.0.
  public func adjustAlpha(by amount: Double) -> Ansi.Color2
  {
    let alpha = Ansi.Color2.clip(value: self.alpha + amount, min: 0, max: 1)
    return Ansi.Color2(red: self.red, green: self.green, blue: self.blue, alpha: alpha)
  }
}

private extension Ansi.Color2
{
  /// Convert RGB to LAB
  ///
  /// - returns: Ansi.Color2.LAB
  private func toLAB() -> LAB
  {
    let XYZ = convertRGBToXYZ()
    return Ansi.Color2.convertXYZToLAB(xyz: XYZ)
  }
  
  /// Convert RGB to XYZ
  ///
  /// - returns: Ansi.Color2.XYZ
  private func convertRGBToXYZ() -> XYZ
  {
    func adjustPrimary(_ c: Double) -> Double
    {
      return (c > 0.04045 ? pow((c + 0.055) / 1.055, 2.4) : c / 12.92) * 100
    }
    
    //Observer = 2°, Illuminant = D65
    func toXYZ() -> XYZ
    {
      let red = adjustPrimary(self.rgb.red)
      let green = adjustPrimary(self.rgb.green)
      let blue = adjustPrimary(self.rgb.blue)
      
      return XYZ(
        x: red * 0.4124 + green * 0.3576 + blue * 0.1805,
        y: red * 0.2126 + green * 0.7152 + blue * 0.0722,
        z: red * 0.0193 + green * 0.1192 + blue * 0.9505)
    }
    return toXYZ()
  }
  
  /// Convert XYZ to LAB
  ///
  /// - parameters:
  ///   - xyz: Ansi.Color2.XYZ
  /// - returns: Ansi.Color2.LAB
  private static func convertXYZToLAB(xyz value: XYZ) -> LAB
  {
    
    // CIE XYZ tristimulus values of the reference white point,
    // Observer = 2°, Illuminant = D65
    let wpRefX: Double = 95.047
    let wpRefY: Double = 100.000
    let wpRefZ: Double = 108.883
    
    enum XYZComponents
    {
      case x, y, z
    }
    
    func convertXYZ(_ v: Double, _ c: XYZComponents) -> Double
    {
      let adjComp = c == .x ? v / wpRefX : c == .y ? v / wpRefY : v / wpRefZ
      return adjComp > 0.008856 ? pow(adjComp, 1 / 3) : (7.787 * adjComp) + (16 / 116)
    }
    
    func toCieLAB(vx: Double, vy: Double, vz: Double) -> LAB
    {
      return LAB(l: (116 * vy) - 16, a: 500 * (vx - vy), b: 200 * (vy - vz))
    }
    
    return toCieLAB(vx: convertXYZ(value.x, .x),
                    vy: convertXYZ(value.y, .y),
                    vz: convertXYZ(value.z, .z))
  }
}


private extension Ansi.Color2
{
  /// Convert RGB to HSL
  ///
  /// - returns: Ansi.Color2.HSL
  private func toHSL() -> HSL
  {
    var component = (h: 0.0, s: 0.0, l: 0.0)
    let maximum = max(max(self.red, self.blue), self.green)
    let minimum = min(min(self.red, self.blue), self.green)
    let delta = maximum - minimum
    component.l = maximum
    
    if delta != 0
    {
      if maximum == self.red
      {
        component.h = fmod(((self.green - self.blue) / delta), 6.0)
      }
      else if maximum == self.green
      {
        component.h = (self.blue - self.red) / delta + 2.0
      }
      else // if maximum == self.blue
      {
        component.h = (self.red - self.green) / delta + 4.0
      }
      component.h *= 60.0
      component.s = delta / component.l
    }
    return HSL(hue: component.h * 360, saturation: component.s, lightness: component.l)
  }
}

private extension Ansi.Color2
{
  /// Convert RGB to CMYB
  ///
  /// - returns: Ansi.Color2.CMYB
  private func toCMYB() -> CMYB
  {
    // CMY Conversion
    var cyan = (1 - self.red)
    var magenta = (1 - self.green)
    var yellow = (1 - self.blue)
    
    var black = 1.0
    if cyan < black
    {
      black = cyan
    }
    
    if magenta < black
    {
      black = magenta
    }
    
    if yellow < black
    {
      black = yellow
    }
    
    // Black
    if black == 1.0
    {
      cyan = 0
      magenta = 0
      yellow = 0
    }
    else
    {
      cyan = ( cyan - black ) / ( 1 - black )
      magenta = ( magenta - black ) / ( 1 - black )
      yellow = ( yellow - black ) / ( 1 - black )
    }
    
    return CMYB(cyan: cyan, magenta: magenta, yellow: yellow, black: black)
  }
}

public extension Ansi.Color2
{
  internal struct XYZ
  {
    let x: Double
    let y: Double
    let z: Double
  }
  
  /// CIE XYZ color space component values with an observer at 2° and a D65 illuminant.
  ///
  /// - Parameters:
  ///   - l: The lightness, specified as a value from 0 to 1.0
  ///   - a: The red-green axis, specified as a value from -0.5 to 0.5
  ///   - b: The yellow-blue axis, specified as a value from -0.5 to 0.5
  public struct LAB
  {
    let l: Double
    let a: Double
    let b: Double
    
    internal init(l: Double, a: Double, b: Double)
    {
      self.l = Ansi.Color2.clip(value: l, min: 0, max: 1)
      self.a = Ansi.Color2.clip(value: a, min: -0.5, max: 0.5)
      self.b = Ansi.Color2.clip(value: b, min: -0.5, max: 0.5)
    }
    
    /// Convert LAB to RGB
    ///
    /// - returns: Ansi.Color2.RGB
    internal func toRGB() -> RGB
    {
      let xyz = convertLABToXYZ()
      return LAB.convertXYZToRGB(xyz: xyz)
    }
    
    /// Convert LAB to XYZ
    ///
    /// - returns: Ansi.Color2.XYZ
    private func convertLABToXYZ() -> XYZ
    {
      // CIE XYZ tristimulus values of the reference white point,
      let wpRefX: Double = 95.047
      let wpRefY: Double = 100.000
      let wpRefZ: Double = 108.883
      
      enum XYZComponents
      {
        case x, y, z
      }
      
      // Observer = 2°, Illuminant = D65
      func toXYZ(_ v: Double, _ c: XYZComponents) -> Double
      {
        let comp3 = pow(v, 3)
        let adjComp = comp3 > 0.008856 ? comp3 : (v - (16 / 116)) / 7.787
        return c == .x ? adjComp * wpRefX : c == .y ? adjComp * wpRefY : adjComp * wpRefZ //.Z
      }
      
      let y = (self.l + 16) / 116
      let x = (self.a / 500) + y
      let z = y - (self.b / 200)
      
      return XYZ(x: toXYZ(x, .x), y: toXYZ(y, .y), z: toXYZ(z, .z))
    }
    
    /// Convert XYZ to RGB
    ///
    /// - parameters:
    ///   - xyz: Ansi.Color2.XYZ
    /// - returns: Ansi.Color2.RGB
    private static func convertXYZToRGB(xyz value: XYZ) -> RGB
    {
      // Observer = 2°, Illuminant = D65
      let vx = value.x / 100
      let vy = value.y / 100
      let vz = value.z / 100
      
      func convertPrimary(_ v: Double) -> Double
      {
        return v > 0.0031308 ? 1.055 * (pow(v, 1 / 2.4)) - 0.055 : 12.92 * v
      }
      
      return RGB(red: convertPrimary(vx * 3.2406 + vy * -1.5372 + vz * -0.4986),
                 green: convertPrimary(vx * -0.9689 + vy * 1.8758 + vz * 0.0415),
                 blue: convertPrimary(vx * 0.0557 + vy * -0.2040 + vz * 1.0570))
    }
  }
}

public extension Ansi.Color2
{
  /// CMYB color model is a subtractive color model, used in color printing.
  ///
  /// - Parameters:
  ///   - cyan: cyan ink, specified as a value from 0.0 to 1.0
  ///   - magenta: magenta ink, specified as a value from 0.0 to 1.0
  ///   - yellow: yellow ink, specified as a value from 0.0 to 1.0
  ///   - black: black ink, specified as a value from 0.0 to 1.0
  public struct CMYB
  {
    public let cyan: Double
    public let magenta: Double
    public let yellow: Double
    public let black: Double
    
    init(cyan: Double, magenta: Double, yellow: Double, black: Double)
    {
      self.cyan = Ansi.Color2.clip(value: cyan, min: 0, max: 1)
      self.magenta = Ansi.Color2.clip(value: magenta, min: 0, max: 1)
      self.yellow = Ansi.Color2.clip(value: yellow, min: 0, max: 1)
      self.black = Ansi.Color2.clip(value: black, min: 0, max: 1)
    }
    
    /// Convert CMYB to RGB
    ///
    /// - returns: Ansi.Color2.RGB
    internal func toRGB() -> RGB
    {
      // CMYB to CMY
      let cyan = (self.cyan * (1 - self.black) + self.black)
      let magenta = (self.magenta * (1 - self.black) + self.black)
      let yellow = (self.yellow * (1 - self.black) + self.black)
      
      // CMY to RGB
      return RGB(red: 1 - cyan, green: 1 - magenta, blue: 1 - yellow)
    }
    
  }
}

public extension Ansi.Color2
{
  /// RGB color model is an additive color model in which red, green and blue light are added together
  /// in various ways to reproduce a broad array of colors
  ///
  /// - Parameters:
  ///   - red: The red component, specified as a value from 0.0 to 1.0
  ///   - green: The green component, specified as a value from 0.0 to 1.0
  ///   - blue: The blue component, specified as a value from 0.0 to 1.0
  internal struct RGB
  {
    internal let red: Double
    internal let green: Double
    internal let blue: Double
    
    init(red: Double, green: Double, blue: Double)
    {
      self.red = Ansi.Color2.clip(value: red, min: 0, max: 1)
      self.green = Ansi.Color2.clip(value: green, min: 0, max: 1)
      self.blue = Ansi.Color2.clip(value: blue, min: 0, max: 1)
    }
  }
}

public extension Ansi.Color2
{
  /// HSL color from the hue, saturation, lightness components.
  ///
  /// - Parameters:
  ///   - hue: The hue component of the color object, specified as a value between 0.0 and 360.0 degree.
  ///   - saturation: The saturation component of the color object, specified as a value between 0.0 and 1.0.
  ///   - lightness: The lightness component of the color object, specified as a value between 0.0 and 1.0.
  public struct HSL
  {
    public let hue: Double
    public let saturation: Double
    public let lightness: Double
    
    internal init(hue: Double, saturation: Double, lightness: Double)
    {
      self.hue = hue / 360
      self.saturation = Ansi.Color2.clip(value: saturation, min: 0, max: 1)
      self.lightness = Ansi.Color2.clip(value: lightness, min: 0, max: 1)
    }
    
    /// Convert HSL to RGB
    ///
    /// - returns: Ansi.Color2.RGB
    internal func toRGB() -> RGB
    {
      let h = self.hue * 360
      let chroma = self.lightness * self.saturation
      let x = chroma * (1.0 - fabs(fmod(h / 60.0, 2.0) - 1.0))
      let m = self.lightness - chroma
      
      if h >= 0.0 && h < 60.0
      {
        return RGB(red: chroma + m, green: x + m, blue: m)
      }
      else if h >= 60.0 && h < 120.0
      {
        return RGB(red: x + m, green: chroma + m, blue: m)
      }
      else if h >= 120.0 && h < 180.0
      {
        return RGB(red: m, green: chroma + m, blue: x + m)
      }
      else if h >= 180.0 && h < 240.0
      {
        return RGB(red: m, green: x + m, blue: chroma + m)
      }
      else if h >= 240.0 && h < 300.0
      {
        return RGB(red: x + m, green: m, blue: chroma + m)
      }
      else if h >= 300.0 && h < 360.0
      {
        return RGB(red: chroma + m, green: m, blue: x + m)
      }
      else
      {
        return RGB(red: m, green: m, blue: m)
      }
    }
  }
}
