//
//          File:   Color.swift
//    Created by:   African Swift

import Darwin
//import AppKit

// MARK: -
// MARK: Compuphase color distance -
public extension Ansi.Color
{
  /// Distance between 2 colors
  ///
  /// - parameters:
  ///   - color: 2nd color
  /// - returns: Double representing comparable color distance
  public func distanceTo(color: Ansi.Color) -> Double
  {
    let red1 = self.RGB.red * 255.0
    let green1 = self.RGB.green * 255.0
    let blue1 = self.RGB.blue * 255.0
    
    let red2 = color.RGB.red * 255.0
    let green2 = color.RGB.green * 255.0
    let blue2 = color.RGB.blue * 255.0
    
    let rMean = (red1 + red2) / 2.0
    
    let rDiff = red1 - red2
    let gDiff = green1 - green2
    let bDiff = blue1 - blue2
    
    let rProd = Double(Int((512.0 + rMean) * rDiff * rDiff) >> 8)
    let gProd = 4.0 * gDiff * gDiff
    let bProd = Double(Int((767.0 - rMean) * bDiff * bDiff) >> 8)
    
    return sqrt(rProd + gProd + bProd)
  }
}

// MARK: -
// MARK: Grayscale Intensity -
public extension Ansi.Color
{
  /// Calculates weighted pixel grayscale intensity
  ///
  /// - returns: weighted pixel intensity as Double
  public func grayscaleIntensity() -> Double
  {
    // RGB Linear-Intensity Values
    let redIntensity = 0.2126
    let greenIntensity = 0.7152
    let blueIntensity = 0.0722
    
    // Calculate intensity using weighted linear intensity
    let maxRGBIntensity: Double = redIntensity + greenIntensity + blueIntensity
    
    let weighted = [
      abs(self.RGB.red * redIntensity),
      abs(self.RGB.green * greenIntensity),
      abs(self.RGB.blue * blueIntensity)]
    
    let weightedRGB = weighted.reduce(0) { $0 + $1 }
    return weightedRGB / maxRGBIntensity
  }
}

// MARK: -
// MARK: Average array of Ansi.Color: square root formulation -
public extension Ansi.Color
{
  /// Calculates the average of an array of colors
  ///
  /// - parameters:
  ///   - colors: NSColor Array
  /// - returns: NSColor average
  public static func average(colors: [Ansi.Color]) -> Ansi.Color
  {
    var foundBlack = false
    
    // Average of 2 color components
    func averageComponent(
      component1: Double,
                 component2: Double) -> Double
    {
      return sqrt(((component1 * component1) +
        (component2 * component2)) / 2.0)
    }
    
    if colors.count == 1
    {
      return colors[0]
    }
    
    /* Start average color with the 1st color in the array */
    var averageColor = colors[0]
    for index in 1 ..< colors.count
    {
      let secondColor = colors[index]
      let darkThreshold = 0.2
      
      // Ignore more dark pixels below threshw specified threshold;
      if secondColor.RGB.red <= darkThreshold &&
        secondColor.RGB.green <= darkThreshold &&
        secondColor.RGB.blue <= darkThreshold && foundBlack == true
      {
        continue
      }
      else if secondColor.RGB.red <= darkThreshold &&
        secondColor.RGB.green <= darkThreshold &&
        secondColor.RGB.blue <= darkThreshold
      {
        foundBlack = true
      }
      
      let combinedAverage = Ansi.Color(
        red: averageComponent(
          component1: averageColor.RGB.red,
          component2: secondColor.RGB.red),
        green: averageComponent(
          component1: averageColor.RGB.green,
          component2: secondColor.RGB.green),
        blue: averageComponent(
          component1: averageColor.RGB.blue,
          component2: secondColor.RGB.blue),
        alpha: averageComponent(
          component1: averageColor.alpha,
          component2: secondColor.alpha))
      averageColor = combinedAverage
      
    }
    return averageColor
  }
  
}

// MARK: -
// MARK: Convert NSImage.Pixel to Ansi.Color -
public extension Ansi.Color
{
  /// Convert NSImage.Pixel to Ansi.Color
  ///
  /// - parameter s:
  ///   - red: UInt8
  ///   - green: UInt8
  ///   - blue: UInt8
  ///   - alpha: UInt8
  /// - returns: Ansi.Color
  public static func convertPixel(
    red: UInt8,
        green: UInt8,
        blue: UInt8,
        alpha: UInt8) -> Ansi.Color
  {
    func doubleColor(component: UInt8) -> Double
    {
      return Double(component) / 255.0
    }
    
    return Ansi.Color(
      red: doubleColor(component: red),
      green: doubleColor(component: green),
      blue: doubleColor(component: blue),
      alpha: doubleColor(component: alpha))
  }
}

// TODO: NSImage.Pixel - Temporarily Removed, move to extension of NSImage
//#if os(OSX)
//  public extension Ansi.Color
//  {
//    ///  Convert NSImage.Pixel to Ansi.Color
//    ///  - parameter pixel: Pixel extracted from offSet in NSImage.pixelArray
//    ///  - returns: NSColor
//    public static func convertPixel(pixel: NSImage.Pixel) -> Ansi.Color
//    {
//      func floatColor(component component: UInt8) -> Double
//      {
//        return Double(component) / 255.0
//      }
//      
//      return Ansi.Color(
//        red: floatColor(component: pixel.red),
//        green: floatColor(component: pixel.green),
//        blue: floatColor(component: pixel.blue),
//        alpha: floatColor(component: pixel.alpha))
//    }
//  }
//  
//#endif

// MARK: -
// MARK: Convert Ansi.Color to hex string -
public extension Ansi.Color
{
  /// Converts Ansi.Color to hex string e.g. ea6699
  ///
  /// - returns: String
  public func toHex() -> String
  {
    return String(format:"%02X", Int(self.RGB.red * 255.0))
      + String(format:"%02X", Int(self.RGB.green * 255.0))
      + String(format:"%02X", Int(self.RGB.blue * 255.0))
  }
  
  /// Convert Ansi.Color Components to String
  ///
  /// - returns: String
  public func toCharacters() -> String
  {
    // set unicode offset to skip special characters
    let unicodeOffset = 256
    return String(UnicodeScalar(Int(self.RGB.red * 255.0) + unicodeOffset)) +
      String(UnicodeScalar(Int(self.RGB.green * 255.0) + unicodeOffset)) +
      String(UnicodeScalar(Int(self.RGB.blue * 255.0) + unicodeOffset))
  }
  
  /// Converts & Packs Ansi.Color components as String
  ///
  /// - returns: UInt32
  public func packIntoString() -> String
  {
    func packComponents(color: Ansi.Color) -> UInt32
    {
      let red = UInt32(color.RGB.red * 255.0)
      let green = UInt32(color.RGB.green * 255.0)
      let blue = UInt32(color.RGB.blue * 255.0)
      return red << 16 | green << 8 | blue
    }
    
    let numberAsString = String(packComponents(color: self))
    let length = numberAsString.characters.count
    var result = ""
    for index in stride(from: 0, to: length, by: 4)
    {
      let endIndex = index + 4 < length ? index + 4 : length
      let segment = numberAsString.substring(with: index..<endIndex) ?? ""
      result += String(UnicodeScalar(Int(segment) ?? 0))
    }
    return result
  }
}
