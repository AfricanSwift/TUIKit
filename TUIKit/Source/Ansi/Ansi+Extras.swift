
//          File:   Ansi+Extras.swift
//    Created by:   African Swift

import Foundation
import AppKit

// MARK: - Cursor Sequences -
public extension Ansi
{
  /// Flash the screen
  /// Reverse the video and then restore
  ///
  /// - parameter delay: Double (default delay = 0.5 seconds)
  public static func flashScreen(_ delay: Double = 0.5)
  {
    /// Switch to alternate screen buffer to save current state
    /// Reverse Video. For some reason \n is required to activate
    Ansi.Set.screenBufferAlternate().stdout()
    Ansi.Set.videoReverse().stdout()
    Ansi.flush()
    Thread.sleep(forTimeInterval: delay)
    
    /// Resume Normal Video.
    /// Switch back to the NormalScreenBuffer
    Ansi.Set.videoNormal().stdout()
    Ansi.Set.screenBufferNormal().stdout()
//    Ansi.Cursor.up(quantity: 1).stdout()
    Ansi.flush()
  }
}
