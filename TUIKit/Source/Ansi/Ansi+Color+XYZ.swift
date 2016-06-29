
//          File:   Color+XYZ.swift
//    Created by:   African Swift

import Darwin

internal extension Ansi.Color
{
  /// Convert RGB to XYZ
  /// - parameter rgb: Ansi.Color.RGBComponents
  /// - returns: Ansi.Color.XYZComponents
  internal static func convertRGBToXYZ(
    rgb value: Ansi.Color.RGBComponents) -> Ansi.Color.XYZComponents
  {
    
    func adjustPrimary(_ component: Double) -> Double
    {
      return (component > 0.04045 ?
        pow((component + 0.055) / 1.055, 2.4) :
        component / 12.92) * 100
    }
    
    //Observer = 2°, Illuminant = D65
    func toXYZ(
      red: Double,
          green: Double,
          blue: Double) -> Ansi.Color.XYZComponents
    {
      return Ansi.Color.XYZComponents(
        X: red * 0.4124 + green * 0.3576 + blue * 0.1805,
        Y: red * 0.2126 + green * 0.7152 + blue * 0.0722,
        Z: red * 0.0193 + green * 0.1192 + blue * 0.9505)
    }
    
    return toXYZ(
      red: adjustPrimary(value.red),
      green: adjustPrimary(value.green),
      blue: adjustPrimary(value.blue))
  }
  
  /// Convert LAB to XYZ
  /// - parameter lab: Ansi.Color.LABComponents
  /// - returns: Ansi.Color.XYZComponents
  internal static func convertLABToXYZ(
    lab value: Ansi.Color.LABComponents) -> Ansi.Color.XYZComponents
  {
    
    // CIE XYZ tristimulus values of the reference white point,
    let whitepointReferenceX: Double = 95.047
    let whitepointReferenceY: Double = 100.000
    let whitepointReferenceZ: Double = 108.883
    
    enum XYZComponents
    {
      case x, y, z
    }
    
    // Observer = 2°, Illuminant = D65
    func toXYZ(
      component: Double,
                selection: XYZComponents) -> Double
    {
      let comp3 = pow(component, 3)
      let adjustedComponent = comp3 > 0.008856
        ? comp3 : (component - (16/116)) / 7.787
      
      return selection == .x ? adjustedComponent * whitepointReferenceX :
        selection == .y ? adjustedComponent * whitepointReferenceY :
        adjustedComponent * whitepointReferenceZ //.Z
    }
    
    return Ansi.Color.XYZComponents(
      X: toXYZ(component: (value.a / 500) + ((value.lightness + 16) / 116),
        selection: .x),
      Y: toXYZ(component: (value.lightness + 16) / 116,
        selection: .y),
      Z: toXYZ(component: ((value.lightness + 16) / 116) - (value.b / 200),
        selection: .z))
  }
}
