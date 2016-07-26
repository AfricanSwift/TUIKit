//
//          File:   TUIRender.swift
//    Created by:   African Swift

import Darwin


/// Unicode Render Style
/// - **drawille**: Braille character rendering
/// - **short**: Short ASCII ramp (paulbourke.net) using color
/// - **short2**: Short ASCII ramp (iJoshSmith) using color
/// - **long**: Long ASCII ramp (www.ludd.luth.se) using color
/// - **ditherShort**: Short ASCII ramp using braille value
/// - **ditherLong**: Long ASCII ramp using braille value
/// - **block**: Block ramp using braille value
/// - **block2**: Block ramp using color & braille value
public enum RenderStyle
{
  case drawille, short, short2, long, ditherShort, ditherLong, block, block2, block3
  
  // http://paulbourke.net/dataformats/asciiart/
  private static let shortColorRamp = " .:-=+*#%@"
    .characters.map { String($0) }
  
  // Calculated by iJoshSmith here:
  // https://github.com/ijoshsmith/swift-ascii-art
  private static let shortColorRamp2 = "@8&5$%A#J7f+/!^;-,\'. "
    .characters.reversed().map { String($0) }
  
  // http://www.ludd.luth.se/~vk/pics/ascii/junkyard/techstuff/FAQ/FAQ_Jorn_Barger.html */
  private static let longColorRampData = " .'`,^:" +
    String(UnicodeScalar(34))
    + String(UnicodeScalar(59)) + "~-_+<>i!lI?/"
    + String(UnicodeScalar(92)) +
  "|()1{}[]rcvunxzjftLCJUYXZO0Qoahkbdpqwm*WMB8&%$#@"
  
  private static let longColorRamp = longColorRampData
    .characters.map { String($0) }
  
  private static let blockColorRamp = " ░▒▓█"
    .characters.map { String($0) }
  
  private static let blockBlackRamp = [
    165 : 0x2588,   // FULL BLOCK
    156 : 0x2586,   // LOWER THREE QUARTERS BLOCK
    144 : 0x2584,   // LOWER HALF BLOCK
    120 : 0x2581,   // LOWER ONE EIGHTH BLOCK
    24  : 0x2581,   // LOWER ONE EIGHTH BLOCK
    47  : 0x258C,   // LEFT HALF BLOCK
    118 : 0x2590,   // RIGHT HALF BLOCK
    21  : 0x2580,   // UPPER HALF BLOCK
    9   : 0x2594,   // UPPER ONE EIGHTH BLOCK
    12  : 0x2594,   // UPPER ONE EIGHTH BLOCK
  ]
  
  private static let blockBlackDot = 0x2591
  
  private static let blockWhiteRamp = [
    0x2593,     // DARK SHADE
    0x2592,     // MEDIUM SHADE
    0x2591     // LIGHT SHADE
  ]
  
  /// ASCII color ramp character based on NSColor grayscale intensity
  ///
  /// - parameters:
  ///   - color: Ansi.Color
  ///   - ramp: [String]
  /// - returns: Ansi
  private static func asciiRamp(
    color: Ansi.Color,
          ramp: [String]) -> Ansi
  {
    let intensity = color.grayscaleIntensity()
    return Ansi(ramp[Int(Double(ramp.count - 1) * intensity)])
  }
  
  /// ASCII color ramp character based on Braille value / Braille max value (0xFF)
  ///
  /// - parameters:
  ///   - character: TUICharacter
  ///   - ramp: [String]
  /// - returns: Ansi
  private static func asciiBrailleRamp(
    character: TUICharacter,
              ramp: [String]) -> Ansi
  {
    let intensity = Double(character.pixelBase) / 255.0
    return Ansi(ramp[Int(Double(ramp.count - 1) * intensity)])
  }
  
  /// Block2 Ramp
  ///
  /// - parameters:
  ///   - color: Ansi.Color
  ///   - character: TUICharacter
  /// - returns: Ansi
  private static func block2Ramp(
    color: Ansi.Color,
          character: TUICharacter) -> Ansi
  {
    let grayscale = color.grayscaleIntensity()
    if grayscale > 0.5
    {
      let ramp = RenderStyle.blockWhiteRamp
      let intensity = (1.0 - color.grayscaleIntensity()) / 0.5
      return Ansi(String(UnicodeScalar(ramp[Int(Double(ramp.count - 1) * intensity)])))
    }
    else // Black
    {
      guard let rampValue = RenderStyle.blockBlackRamp[character.pixelBase] else
      {
        return Ansi(String(UnicodeScalar(RenderStyle.blockBlackDot)))
      }
      return Ansi(String(UnicodeScalar(rampValue)))
    }
  }
  
  /// Block3 Ramp
  ///
  /// - parameters:
  ///   - color: Ansi.Color
  ///   - character: TUICharacter
  /// - returns: Ansi
  private static func block3Ramp(
    color: Ansi.Color,
    character: TUICharacter) -> Ansi
  {
    return Ansi("△")
  }
  
  /// rampGen
  ///
  /// - parameters:
  ///   - character: TUICharacter
  ///   - color: Ansi.Color
  /// - returns: Ansi
  internal func rampGen(
    character: TUICharacter,
              color: Ansi.Color) -> Ansi
  {
    switch self
    {
    case .drawille:
      return Ansi(String(character.value))
    case .short:
      return RenderStyle.asciiRamp(
        color: color,
        ramp: RenderStyle.shortColorRamp)
    case .short2:
      return RenderStyle.asciiRamp(
        color: color,
        ramp: RenderStyle.shortColorRamp2)
    case .long:
      return RenderStyle.asciiRamp(
        color: color,
        ramp: RenderStyle.longColorRamp)
    case .block:
      return RenderStyle.asciiBrailleRamp(
        character: character,
        ramp: RenderStyle.blockColorRamp)
    case .block2:
      return RenderStyle.block2Ramp(
        color: color,
        character: character)
    case .block3:
      return RenderStyle.block3Ramp(
        color: color,
        character: character)
    case .ditherShort:
      return RenderStyle.asciiBrailleRamp(
        character: character,
        ramp: RenderStyle.shortColorRamp)
    case .ditherLong:
      return RenderStyle.asciiBrailleRamp(
        character: character,
        ramp: RenderStyle.longColorRamp)
    }
  }
}

/// Ansi Color Space
public enum TUIColorSpace
{
  case mono, foreground16, foreground256, foregroundRGB
  case background16, background256, backgroundRGB
}

/// Ansi Color Selection
public enum TUIColorComposite
{
  case first, average
}

/// Render Parameters
public struct TUIRenderParameter
{
  internal private(set) var colorspace: TUIColorSpace
  internal private(set) var composite: TUIColorComposite
  internal private(set) var style: RenderStyle
  
  public init(colorspace: TUIColorSpace = .foreground256,
                composite: TUIColorComposite = .first,
                style: RenderStyle = .drawille)
  {
    self.colorspace = colorspace
    self.composite = composite
    self.style = style
  }
}

// MARK: -
// MARK: RenderParameter Equatable -
extension TUIRenderParameter: Equatable { }

/// Equatable Operator for RenderParameter
///
/// - parameters:
///   - lhs: TUICharacter.RenderParameter
///   - rhs: TUICharacter.RenderParameter
/// - returns: Bool, True if lhs and rhs are equivalent
public func == (
  lhs: TUIRenderParameter,
  rhs: TUIRenderParameter) -> Bool
{
  return lhs.colorspace == rhs.colorspace
    && lhs.composite == rhs.composite
    && lhs.style == rhs.style
}
