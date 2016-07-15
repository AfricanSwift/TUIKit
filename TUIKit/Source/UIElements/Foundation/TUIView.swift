//
//          File:   TUIView.swift
//    Created by:   African Swift

import Darwin

// MARK: -
// MARK: TUIView -
public struct TUIView
{
  public private(set) var origin: TUIPoint
  public private(set) var size: TUIWindowSize
  
  /// Flag indicating if the cache is invalid
  /// Controls rendering
  internal var invalidate: Bool
  
  // Optional TUIBorder for the view
  public let border: TUIBorder
  private var buffer: [[TUICharacter]]
  private let borderColor: Ansi
  public let backgroundColor: Ansi
  
  /// View cache (rendered Ansi)
  /// Used for direct view draw, unused with TUIScreen
  public var cache: [Ansi]
  
  /// Border parts
  internal var borderParts: (top: Ansi, bottom: Ansi, left: Ansi, right: Ansi) {
    let color = self.borderColor != "" ? self.borderColor : Ansi.Color.resetAll()
    guard let box = border.toTUIBox() else {
      return ("", "", "", "")
    }
    let width = Int(self.size.character.width)
    let topline = String(repeating: box.horizontal.top, count: width)
    let bottomline = String(repeating: box.horizontal.bottom, count: width)
    return
      (Ansi("\(color)\(box.top.left)\(topline)\(box.top.right)\(Ansi.Color.resetAll())"),
       Ansi("\(color)\(box.bottom.left)\(bottomline)\(box.bottom.right)\(Ansi.Color.resetAll())"),
       Ansi("\(color)\(box.vertical.left)\(Ansi.Color.resetAll())"),
       Ansi("\(color)\(box.vertical.right)\(Ansi.Color.resetAll())"))
  }
  
