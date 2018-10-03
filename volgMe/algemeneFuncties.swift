//
//  algemeneFuncties.swift
//  volgMe
//
//  Created by Toine Schnabel on 30/09/2018.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import Foundation

enum soortFout {case error,warning,debug}
var soortPlaatsKeuzes = ["":"🔴", "Hotel":"","Slaapplaats":"","Thuis":"🏠","Restaurant":"","Bar":"","Camperplaats":"","Kasteel":"","Station":"","Winkel":"","Camping":""]



//func ErrMsg(_ titel:String,_ fout:soortFout){
//    switch fout {
//    case .warning : print ("warning: " + titel)
//    case .debug :print ("debug: " + titel)
//    default: print ("ERROR: " + titel) }
//}

func ErrMsg(_ titel:String,_ fout:soortFout,_ function:String){
    switch fout {
    case .warning : print (function + "..warning: " + titel)
    case .debug :print (function + "..debug: " + titel)
    default: print (function + "..ERROR: " + titel) }
}

