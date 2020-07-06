//
//  CodeListTableViewController.swift
//  QRScanner v1.0
//
//  Created by Corentin Medina on 15/01/2020.
//  Copyright © 2020 Corentin Medina. All rights reserved.
//

import UIKit
import Firebase

class CodeListTableViewController: UITableViewController {
    func viewWillappear() {
        reloadAllData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let newObj = codeCadeau(code: "MCDO25", enddate: "08/05/2020", marchant: "Mcdonald's", qrcode: "dleenfnlm", startdate: "01/01/2020", value: "25%")
        //obj.append(newObj)
        loadData()
        
        
        reloadAllData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAllData), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    func loadData() {
        do {
            obj = []
            let storedObjItem = UserDefaults.standard.object(forKey: "items_qr")
            if (storedObjItem != nil) {
                let storedItems = try JSONDecoder().decode([codeCadeau].self, from: storedObjItem as! Data)
                print("Retrieved items: \(storedItems)")
                obj = storedItems.sorted(by: {$0.marchant < $1.marchant})
            }
        } catch let err {
            print(err)
        }   
    }
    
    func saveData() {
        let items: [codeCadeau] = obj
        //Storing Items
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "items_qr")
        }
    }
    

    
    @objc func reloadAllData() {
        tableView.reloadData()
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        reloadAllData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return obj.count //retourne le nombre de cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "codeCell", for: indexPath)
        cell.contentView.layer.cornerRadius = 25
        cell.contentView.layer.masksToBounds = false
        
        
        
        
        //let objData = UserDefaults.standard.object(forKey: "obj") as? NSData
        //let placesArray = NSKeyedUnarchiver.unarchiveObject(with: objData as! Data) as? [codeCadeau]
        
        
        
        
        let end = obj[indexPath.row].enddate
        let dateFormat = "dd/MM/yyyy"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        let endDate = dateFormatter.date(from: end)
        
        let currentDate = Date()
        
        cell.textLabel?.text = obj[indexPath.row].marchant
        cell.detailTextLabel?.text = obj[indexPath.row].value
        
        let calendar = Calendar.current
        let firstDate = currentDate
        let secondDate = endDate

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate!)
        
        
        let remainingDays = calendar.dateComponents([.day], from: date1, to: date2)
        
        if endDate! < currentDate {
            print("Expired ❌")
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.text = "Expired"
            //cell.accessoryType = .none
            //cell.isUserInteractionEnabled = false
        }
        else if (remainingDays.day! <= 5) {
            cell.textLabel?.textColor = UIColor.orange
            cell.detailTextLabel?.textColor = UIColor.orange
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "HistoryDetailViewController") as?  HistoryDetailViewController
        //ce qui va être push
        vc?._marchantName = obj[indexPath.row].marchant
        vc?._reductionPercent = obj[indexPath.row].value
        vc?._promoCode = obj[indexPath.row].code
        vc?._startDate = obj[indexPath.row].startdate
        vc?._endDate = obj[indexPath.row].enddate
        //vc?.labelDescription.text = cars[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            obj.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
