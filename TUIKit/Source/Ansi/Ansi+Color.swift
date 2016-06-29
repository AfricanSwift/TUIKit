
//          File:   Color+Ansicodes.swift
//    Created by:   African Swift

import Darwin

// MARK: - Foreground: Static Base Colors -
public extension Ansi.Color
{
  /// Averages current color with a provided color.
  /// - parameter color: Ansi.Color
  /// - returns: Ansi.Color
  internal func averageWith(color: Ansi.Color) -> Ansi.Color
  {
    let red = (self.RGB.red + color.RGB.red) / 2
    let green = (self.RGB.green + color.RGB.green) / 2
    let blue = (self.RGB.blue + color.RGB.blue) / 2
    return Ansi.Color(red: red, green: green, blue: blue, alpha: 1)
  }
  
  /// Foreground
  public struct Foreground
  {
    private static let base = 30
    private static let extended = 90
    
    private static let fgBase =
    {
        (function: Int) -> Ansi in
        return Ansi("\(Ansi.C1.CSI)\(base + function)m")
    }
    
    private static let fgExtended =
    {
        (function: Int) -> Ansi in
        return Ansi("\(Ansi.C1.CSI)\(extended + function)m")
    }
    
    /// Set foreground color to Black.
    /// - returns: Ansi
    public static func black() -> Ansi
    {
      return fgBase(0)
    }
    
    /// Set foreground color to Red.
    /// - returns: Ansi
    public static func red() -> Ansi
    {
      return fgBase(1)
    }
    
    /// Set foreground color to Green.
    /// - returns: Ansi
    public static func green() -> Ansi
    {
      return fgBase(2)
    }
    
    /// Set foreground color to Brown.
    /// - returns: Ansi
    public static func brown() -> Ansi
    {
      return fgBase(3)
    }
    
    /// Set foreground color to Blue.
    /// - returns: Ansi
    public static func blue() -> Ansi
    {
      return fgBase(4)
    }
    
    /// Set foreground color to Magenta.
    /// - returns: Ansi
    public static func magenta() -> Ansi
    {
      return fgBase(5)
    }
    
    /// Set foreground color to Cyan.
    /// - returns: Ansi
    public static func cyan() -> Ansi
    {
      return fgBase(6)
    }
    
    /// Set foreground color to LightGray.
    /// - returns: Ansi
    public static func lightGray() -> Ansi
    {
      return fgBase(7)
    }
    
    /// Set foreground color to default.
    /// - returns: Ansi
    public static func reset() -> Ansi
    {
      return fgBase(9)
    }
    
    /// Set foreground color to DarkGray.
    /// - returns: Ansi
    public static func darkGray() -> Ansi
    {
      return fgExtended(0)
    }
    
    /// Set foreground color to LightRed.
    /// - returns: Ansi
    public static func lightRed() -> Ansi
    {
      return fgExtended(1)
    }
    
    /// Set foreground color to LightGreen.
    /// - returns: Ansi
    public static func lightGreen() -> Ansi
    {
      return fgExtended(2)
    }
    
    /// Set foreground color to Yellow.
    /// - returns: Ansi
    public static func yellow() -> Ansi
    {
      return fgExtended(3)
    }
    
    /// Set foreground color to LightBlue.
    /// - returns: Ansi
    public static func lightBlue() -> Ansi
    {
      return fgExtended(4)
    }
    
    /// Set foreground color to LightMagenta.
    /// - returns: Ansi
    public static func lightMagenta() -> Ansi
    {
      return fgExtended(5)
    }
    
    /// Set foreground color to LightCyan.
    /// - returns: Ansi
    public static func lightCyan() -> Ansi
    {
      return fgExtended(6)
    }
    
    /// Set foreground color to White.
    /// - returns: Ansi
    public static func white() -> Ansi
    {
      return fgExtended(7)
    }
    
