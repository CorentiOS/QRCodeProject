//
//  HistoryDetailViewController.swift
//  QRScanner
//
//  Created by Corentin Medina on 03/02/2020.
//  Copyright © 2020 Corentin Medina. All rights reserved.
//

import UIKit

class HistoryDetailViewController: UIViewController {
    
    @IBOutlet weak var marchantName: UILabel!
    @IBOutlet weak var reductionPercent: UILabel!
    @IBOutlet weak var promoCode: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var btnCopy: UIButton!
    
    
    var _marchantName = ""
    var _reductionPercent = ""
    var _promoCode = ""
    var _startDate = ""
    var _endDate = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCopy.layer.cornerRadius = 5
        
        marchantName.layer.cornerRadius = 8
        marchantName.layer.masksToBounds = true
        
        reductionPercent.layer.cornerRadius = 8
        reductionPercent.layer.masksToBounds = true
        
        promoCode.layer.cornerRadius = 8
        promoCode.layer.masksToBounds = true
        
        startDate.layer.cornerRadius = 8
        startDate.layer.masksToBounds = true
        
        endDate.layer.cornerRadius = 8
        endDate.layer.masksToBounds = true
        
        marchantName.text = _marchantName
        reductionPercent.text = _reductionPercent
        promoCode.text = _promoCode
        startDate.text = _startDate
        endDate.text = _endDate
        
        let end = _endDate
        let dateFormat = "dd/MM/yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let endDateStr = dateFormatter.date(from: end)
        let currentDate = Date()
        let calendar = Calendar.current
        let firstDate = currentDate
        let secondDate = endDateStr
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate!)
        let remainingDays = calendar.dateComponents([.day], from: date1, to: date2)
        if endDateStr! < currentDate {
            marchantName.textColor = UIColor.gray
            reductionPercent.textColor = UIColor.gray
            promoCode.textColor = UIColor.gray
            startDate.textColor = UIColor.gray
            endDate.textColor = UIColor.gray
            promoCode.text = "Expired"
            btnCopy.isEnabled = false
            btnCopy.setTitle("Your promotion is expired", for: .disabled)
            btnCopy.backgroundColor = UIColor.red
        } else if (remainingDays.day! <= 5) {
            endDate.textColor = UIColor.orange
        }
        
        
    }
    
    @IBAction func btnPressCopy(_ sender: Any) {
        let board = UIPasteboard.general
        board.string = promoCode.text
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:))
    }
    
    
    
    // MARK: - Navigation
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
