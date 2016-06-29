
//          File:   TUIView.swift
//    Created by:   African Swift

import Darwin

public struct TUIView
{
  public private(set) var origin: TUIPoint
  public private(set) var size: TUIViewSize
  private var invalidate: Bool
  private let border: TUIBorders
  private var parent: TUIScreen?
  private var buffer: [[TUICharacter]]
  
  /// Flat array of active buffer cell indexes
  internal var activeIndex: [(x: Int, y: Int, type: TUICharacter.Category)] {
    let rows = self.size.character.height.toInt()
    let columns = self.size.character.width.toInt()
    let viewArray = (0..<rows)
      .map { r in (0..<columns)
        .map { c in (x: c, y: r, type: self.buffer[r][c].type) } }
    return viewArray
      .flatMap { $0 }
      .filter { $0.type != .none }
  }
  
  /// Calculate Sizes (Character and Pixel)
  ///
  /// - parameter width: Int
  /// - parameter height: Int
  /// - returns: Tuple (character: TUISize, pixel: TUISize)
  private static func calcSize(width: Int, height: Int) ->
    (character: TUISize, pixel: TUISize)
  {
    let w = Int(ceil(Double(width) / 2.0))
    let h = Int(ceil(Double(height) / 4.0))
    return (character: TUISize(width: w, height: h),
            pixel: TUISize(width: w * 2, height: h * 4))
  }
  
  /// Default initializer
  ///
  /// - parameter x: Int
  /// - parameter y: Int
  /// - parameter width: Int
  /// - parameter height: Int
  /// - parameter border: TUIBorders
  public init(x: Int, y: Int, width: Int, height: Int, border: TUIBorders)
  {
    self.origin = TUIPoint(x: x, y: y)
    let size = TUIView.calcSize(width: width, height: height)
    self.size = TUIViewSize(pixel: size.pixel, character: size.character)
    self.invalidate = true
    self.border = border
    self.buffer = init2D(
      dimension1: self.size.character.height.toInt(),
      dimension2: self.size.character.width.toInt(),
      repeatedValue: TUICharacter(
        character: " ",
        color: Ansi.Color(red: 0, green: 0, blue: 0, alpha: 0)))
  }
}

// MARK: - View Adjustments -
public extension TUIView
{
  /// Move View
  ///
  /// - parameter x: Int
  /// - parameter y: Int
  public mutating func move(x: Int, y: Int)
  {
    self.origin = TUIPoint(x: x, y: y)
    self.invalidate = true
  }
  
  // TODO: consider adding closure to resize i.e. to allow updates before the paint
  
  /// Resize View
  ///
  /// - parameter width: Int
  /// - parameter height: Int
  public mutating func resize(width: Int, height: Int)
  {
    self = TUIView.init(
      x: self.origin.x.toInt(),
      y: self.origin.y.toInt(),
      width: width,
      height: height,
      border: self.border)
    self.invalidate = false
  }
  
  // TODO: EValuate cost for this way of clearing vs. looping and switching everything off.
  
  /// Clear everything
  public mutating func clear()
  {
    self.buffer = init2D(
      dimension1: self.size.character.height.toInt(),
      dimension2: self.size.character.width.toInt(),
      repeatedValue: TUICharacter(
        character: " ",
        color: Ansi.Color(red: 0, green: 0, blue: 0, alpha: 0)))
    self.invalidate = true
  }
}

// MARK: - Render & Draw -
public extension TUIView
{
  /// Draw Pixel
  ///
  /// - parameter parameters: TUIRenderParameter
  /// - returns: [Ansi]
  public mutating func draw(
    parameters: TUIRenderParameter = TUIRenderParameter()) -> [Ansi]
  {

    var result = [Ansi]()
    for y in self.buffer.indices
    {
      var xbuffer = Ansi("")
      for x in self.buffer[0].indices
      {
        xbuffer += self.buffer[y][x].toAnsi(parameters: parameters)
      }
      result.append(xbuffer.compress())
    }
    return result
  }
  
  /// Draw Pixel
  ///
  /// - parameter x: Double
  /// - parameter y: Double
  /// - parameter color: Ansi.Color
  public mutating func drawPixel(x: Double, y: Double, color: Ansi.Color)
  {
    let char = (x: round(x).toInt() / 2, y: round(y).toInt() / 4)
    self.buffer[char.y][char.x].setPixel(x: x, y: y, action: .on, color: color)
    self.invalidate = true
  }
  
  /// Draw Character
  ///
  /// - parameter x: Int
  /// - parameter y: Int
  /// - parameter character: Character
  /// - parameter color: Ansi.Color
  public mutating func drawCharacter(
    x: Int, y: Int, character: Character, color: Ansi.Color)
  {
    self.buffer[y][x].setCharacter(character: character, color: color)
    self.invalidate = true
  }
  
  /// Draw Ansi Character
  ///
  /// - parameter x: Int
  /// - parameter y: Int
  /// - parameter character: Character
  /// - parameter ansi: Ansi
  public mutating func drawAnsiCharacter(
    x: Int, y: Int, character: Character, ansi: Ansi)
  {
    self.buffer[y][x].setAnsiCharacter(character: character, ansi: ansi)
    self.invalidate = true
  }
  
  /// Draw Text
  ///
  /// - parameter x: Int
  /// - parameter y: Int
  /// - parameter text: String
  /// - parameter color: Ansi.Color
  /// - parameter linewrap: Bool
  public mutating func drawText(
    x: Int, y: Int, text: String, color: Ansi.Color, linewrap: Bool = false)
  {
    let char = text.characters
    var position = (x: x, y: y)
    var index = 0
    for i in char.indices
    {
      if position.x + index > self.size.character.width.toInt() - 1 && !linewrap
      {
        break
      }
      else if position.x + index > self.size.character.width.toInt() - 1 && linewrap
      {
        if position.y + 1 > self.size.character.height.toInt() - 1
        {
          break
        }
        index = 0
        position.y += 1
        position.x = 0
      }
      self.buffer[position.y][position.x + index]
        .setCharacter(character: char[i], color: color)
      index += 1
    }
  }
  
  /// Limited to SGR Control Codes (Attributes & Colors)
  ///
  /// - parameter x: Int
  /// - parameter y: Int
  /// - parameter text: String
  /// - parameter linewrap: Bool
  public mutating func drawAnsiText(
    x: Int, y: Int, text: String, linewrap: Bool = false)
  {
    guard let tokens = try? Ansi.tokenizer(input: Ansi(text)) else {
      return
    }
    
    let position = (x: x, y: y)
    var xoffset = 0
    var carryOverAnsi = Ansi("")
    for t in tokens
    {
      if t.function == "<Uncompressable>" // Leading whitespace
      {
        let char = t.text.characters
        for i in char.indices
        {
          self.buffer[position.y][position.x + xoffset]
            .setAnsiCharacter(character: char[i], ansi: "")
          xoffset += 1
        }
        continue
      }
      
      if t.function.contains("m") && t.suffix.characters.count == 0
      {
        carryOverAnsi += Ansi(Ansi.C1.CSI + t.parameter + t.function)
      }

      let char = t.suffix.characters
      var isFirstChar = true
      for i in char.indices
      {
        let ansi = isFirstChar ? Ansi(Ansi.C1.CSI + t.parameter + t.function) + carryOverAnsi : ""
        carryOverAnsi = Ansi("")
        self.buffer[position.y][position.x + xoffset]
          .setAnsiCharacter(character: char[i], ansi: ansi)
        xoffset += 1
        isFirstChar = false
      }
    }
  }
}
