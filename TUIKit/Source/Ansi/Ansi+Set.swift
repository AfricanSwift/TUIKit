//
//          File:   Ansi+Set.swift
//    Created by:   African Swift

import Darwin

public extension Ansi
{
  /// DEC Private Mode Set (DECSET) & Reset (DECRST).
  /// - CSI ? Pm h ... CSI ? Pm l
  ///
  /// Set Mode (SM) / Reset Mode (RM)
  /// - CSI Pm l ... CSI Pm h
  public enum Set
  {
    private static let setH = {
      (function: Int) -> Ansi in
      return Ansi("\(Ansi.C1.CSI)\(function)h")
    }
    
    private static let setL = {
      (function: Int) -> Ansi in
      return Ansi("\(Ansi.C1.CSI)\(function)l")
    }
    
    private static let setHQ = {
      (function: Int) -> Ansi in
      return Ansi("\(Ansi.C1.CSI)?\(function)h")
    }
    
    private static let setLQ = {
      (function: Int) -> Ansi in
      return Ansi("\(Ansi.C1.CSI)?\(function)l")
    }
    
//    /// Ps = 2  -> Keyboard Action Mode (AM).
//    public static func keyboardActionModeOn() -> Ansi
//    {
//      return setH(2)
//    }
//    
//    /// Ps = 2  -> Keyboard Action Mode (AM).
//    public static func keyboardActionModeOff() -> Ansi {
//      return setL(2)
//    }
    
    /// Ps = 4  -> Insert Mode (IRM)
    ///
    /// - returns: Ansi
    public static func modeInsert() -> Ansi
    {
      return setH(4)
    }
    
    /// Ps = 4  -> Replace Mode (IRM)
    ///
    /// - returns: Ansi
    public static func modeReplace() -> Ansi
    {
      return setL(4)
    }
    
//    /// Ps = 1 2  -> Send/receive (SRM).
//    public static func sendReceiveOn() -> Ansi
//    {
//      return setH(12)
//    }
//    
//    /// Ps = 1 2  -> Send/receive (SRM).
//    public static func sendReceiveOff() -> Ansi
//    {
//      return setL(12)
//    }
    
    /// Ps = 2 0  -> Automatic Newline (LNM)
    ///
    /// - returns: Ansi
    public static func linefeedAutomaticNewline() -> Ansi
    {
      return setH(20)
    }
    
    /// Ps = 2 0  -> Normal Linefeed (LNM)
    ///
    /// - returns: Ansi
    public static func linefeedNormal() -> Ansi
    {
      return setL(20)
    }
    
    /// Application Cursor Keys (DECCKM)
    /// 
    /// Causes the cursor keys to send application control functions.
    public static func cursorKeysApplication() -> Ansi
    {
      return setHQ(1)
    }
    
    /// Normal Cursor Keys (DECCKM)
    ///
    /// Causes the cursor keys to generate ANSI cursor control sequences.
    public static func cursorKeysNormal() -> Ansi
    {
      return setLQ(1)
    }
    
//    /// Ps = 2 -> Designate USASCII for character sets
//    /// G0-G3 (DECANM), and set VT100 mode.
//    public static func designateUSASCII() -> Ansi
//    {
//      return setHQ(2)
//    }
//    
//    /// Ps = 2 -> Designate VT52 mode (DECANM).
//    public static func designateVT52() -> Ansi
//    {
//      return setLQ(2)
//    }
    
    /// Ps = 3 -> 132 Column Mode (DECCOLM)
    ///
    /// - returns: Ansi
    public static func column132() -> Ansi
    {
      return setHQ(3)
    }
    
    /// Ps = 3 -> 80 Column Mode (DECCOLM)
    ///
    /// - returns: Ansi
    public static func column80() -> Ansi
    {
      return setLQ(3)
    }
    
    /// Ps = 4 -> Smooth (Slow) Scroll (DECSCLM)
    ///
    /// - returns: Ansi
    public static func scrollSmooth() -> Ansi
    {
      return setHQ(4)
    }
    
