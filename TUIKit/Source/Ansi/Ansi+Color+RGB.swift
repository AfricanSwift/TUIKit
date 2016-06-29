
//          File:   Color+RGB.swift
//    Created by:   African Swift

import Darwin

// MARK: - LAB to RGB -
public extension Ansi.Color
{
  /// Convert LAB to RGB
  /// - parameter lab: Ansi.Color.LABComponents
  /// - returns: Ansi.Color.RGBComponents
  private static func convertLABToRGB(
    lab value: Ansi.Color.LABComponents) -> Ansi.Color.RGBComponents
  {
    let XYZ = convertLABToXYZ(lab: value)
    return convertXYZToRGB(xyz: XYZ)
  }
}

// MARK: - XYZ to RGB -
public extension Ansi.Color
{
  /// Convert XYZ to RGB
  /// - parameter xyz: Ansi.Color.XYZComponents
  /// - returns: Ansi.Color.RGBComponents
  private static func convertXYZToRGB(
    xyz value: Ansi.Color.XYZComponents) -> Ansi.Color.RGBComponents
  {
    // Observer = 2°, Illuminant = D65
    let vx = value.X / 100
    let vy = value.Y / 100
    let vz = value.Z / 100
    
    func convertPrimary(
      component: Double) -> Double
    {
      return component > 0.0031308 ?
        1.055 * (pow(component, 1 / 2.4)) - 0.055 : 12.92 * component
    }
    
    return Ansi.Color.RGBComponents(
      red: convertPrimary(component: vx * 3.2406 +
        vy * -1.5372 + vz * -0.4986),
      green: convertPrimary(component: vx * -0.9689 +
        vy * 1.8758 + vz * 0.0415),
      blue: convertPrimary(component: vx * 0.0557 +
        vy * -0.2040 + vz * 1.0570))
  }
}

// MARK: - HSL to RGB -
public extension Ansi.Color
{
  /// Convert HSL to RGB
  /// - parameter hsl: Ansi.Color.HSLComponents
  /// - returns: Ansi.Color.RGBComponents
  internal static func convertHSLtoRGB(
    hsl value: Ansi.Color.HSLComponents) -> Ansi.Color.RGBComponents {
    
    guard value.saturation != 0 else
    {
      return Ansi.Color.RGBComponents(
        red: value.lightness,
        green: value.lightness,
        blue: value.lightness)
    }
    
    func hue2RGBComponent(hue h: Double) -> Double
    {
      let v2 = value.lightness < 0.5 ?
        value.lightness * (1 + value.saturation) :
        (value.lightness + value.saturation) -
        (value.saturation * value.lightness)
      
      let v1 = 2 * value.lightness - v2
      let vHue = value.hue < 0 ? value.hue + 1 :
        value.hue > 1 ? value.hue - 1 : value.hue
      
      if 6 * vHue < 1
      {
        return ( v1 + ( v2 - v1 ) * 6 * vHue )
      }
      
      if 2 * vHue < 1
      {
        return v2
      }
      
      if 3 * vHue < 2
      {
        return v1 + ( v2 - v1 ) * ( 2 / 3 - vHue ) * 6
      }
      
      return v1
    }
    
    // Use proportionate hue to calulate respective RGB component
    return Ansi.Color.RGBComponents(
      red: hue2RGBComponent(hue: value.hue + 1 / 3),
      green: hue2RGBComponent(hue: value.hue),
      blue: hue2RGBComponent(hue: value.hue - 1 / 3))
  }
}

// MARK: - CMYK to RGB -
public extension Ansi.Color
{
  /// Convert CMYK to RGB
  /// - parameter cmyk: Ansi.Color.HSLComponents
  /// - returns: Ansi.Color.RGBComponents
  internal static func convertCMYKtoRGB(
    cmyk value: Ansi.Color.CMYKComponents) -> Ansi.Color.RGBComponents
  {
    // CMYK to CMY
    let cyan = ( value.cyan * ( 1 - value.key ) + value.key )
    let magenta = ( value.magenta * ( 1 - value.key  ) + value.key  )
    let yellow = ( value.yellow * ( 1 - value.key  ) + value.key  )
    
    // CMY to RGB
    return Ansi.Color.RGBComponents(
      red: 1 - cyan,
      green: 1 - magenta,
      blue: 1 - yellow)
  }
}
