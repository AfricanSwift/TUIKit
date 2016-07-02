//
//          File:   Color+CMYK.swift
//    Created by:   African Swift

import Darwin

// MARK: -
// MARK: RGB to CMYK -
internal extension  Ansi.Color
{
  /// Convert RGB to CMY
  ///
  /// - parameters:
  ///   - rgb: Ansi.Color.RGBComponents
  /// - returns: Ansi.Color.CMYKComponents
  internal static func convertRGBtoCMYK(
    rgb value: Ansi.Color.RGBComponents) ->  Ansi.Color.CMYKComponents
  {
    // CMY Conversion
    var cyan = (1 - value.red)
    var magenta = (1 - value.green)
    var yellow = (1 - value.blue)
    
    // Set default key to // Black
    var key = 1.0
    
    if cyan < key
    {
      key = cyan
    }
    
    if magenta < key
    {
      key = magenta
    }
    
    if yellow < key
    {
      key = yellow
    }
    
    // Black
    if key == 1.0
    {
      cyan = 0
      magenta = 0
      yellow = 0
    }
    else
    {
      cyan = ( cyan - key ) / ( 1 - key )
      magenta = ( magenta - key ) / ( 1 - key )
      yellow = ( yellow - key ) / ( 1 - key )
    }
    
    return Ansi.Color.CMYKComponents(
      cyan: cyan,
      magenta: magenta,
      yellow: yellow,
      key: key)
  }
}