    /// Ps = 4 -> Jump (Fast) Scroll (DECSCLM)
    ///
    /// - returns: Ansi
    public static func scrollJump() -> Ansi
    {
      return setLQ(4)
    }
    
    /// Ps = 5 -> Reverse Video (DECSCNM)
    ///
    /// - returns: Ansi
    public static func videoReverse() -> Ansi
    {
      return setHQ(5)
    }
    
    /// Ps = 5 -> Normal Video (DECSCNM)
    ///
    /// - returns: Ansi
    public static func videoNormal() -> Ansi
    {
      return setLQ(5)
    }
    
    /// Ps = 6  -> Origin Mode (DECOM)
    ///
    /// - returns: Ansi
    public static func modeOrigin() -> Ansi
    {
      return setHQ(6)
    }
    
    /// Ps = 6  -> Normal Cursor Mode (DECOM)
    ///
    /// - returns: Ansi
    public static func modeNormalCursor() -> Ansi
    {
      return setLQ(6)
    }
    
    /// Ps = 7  -> Wraparound Mode (DECAWM)
    ///
    /// - returns: Ansi
    public static func wraparoundModeOn() -> Ansi
    {
      return setHQ(7)
    }
    
    /// Ps = 7  -> No Wraparound Mode (DECAWM)
    ///
    /// - returns: Ansi
    public static func wraparoundModeOff() -> Ansi
    {
      return setLQ(7)
    }
    
    /// Ps = 8  -> Auto-repeat Keys (DECARM)
    ///
    /// - returns: Ansi
    public static func autorepeatKeysOn() -> Ansi
    {
      return setHQ(8)
    }
    
    /// Ps = 8  -> No Auto-repeat Keys (DECARM)
    ///
    /// - returns: Ansi
    public static func autorepeatKeysOff() -> Ansi
    {
      return setLQ(8)
    }
    
    /// Ps = 9  -> Send Mouse X & Y on button press
    ///
    /// - returns: Ansi
    public static func sendMouseXYOnButtonPressOn() -> Ansi
    {
      return setHQ(9)
    }
    
    /// Ps = 9  -> Don't Send Mouse X & Y on button press.
    ///
    /// - returns: Ansi
    public static func sendMouseXYOnButtonPressOff() -> Ansi
    {
      return setLQ(9)
    }
    
//    /// Ps = 1 0  -> Show toolbar (rxvt).
//    public static func toolbarOn() -> Ansi
//    {
//      return setHQ(10)
//    }
//    
//    /// Ps = 1 0  -> Hide toolbar (rxvt).
//    public static func toolbarOff() -> Ansi
//    {
//      return setLQ(10)
//    }
    
    /// Ps = 1 2  -> Start Blinking Cursor (att610)
    ///
    /// - returns: Ansi
    public static func blinkingCursorStart() -> Ansi
    {
      return setHQ(12)
    }
    
    /// Ps = 1 2  -> Stop Blinking Cursor (att610)
    ///
    /// - returns: Ansi
    public static func blinkingCursorStop() -> Ansi
    {
      return setLQ(12)
    }
    
//    /// Ps = 1 8  -> Print form feed (DECPFF).
//    public static func printFormFeedOn() -> Ansi
//    {
//      return setHQ(18)
//    }
//    
//    /// Ps = 1 8  -> Don't Print form feed (DECPFF).
//    public static func printFormFeedOff() -> Ansi
//    {
//      return setLQ(18)
//    }
    
//    /// Ps = 1 9  -> Set print extent to full screen (DECPEX).
//    public static func printExtentToFullscreen() -> Ansi
//    {
//      return setHQ(19)
//    }
//    
//    /// Ps = 1 9  -> Limit print to scrolling region (DECPEX).
//    public static func printExtentToScrollRegion() -> Ansi
//    {
//      return setLQ(19)
//    }
    
    /// Show Cursor (DECTCEM)
    ///
    /// Makes the cursor visible
    /// - returns: Ansi
    public static func cursorOn() -> Ansi
    {
      return setHQ(25)
    }
    
    /// Hide Cursor (DECTCEM)
    ///
    /// Makes the cursor not visible
    /// - returns: Ansi
    public static func cursorOff() -> Ansi
    {
      return setLQ(25)
    }
    
