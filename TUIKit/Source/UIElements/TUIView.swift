//
//          File:   TUIView.swift
//    Created by:   African Swift

import Darwin

public struct TUIView
{
  public private(set) var origin: TUIPoint
  public private(set) var size: TUIWindowSize
  private var invalidate: Bool
  private let border: TUIBorders
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
  
  /// Default initializer
  ///
  /// - parameters:
  ///   - x: Int
  ///   - y: Int
  ///   - width: Int
  ///   - height: Int
  ///   - border: TUIBorders
  public init(x: Int, y: Int, width: Int, height: Int, border: TUIBorders)
  {
    self.origin = TUIPoint(x: x, y: y)
    self.size = TUIWindowSize(width: width, height: height)
    self.invalidate = true
    self.border = border
    self.buffer = init2D(
      d1: self.size.character.height.toInt(),
      d2: self.size.character.width.toInt(),
      repeatedValue: TUICharacter(
        character: " ",
        color: Ansi.Color(red: 0, green: 0, blue: 0, alpha: 0)))
  }
}

// MARK: -
// MARK: View Adjustments -
public extension TUIView
{
  /// Move View
  ///
  /// - parameters:
  ///   - x: Int
  ///   - y: Int
  public mutating func move(x: Int, y: Int)
  {
    self.origin = TUIPoint(x: x, y: y)
    self.invalidate = true
  }
  
  /// Resize View
  ///
  /// - parameters:
  ///   - width: Int
  ///   - height: Int
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
  
  /// Clear everything
  public mutating func clear()
  {
    self.buffer = init2D(
      d1: self.size.character.height.toInt(),
      d2: self.size.character.width.toInt(),
      repeatedValue: TUICharacter(
        character: " ",
        color: Ansi.Color(red: 0, green: 0, blue: 0, alpha: 0)))
    self.invalidate = true
  }
}

// MARK: -
// MARK: Render & Draw -
public extension TUIView
{
  /// Draw Pixel
  ///
  /// - parameters:
  ///   - parameters: TUIRenderParameter
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
  /// - parameters:
  ///   - x: Double
  ///   - y: Double
  ///   - color: Ansi.Color
  public mutating func drawPixel(x: Double, y: Double, color: Ansi.Color)
  {
    let char = (x: round(x).toInt() / 2, y: round(y).toInt() / 4)
    self.buffer[char.y][char.x].setPixel(x: x, y: y, action: .on, color: color)
    self.invalidate = true
  }
  
  /// Draw Character
  ///
  /// - parameters:
  ///   - x: Int
  ///   - y: Int
  ///   - character: Character
  ///   - color: Ansi.Color
  public mutating func drawCharacter(
    x: Int, y: Int, character: Character, color: Ansi.Color)
  {
    self.buffer[y][x].setCharacter(character: character, color: color)
    self.invalidate = true
  }
  
  /// Draw Ansi Character
  ///
  /// - parameters:
  ///   - x: Int
  ///   - y: Int
  ///   - character: Character
  ///   - ansi: Ansi
  public mutating func drawAnsiCharacter(
    x: Int, y: Int, character: Character, ansi: Ansi)
  {
    self.buffer[y][x].setAnsiCharacter(character: character, ansi: ansi)
    self.invalidate = true
  }
  
  /// Draw Text
  ///
  /// - parameters:
  ///   - x: Int
  ///   - y: Int
  ///   - text: String
  ///   - color: Ansi.Color
  ///   - linewrap: Bool
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
  /// - parameters:
  ///   - x: Int
  ///   - y: Int
  ///   - text: String
  ///   - linewrap: Bool
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
