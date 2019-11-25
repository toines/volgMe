//
//  debugExtensions.swift
//  volgMe
//
//  Created by Toine Schnabel on 24/11/2019.
//  Copyright © 2019 Toine Schnabel. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {

    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}