    /// Ps = 3 0  -> Show scrollbar (rxvt)
    ///
    /// - returns: Ansi
    public static func scrollbarOn() -> Ansi
    {
      return setHQ(30)
    }
    
    /// Ps = 3 0  -> Hide scrollbar (rxvt)
    ///
    /// - returns: Ansi
    public static func scrollbarOff() -> Ansi
    {
      return setLQ(30)
    }
    
//    /// Ps = 3 5  -> Enable font-shifting functions (rxvt).
//    public static func fontShiftingFunctionsOn() -> Ansi
//    {
//      return setHQ(35)
//    }
//    
//    /// Ps = 3 5  -> Disable font-shifting functions (rxvt).
//    public static func fontShiftingFunctionsOff() -> Ansi
//    {
//      return setLQ(35)
//    }
    
//    /// Ps = 3 8  -> Enter Tektronix Mode (DECTEK).
//    public static func tektronixOn() -> Ansi
//    {
//      return setHQ(38)
//    }
//    
//    /// Ps = 3 8  -> Disable Tektronix Mode (DECTEK).
//    public static func tektronixOff() -> Ansi
//    {
//      return setLQ(38)
//    }
    
    /// Ps = 4 0  -> Allow 80 -> 132 Mode
    ///
    /// - returns: Ansi
    public static func mode80To132On() -> Ansi
    {
      return setHQ(40)
    }
    
    /// Ps = 4 0  -> Disallow 80 -> 132 Mode
    ///
    /// - returns: Ansi
    public static func mode80To132Off() -> Ansi
    {
      return setLQ(40)
    }
    
//    /// Ps = 4 1  -> more(1) fix (see curses resource).
//    public static func moreFixOn() -> Ansi
//    {
//      return setHQ(41)
//    }
//    
//    /// Ps = 4 1  -> No more(1) fix (see curses resource).
//    public static func moreFixOff() -> Ansi
//    {
//      return setLQ(41)
//    }
    
//    /// Ps = 4 2  -> Enable National Replacement Character sets (DECNRCM).
//    public static func nationalReplacementCharactersetOn() -> Ansi
//    {
//      return setHQ(42)
//    }
//    
//    /// Ps = 4 2  -> Disable National Replacement Character sets (DECNRCM).
//    public static func nationalReplacementCharactersetOff() -> Ansi
//    {
//      return setLQ(42)
//    }
    
//    /// Ps = 4 4  -> Turn On Margin Bell.
//    public static func marginBellOn() -> Ansi
//    {
//      return setHQ(44)
//    }
//    
//    /// Ps = 4 4  -> Turn Off Margin Bell.
//    public static func marginBellOff() -> Ansi
//    {
//      return setLQ(44)
//    }
    
//    /// Ps = 4 5  -> Reverse-wraparound Mode.
//    public static func reverseWraparoundOn() -> Ansi
//    {
//      return setHQ(45)
//    }
//    
//    /// Ps = 4 5  -> NoReverse-wraparound Mode.
//    public static func reverseWraparoundOff() -> Ansi
//    {
//      return setLQ(45)
//    }
    
//    /// Ps = 4 6  -> Start Logging.  This is normally disabled by a
//    /// compile-time option.
//    public static func loggingOn() -> Ansi
//    {
//      return setHQ(46)
//    }
//    
//    /// Ps = 4 6  -> Stop Logging.  This is normally disabled by a
//    /// compile-time option.
//    public static func loggingOff() -> Ansi
//    {
//      return setLQ(46)
//    }
    
    /// Ps = 4 7  -> Use Normal Screen Buffer
    ///
    /// - returns: Ansi
    public static func screenBufferNormal() -> Ansi
    {
      return setHQ(47)
    }
    
    /// Ps = 4 7  -> Use Alternate Screen Buffer
    ///
    /// - returns: Ansi
    public static func screenBufferAlternate() -> Ansi
    {
      return setLQ(47)
    }
    
//    /// Ps = 6 6  -> Numeric keypad (DECNKM).
//    public static func keypadNumeric() -> Ansi
//    {
//      return setHQ(66)
//    }
//    
//    /// Ps = 6 6  -> Application keypad (DECNKM).
//    public static func keypadApplication() -> Ansi
//    {
//      return setLQ(66)
//    }
    
