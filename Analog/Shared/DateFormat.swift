//
//  DateFormat.swift
//  Analog
//
//  Created by Frederik Christensen on 28/04/2019.
//  Copyright © 2019 analogio. All rights reserved.
//

import Foundation

public enum DateFormat {
    public static func format(_ dateString: String?) -> String? {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.locale = Locale(identifier: "da_DK")
            return formatter
        }()

        let prettyDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "da_DK")
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter
        }()

        if let dateUsed = dateString, let date = dateFormatter.date(from: dateUsed) {
            return prettyDateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
