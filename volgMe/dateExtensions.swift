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


extension Date
{
    func week()->Date
    {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "yyww"
        Formatter.locale = Locale.current
        return Formatter.date(from: Formatter.string(from: self))!
        
    }
    func dagLong0()->String
    {
        let Formatter = DateFormatter()
        Formatter.dateStyle = DateFormatter.Style.long
        Formatter.locale = Locale.current
        //        println("dag   --\(Formatter.stringFromDate(self))")
        return Formatter.string(from: self)
    }
    var geldig :Bool {get {return (self != Date.distantFuture) && (self != Date.distantPast) }}
    var eindeDag :Date {get {return (dateToFormattedString("yyyyMMdd235959").toDate(yyyyMMddHHmmss))}}
    var beginDag :Date {get {return (dateToFormattedString("yyyyMMdd000001").toDate(yyyyMMddHHmmss))}}
    var dagLong :  String {get {return self.dagLong0()}}
    var dd : String {get {return self.dateToFormattedString("dd")}}
    var d : String {get {return self.dateToFormattedString("d")}}
    var MMMM_yyyy : String {get {return dateToFormattedString("MMMM yyyy")}}
    var dag:String {get {return dateToFormattedString("yyMMdd")}}
    var jaar:String {get {return dateToFormattedString("yy")}}
    var maand:String {get {return dateToFormattedString("yyMM")}}
    var MMMM:String {get {return dateToFormattedString("MMMM")}}
    var MMM:String {get {return dateToFormattedString("MMM")}}
    var yyyy : String {get {return dateToFormattedString("yyyy")}}
    var yyMM : String {get {return dateToFormattedString("yyMM")}}
    var yyyyMM : String {get {return dateToFormattedString("yyyyMM")}}
    var yyyyMMdd : String {get {return dateToFormattedString("yyyyMMdd")}}
    var yy : String {get {return self.dateToFormattedString("yy")}}
    var mm : String {get {return self.dateToFormattedString("MM")}}
    var yyMMddHHmmss : String {get {return self.dateToFormattedString("yyMMddHHmmss")}}
    var yyyyMMddHHmmss : String {get {return self.dateToFormattedString("yyyyMMddHHmmss")}}
    var yyyy_MM_dd_HH_mm_ss : String {get {return self.dateToFormattedString("yyyy-MM-dd HH:mm:ss")}}
    var dd_MM_yyyy_HH_mm : String {get {return self.dateToFormattedString("dd MM yyyy HH:mm")}}
    var dd_MMM_yyyy_HH_mm : String {get {return self.dateToFormattedString("dd MMM yyyy HH:mm")}}
    var yyMMddHHmm : String {get {return self.dateToFormattedString("yyMMddHHmm")}}
    var dd_MM : String {get {return self.dateToFormattedString("dd-MM")}}
    var HHmm : String{get {return self.dateToFormattedString("HH:mm")}}
    var HH_mm_ss : String{get {return self.dateToFormattedString("HH:mm:ss SSS")}}
    var eersteVanDeMaandOm0000 : Date {get {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "yyyyMMdd"
        Formatter.locale = Locale.current
        return Formatter.date(from:self.dateToFormattedString("yyyyMM") + "01")!}
    }
    var laatsteVanDeMaandOm2359 : Date {get {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "yyyyMMdd"
        Formatter.locale = Locale.current
        let work = Formatter.date(from:self.dateToFormattedString("yyyyMM") + "01")!.addingTimeInterval(-1)
        
        let date = Calendar.current.date(byAdding: .month, value: 1, to: work)
        return date!}
    }
    func dateToFormattedString(_ _dateFormat:String)->String
    {
        let Formatter = DateFormatter()
        Formatter.dateFormat = _dateFormat
        
        Formatter.locale = Locale.current
        
        //        print ("\(Locale.current.languageCode)  -- \(Locale.current)")
        return Formatter.string(from: self)
    }
    
    
    
    func ww()->String
    {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "ww"
        Formatter.locale = Locale.current
        return Formatter.string(from: self)
        
    }
    func ee()->String    //returns dag in de week 1...7
    {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "ee"
        Formatter.locale = Locale.current
        return Formatter.string(from: self)
        
    }
    func EE()->String    //returns dag in de week 1...7
    {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "EE"
        Formatter.locale = Locale.current
        return Formatter.string(from: self)
        
    }
    func eee()->String    //returns dag in de week 1...7
    {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "eee"
        Formatter.locale = Locale.current
        return Formatter.string(from: self)
        
    }
    func EEE()->String    //returns dag in de week 1...7
    {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "EEE"
        Formatter.locale = Locale.current
        return Formatter.string(from: self)
        
    }
    func EEEE()->String    //returns dag in de week 1...7
    {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "EEEE"
        Formatter.locale = Locale.current
        return Formatter.string(from: self)
        
    }
    