    /// Ps = 6 7  -> Backarrow key sends delete (DECBKM)
    ///
    /// - returns: Ansi
    public static func backarrowKeySendsDelete() -> Ansi
    {
      return setHQ(67)
    }
    
    /// Ps = 6 7  -> Backarrow key sends backspace (DECBKM)
    ///
    /// - returns: Ansi
    public static func backarrowKeySendsBackspace() -> Ansi
    {
      return setLQ(67)
    }
    
//    /// Ps = 6 9  -> Disable left and right margin mode (DECLRMM),
//    /// VT420 and up.
//    public static func leftRightMarginModeOff() -> Ansi
//    {
//      return setHQ(69)
//    }
//    
//    /// Ps = 6 9  -> Enable left and right margin mode (DECLRMM),
//    /// VT420 and up.
//    public static func leftRightMarginModeOn() -> Ansi
//    {
//      return setLQ(69)
//    }
    
    /// Ps = 9 5  -> Clear screen when DECCOLM is set/reset (DECNCSM)
    ///
    /// - returns: Ansi
    public static func clearWhenSetResetOn() -> Ansi
    {
      return setHQ(95)
    }
    
    /// Ps = 9 5  -> Do not clear screen when DECCOLM is set/reset (DECNCSM)
    ///
    /// - returns: Ansi
    public static func clearWhenSetResetOff() -> Ansi
    {
      return setLQ(95)
    }
    
    /// Ps = 1 0 0 0  -> Don't Send Mouse X & Y on button press and release
    ///
    /// - returns: Ansi
    public static func sendMouseXYOnButtonPressX11Off() -> Ansi
    {
      return setLQ(1000)
    }
    
    /// Ps = 1 0 0 0  -> Send Mouse X & Y on button press and release
    ///
    /// - returns: Ansi
    public static func sendMouseXYOnButtonPressX11On() -> Ansi
    {
//      return Ansi("\(Ansi.C1.CSI)?1000h")
      
      
      return setHQ(1000)
    }
    
    /// Ps = 1 0 0 1  -> Don't Use Hilite Mouse Tracking
    ///
    /// - returns: Ansi
    public static func hiliteMouseTrackingOff() -> Ansi
    {
      return setHQ(1001)
    }
    
    /// Ps = 1 0 0 1  -> Use Hilite Mouse Tracking
    ///
    /// - returns: Ansi
    public static func hiliteMouseTrackingOn() -> Ansi
    {
      return setLQ(1001)
    }
    
    /// Ps = 1 0 0 2  -> Don't Use Cell Motion Mouse Tracking
    ///
    /// - returns: Ansi
    public static func cellMouseTrackingOff() -> Ansi
    {
      return setHQ(1002)
    }
    
    /// Ps = 1 0 0 2  -> Use Cell Motion Mouse Tracking
    ///
    /// - returns: Ansi
    public static func cellMouseTrackingOn() -> Ansi
    {
      return setLQ(1002)
    }
    
    /// Ps = 1 0 0 3  -> Don't Use All Motion Mouse Tracking
    ///
    /// - returns: Ansi
    public static func allMouseTrackingOff() -> Ansi
    {
      return setHQ(1003)
    }
    
    /// Ps = 1 0 0 3  -> Use All Motion Mouse Tracking
    ///
    /// - returns: Ansi
    public static func allMouseTrackingOn() -> Ansi
    {
      return setLQ(1003)
    }
    
//    /// Ps = 1 0 0 4  -> Send FocusIn/FocusOut events.
//    public static func focusInOutEventsOn() -> Ansi
//    {
//      return setHQ(1004)
//    }
//    
//    /// Ps = 1 0 0 4  -> Don't Send FocusIn/FocusOut events.
//    public static func focusInOutEventsOff() -> Ansi
//    {
//      return setLQ(1004)
//    }
    
