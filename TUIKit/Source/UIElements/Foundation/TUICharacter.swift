//
//          File:   TUICharacter.swift
//    Created by:   African Swift

import Darwin

// MARK: -
// MARK: TUICharacter -
public struct TUICharacter
{
  /// Category
  ///
  /// - pixel: value represents braille pixel
  /// - character: value represents character
  /// - ansi: string ansi codes; similar to character, color emptied.
  internal enum Category
  {
    case pixel, character, ansi, none
  }
  
  /// Pixel Type Enum (pixel or character)
  internal private(set) var type: Category
  
  /// Pixel Color Array
  private var color: [Ansi.Color] = []
  
  /// Ansi Control Codes when type = .ansi
  /// - String extensions for Ansi Color + Attributes
  private var ansi: Ansi
  
  /// Pixel Character
  internal private(set) var value: Character
  
  /// Pixel Base: 0-255 (cached base pixel value)
  internal private(set) var pixelBase: Int
  
  /// Flag indicating if the cache is invalid
  /// Controls rendering
  private var invalidate: Bool
  
  /// Cache (rendered Ansi)
  private var cache: Ansi
  
  /// Last render parameter values
  private var lastRenderParameters: TUIRenderParameter
  
  /// renderDefault (used in toAnsi())
  private static let renderDefault = TUIRenderParameter()
  
  /// Default init
  internal init()
  {
    self.type = .pixel
    self.ansi = ""
    self.value = Character(UnicodeScalar(braille.base))
    self.pixelBase = 0
    self.cache = ""
    self.invalidate = false
    self.lastRenderParameters = TUIRenderParameter()
  }
  
  /// Convenience init for a character
  ///
  /// - parameter character: Character
  /// - parameter color: Ansi.Color
  internal init(character: Character, color: Ansi.Color)
  {
    self.init()
    self.setCharacter(character: character, color: color)
    self.invalidate = true
  }
  
  /// Convenience init for a pixel (braille)
  ///
  /// - parameters:
  ///   - x: Double
  ///   - y: Double
  ///   - action: SetAction (.on, .off, .invert)
  ///   - color: Ansi.Color
  internal init(x: Double, y: Double, action: SetAction, color: Ansi.Color)
  {
    self.init()
    self.setPixel(x: x, y: y, action: action, color: color)
  }
  
  /// ### Braille Patterns
  /// [Braille Patterns](https://en.wikipedia.org/wiki/Braille_Patterns)
  ///
  /// ```
  ///    Pixel    Hex
  ///    Index    values
  ///    ┌───┐    ┌─────────┐
  ///    │1 4│    │0x01 0x08│
  ///    │2 5│    │0x02 0x10│
  ///    │3 6│    │0x04 0x20│
  ///    │7 8│    │0x40 0x80│
  ///    └───┘    └─────────┘
  private let braille = (
    pixel: [
      [0x01, 0x08],
      [0x02, 0x10],
      [0x04, 0x20],
      [0x40, 0x80]],
    base: 0x2800)
}

// MARK: -
// MARK: setPixel and setCharacter Methods  -
public extension TUICharacter
{
  /// Pixel Set Action
  ///
  /// - on: turn pixel on
  /// - off: turn pixel off
  /// - invert: invert pixel
  public enum SetAction
  {
    case on, off, invert
  }
  
  
  // FIXME: Strange behavior in TUIView render for both action == .invert or .off
  
  /// Set Pixel
  ///
  /// - parameters:
  ///   - x: Double value
  ///   - y: Double value
  ///   - action: SetAction value
  ///   - color: Ansi.Color value
  internal mutating func setPixel(x: Double, y: Double, action: SetAction, color: Ansi.Color)
  {
    let offset = (x: Int(round(x)) % 2, y: Int(round(y)) % 4)
    let mapHex = braille.pixel[offset.y][offset.x]
    if self.type == .character
    {
      self.color.removeAll()
    }
    
    switch action {
    case .on:
      self.pixelBase |= mapHex
      self.color.append(color)
    case .off:
      self.pixelBase &= ~mapHex
      if self.color.count > 0
      {
        self.color.removeLast()
      }
    case .invert:
      if self.pixelBase & mapHex != 0
      {
        self.pixelBase &= ~mapHex
        if self.color.count > 0
        {
          self.color.removeLast()
        }
      }
      else
      {
        self.pixelBase |= mapHex
        self.color.append(color)
      }
      
//      self.pixelBase ^= mapHex
//      if (self.pixelBase & mapHex) == 0
//      {
//        self.color.append(color)
//      }
    }
    
    // set to .none when all pixels are off
    if self.pixelBase == 0
    {
      self.color.removeAll()
      self.type = .none
      self.value = Character(UnicodeScalar(0))
    }
    else
    {
      self.type = .pixel
      self.value = Character(UnicodeScalar(self.pixelBase + braille.base))
    }
    self.invalidate = true
  }
  
