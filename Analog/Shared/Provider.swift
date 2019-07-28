//
//  Provider.swift
//  Analog
//
//  Created by Frederik Christensen on 19/06/2019.
//  Copyright © 2019 analogio. All rights reserved.
//

import Foundation
import ClipCardAPI
import Client
import ShiftPlanningAPI
import Entities

public class Provider {
    public let clipcard: ClipCardAPI
    public let shiftplanning: ShiftPlanningAPI

    init(clipcard: ClipCardAPI, shiftplanning: ShiftPlanningAPI) {
        self.clipcard = clipcard
        self.shiftplanning = shiftplanning
    }
}