    /// Ps = 1 0 0 5  -> Enable UTF-8 Mouse Mode
    ///
    /// - returns: Ansi
    public static func utf8MouseModeOn() -> Ansi
    {
      return setHQ(1005)
    }
    
    /// Ps = 1 0 0 5  -> Disable UTF-8 Mouse Mode
    ///
    /// - returns: Ansi
    public static func utf8MouseModeOff() -> Ansi
    {
      return setLQ(1005)
    }
    
    /// Ps = 1 0 0 6  -> Enable SGR Mouse Mode
    ///
    /// - returns: Ansi
    public static func sgrMouseModeOn() -> Ansi
    {
      return setHQ(1006)
    }
    
    /// Ps = 1 0 0 6  -> Disable SGR Mouse Mode
    ///
    /// - returns: Ansi
    public static func sgrMouseModeOff() -> Ansi
    {
      return setLQ(1006)
    }
    
    /// Ps = 1 0 0 7  -> Enable Alternate Scroll Mode
    ///
    /// - returns: Ansi
    public static func alternateScrollOn() -> Ansi
    {
      return setHQ(1007)
    }
    
    /// Ps = 1 0 0 7  -> Disable Alternate Scroll Mode
    ///
    /// - returns: Ansi
    public static func alternateScrollOff() -> Ansi
    {
      return setLQ(1007)
    }
    
    /// Ps = 1 0 1 0  -> Scroll to bottom on tty output (rxvt)
    ///
    /// - returns: Ansi
    public static func scrollToBottomOnOutputOn() -> Ansi
    {
      return setHQ(1010)
    }
    
    /// Ps = 1 0 1 0  -> Don't Scroll to bottom on tty output (rxvt)
    ///
    /// - returns: Ansi
    public static func scrollToBottomOnOutputOff() -> Ansi
    {
      return setLQ(1010)
    }
    
    /// Ps = 1 0 1 1  -> Scroll to bottom on key press (rxvt)
    ///
    /// - returns: Ansi
    public static func scrollToBottomOnKeypressOn() -> Ansi
    {
      return setHQ(1011)
    }
    
    /// Ps = 1 0 1 1  -> Don't Scroll to bottom on key press (rxvt)
    ///
    /// - returns: Ansi
    public static func scrollToBottomOnKeypressOff() -> Ansi
    {
      return setLQ(1011)
    }
    
    /// Ps = 1 0 1 5  -> Enable urxvt Mouse Mode
    ///
    /// - returns: Ansi
    public static func urxvtMouseOn() -> Ansi
    {
      return setHQ(1015)
    }
    
