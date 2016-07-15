//
//          File:   Example+Figfont.swift
//    Created by:   African Swift

import Foundation

public extension Example
{
  public struct Figfont
  {
    public static func demo() throws
    {
      Ansi.Cursor.position().stdout()
      _ = try? renderWhimsy()
      
      print()
      
      _ = try? renderSlantRelief()
      
      print()
      
      _ = try? renderAnsiShadow()
      
      print("".resetall)
    }
  }
}

public extension Example.Figfont
{
  /// ````
  ///    ,d8888b  d8,             ,d8888b
  ///    88P'    `8P              88P'                        d8P
  /// d888888P                 d888888P                    d888888P
  ///   ?88'      88b d888b8b    ?88'     d8888b   88bd88b   ?88'
  ///   88P       88Pd8P' ?88    88P     d8P' ?88  88P' ?8b  88P
  ///  d88       d88 88b  ,88b  d88      88b  d88 d88   88P  88b
  /// d88'      d88' `?88P'`88bd88'      `?8888P'd88'   88b  `?8b
  ///                       )88
  ///                      ,88P
  ///                  `?8888P
  /// ````
  private static func renderWhimsy() throws
  {
    let path = "Whimsy.flf"
    guard let fontWhimsy = try Figlet(fontFile: path) else {
      exit(1)
    }
    
    for line in fontWhimsy.drawText(text: "Figfont")
    {
      print(Example.WWDC.generateRandomColor() + line)
    }
  }
}

public extension Example.Figfont
{

  /// ````
  /// __/\\\\\\\\\\\\\\\_________________________/\\\________/\\\_______________________
  ///  _\///////\\\/////_________________________\/\\\_____/\\\//________________________
  ///   _______\/\\\________________________/\\\__\/\\\__/\\\//_______/\\\______/\\\______
  ///    _______\/\\\_________/\\\____/\\\__\///___\/\\\\\\//\\\______\///____/\\\\\\\\\\\_
  ///     _______\/\\\________\/\\\___\/\\\___/\\\__\/\\\//_\//\\\______/\\\__\////\\\////__
  ///      _______\/\\\________\/\\\___\/\\\__\/\\\__\/\\\____\//\\\____\/\\\_____\/\\\______
  ///       _______\/\\\________\/\\\___\/\\\__\/\\\__\/\\\_____\//\\\___\/\\\_____\/\\\_/\\__
  ///        _______\/\\\________\//\\\\\\\\\___\/\\\__\/\\\______\//\\\__\/\\\_____\//\\\\\___
  ///         _______\///__________\/////////____\///___\///________\///___\///_______\/////____
  /// ````
  private static func renderSlantRelief() throws
  {
    let path3D = "Slant Relief.flf"
    guard let font3D = try Figlet(fontFile: path3D) else {
      exit(1)
    }
    let backColor = Ansi.Color.Foreground.color256(index: 17)
    let frontColor = Ansi.Color.Foreground.color256(index: 202)
    let backChar = Character("_")
    
    for line in font3D.drawText(text: "TuiKit")
    {
      var firstNonSpaceFound = false
      var lastChar = Character(" ")
      let result = line.characters.flatMap { c -> String? in
        // Kerning of 3D Font (strip whitespace)
        if !firstNonSpaceFound && c != Character(" ") { firstNonSpaceFound = true }
        if c == Character(" ") && firstNonSpaceFound { return nil }
        
        // Color of 3D Font
        if c == backChar && lastChar != backChar
        {
          lastChar = c
          return backColor.toString() + String(c)
        }
        else if c != backChar && lastChar == backChar
        {
          lastChar = c
          return frontColor.toString() + String(c)
        }
        return String(c)
        }.joined(separator: "")
      
      print(result)
    }
  }
}

public extension Example.Figfont
{
  /// ````
  /// ████████╗██╗   ██╗██╗██╗  ██╗██╗████████╗
  /// ╚══██╔══╝██║   ██║██║██║ ██╔╝██║╚══██╔══╝
  ///    ██║   ██║   ██║██║█████╔╝ ██║   ██║
  ///    ██║   ██║   ██║██║██╔═██╗ ██║   ██║
  ///    ██║   ╚██████╔╝██║██║  ██╗██║   ██║
  ///    ╚═╝    ╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝   ╚═╝
  /// ````
  private static func renderAnsiShadow() throws
  {
    let pathShadow = "ANSI Shadow.flf"
    guard let fontShadow = try Figlet(fontFile: pathShadow) else {
      exit(1)
    }
    
    let backColor = Ansi.Color.Foreground.brown()
    let frontColor = Ansi.Color.Foreground.red()
    let foreChar = Character("█")
    
    for line in fontShadow.drawText(text: "TuiKit")
    {
      var lastChar = Character(" ")
      let result = line.characters.flatMap { c -> String? in
        
        // Color of Shadow Font
        if c == foreChar && lastChar != foreChar
        {
          lastChar = c
          return frontColor.toString() + String(c)
        }
        else if c != foreChar && lastChar == foreChar
        {
          lastChar = c
          return backColor.toString() + String(c)
        }
        return String(c)
        }.joined(separator: "")
      
      print(result)
    }
  }
}
