//
//          File:   main.swift
//    Created by:   African Swift

import Darwin
import Foundation

Ansi.Set.cursorOff().stdout()

// WWDC 2016 Logo Example
Example.WWDC.demo()
Ansi.Display.Erase.all().stdout()

// Fig Font Example
try Example.Figfont.demo()
Ansi.Display.Erase.all().stdout()

// Demo of line graphics
Example.LineGraphics.demo()
Ansi.Display.Erase.all().stdout()

// Random views
Example.RandomViews.demo()

Ansi.Set.cursorOn().stdout()