    /// Ps = 1 0 1 5  -> Disable urxvt Mouse Mode
    ///
    /// - returns: Ansi
    public static func urxvtMouseOff() -> Ansi
    {
      return setLQ(1015)
    }
    
//    /// Ps = 1 0 3 4  -> Interpret "meta" key, sets eighth bit.
//    /// (enables the eightBitInput resource).
//    public static func interpretMetaKeyOn() -> Ansi
//    {
//      return setHQ(1034)
//    }
//    
//    /// Ps = 1 0 3 4  -> Don't interpret "meta" key, sets eighth bit.
//    /// (enables the eightBitInput resource).
//    public static func interpretMetaKeyOff() -> Ansi
//    {
//      return setLQ(1034)
//    }
    
//    /// Ps = 1 0 3 5  -> Enable special modifiers for Alt and Num-
//    /// Lock keys.  (This enables the numLock resource).
//    public static func specialModifiersAltNumlockKeysOn() -> Ansi
//    {
//      return setHQ(1035)
//    }
//    
//    /// Ps = 1 0 3 5  -> Disable special modifiers for Alt and Num-
//    /// Lock keys.  (This enables the numLock resource).
//    public static func specialModifiersAltNumlockKeysOff() -> Ansi
//    {
//      return setLQ(1035)
//    }
    
//    /// Ps = 1 0 3 6  -> Send ESC when Meta modifies a key.  (This
//    /// enables the metaSendsEscape resource).
//    public static func sendESCWhenMetaModifiesKeysOn() -> Ansi
//    {
//      return setHQ(1036)
//    }
//    
//    /// Ps = 1 0 3 6  -> Don't Send ESC when Meta modifies a key.  (This
//    /// enables the metaSendsEscape resource).
//    public static func sendESCWhenMetaModifiesKeysOff() -> Ansi
//    {
//      return setLQ(1036)
//    }
    
//    /// Ps = 1 0 3 7  -> Send DEL from the editing-keypad Delete key.
//    public static func keypadDeleteKeySendDEL4() -> Ansi
//    {
//      return setHQ(1037)
//    }
//    
//    /// Ps = 1 0 3 7  -> Send VT220 Remove from editing-keypad Delete key.
//    public static func keypadDeleteKeySendV220Remove() -> Ansi
//    {
//      return setLQ(1037)
//    }
    
//    /// Ps = 1 0 3 9  -> Send ESC when Alt modifies a key.  (This
//    /// enables the altSendsEscape resource).
//    public static func sendESCWhenAltModifiesKeysOn() -> Ansi
//    {
//      return setHQ(1039)
//    }
//    
//    /// Ps = 1 0 3 9  -> Don't Send ESC when Alt modifies a key.  (This
//    /// enables the altSendsEscape resource).
//    public static func sendESCWhenAltModifiesKeysOff() -> Ansi
//    {
//      return setLQ(1039)
//    }
    
//    /// Ps = 1 0 4 0  -> Keep selection even if not highlighted.
//    /// (This enables the keepSelection resource).
//    public static func keepSelectionOn() -> Ansi
//    {
//      return setHQ(1040)
//    }
//    
//    /// Ps = 1 0 4 0  -> Don't keep selection even if not highlighted.
//    /// (This enables the keepSelection resource).
//    public static func keepSelectionOff() -> Ansi
//    {
//      return setLQ(1040)
//    }
    
//    /// Ps = 1 0 4 1  -> Use the CLIPBOARD selection.  (This enables
//    /// the selectToClipboard resource).
//    public static func useClipboardSelectionOn() -> Ansi
//    {
//      return setHQ(1041)
//    }
//    
//    /// Ps = 1 0 4 1  -> Use the PRIMARY selection.  (This disables
//    /// the selectToClipboard resource).
//    public static func useClipboardSelectionOff() -> Ansi
//    {
//      return setLQ(1041)
//    }
    
//    /// Ps = 1 0 4 2  -> Enable Urgency window manager hint when
//    /// Control-G is received.  (This enables the bellIsUrgent resource).
//    public static func urgencyWindowManagerHintOn() -> Ansi
//    {
//      return setHQ(1042)
//    }
//    
//    /// Ps = 1 0 4 2  -> Disable Urgency window manager hint when
//    /// Control-G is received.  (This disables the bellIsUrgent resource).
//    public static func urgencyWindowManagerHintOff() -> Ansi
//    {
//      return setLQ(1042)
//    }
    
//    /// Ps = 1 0 4 3  -> Enable raising of the window when Control-G
//    /// is received.  (enables the popOnBell resource).
//    public static func raisingOfWindowOn() -> Ansi
//    {
//      return setHQ(1043)
//    }
//    
//    /// Ps = 1 0 4 3  -> Disable raising of the window when Control-G
//    /// is received.  (Disable the popOnBell resource).
//    public static func raisingOfWindowOff() -> Ansi
//    {
//      return setLQ(1043)
//    }
    
//    /// Use Alternate Screen Buffer 2,
//    /// clearing screen first if in the Alternate Screen.
//    /// (This may be disabled by the titeInhibit resource).
//    public static func screenBufferAlternate2() -> Ansi
//    {
//      return setHQ(1047)
//    }
//    
//    /// Use Normal Screen Buffer 2,
//    /// clearing screen first if in the Alternate Screen.
//    /// (This may be disabled by the titeInhibit resource).
//    public static func screenBufferNormal2() -> Ansi
//    {
//      return setLQ(1047)
//    }
    
    /// Ps = 1 0 4 8  -> Save cursor as in DECSC
    ///
    /// - returns: Ansi
    public static func cursorSave() -> Ansi
    {
      return setHQ(1048)
    }
    
