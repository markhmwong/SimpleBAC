//
//  ViewConstants.swift
//  LastDrop
//
//  Created by Mark Wong on 24/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

enum DrinkMenu: Int {
    case Wine = 0
    case Beer
    case Spirit
}

struct DeviceHeight {
    static let iphone8: CGFloat = 667.0 //will suit the 6,7,8
    static let iphonePlus: CGFloat = 1000
    static let iphonex: CGFloat = 888.0 // xs, x
    static let iphoneMax: CGFloat = 1000 // xr, max models
}

struct FontConstants {
    struct Size {
        static let MainResult: CGFloat = 60.0
        static let Text: CGFloat = 20
        static let Title: CGFloat = 38
        static let Subtitle: CGFloat = 30
        static let PlaceHolder: CGFloat = 20.0
        static let MenuBar: CGFloat = 16
        static let Disclaimer: CGFloat = 12
    }
    
    struct Color {

        static let GlobalWhite: UIColor = UIColor(red:0.99, green:0.99, blue:0.99, alpha:1.0)
        static let Global: UIColor = UIColor(red:0.62, green:0.65, blue:0.70, alpha:1.0)
        static let Subtitle: UIColor = UIColor(red:0.22, green:0.25, blue:0.30, alpha:1.0)
        static let CardTitle: UIColor = UIColor(red:0.8, green:0.8, blue:0.8, alpha:0.6)
        static let PlaceHolder: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        static let TextFieldBackGround: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        static let TextMuted: UIColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.7)

//        static let ButtonSelected: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        static let ButtonUnselected: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        struct Button {
            static let Enabled: UIColor = UIColor(red:0.99, green:0.99, blue:0.99, alpha:1.0)
            static let Disabled: UIColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)
            static let Muted: UIColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.7)
        }
        
        struct Cup {
            static let FillColor: UIColor = UIColor(red:0.22, green:0.22, blue:0.22, alpha:1.0)
        }
        
        
    }
    
    static let Standard: String = "Avenir-Heavy"
    static let StandardBold: String = "Avenir-Black"
    struct Avenir {
        static let AvenirLight: String = "Avenir-Light"
        static let AvenirBlack: String = "Avenir-Black"
        static let AvenirBook: String = "Avenir-Book"
        static let AvenirMedium: String = "Avenir-Medium"
    }
}

/// Structure for visual properties such as dimensions, colour etc.
struct Theme {
    struct View {
        struct General {
            static let CornerRadius: CGFloat = 20.0
        }
        
        struct Button {
            static let BorderWidth: CGFloat = 2.0
        }
        
        
        struct DrinkMenu {
            struct Color {
                static let DrinkMenuCellViewBackground: UIColor = UIColor(red:0.22, green:0.25, blue:0.30, alpha:0.6)
            }
        }

        
        struct MenuBar {
            struct Size {
                /* Height (CGFloat) of 50 */
                static let Height: CGFloat = 50.0
                static let Width: CGFloat = 0.0 // set by constraints

            }
        }
    }

}

//Theme Color Structs
struct ThemeConstants {
    static let CellViewBackground: UIColor = UIColor(red:0.20, green:0.15, blue:0.20, alpha:1.0)
    static let CardViewBackground: UIColor = UIColor(red:0.39, green:0.30, blue:0.32, alpha:1.0)
    static let InputBackground: UIColor = UIColor(red:0.64, green:0.60, blue:0.53, alpha:1.0)
    static let CellViewBackgroundB: UIColor = UIColor(red:0.15, green:0.20, blue:0.27, alpha:1.0)
}

struct TimesChanging {
    // purple brown UIColor(red:0.20, green:0.15, blue:0.20, alpha:1.0)
    // pastel brown red UIColor(red:0.39, green:0.30, blue:0.32, alpha:1.0)
    // pastel orange UIColor(red:0.97, green:0.48, blue:0.32, alpha:1.0)
    // pastel mandarin UIColor(red:1.00, green:0.59, blue:0.31, alpha:1.0)
    // pastel gray UIColor(red:0.64, green:0.60, blue:0.53, alpha:1.0)
    
    static let CellViewBackground: UIColor = UIColor(red:0.24, green:0.24, blue:0.23, alpha:1.0)
    static let CardViewBackground: UIColor = UIColor(red:0.97, green:0.48, blue:0.32, alpha:1.0)
    static let InputBackground: UIColor = UIColor(red:0.80, green:0.78, blue:0.76, alpha:1.0)
    static let CellViewBackgroundB: UIColor = UIColor(red:0.15, green:0.20, blue:0.27, alpha:1.0)
}

struct AnchorTheme {
    static let CardShadowBackground: UIColor = UIColor(red:0.02, green:0.03, blue:0.05, alpha:1.0)
    static let CellViewBackground: UIColor = UIColor(red:0.07, green:0.10, blue:0.16, alpha:1.0)
    static let CardViewBackgroundEnd: UIColor = UIColor(red:0.13, green:0.18, blue:0.28, alpha:1.0)
    static let CardViewBackgroundStart: UIColor = UIColor(red:0.13, green:0.18, blue:0.28, alpha:1.0)
    static let CardViewBackground: UIColor = UIColor(red:0.07, green:0.10, blue:0.16, alpha:1.0)
    static let InputBackground: UIColor = UIColor(red:0.80, green:0.78, blue:0.76, alpha:1.0)
    static let CellViewBackgroundB: UIColor = UIColor(red:0.15, green:0.20, blue:0.27, alpha:1.0)
}

struct Indian {
    
    static let CardViewBackground: UIColor = UIColor(red:0.99, green:0.86, blue:0.42, alpha:1.0)
    static let CellViewBackground: UIColor = UIColor(red:0.11, green:0.11, blue:0.12, alpha:1.0)
}

struct LDAnimation {
    
    static let TextDuration: Double = 0.25
    
}
