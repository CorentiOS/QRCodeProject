//
//  myClass.swift
//  QRScanner
//
//  Created by Corentin Medina on 09/03/2020.
//  QRScanner v1.0 © 2020 Corentin Medina. All rights reserved.
//

import Foundation

class codeCadeau : Codable {
    
    var code:String = "";
    var enddate:String = "";
    var marchant:String = "";
    var qrcode:String = "";
    var startdate:String = "";
    var value:String = "";
    
    init(code:String, enddate:String, marchant:String, qrcode:String, startdate:String, value:String) {
        self.code = code
        self.enddate = enddate
        self.marchant = marchant
        self.qrcode = qrcode
        self.startdate = startdate
        self.value = value
    }
    
    

}