    /// Ps = 1 0 4 8  -> Restore cursor as in DECSC
    ///
    /// - returns: Ansi
    public static func cursorRestore() -> Ansi
    {
      return setLQ(1048)
    }
    
    /// Ps = 1 0 4 9  -> Save cursor as in DECSC and use Alternate
    /// Screen Buffer, clearing it first.  (This may be disabled by
    /// the titeInhibit resource).
    /// This combines the effects of the 1 0 4 7 and 1 0 4 8 modes.
    /// Use this with terminfo-based applications rather than the 4 7 mode
    ///
    /// - returns: Ansi
    public static func screenBufferAlternateCursorSave() -> Ansi
    {
      return setHQ(1049)
    }
    
    /// Ps = 1 0 4 9  -> Use Normal Screen Buffer and restore cursor
    /// as in DECRC.  (This may be disabled by the titeInhibit
    /// resource).  This combines the effects of the 1 0 4 7  and 1 0 4 8
    /// modes.  Use this with terminfo-based applications rather
    /// than the 4 7  mode
    ///
    /// - returns: Ansi
    public static func screenBufferNormalCursorRestore() -> Ansi
    {
      return setLQ(1049)
    }
    
//    /// Ps = 1 0 5 0  -> Set terminfo/termcap function-key mode.
//    public static func terminfoTermcapFunctionkeyOn() -> Ansi
//    {
//      return setHQ(1050)
//    }
//    
//    /// Ps = 1 0 5 0  -> Reset terminfo/termcap function-key mode.
//    public static func terminfoTermcapFunctionkeyOff() -> Ansi
//    {
//      return setLQ(1050)
//    }
    
//    /// Ps = 1 0 5 1  -> Set Sun function-key mode.
//    public static func sunFunctionkeyOn() -> Ansi
//    {
//      return setHQ(1051)
//    }
//    
//    /// Ps = 1 0 5 1  -> Reset Sun function-key mode.
//    public static func sunFunctionkeyOff() -> Ansi
//    {
//      return setLQ(1051)
//    }
    
//    /// Ps = 1 0 5 2  -> Set HP function-key mode.
//    public static func hpFunctionkeyOn() -> Ansi
//    {
//      return setHQ(1052)
//    }
//    
//    /// Ps = 1 0 5 2  -> Reset HP function-key mode.
//    public static func hpFunctionkeyOff() -> Ansi
//    {
//      return setLQ(1052)
//    }
    
//    /// Ps = 1 0 5 3  -> Set SCO function-key mode.
//    public static func scoFunctionkeyOn() -> Ansi
//    {
//      return setHQ(1053)
//    }
//    
//    /// Ps = 1 0 5 3  -> Reset SCO function-key mode.
//    public static func scoFunctionkeyOff() -> Ansi
//    {
//      return setLQ(1053)
//    }
    
//    /// Ps = 1 0 6 0  -> Set legacy keyboard emulation (X11R6).
//    public static func legacyKeyboardEmulationOn() -> Ansi
//    {
//      return setHQ(1060)
//    }
//    
//    /// Ps = 1 0 6 0  -> Reset legacy keyboard emulation (X11R6).
//    public static func legacyKeyboardEmulationOff() -> Ansi
//    {
//      return setLQ(1060)
//    }
    
//    /// Ps = 1 0 6 1  -> Set VT220 keyboard emulation.
//    public static func keyboardEmulationVT200() -> Ansi
//    {
//      return setHQ(1061)
//    }
//    
//    /// Ps = 1 0 6 1  -> Reset keyboard emulation to Sun/PC style..
//    public static func keyboardEmulationPCStyle() -> Ansi
//    {
//      return setLQ(1061)
//    }
    
//    /// Ps = 2 0 0 4  -> Set bracketed paste mode.
//    public static func bracketedPasteOn() -> Ansi
//    {
//      return setHQ(2004)
//    }
//    
//    /// Ps = 2 0 0 4  -> Reset bracketed paste mode.
//    public static func bracketedPasteOff() -> Ansi
//    {
//      return setLQ(2004)
//    }
  }
}
