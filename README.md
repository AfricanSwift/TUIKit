# Terminal UIKit

![Platforms](https://img.shields.io/badge/Platforms-OSX-ff2974.svg)<BR>
![Swift version](https://img.shields.io/badge/Swift-3.0-FF2974.svg)<BR>
![ANSI support](https://img.shields.io/badge/Ansi-ECMA%2048-ff2974.svg?style=flat)

## Description
Swift native UIKit for the terminal with functionality similar to ncurses.

## Objective
- Implement a cross platform native Swift implementation of ncurses with a simpler and full featured API.
- Implement a UI element and extended widget API.

## Planned Goals
- Support multiple render modes: 
  - **Character:** ASCII, Unicode and Drawille (braille).
  - **Color:** Mono, 16 Color, 256 Color and RGB 
- **UI Elements:** View, Button, Label, Rich Text Label
- **Line graphics:** Pixel, Line, Arc, Ellipse, Rectangle, Rounded Rectangle, Pie, Polygon, Polyhedron, Star 

> 
## TUICharacter ![View](https://img.shields.io/badge/Beta-Ready-29bb74.svg?style=flat)
TUICharacter is a foundational UI element built to support:

- **Multiple symbol types:** Unicode character or Drawille (braille pixels).
- Rendering options:
  - **Color:** Mono, 16 Color, 256 Color and RGB.
  - **Character:** Color Intensity and Braille value character ramp (details below)
- **"Rich Text" Support:** mix of Ansi Color and Attributes.
- Caching of rendered Ansi. 

TUICharacter supports either a fixed unicode character or scalar value which encodes 2x4 *(x, y)* pixels as a single braille character. In this way collections of TUICharacters can intermix a variety of braille pixels with unicode text.

> 
#### TUICharacter Rendering
Multiple rendering styles are supported for braille pixel encoded values:

- **Drawille**: Renders as braille pixels
- **Short**: Short ASCII ramp (paulbourke.net) using color intensities.
- **Short2**: Short ASCII ramp (iJoshSmith) using color intensities.
- **Long**: Long ASCII ramp (www.ludd.luth.se) using color intensities.
- **DitherShort**: Short ASCII ramp using braille values.
- **DitherLong**: Long ASCII ramp using braille values.
- **Block**: Block ramp using braille values.
- **Block2**: Block ramp using a combination of color intensities & braille values.

**Note**: Unicode text is unaffected by the rendering style.

### TUIView
UI view, built from a 2D array of TUICharacter. 
- Two draw modes
  - Draw at prompt
  - Draw at origin
- Caching of rendered Ansi.
- Array of active characters to expedite draw, and to apply animation:
  - dissolve
  - materialize
- Painters Algorithm 

#### TUIProgress
Flexible design allowing full customization using TUIBarBits:

- **percent**: % complete
- **message**: Status message
- **elapsed**: Elapsed time in seconds
- **eta**: Estimated total duration
- **remaining**: Estimate time remaining
- **rate**: Current rate of progression per second
- **space**: Space Character
- **text**: Custom text
- **complete**: Complete character / sequence
- **incomplete**: Incomplete character
- **scanner**: left to right activity scanner
- **cylon**: similar to Battlestar Galatica namesake
- **animate**: sequence animation
- **spinner**: sequence spinner

> Ansi

> Line Graphics 

### Extended Features
- Progress bar and Spinners ![Progressbar](https://img.shields.io/badge/Beta-Ready-29bb74.svg?style=flat)
- Table views
- **Charting:** Bar, Stacker Bar, Line, Pie
- Gauges
- Menus
- Image view
- Sprites
- Run loop
- Support terminfo / termcap databases for terminal compatibilty

# Ansi Control Sequences 

The following *xterm control sequence introducer (CSI*) categories are supported:

1. Select Graphic Rendition
2. Cursor Control
3. Display Control
4. Line Control
5. Tab Control
6. Window Control
7. Private Mode: Set / Reset

#### Select Graphic Rendition ![ANSI build](https://img.shields.io/badge/Build-Complete-29bb74.svg?style=flat)

|       Character | Control Sequences                        |
| --------------: | ---------------------------------------- |
|      Attributes | Reset, Bold, Dim, Italic, Underline, Blink, Rapid Blink, Inverse, Positive Visible, Invisible, Crossed-Out, Double Underline. |
| Standard Colors | Black, Red, Green, Brown, Blue, Magenta, Cyan, Light Gray.<BR> ![Standard Colors](https://raw.githubusercontent.com/AfricanSwift/TUIKit/master/TUIKit/Source/Reference/Ansi-StandardColors.png) |
|   Bright Colors | Dark Gray, Light Red, Light Green, Yellow, Light Blue, Light Magenta, Light Cyan, White.<BR>![Bright Colors](https://raw.githubusercontent.com/AfricanSwift/TUIKit/master/TUIKit/Source/Reference/Ansi-BrightColors.png) |
|      256 Colors | 16 Base Colors + 216 Component Colors + 24 Grayscale. <BR><BR>![256 Colors](https://raw.githubusercontent.com/AfricanSwift/TUIKit/master/TUIKit/Source/Reference/Ansi-256Colors.png) |
|      RGB Colors | 24-bit Colors — ISO-8613-3.              |

#### Cursor Control ![ANSI build](https://img.shields.io/badge/Build-Complete-29bb74.svg?style=flat)

|      Cursor | Control Sequences                        |
| ----------: | ---------------------------------------- |
| Directional | Up, Down, Forward, Backward, Absolute Position (row, column) |
|      Column | Absolute (move to specific column), Relative (offset from current column) |
|         Row | Absolute (move to specific row), Relative (offset from current row) |
|       Style | Blinking Block, Steady Block, Blinking Underline, Steady Underline, Blinking Bar, Steady Bar. |
|       State | Save Cursor, Restore Cursor              |

#### Display Control
- Erase: Below, Above, All, Saved Lines (scroll back buffer).

#### Line Control
- Next, Previous, Insert, Delete.
- Erase: Cursor To Right, Cursor To Left, All.
- Scroll: Up, Down, Set Region.

#### Tab Control
- Forward, Backward
- Clear: Current Column, All

#### Window Control
- Move window to absolute x, y
- Resize window to absolute x, y
- Resize Text Area to absolute x, y
- De-inconify Window
- Raise to front of stack order
- Lower to bottom of stack order
- Refresh Window
- Restore Maximized Window
- Maximize Window
- Report: Position, Pixel Size, Character Text Area Size, Character Screen Size, Icon Label
- Change Icon Name and Window Title
- Change Icon Name
- Change Window Title

#### Private Mode Set / Reset
- Keyboard Action Mode
- Insert / Replace Mode
- Send / Receive Mode
- Linefeed Mode
- Cursors Keys Mode
- Designate Character Set
- Column Mode (80 / 132)
- Scroll Mode (Smooth / Jump)
- Video Mode (Reverse / Normal)
- Origin Mode
- Wrap Around Mode
- Auto Repeat Keys Mode
- Show Toolbar Mode
- Print Modes
- Cursor Mode (On / Off)
- Scrollbar Mode
- Font Shifting Function Mode
- Tektronic Mode
- Margin Bell Mode
- Reverse Wraparound Mode
- Logging Mode
- Screen Buffer Mode (Normal / Alternate)
- Keypad Modes
- Mouse Modes

## Ansi Colors
The ANSI / VT100 terminals and terminal emulators are not just able to display 
black and white text, they can display colors and formatted text.

| Terminal   | 8    | 16   | 256  | RGB  |
| ---------- | ---- | ---- | ---- | ---- |
| aTerm      | ok   | ~    | -    | -    |
| Eterm      | ok   | ~    | ok   | -    |
| GNOME      | ok   | ok   | ok   | -    |
| Guake      | ok   | ok   | ok   | -    |
| Konsole    | ok   | ok   | ok   | -    |
| Nautilus   | ok   | ok   | ok   | -    |
| rxvt       | ok   | ok   | -    | -    |
| Terminator | ok   | ok   | ok   | -    |
| Tilda      | ok   | ok   | -    | -    |
| XFCE4      | ok   | ok   | ok   | -    |
| XTerm      | ok   | ok   | ok   | -    |
| xvt        | -    | -    | -    | -    |
| Linux TTY  | ok   | ~    | -    | -    |
| VTE        | ok   | ok   | ok   | -    |
| iTerm2     | ok   | ok   | ok   | -    |
| iTerm3     | ok   | ok   | ok   | ok   |

### Contributing
If you have comments, complaints and/or feature requests: open an issue or a pull request.

### Author and license
African Swift

* [github.com/AfricanSwift](https://github.com/AfricanSwift)
* [twitter.com/SwiftAfricanus](http://twitter.com/SwiftAfricanus)

TKit is available under the MIT license. See the LICENSE file for more info.