  /// Set Character
  ///
  /// - parameters:
  ///   - character: Character value
  ///   - color: Ansi.Color value
  internal mutating func setCharacter(character: Character, color: Ansi.Color)
  {
    if character == Character(" ")
    {
      self.setNone()
      return
    }
    self.color.removeAll()
    self.type = .character
    self.value = character
    self.color.append(color)
    self.pixelBase = 0
    self.invalidate = true
  }
  
  /// Set Ansi Character
  ///
  /// - parameters:
  ///   - character: Character value
  ///   - ansi: Ansi value
  internal mutating func setAnsiCharacter(character: Character, ansi: Ansi)
  {
    if character == Character(" ") && ansi == Ansi("")
    {
      self.setNone()
      return
    }
    self.color.removeAll()
    self.type = .ansi
    self.value = character
    self.ansi = ansi
    self.pixelBase = 0
    self.invalidate = true
  }
  
  /// Set Character to None
  internal mutating func setNone()
  {
    self.color.removeAll()
    self.type = .none
    self.value = Character(UnicodeScalar(0))
    self.ansi = ""
    self.pixelBase = 0
    self.invalidate = true
  }
}

// MARK: -
// MARK: ColorComposite and ColorSpace -
private extension TUICharacter
{
  /// First Color
  ///
  /// - returns: Ansi.Color?
  private func firstColor() -> Ansi.Color?
  {
    return self.color.first
  }
  
  /// Color Array sorted by Index
  ///
  /// - returns: [Ansi.Color]
  private func colorArray() -> [Ansi.Color]
  {
    return self.color
  }
  
  /// Average of Colors
  ///
  /// - returns: Ansi.Color?
  private func averageColor() -> Ansi.Color?
  {
    guard let initial = self.firstColor() else { return nil }
    return self.colorArray().reduce(initial) { $0.averageWith(color: $1) }
  }
  
  /// render Ansi.Color Composite
  ///
  /// - parameters:
  ///   - composite: TUIColorComposite
  /// - returns: Ansi.Color
  private func renderColor(composite: TUIColorComposite) -> Ansi.Color?
  {
    switch composite
    {
    case .first:
      return self.firstColor()
    case .average:
      return self.averageColor()
    }
  }
  
  /// colorToAnsi: Ansi.Color control codes
  ///
  /// - parameters:
  ///   - colorspace: TUIColorSpace
  ///   - color: Ansi.Color
  /// - returns: Ansi
  private func colorToAnsi(colorspace: TUIColorSpace, color: Ansi.Color) -> Ansi
  {
    switch colorspace
    {
    case .mono:
      return Ansi("")
    case .foreground16:
      return color.foreground16()
    case .foreground256:
      return color.foreground256()
    case .foregroundRGB:
      return color.foregroundRGB()
    case .background16:
      return color.background16()
    case .background256:
      return color.background256()
    case .backgroundRGB:
      return color.backgroundRGB()
    }
  }
}

// MARK: - Render Methpds -
internal extension TUICharacter
{
  /// Ansi Render
  ///
  /// - parameters:
  ///   - colorspace: ColorSpace
  ///   - composite: ColorComposite
  ///   - style: RenderStyle
  /// - returns: Ansi
  private func render(
    colorspace: TUIColorSpace = .foreground256,
    composite: TUIColorComposite = .first,
    style: RenderStyle = .drawille) -> Ansi
  {
    
    if self.type == .ansi
    {
      return self.ansi + self.value
    }
    
    if self.type == .none
    {
      return " "
    }

    guard let colorComposite = renderColor(composite: composite) else
    {
      return Ansi("")
    }
    
    let ansiColor = colorToAnsi(colorspace: colorspace, color: colorComposite)
    
    return self.type == .character ? ansiColor + self.value :
      ansiColor + style.rampGen(character: self, color: colorComposite)
  }
  
  /// TUICharacter to Ansi Render
  ///
  /// Lazy Render only on cache invalidation and/or change of prior render parameters.
  ///
  /// __Default Render Parameters__
  ///
  /// ````
  ///     RenderParameter(
  ///       colorspace: ColorSpace = .foreground256,
  ///       composite: ColorComposite = .first,
  ///       style: RenderStyle = .drawille)
  /// ````
  ///
  /// - parameters:
  ///   - parameters: RenderParameters (Optional)
  /// - returns: Ansi
  internal mutating func toAnsi(
    parameters: TUIRenderParameter = TUICharacter.renderDefault) -> Ansi
  {
    if self.invalidate || parameters != self.lastRenderParameters
      && parameters != TUICharacter.renderDefault
    {
      self.cache = self.render(
        colorspace: parameters.colorspace,
        composite: parameters.composite,
        style: parameters.style)
      self.invalidate = false
      self.lastRenderParameters = parameters
    }
    return self.cache
  }
}
