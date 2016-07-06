//
//          File:   Example+WWDCLogo.swift
//    Created by:   African Swift

import Foundation

public struct Example_WWDCLogo
{
  internal static func generateRandomColor() -> Ansi
  {
    let limit = 0.1
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
  
  public static func demo()
  {
    
    Ansi.Set.cursorOff().stdout()
    var view = TUIView(x: 0, y: 0, width: 140, height: 160, border: .single)
    
    func draw()
    {
      let renderparm = TUIRenderParameter(
        colorspace: .foreground256,
        composite: .first,
        style: .block)
      Ansi.Cursor.position(
        row: view.origin.y.toInt(),
        column: view.origin.x.toInt()).stdout()
//      print(view.draw(parameters: renderparm).map { $0.toString() }.joined(separator: "\n"))
    }
    
    let path = "wwdc16_logo"
    guard var logoWWDC16 = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
      else { exit(1) }
    
    let logoparts = [
      "let", "do", "var", "as", "for", "try", "\\(", "\\)", "=", "\\*", "#", ":",
      "~", "in", "@", "/", "\\+", "if", "\\{", "\\}", "<", ">", "_",
      "\\]", "\"", "\\.", "OCR of Apple WWDC 2016 Logo"]
    let partsColors = logoparts.map { ($0, Example_WWDCLogo.generateRandomColor()) }
    for part in partsColors
    {
      logoWWDC16 = logoWWDC16.replacingOccurrences(
        of: part.0,
        with: part.1.toString() + part.0,
        options: .caseInsensitiveSearch)
    }
    
    let lines = logoWWDC16.characters.split(separator: "\n", omittingEmptySubsequences: false).map { String($0) }
    for index in lines.indices
    {
      view.drawAnsiText(x: 0, y: index, text: lines[index])
    }
    
    draw()
    Thread.sleep(forTimeInterval: 1)
    
    let positions = view.activeIndex.sorted { (_, _) in arc4random() < arc4random() }
    var updateCount = 0
    for pos in positions
    {
      view.drawAnsiCharacter(x: pos.x, y: pos.y, character: " ", ansi: "")
      updateCount += 1
      if updateCount % 100 == 0
      {
        draw()
        Thread.sleep(forTimeInterval: 0.01)
      }
    }
    draw()

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
    draw()
    
    Ansi.Set.cursorOn().stdout()
    Ansi.resetAll().stdout()
  }
  
}