    /// Ansi 256 colors
    /// - parameter index: Ansi Color Value (0 - 256)
    /// - returns: Ansi
    public static func color256(index: Int) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)38;5;\(index)m")
    }
    
    /// Ansi RGB colors
    /// - parameter red: Red Channel Value (0 - 255)
    /// - parameter green: Green Channel Value (0 - 255)
    /// - parameter blue: Blue Channel Value (0 - 255)
    /// - returns: Ansi
    public static func colorRGB(red: Int, green: Int, blue: Int) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)38;2;\(red);\(green);\(blue)m")
    }
    
    /// Ansi RGB to 256 colors
    /// - parameter red: Red Channel Value (0 - 255)
    /// - parameter green: Green Channel Value (0 - 255)
    /// - parameter blue: Blue Channel Value (0 - 255)
    /// - returns: Ansi
    public static func colorRGB256(red: Int, green: Int, blue: Int) -> Ansi
    {
      let colorIndex = Ansi.Color(
        red: red.toDouble() / 255,
        green: green.toDouble() / 255,
        blue: blue.toDouble() / 255,
        alpha: 1).toAnsi256()
      return Ansi.Color.Foreground.color256(index: colorIndex)
    }
  }
}

// MARK: - Ansi.Color.Choices -
public extension Ansi.Color
{
  public enum Choices
  {
    case black, red, green, brown, blue, magenta, cyan, lightgray, darkgray
    case lightred, lightgreen, yellow, lightblue, lightmagenta, lightcyan, white
    case color256(Int), rgb(Int, Int, Int), rgb256(Int, Int, Int), reset
    
    private func toAnsi(color: Any) -> Ansi
    {
      typealias foreground = Ansi.Color.Foreground.Type
      typealias background = Ansi.Color.Background.Type
      let isBackground = color is background ? true : false
      let f = color is foreground ? (color as? foreground) : nil
      let b = color is background ? (color as? background) : nil
      
      /// Switch over standard Ansi colors
      /// - returns: Ansi
      func matchStandardColor() -> Ansi
      {
        switch self
        {
          case .black:
            return (isBackground ? b?.black() : f?.black()) ?? Ansi("")
          case .red:
            return (isBackground ? b?.red() : f?.red()) ?? Ansi("")
          case .green:
            return (isBackground ? b?.green() : f?.green()) ?? Ansi("")
          case .brown:
            return (isBackground ? b?.brown() : f?.brown()) ?? Ansi("")
          case .blue:
            return (isBackground ? b?.blue() : f?.blue()) ?? Ansi("")
          case .magenta:
            return (isBackground ? b?.magenta() : f?.magenta()) ?? Ansi("")
          case .cyan:
            return (isBackground ? b?.cyan() : f?.cyan()) ?? Ansi("")
          case .lightgray:
            return (isBackground ? b?.lightGray() : f?.lightGray()) ?? Ansi("")
          default:
            // If not matched, search high intensity
            return matchHighIntensityColor()
        }
      }
      
      /// Switch over high intensity Ansi colors
      /// - returns: Ansi
      func matchHighIntensityColor() -> Ansi
      {
        switch self
        {
          case .darkgray:
            return (isBackground ? b?.darkGray() : f?.darkGray()) ?? Ansi("")
          case .lightred:
            return (isBackground ? b?.lightRed() : f?.lightRed()) ?? Ansi("")
          case .lightgreen:
            return (isBackground ? b?.lightGreen() : f?.lightGreen()) ?? Ansi("")
          case .yellow:
            return (isBackground ? b?.yellow() : f?.yellow()) ?? Ansi("")
          case .lightblue:
            return (isBackground ? b?.lightBlue() : f?.lightBlue()) ?? Ansi("")
          case .lightmagenta:
            return (isBackground ? b?.lightMagenta() : f?.lightMagenta()) ?? Ansi("")
          case .lightcyan:
            return (isBackground ? b?.lightCyan() : f?.lightCyan()) ?? Ansi("")
          case .white:
            return (isBackground ? b?.white() : f?.white()) ?? Ansi("")
          default:
            // If not matched, search extended
            return matchExtendedColor()
        }
      }
      
      /// Switch over extended Ansi colors
      /// - returns: Ansi
      func matchExtendedColor() -> Ansi
      {
        switch self
        {
          case .color256(let index):
            return (isBackground ? b?.color256(index: index) :
              f?.color256(index: index)) ?? Ansi("")
          case .rgb(let red, let green, let blue):
            return (isBackground ? b?.colorRGB(red: red, green: green, blue: blue) :
              f?.colorRGB(red: red, green: green, blue: blue)) ?? Ansi("")
        case .rgb256(let red, let green, let blue):
          return (isBackground ? b?.colorRGB256(red: red, green: green, blue: blue) :
            f?.colorRGB256(red: red, green: green, blue: blue)) ?? Ansi("")
          case .reset:
            return (isBackground ? b?.reset() : f?.reset()) ?? Ansi("")
          default:
            /// This should never be executed
            return Ansi("")
        }
      }
      
      return matchStandardColor()
    }
  }
}

