//
//  Font.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit

public enum Font {
    public static func font(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }

    public static func boldFont(size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
}