  /// Flat array of active buffer cell indexes
  internal var activeIndex: [(x: Int, y: Int, type: TUICharacter.Category)] {
    let rows = Int(self.size.character.height)
    let columns = Int(self.size.character.width)
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
  public init(x: Int, y: Int, width: Int, height: Int, border: TUIBorder = .single,
              borderColor: Ansi = "", backgroundColor: Ansi = "")
  {
    self.origin = TUIPoint(x: x, y: y)
    self.size = TUIWindowSize(width: width, height: height)
    self.invalidate = true
    self.border = border
    self.buffer = init2D(
      d1: Int(self.size.character.height),
      d2: Int(self.size.character.width),
      repeatedValue: TUICharacter(
        character: " ",
        color: Ansi.Color(red: 0, green: 0, blue: 0, alpha: 0)))
    self.borderColor = borderColor
    self.backgroundColor = backgroundColor
    
    var cacheSize = Int(self.size.character.height)
    if case .none = border { } else { cacheSize += 2 }
    self.cache = [Ansi](repeating: Ansi(""), count: cacheSize)
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
  }
  
  /// Resize View
  ///
  /// - parameters:
  ///   - width: Int
  ///   - height: Int
  public mutating func resize(width: Int, height: Int)
  {
    self = TUIView.init(
      x: Int(self.origin.x),
      y: Int(self.origin.y),
      width: width,
      height: height,
      border: self.border)
    self.invalidate = false
  }
  
  /// Clear everything
  public mutating func clear()
  {
    self.buffer = init2D(
      d1: Int(self.size.character.height),
      d2: Int(self.size.character.width),
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
  /// Draw
  ///
  /// - parameters:
  ///   - atOrigin: Bool (default = true): controls whether the view is
  ///     drawn at origin or the cursor offset
  ///   - parameters: TUIRenderParameter
  public mutating func draw(
    atOrigin: Bool = false,
    parameters: TUIRenderParameter = TUIRenderParameter())
  {
    if self.invalidate
    {
      render(parameters: parameters)
    }
    
    var y = Int(self.origin.y)
    let x = Int(self.origin.x)
    
    for line in self.cache
    {
      _ = atOrigin ? Ansi.Cursor.position(row: y, column: x).stdout() : ()
      _ = atOrigin ? line.stdout() : (line + "\n").stdout()
      y += 1
    }
    Ansi.resetAll().stdout()
    Ansi.flush()
  }
  
  /// Render view cache
  ///
  /// - parameters:
  ///   - parameters: TUIRenderParameter
  internal mutating func render(parameters: TUIRenderParameter)
  {
    guard self.invalidate else { return }
    
    var hasBorder = true
    if case .none = self.border
    {
      hasBorder = false
    }
    
    let left = hasBorder ? self.borderParts.left : ""
    let right = hasBorder ? self.borderParts.right : ""
    
    if hasBorder
    {
//      self.cache[0] = self.borderParts.top + "\n"
//      self.cache[self.cache.count - 1] = self.borderParts.bottom + "\n"
      self.cache[0] = self.borderParts.top
      self.cache[self.cache.count - 1] = self.borderParts.bottom
    }
    
    let offset = hasBorder ? 1 : 0
    for y in self.buffer.indices
    {
      var lineBuffer = Ansi("")
      for x in self.buffer[0].indices
      {
        lineBuffer += self.buffer[y][x].toAnsi(parameters: parameters)
      }
//      self.cache[y + offset] = (left + self.backgroundColor + lineBuffer + right + "\n")
      self.cache[y + offset] = (left + self.backgroundColor + lineBuffer + right)
    }
    self.invalidate = false
  }
  
  /// Draw Pixel
  ///
  /// - parameters:
  ///   - x: Double
  ///   - y: Double
  ///   - color: Ansi.Color
  public mutating func drawPixel(x: Double, y: Double, color: Ansi.Color)
  {
    let char = (x: Int(round(x)) / 2, y: Int(round(y)) / 4)
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
    let chars = text.characters
    var position = (x: x, y: y)
    var index = 0
    for i in chars.indices
    {
      if position.x + index > Int(self.size.character.width) - 1 && !linewrap
      {
        break
      }
      else if position.x + index > Int(self.size.character.width) - 1 && linewrap
      {
        if position.y + 1 > Int(self.size.character.height) - 1
        {
          break
        }
        index = 0
        position.y += 1
        position.x = 0
      }
      self.buffer[position.y][position.x + index]
        .setCharacter(character: chars[i], color: color)
      index += 1
    }
    self.invalidate = true
  }
  
  
  // FIXME: Crashes when text is longer than view size, drawText has safe guards, this doesn't
  
  /// Limited to SGR Control Codes (Attributes & Colors)
  ///
  /// - parameters:
  ///   - x: Int
  ///   - y: Int
  ///   - text: String
  ///   - linewrap: Bool
  public mutating func drawAnsiText(x: Int, y: Int, text: String, linewrap: Bool = false)
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

      let ans = Ansi(Ansi.C1.CSI + t.parameter + t.function) + carryOverAnsi
      setAnsiText(text: t.suffix, y: y, x: x, xoffset: &xoffset, ansi: ans, linewrap: linewrap)
      
//      let char = t.suffix.characters
//      var isFirstChar = true
//      for i in char.indices
//      {
////        print("====>> ", t.suffix, position.y, position.x + xoffset)
//        let ansi = isFirstChar ? Ansi(Ansi.C1.CSI + t.parameter + t.function) + carryOverAnsi : ""
//        carryOverAnsi = Ansi("")
//        self.buffer[position.y][position.x + xoffset]
//          .setAnsiCharacter(character: char[i], ansi: ansi)
//        xoffset += 1
//        isFirstChar = false
//      }
    }
    self.invalidate = true
  }
  
  private mutating func setAnsiText(text: String, y: Int, x: Int, xoffset: inout Int, ansi: Ansi, linewrap: Bool)
  {
//    print("---> ", text, y, x)
//    var xoffset = 0
    var p = (x: x, y: y)
    var isFirstChar = true
    let chars = text.characters
    
    for index in chars.indices
    {
      guard p.x + xoffset <= Int(self.size.character.width) - 1 && !linewrap else { break }
      self.buffer[p.y][p.x + xoffset]
        .setAnsiCharacter(character: chars[index], ansi: isFirstChar ? ansi : "")
      xoffset += 1
      isFirstChar = false
      if p.x + xoffset > Int(self.size.character.width) - 1 && linewrap
      {
        if p.y + 1 > Int(self.size.character.height) - 1 { break }
        p.x = 0
        p.y += 1
        xoffset = 0
      }
    }
  }
  
}