// MARK: - String Ansi.Color.Choices: Foreground -
public extension String
{
  /// Ansi Foreground Color
  /// - returns: String (with prepended Ansi Color)
  public var foreground: ((Ansi.Color.Choices) -> String)
  {
    return { choice in
      Ansi.Color.Choices.toAnsi(choice)(
        color: Ansi.Color.Foreground.self).toString() + self
    }
  }
}

// MARK: - Background: Static Base Colors -
public extension Ansi.Color
{
  
  /// Background
  public struct Background
  {
    private static let base = 40
    private static let extended = 100
    
    private static let bgBase =
    {
        (function: Int) -> Ansi in
        return Ansi("\(Ansi.C1.CSI)\(base + function)m")
    }
    
    private static let bgExtended =
    {
        (function: Int) -> Ansi in
        return Ansi("\(Ansi.C1.CSI)\(extended + function)m")
    }
    
    /// Set background color to Black.
    /// - returns: Ansi
    public static func black() -> Ansi
    {
      return bgBase(0)
    }
    
    /// Set background color to Red.
    /// - returns: Ansi
    public static func red() -> Ansi
    {
      return bgBase(1)
    }
    
    /// Set background color to Green.
    /// - returns: Ansi
    public static func green() -> Ansi
    {
      return bgBase(2)
    }
    
    /// Set background color to Brown.
    /// - returns: Ansi
    public static func brown() -> Ansi
    {
      return bgBase(3)
    }
    
    /// Set background color to Blue.
    /// - returns: Ansi
    public static func blue() -> Ansi
    {
      return bgBase(4)
    }
    
    /// Set background color to Magenta.
    /// - returns: Ansi
    public static func magenta() -> Ansi
    {
      return bgBase(5)
    }
    
    /// Set background color to Cyan.
    /// - returns: Ansi
    public static func cyan() -> Ansi
    {
      return bgBase(6)
    }
    
    /// Set background color to LightGray.
    /// - returns: Ansi
    public static func lightGray() -> Ansi
    {
      return bgBase(7)
    }
    
    /// Set background color to default.
    /// - returns: Ansi
    public static func reset() -> Ansi
    {
      return bgBase(9)
    }
    
    /// Set background color to DarkGray.
    /// - returns: Ansi
    public static func darkGray() -> Ansi
    {
      return bgExtended(0)
    }
    
    /// Set background color to LightRed.
    /// - returns: Ansi
    public static func lightRed() -> Ansi
    {
      return bgExtended(1)
    }
    
    /// Set background color to LightGreen.
    /// - returns: Ansi
    public static func lightGreen() -> Ansi
    {
      return bgExtended(2)
    }
    
    /// Set background color to Yellow.
    /// - returns: Ansi
    public static func yellow() -> Ansi
    {
      return bgExtended(3)
    }
    
    /// Set background color to LightBlue.
    /// - returns: Ansi
    public static func lightBlue() -> Ansi
    {
      return bgExtended(4)
    }
    
    /// Set background color to LightMagenta.
    /// - returns: Ansi
    public static func lightMagenta() -> Ansi
    {
      return bgExtended(5)
    }
    
