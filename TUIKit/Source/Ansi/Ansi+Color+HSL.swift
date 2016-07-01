//
//          File:   Color+HSL.swift
//    Created by:   African Swift

import Darwin

//MARK: - RGB to HSL -
public extension Ansi.Color
{
  /// Convert RGB to HSL
  ///
  /// - parameters:
  ///   - rgb: Ansi.Color.RGBComponents
  /// - returns: Ansi.Color.HSLComponents
  internal static func convertRGBtoHSL(
    rgb value: Ansi.Color.RGBComponents) -> Ansi.Color.HSLComponents
  {
    var hue: Double
    var saturation: Double
    var lightness: Double
    let minComponent = min(value.red, value.green, value.blue)
    let maxComponent = max(value.red, value.green, value.blue)
    let deltaComponent = maxComponent - minComponent
    lightness = (maxComponent + minComponent) / 2.0
    
    // This is a gray, no chroma...
    if deltaComponent == 0
    {
      // HSL results from 0 to 1
      hue = 0
      saturation = 0
    }
    else
    {
      // Chromatic data...
      if lightness < 0.5
      {
        saturation = deltaComponent / (maxComponent + minComponent)
      }
      else
      {
        saturation = deltaComponent / ( 2 - maxComponent - minComponent)
      }
    }
    
    func delta(component: Double) -> Double
    {
      return ((maxComponent - component) / 6
        + (deltaComponent / 2)) / deltaComponent
    }
    
    
    let deltaRed = delta(component: value.red)
    let deltaGreen = delta(component: value.green)
    let deltaBlue = delta(component: value.blue)
    
    switch maxComponent
    {
      case value.red:
        hue = deltaBlue - deltaGreen
      case value.green:
        hue = (1 / 3) + deltaRed - deltaBlue
      case value.blue:
        hue = (2 / 3) + deltaGreen - deltaRed
      default:
        hue = 0 // Should never occur
    }
    
    if hue < 0
    {
      hue += 1
    }
    else if hue > 1
    {
      hue -= 1
    }
    
    return Ansi.Color.HSLComponents(
      hue: hue,
      saturation: saturation,
      lightness: lightness)
  }
}

// MARK: - HSL Adjustments -
public extension Ansi.Color
{
  
  /// Adjust hue (Increase or Decrease).
  ///
  /// - parameters:
  ///   - amount: Degree as ratio -1.0 to 1.0 (-360 to 360 degrees)
  /// - returns: Ansi.Color
  public func adjustHue(_ amount: Double) -> Ansi.Color
  {
    return Ansi.Color(
      hue: self.HSL.hue + amount,
      saturation: self.HSL.saturation,
      lightness: self.HSL.lightness,
      alpha: self.alpha)
  }
  
  /// Adjust Lightness (Increase or Decrease).
  ///
  /// - parameters:
  ///   - amount: Double between -1.0 and 1.0
  /// - returns: Ansi.Color
  public func adjustLightness(_ amount: Double) -> Ansi.Color
  {
    return Ansi.Color(
      hue: self.HSL.hue,
      saturation: self.HSL.saturation,
      lightness: self.HSL.lightness + amount,
      alpha: self.alpha)
  }
  
  /// Adjust Saturation (Increase or Decrease).
  ///
  /// - parameters:
  ///   - amount: Double between -1.0 and 1.0
  /// - returns: Ansi.Color
  public func adjustSaturation(_ amount: Double) -> Ansi.Color
  {
    return Ansi.Color(
      hue: self.HSL.hue,
      saturation: self.HSL.saturation + amount,
      lightness: self.HSL.lightness,
      alpha: self.alpha)
  }
  
  /// Returns a complementary color for the given NSColor
  /// from the opposite side of the color wheel 50% = 180 degrees.
  ///
  /// - returns: Ansi.Color
  public func complementaryHue() -> Ansi.Color
  {
    return self.adjustHue(0.5)
  }
  
  /// Converts the given NSColor to grayscale
  ///
  /// - returns: Ansi.Color
  public func contrastColor() -> Ansi.Color
  {
    var lightDark: Double = 0
    if self.HSL.lightness > 0.5
    {
      lightDark = 0
    }
    else
    {
      lightDark = 1
    }
    
    return Ansi.Color(
      hue: self.HSL.hue,
      saturation: self.HSL.saturation,
      lightness: lightDark,
      alpha: self.alpha)
  }
}
