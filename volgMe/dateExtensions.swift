//
//  dateExtensions.swift
//  volgMe
//
//  Created by Toine Schnabel on 24-09-18.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import Foundation
import UIKit

typealias Date_70 = Float  //origineel Double, Float is vaak nauwkeurig genoeg.

extension Date_70 {
    init(_ datum:Date) {self.init(Float(datum.timeIntervalSince1970))}
    var date:Date {get {return Date(timeIntervalSince1970: Double(self))}}
}