    /// Set background color to LightCyan.
    /// - returns: Ansi
    public static func lightCyan() -> Ansi
    {
      return bgExtended(6)
    }
    
    /// Set background color to White.
    /// - returns: Ansi
    public static func white() -> Ansi
    {
      return bgExtended(7)
    }
    
    /// Ansi 256 colors
    /// - parameter index: Ansi Color Value (0 - 256)
    /// - returns: Ansi
    public static func color256(index: Int) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)48;5;\(index)m")
    }
    
    /// Ansi RGB colors
    /// - parameter red: Red Channel Value (0 - 255)
    /// - parameter green: Green Channel Value (0 - 255)
    /// - parameter blue: Blue Channel Value (0 - 255)
    /// - returns: Ansi
    public static func colorRGB(red: Int, green: Int, blue: Int) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)48;2;\(red);\(green);\(blue)m")
    }
    
    /// Ansi RGB to 256 colors
    /// - parameter red: Red Channel Value (0 - 255)
    /// - parameter green: Green Channel Value (0 - 255)
    /// - parameter blue: Blue Channel Value (0 - 255)
    /// - returns: Ansi
    public static func colorRGB256(red: Int, green: Int, blue: Int) -> Ansi
    {
      let colorIndex = Ansi.Color(
        red: red.toDouble() / 255,
        green: green.toDouble() / 255,
        blue: blue.toDouble() / 255,
        alpha: 1).toAnsi256()
      return Ansi.Color.Background.color256(index: colorIndex)
    }
  }
}

// MARK: - String Ansi.Color.Choices: Background -
public extension String
{
  /// Ansi Background Color
  /// - returns: String (with prepended Ansi Color)
  public var background: ((Ansi.Color.Choices) -> String)
  {
    return { choice in
      Ansi.Color.Choices.toAnsi(choice)(
        color: Ansi.Color.Background.self).toString() + self
    }
  }
}

// MARK: - Ansi.Color Instance Colors -
public extension Ansi.Color
{
  /// Convert to nearest Ansi grayscale color
  /// - returns: Ansi
  public func foregroundGray() -> Ansi
  {
    let index = self.nearestAnsiGrayscale()
    return Ansi.Color.Foreground.color256(index: index)
  }
  
  /// Convert to nearest Ansi grayscale color
  /// - returns: Ansi
  public func backgroundGray() -> Ansi
  {
    let index = self.nearestAnsiGrayscale()
    return Ansi.Color.Background.color256(index: index)
  }
  
  /// Convert to nearest 16 Ansi color
  /// - returns: Ansi
  public func foreground16() -> Ansi
  {
    let index = self.nearestAnsi16Color()
    return Ansi.Color.Foreground.color256(index: index)
  }
  
  /// Convert to nearest 16 Ansi color
  /// - returns: Ansi
  public func background16() -> Ansi
  {
    let index = self.nearestAnsi16Color()
    return Ansi.Color.Background.color256(index: index)
  }
  
  /// Convert to nearest 256 Ansi color
  /// - returns: Ansi
  public func foreground256() -> Ansi
  {
    let index = self.toAnsi256()
    return Ansi.Color.Foreground.color256(index: index)
  }
  
  /// Convert to nearest 256 Ansi color
  /// - returns: Ansi
  public func background256() -> Ansi
  {
    let index = self.toAnsi256()
    return Ansi.Color.Background.color256(index: index)
  }
  
  /// Convert to RGB color (limited support)
  /// - returns: Ansi
  public func foregroundRGB() -> Ansi
  {
    return Ansi.Color.Foreground.colorRGB(
      red: Int(self.RGB.red * 255.0),
      green: Int(self.RGB.green * 255.0),
      blue: Int(self.RGB.blue * 255.0))
  }
  
  /// Convert to RGB color (limited support)
  /// - returns: Ansi
  public func backgroundRGB() -> Ansi
  {
    return Ansi.Color.Background.colorRGB(
      red: Int(self.RGB.red * 255.0),
      green: Int(self.RGB.green * 255.0),
      blue: Int(self.RGB.blue * 255.0))
  }
}

