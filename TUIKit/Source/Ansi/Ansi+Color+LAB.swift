
//          File:   Color+LAB.swift
//    Created by:   African Swift

import Darwin

// MARK: - RGB to LAB -
public extension Ansi.Color
{
  /// Convert RGB to LAB
  /// - parameter rgb: Ansi.Color.RGBComponents
  /// - returns: Ansi.Color.LABComponents
  internal static func convertRGBtoLAB(
    rgb value: Ansi.Color.RGBComponents) -> Ansi.Color.LABComponents
  {
    
    let XYZ = Ansi.Color.convertRGBToXYZ(
      rgb: Ansi.Color.RGBComponents(
        red: value.red * 255.0,
        green: value.green * 255.0,
        blue: value.blue * 255.0))
    
    return Ansi.Color.convertXYZToLAB(
      xyz: Ansi.Color.XYZComponents(
        X: XYZ.X,
        Y: XYZ.Y,
        Z: XYZ.Z))
  }
}

// MARK: - XYZ to LAB -
public extension Ansi.Color
{
  /// Convert XYZ to LAB
  /// - parameter xyz: Ansi.Color.XYZComponents
  /// - returns: Ansi.Color.LABComponents
  private static func convertXYZToLAB(
    xyz value: Ansi.Color.XYZComponents) -> Ansi.Color.LABComponents
  {
    
    // CIE XYZ tristimulus values of the reference white point,
    // Observer = 2°, Illuminant = D65
    let whitepointReferenceX: Double = 95.047
    let whitepointReferenceY: Double = 100.000
    let whitepointReferenceZ: Double = 108.883
    
    enum XYZComponents
    {
      case x, y, z
    }
    
    func convertXYZ(value: Double, component: XYZComponents) -> Double
    {
      let adjustedComponent = component == .x ?
        value / whitepointReferenceX
        : component == .y ? value / whitepointReferenceY
        : value / whitepointReferenceZ
      return adjustedComponent > 0.008856
        ? pow(adjustedComponent, 1 / 3) :
        (7.787 * adjustedComponent) + (16 / 116)
    }
    
    func toCieLAB(
      vx: Double,
         vy: Double,
         vz: Double) -> Ansi.Color.LABComponents
    {
      return Ansi.Color.LABComponents(
        lightness: (116 * vy) - 16,
        a: 500 * (vx - vy),
        b: 200 * (vy - vz))
    }
    
    return toCieLAB(
      vx: convertXYZ(value: value.X, component: .x),
      vy: convertXYZ(value: value.Y, component: .y),
      vz: convertXYZ(value: value.Z, component: .z))
  }
}
