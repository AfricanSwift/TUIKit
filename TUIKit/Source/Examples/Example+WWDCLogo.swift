//
//          File:   Example+WWDCLogo.swift
//    Created by:   African Swift

import Foundation

// MARK: -
// MARK: Demo & draw -
public struct Example
{
  public struct WWDC
  {
    public static func demo()
    {
      Ansi.Set.cursorOff().stdout()
      let borderColor = Ansi.Color.Foreground.white()
        + Ansi.Color.Background.color256(index: 236)
      let backgroundColor = Ansi.Color.Background.color256(index: 232)
      var view = TUIView(
        x: 5, y: 2, width: 106, height: 160,
        border: .halfblock, borderColor: borderColor,
        backgroundColor: backgroundColor)
      WWDC.logoWWDC(view: &view)
      WWDC.richText(view: &view)
      Ansi.Set.cursorOn().stdout()
      Ansi.resetAll().stdout()
    }
    
    private static func draw(view: inout TUIView)
    {
      let renderparm = TUIRenderParameter(
        colorspace: .foreground256,
        composite: .first,
        style: .block)
      Ansi.Cursor.position(
        row: view.origin.y.toInt(),
        column: view.origin.x.toInt()).stdout()
      view.draw(atOrigin: true, parameters: renderparm)
    }
  }
}

// MARK: -
// MARK: WWDC logo example -
public extension Example.WWDC
{
  internal static func generateRandomColor() -> Ansi
  {
    let limit = 0.3
    let r = arc4random_uniform(255).toDouble() / 255
    let g = arc4random_uniform(255).toDouble() / 255
    let b = arc4random_uniform(255).toDouble() / 255
    
    func brightenColor(
      _ red: Double,
      green: Double,
      blue: Double) -> (r: Double, g: Double, b: Double)
    {
      return (r: r <= limit ? r + 0.2 : r,
              g: g <= limit ? g + 0.2 : g,
              b: b <= limit ? b + 0.2 : b)
    }
    let part = brightenColor(r, green: g, blue: b)
    let color = Ansi.Color(red: part.r, green: part.g, blue: part.b, alpha: 1)
    return color.foreground256()
  }

  private static func logoWWDC(view: inout TUIView)
  {
    let path = "wwdc16_logo"
    guard var logoWWDC16 = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
      else { exit(EXIT_FAILURE) }
    let logoparts = [
      "let", "do", "var", "as", "for", "try", "\\(", "\\)", "=", "\\*", "#", ":",
      "~", "in", "@", "/", "\\+", "if", "\\{", "\\}", "<", ">", "_",
      "\\]", "\"", "\\.", "OCR of Apple WWDC 2016 Logo"]
    let partsColors = logoparts.map { ($0, generateRandomColor()) }
    for part in partsColors
    {
      logoWWDC16 = logoWWDC16.replacingOccurrences(
        of: part.0,
        with: part.1.toString() + part.0,
        options: .caseInsensitiveSearch)
    }
    let lines = logoWWDC16.characters
      .split(separator: "\n", omittingEmptySubsequences: false)
      .map { String($0) }
    for index in lines.indices
    {
      view.drawAnsiText(x: 0, y: index, text: lines[index])
    }
    
    draw(view: &view)
    Thread.sleep(forTimeInterval: 1)
    dissolveLogo(view: &view)
  }
  
  private static func dissolveLogo(view: inout TUIView, interval: Double = 0.03)
  {
    let positions = view.activeIndex.sorted { (_, _) in arc4random() < arc4random() }
    var updateCount = 0
    for pos in positions
    {
      view.drawAnsiCharacter(x: pos.x, y: pos.y, character: " ", ansi: "")
      updateCount += 1
      if updateCount % 100 == 0
      {
        draw(view: &view)
        Thread.sleep(forTimeInterval: interval)
      }
    }
    draw(view: &view)
  }
}

// MARK: -
// MARK: Rich text example -
public extension Example.WWDC
{
  private static func richText(view: inout TUIView)
  {
    typealias AColor = Ansi.Color.Choices
    let color = (
      variable: AColor.rgb256(255, 255, 255),
      keyword: AColor.rgb256(0, 156, 143),
      structs: AColor.rgb256(126, 49, 137),
      value: AColor.rgb256(124, 120, 182),
      method: AColor.rgb256(76, 176, 77)
    )
    
    var coloredCode = "let ".attribute(.bold).foreground(color.keyword).attribute(.inverse) +
      "WWDC = ".foreground(color.variable).attribute(.inverseoff)
    coloredCode += "2016".foreground(color.value).attribute(.underline) +
      ".commence()".foreground(color.method).attribute(.underlineoff).attribute(.blinkslow) +
      ".".attribute(.reset)
    
    view.drawAnsiText(
      x: view.size.character.width.toInt() / 2 - 13,
      y: view.size.character.height.toInt() / 4,
      text: coloredCode)
    draw(view: &view)
  }
}