// MARK: - Color Transforms: Grayscale, Ansi 256, Ansi 16 -
public extension Ansi.Color
{
  /// Calculates the nearest Ansi Grayscale color match
  /// - 0xE8-0xFF:  grayscale from black to white in 24 steps
  ///
  /// [Wikipedia ANSI Colors](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors)
  /// - returns: Int
  private func nearestAnsiGrayscale() -> Int
  {
    let grayOffset = 24.0 * self.grayscaleIntensity()
    return 0xE8 + Int(grayOffset)
  }
  
  /// Convert NSColor to equivalent ANSI 256 color integer value
  ///
  /// https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
  /// - 0x00-0x07:  standard colors (as in ESC [ 30–37 m)
  /// - 0x08-0x0F:  high intensity colors (as in ESC [ 90–97 m)
  /// - 0x10-0xE7:  6 × 6 × 6 = 216 colors: 16 + 36 × r + 6 × g + b (0 ≤ r, g, b ≤ 5)
  /// - 0xE8-0xFF:  grayscale from black to white in 24 steps
  /// - returns: Int
  private func toAnsi256() -> Int
  {
    let red = self.RGB.red * 255
    let green = self.RGB.green * 255
    let blue = self.RGB.blue * 255
    
    return 16 +
      (Int(6 * red / 256) * 36) +
      (Int(6 * green / 256) * 6) +
      (Int(6 * blue / 256))
  }
  
  /// Calculates the nearest Ansi 16 color match
  /// - 0x00-0x07:  standard colors (similar to ESC [ 30–37 m)
  /// - 0x08-0x0F:  high intensity colors (similar to ESC [ 90–97 m)
  ///
  /// [Wikipedia ANSI Colors](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors)
  /// - returns: Int
  private func nearestAnsi16Color() -> Int
  {
    /// RGB Color Components
    struct RGBComponents
    {
      var red: Int
      var green: Int
      var blue: Int
    }
    
    // [Reference xTerm Color palette to RGB](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors)
    let ansi16ColorPalette = [
      /// Black
      0 : RGBComponents(red: 0, green: 0, blue: 0),
      /// Red
      1 : RGBComponents(red: 205, green: 0, blue: 0),
      /// Green
      2 : RGBComponents(red: 0, green: 205, blue: 0),
      /// Brown
      3 : RGBComponents(red: 205, green: 205, blue: 0),
      /// Blue
      4 : RGBComponents(red: 0, green: 0, blue: 238),
      /// Purple
      5 : RGBComponents(red: 205, green: 0, blue: 205),
      /// Cyan
      6 : RGBComponents(red: 0, green: 205, blue: 205),
      /// Gray
      7 : RGBComponents(red: 229, green: 229, blue: 229),
      /// DarkGray
      8 : RGBComponents(red: 127, green: 127, blue: 127),
      /// LightRed
      9 : RGBComponents(red: 255, green: 0, blue: 0),
      /// LightGreen
      10 : RGBComponents(red: 0, green: 255, blue: 0),
      /// Yellow
      11 : RGBComponents(red: 255, green: 255, blue: 0),
      /// LightBlue
      12 : RGBComponents(red: 92, green: 92, blue: 255),
      /// LightPurple
      13 : RGBComponents(red: 255, green: 0, blue: 255),
      /// LightCyan
      14 : RGBComponents(red: 0, green: 255, blue: 255),
      /// White
      15 : RGBComponents(red: 255, green: 255, blue: 255)
    ]
    
    var minimumDistance = 255 * 255 + 255 * 255 + 1
    var result = -1
    
    for (index, components) in ansi16ColorPalette
    {
      let redDifference = Int(self.RGB.red * 255.0) - components.red
      let greenDifference = Int(self.RGB.green * 255.0) - components.green
      let blueDifference = Int(self.RGB.blue * 255.0) - components.blue
      
      let distance = redDifference * redDifference
        + greenDifference * greenDifference
        + blueDifference * blueDifference
      
      if distance < minimumDistance
      {
        minimumDistance = distance
        result = index
      }
    }
    return result
  }
}
