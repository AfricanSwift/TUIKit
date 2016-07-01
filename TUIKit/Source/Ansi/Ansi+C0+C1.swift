//
//          File:   Ansi+C0+C!.swift
//    Created by:   African Swift

import Darwin

// MARK: - C0 (ASCII and derivatives) -
internal extension Ansi
{
  /// C0 (ASCII and derivatives) also referred to as Single Character
  internal struct C0
  {
    /// ESC CTRL-[
    /// The Esc key on the keyboard.
    internal static let ESC = "\u{1B}"
    
    /// BEL CTRL-G
    /// Bell. May also quickly turn on and off inverse video (a visual bell).
    internal static let BEL = "\u{07}"
    
    /// SP Space
    /// Space is a graphic character.
    internal static let SP = "\u{20}"
  }
  
  /// C1 (8-Bit) Control Characters
  internal struct C1
  {
    /// CSI
    /// Control Sequence Introducer (CSI is 0x9b).
    internal static let CSI = Ansi.C0.ESC + "["
    
    /// OSC
    /// Operating System Command (OSC is 0x9d)
    internal static let OSC = Ansi.C0.ESC + "]"
  }
}