    func string()->String
    {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "yyMMddhhmmss"
        Formatter.locale = Locale.current
        //        println("dag   --\(Formatter.stringFromDate(self))")
        return Formatter.string(from: self)
        
    }
    
    func maandDagString()->String
    {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "yyMMdd"
        Formatter.locale = Locale.current
        //        println("dag   --\(Formatter.stringFromDate(self))")
        return Formatter.string(from: self)
    }
    func hh_mm()->String
    {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "HH:mm"
        Formatter.locale = Locale.current
        //        println("dag   --\(Formatter.stringFromDate(self))")
        return Formatter.string(from: self)
        
    }
    func DD_hh_mm()->String
    {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "dd-MM HH:mm"
        Formatter.locale = Locale.current
        //        println("dag   --\(Formatter.stringFromDate(self))")
        return Formatter.string(from: self)
        
    }
    
    
}
//func zelfdeDag(_ a:TimeInterval,_ b:TimeInterval)->Bool {return a.datum.yyyyMMdd == b.datum.yyyyMMdd}
//func zelfdeMaand(_ a:TimeInterval,_ b:TimeInterval)->Bool {return a.datum.yyyyMM == b.datum.yyyyMM}

//=============================== String ===================================

extension String{
    var generatingSearchArguments :(van:Date,tot:Date) {get {
        var tot = Date()
        let dc = NSDateComponents()
        let ca = NSCalendar.current
        switch self.count {
        case 4: dc.year = 1 ; dc.second = -1
        case 6:dc.month = 1 ; dc.second = -1
        case 8:dc.day = 1 ; dc.second = -1
        case 14: dc.second = 60
        default: print ("Length Error generatingSearchArguments")
        }
        tot = ca.date(byAdding: dc as DateComponents,to: self.yyyyMMddHHmmssToDate)!
        
        return (self.yyyyMMddHHmmssToDate,tot)}}
    
    var yyyyMMddHHmmssToDate : Date {get {return self.toDate("yyyyMMddHHmmss")}}
    func toDate(_ _dateFormat:String)->Date
    {
        let Formatter = DateFormatter()
        //        Formatter.dateFormat = _dateFormat
        Formatter.dateFormat = "yyyyMMddHHmmss"
        Formatter.locale = Locale.current
        var retValue = self
        while retValue.count < 8 {retValue += "01"}
        while retValue.count < 14 {retValue += "00"}
        while retValue.count > 14 {retValue.removeLast()}
        if let x = Formatter.date(from: retValue){return x}
        else { print ("x= \(retValue)")
            return Formatter.date(from: "19000101000000")!
        }
    }
    public func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    /* creates a image from a string */
    
    func image(ofSize:CGFloat) -> UIImage {
        if self == "" {return UIImage()}
        let size = CGSize(width: ofSize * CGFloat(self.count) , height: ofSize)
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        UIColor.clear.set()
        let rect = CGRect(x:0,y:0 ,width:size.width,height:size.height)
        UIRectFill(rect)
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(ofSize * 0.8))])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    
}
//func datums(van:Date,totEnMet:Date)->[Date]{
//    let Formatter = DateFormatter()
//    Formatter.dateFormat = "yyMMdd"
//    var z = Formatter.date(from: Formatter.string(from:van))!
//    var datumTabel = [Date]()
//    while z < totEnMet {
//        datumTabel.append(z)
//        z = z.addingTimeInterval(24*60*60)
//    }
//    return datumTabel
//}
func datums(van:Date_70,totEnMet:Date_70)->[Date_70]{
    let Formatter = DateFormatter()
    Formatter.dateFormat = "yyMMdd"
    var z = Formatter.date(from: Formatter.string(from:van.date))!
    var datumTabel = [Date_70]()
    while z < totEnMet.date {
        datumTabel.append(Date_70(z.timeIntervalSince1970))
        z = z.addingTimeInterval(24*60*60)
    }
    return datumTabel
}
func aantalDatums(van:Date_70,totEnMet:Date_70)->Int{
    let Formatter = DateFormatter()
    Formatter.dateFormat = "yyMMdd"
    let z = Formatter.date(from: Formatter.string(from:van.date))!.timeIntervalSince(totEnMet.date)
    return Int(z / (24*60*60))
}

