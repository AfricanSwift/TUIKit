//
//          File:   TUIBorders.swift
//    Created by:   African Swift

import Darwin

// MARK: -
// MARK: TUIBorders -

/// TUI collection of borders to construct view edges, tables, ...
public indirect enum TUIBorder
{
  /// __Standard Borders__
  ///
  /// ````
  /// ┌──┬──┐  ╔══╦══╗  ╒══╤══╕  ╓──╥──╖
  /// │  │  │  ║  ║  ║  │  │  │  ║  ║  ║
  /// ├──┼──┤  ╠══╬══╣  ╞══╪══╡  ╟──╫──╢
  /// │  │  │  ║  ║  ║  │  │  │  ║  ║  ║
  /// └──┴──┘  ╚══╩══╝  ╘══╧══╛  ╙──╨──╜
  /// single   double   double2  double3
  /// ````
  case single, double, double2, double3
  
  /// __Block Borders__
  ///
  /// ````
  /// ███████   ▓▓▓▓▓▓▓   ░░░░░░░   ▛▀▀▀▀▀▜
  /// █  │  █   ▓  │  ▓   ░  │  ░   ▌  │  ▐
  /// █──┼──█   ▓──┼──▓   ░──┼──░   ▌──┼──▐
  /// █  │  █   ▓  │  ▓   ░  │  ░   ▌  │  ▐
  /// ███████   ▓▓▓▓▓▓▓   ░░░░░░░   ▙▃▃▃▃▃▟
  /// block100  block75   block50   halfblock
  /// ````
  case block100, block75, block50, halfblock
  
  /// __ASCII Borders__
  ///
  /// ````
  /// +--+--+    -------    /-----\
  /// |  |  |    |  |  |    |  |  |
  /// |--+--|    |--+--|    |--+--|
  /// |  |  |    |  |  |    |  |  |
  /// +--+--+    -------    \-----/
  /// ascii      ascii2     ascii3
  /// ````
  case ascii, ascii2, ascii3
  
  /// __Other Borders__
  ///
  /// **Custom:** example:
  ///
  /// ````
  /// let attr = Ansi.Color.Foreground.yellow()
  ///
  /// let custom = TUIBox(
  ///   top: TUIBoxLine(left: "┌", middle: "┬", right: "┐"),
  ///   middle: TUIBoxLine(left: "├", middle: "┼", right: "┤"),
  ///   bottom: TUIBoxLine(left: "└", middle: "┴", right: "┘"),
  ///   horizontal: TUIBoxHorizontal(top: "─", middle: "─", bottom: "─"),
  ///   vertical: TUIBoxLine(left: "│", middle: "│", right: "│"))
  /// ````
  ///
  /// **None:** example: 
  /// - borderless view
  case custom(border: TUIBorder), none
  
  /// Array of all TUIBorders
  ///
  /// - returns: [.single, .double, .double2, .double3,
  /// .block100, .block75, .block50, .halfblock,
  /// .ascii, ascii2, ascii3, .none ]
  internal static var allCases: [TUIBorder] =
    [.single, .double, .double2, .double3,
    .block100, .block75, .block50, .halfblock,
    .ascii, ascii2, ascii3, .none ]
  
  /// Standard TUIBox(es) : single, double, double2 and double3
  ///
  /// - parameters:
  ///   - attribute: Ansi (custom Ansi attributes and/or color)
  /// - returns: TUIBox?
  private func matchStandardBoxes() -> TUIBox?
  {
    switch self
    {
      case single:
        return TUIBox(
          top: TUIBoxLine(left: "┌", middle: "┬", right: "┐"),
          middle: TUIBoxLine(left: "├", middle: "┼", right: "┤"),
          bottom: TUIBoxLine(left: "└", middle: "┴", right: "┘"),
          horizontal: TUIBoxHorizontal(top: "─", middle: "─", bottom: "─"),
          vertical: TUIBoxLine(left: "│", middle: "│", right: "│"))
      case double:
        return TUIBox(
          top: TUIBoxLine(left: "╔", middle: "╦", right: "╗"),
          middle: TUIBoxLine(left: "╠", middle: "╬", right: "╣"),
          bottom: TUIBoxLine(left: "╚", middle: "╩", right: "╝"),
          horizontal: TUIBoxHorizontal(top: "═", middle: "═", bottom: "═"),
          vertical: TUIBoxLine(left: "║", middle: "║", right: "║"))
      case double2:
        return TUIBox(
          top: TUIBoxLine(left: "╒", middle: "╤", right: "╕"),
          middle: TUIBoxLine(left: "╞", middle: "╪", right: "╡"),
          bottom: TUIBoxLine(left: "╘", middle: "╧", right: "╛"),
          horizontal: TUIBoxHorizontal(top: "═", middle: "═", bottom: "═"),
          vertical: TUIBoxLine(left: "│", middle: "│", right: "│"))
      case double3:
        return TUIBox(
          top: TUIBoxLine(left: "╓", middle: "╥", right: "╖"),
          middle: TUIBoxLine(left: "╟", middle: "╫", right: "╢"),
          bottom: TUIBoxLine(left: "╙", middle: "╨", right: "╜"),
          horizontal: TUIBoxHorizontal(top: "─", middle: "─", bottom: "─"),
          vertical: TUIBoxLine(left: "║", middle: "║", right: "║"))
      default:
        // if not matched, search blocks
        return matchBlockBoxes()
    }
  }
  
  /// Block TUIBox(es) : halfBlock, block100, block75 and block50
  ///
  /// - parameters:
  ///   - attribute: Ansi (custom Ansi attributes and/or color)
  /// - returns: TUIBox?
  private func matchBlockBoxes() -> TUIBox?
  {
    switch self
    {
      case block100:
        return TUIBox(
          top: TUIBoxLine(left: "█", middle: "█", right: "█"),
          middle: TUIBoxLine(left: "█", middle: "┼", right: "█"),
          bottom: TUIBoxLine(left: "█", middle: "█", right: "█"),
          horizontal: TUIBoxHorizontal(top: "█", middle: "─", bottom: "█"),
          vertical: TUIBoxLine(left: "█", middle: "│", right: "█"))
      case block75:
        return TUIBox(
          top: TUIBoxLine(left: "▓", middle: "▓", right: "▓"),
          middle: TUIBoxLine(left: "▓", middle: "┼", right: "▓"),
          bottom: TUIBoxLine(left: "▓", middle: "▓", right: "▓"),
          horizontal: TUIBoxHorizontal(top: "▓", middle: "─", bottom: "▓"),
          vertical: TUIBoxLine(left: "▓", middle: "│", right: "▓"))
      case block50:
        return TUIBox(
          top: TUIBoxLine(left: "░", middle: "░", right: "░"),
          middle: TUIBoxLine(left: "░", middle: "┼", right: "░"),
          bottom: TUIBoxLine(left: "░", middle: "░", right: "░"),
          horizontal: TUIBoxHorizontal(top: "░", middle: "─", bottom: "░"),
          vertical: TUIBoxLine(left: "░", middle: "│", right: "░"))
      case halfblock:
        return TUIBox(
          top: TUIBoxLine(left: "▛", middle: "▀", right: "▜"),
          middle: TUIBoxLine(left: "▌", middle: "┼", right: "▐"),
          bottom: TUIBoxLine(left: "▙", middle: "▃", right: "▟"),
          horizontal: TUIBoxHorizontal(top: "▀", middle: "─", bottom: "▃"),
          vertical: TUIBoxLine(left: "▌", middle: "│", right: "▐"))
      default:
        // if not matched, search other
        return matchOtherBoxes()
    }
  }

  /// Other TUIBox(es) : ascii, custom and none
  ///
  /// - parameters:
  ///   - attribute: Ansi (custom Ansi attributes and/or color)
  /// - returns: TUIBox?
  private func matchOtherBoxes() -> TUIBox?
  {
    switch self
    {
      case ascii:
        return TUIBox(
          top: TUIBoxLine(left: "+", middle: "+", right: "+"),
          middle: TUIBoxLine(left: "+", middle: "+", right: "+"),
          bottom: TUIBoxLine(left: "+", middle: "+", right: "+"),
          horizontal: TUIBoxHorizontal(top: "-", middle: "-", bottom: "-"),
          vertical: TUIBoxLine(left: "|", middle: "|", right: "|"))
      case ascii2:
        return TUIBox(
          top: TUIBoxLine(left: "-", middle: "-", right: "-"),
          middle: TUIBoxLine(left: "|", middle: "+", right: "|"),
          bottom: TUIBoxLine(left: "-", middle: "-", right: "-"),
          horizontal: TUIBoxHorizontal(top: "-", middle: "-", bottom: "-"),
          vertical: TUIBoxLine(left: "|", middle: "|", right: "|"))
      case ascii3:
        return TUIBox(
          top: TUIBoxLine(left: "\u{2F}", middle: "-", right: "\u{5C}"),
          middle: TUIBoxLine(left: "|", middle: "+", right: "|"),
          bottom: TUIBoxLine(left: "\u{5C}", middle: "-", right: "\u{2F}"),
          horizontal: TUIBoxHorizontal(top: "-", middle: "-", bottom: "-"),
          vertical: TUIBoxLine(left: "|", middle: "|", right: "|"))
      case custom(let customBorder):
        return customBorder.toTUIBox()
      default:
        return nil
    }
  }
  
  /// Output to TUIBox
  ///
  /// - parameters:
  ///   - attribute: Ansi (custom Ansi attributes and/or color)
  /// - returns: TUIBox?
  internal func toTUIBox() -> TUIBox?
  {
    return matchStandardBoxes()
  }
}

// MARK: -
// MARK: TUIBoxLine -
internal struct TUIBoxLine
{
  internal let left: Character
  internal let middle: Character
  internal let right: Character
}

// MARK: -
// MARK: TUIBoxHorizontal -
internal struct TUIBoxHorizontal
{
  internal let top: Character
  internal let middle: Character
  internal let bottom: Character
}

// MARK: -
// MARK: TUIBox -
internal struct TUIBox
{
  internal let top: TUIBoxLine
  internal let middle: TUIBoxLine
  internal let bottom: TUIBoxLine
  internal let horizontal: TUIBoxHorizontal
  internal let vertical: TUIBoxLine
}
