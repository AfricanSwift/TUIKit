
//          File:   Ansi+Attribute.swift
//    Created by:   African Swift

import Darwin

// MARK: - Ansi Attributes -
public extension Ansi
{
  /// Character Attributes (SGR).
  public struct Attribute
  {
    private static let attribute = {
      (function: Int) -> Ansi in
      return Ansi("\(Ansi.C1.CSI)\(function)m")
    }
    
    /// Reset all attributes (default)
    ///
    /// - returns: Ansi
    public static func reset() -> Ansi
    {
      return attribute(0)
    }
    
    /// Bold On
    ///
    /// - returns: Ansi
    public static func boldOn() -> Ansi
    {
      return attribute(1)
    }
    
    /// Bold Off
    ///
    /// - returns: Ansi
    public static func boldOff() -> Ansi
    {
      return attribute(22)
    }
    
    /// Dim On (ISO 6429)
    ///
    /// - returns: Ansi
    public static func dimOn() -> Ansi
    {
      return attribute(2)
    }
    
    /// Dim Off (ISO 6429)
    ///
    /// - returns: Ansi
    public static func dimOff() -> Ansi
    {
      return attribute(22)
    }
    
    /// Italicized On (ISO 6429)
    ///
    /// - returns: Ansi
    public static func italicOn() -> Ansi
    {
      return attribute(3)
    }
    
    /// Italicized Off (ISO 6429)
    ///
    /// - returns: Ansi
    public static func italicOff() -> Ansi
    {
      return attribute(23)
    }
    
    /// Underline On
    ///
    /// - returns: Ansi
    public static func underlineOn() -> Ansi
    {
      return attribute(4)
    }
    
    /// Underline Off
    ///
    /// - returns: Ansi
    public static func underlineOff() -> Ansi
    {
      return attribute(24)
    }
    
    /// Slowly blinking (less then 150 per minute)
    ///
    /// - returns: Ansi
    public static func blinkSlowOn() -> Ansi
    {
      return attribute(5)
    }
    
    /// Steady (not blinking)
    ///
    /// - returns: Ansi
    public static func blinkSlowOff() -> Ansi
    {
      return attribute(25)
    }
    
    /// Rapidly blinking (150 per minute or more)
    ///
    /// - returns: Ansi
    public static func blinkRapidOn() -> Ansi
    {
      return attribute(6)
    }
    
    /// Steady (not blinking)
    ///
    /// - returns: Ansi
    public static func blinkRapidOff() -> Ansi
    {
      return attribute(25)
    }
    
    /// Inverse
    ///
    /// - returns: Ansi
    public static func inverseOn() -> Ansi
    {
      return attribute(7)
    }
    
    /// Positive (not inverse).
    ///
    /// - returns: Ansi
    public static func inverseOff() -> Ansi
    {
      return attribute(27)
    }
    
    /// Visible, i.e., not hidden (VT300).
    ///
    /// - returns: Ansi
    public static func visibleOn() -> Ansi
    {
      return attribute(28)
    }
    
    /// Invisible, i.e., hidden (VT300).
    ///
    /// - returns: Ansi
    public static func visibleOff() -> Ansi
    {
      return attribute(8)
    }
    
    /// Crossed-out characters (ISO 6429)
    ///
    /// - returns: Ansi
    public static func crossedOutOn() -> Ansi
    {
      return attribute(9)
    }
    
    /// Not crossed-out (ISO 6429).
    ///
    /// - returns: Ansi
    public static func crossedOutOff() -> Ansi
    {
      return attribute(29)
    }
    
    /// Doubly-underlined (ISO 6429)
    ///
    /// - returns: Ansi
    public static func underlineDoubleOn() -> Ansi
    {
      return attribute(21)
    }
    
    /// Doubly-underlined (ISO 6429) Off
    ///
    /// - returns: Ansi
    public static func underlineDoubleOff() -> Ansi
    {
      return attribute(24)
    }
  }
}

// MARK: - Ansi.Attribute,Choices -
public extension Ansi.Attribute
{
  public enum Choices
  {
    case reset, bold, boldoff, dim, dimoff, underline, underlineoff
    case blinkslow, blinkslowoff, inverse, inverseoff, visible, visibleoff
    case italic, italicoff, blinkrapid, blinkrapidoff
    case crossedout, crossedoutoff, underlinedouble, underlinedoubleoff
    
    /// String to Ansi Attributes
    ///
    /// - parameter attribute: Ansi.Attribute.Type
    /// - returns: Ansi
    private func toAnsi(attribute: Ansi.Attribute.Type) -> Ansi
    {
      /// Switch over common Ansi attributes
      ///
      /// - returns: Ansi
      func matchCommonAttributes() -> Ansi
      {
        switch self
        {
        case .reset:
          return attribute.reset()
        case .bold:
          return attribute.boldOn()
        case .boldoff:
          return attribute.boldOff()
        case .dim:
          return attribute.dimOn()
        case .dimoff:
          return attribute.dimOff()
        case .underline:
          return attribute.underlineOn()
        case .underlineoff:
          return attribute.underlineOff()
        default:
          return matchCommonAttributes2()
        }
      }
      
      /// Switch over common Ansi attributes
      ///
      /// - returns: Ansi
      func matchCommonAttributes2() -> Ansi
      {
        switch self
        {
        case .blinkslow:
          return attribute.blinkSlowOn()
        case .blinkslowoff:
          return attribute.blinkSlowOff()
        case .inverse:
          return attribute.inverseOn()
        case .inverseoff:
          return attribute.inverseOff()
        case .visible:
          return attribute.visibleOn()
        case .visibleoff:
          return attribute.visibleOff()
        default:
          return matchUncommonAttributes()
        }
      }
      
      /// Switch over uncommon Ansi attributes
      ///
      /// - returns: Ansi
      func matchUncommonAttributes() -> Ansi
      {
        switch self
        {
        case .italic:
          return attribute.italicOn()
        case .italicoff:
          return attribute.italicOff()
        case .blinkrapid:
          return attribute.blinkRapidOn()
        case .blinkrapidoff:
          return attribute.blinkRapidOff()
        case .crossedout:
          return attribute.crossedOutOn()
        case .crossedoutoff:
          return attribute.crossedOutOff()
        case .underlinedouble:
          return attribute.underlineDoubleOn()
        case .underlinedoubleoff:
          return attribute.underlineDoubleOff()
        default:
          /// This should never be executed
          return Ansi("")
        }
      }
      
      return matchCommonAttributes()
    }
  }
}

// MARK: - String Ansi.Attribute.Choices -
public extension String
{
  /// Ansi Attribute
  ///
  /// - returns: String (with prepended Ansi Attribute)
  public var attribute: ((Ansi.Attribute.Choices) -> String)
  {
    return { choice in
      Ansi.Attribute.Choices.toAnsi(choice)(
        attribute: Ansi.Attribute.self).toString() + self
    }
  }
}
