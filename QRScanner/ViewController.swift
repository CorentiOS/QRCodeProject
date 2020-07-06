//
//  ViewController.swift
//  QRScanner v1.0
//
//  Created by Corentin Medina on 06/01/2020.
//  Copyright © 2020 Corentin Medina. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

var obj: [codeCadeau] = []

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var scanBtn: UIButton!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let btnFlash = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanBtn.layer.cornerRadius = 16
        let newObj = codeCadeau(code: "MCDO25", enddate: "08/05/2020", marchant: "Mcdonald's", qrcode: "dleenfnlm", startdate: "01/01/2020", value: "25%")
        obj.append(newObj)
        //saveData()
        loadData()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func setNavigationBar() { //TAB BAR PHOTO
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 64))
        let navItem = UINavigationItem(title: "")
        navBar.tag = 100
        let btnReturn = UIBarButtonItem()
        btnReturn.title = "Close"
        btnReturn.action = #selector(buttonClicked(sender:))
        navItem.rightBarButtonItem = btnReturn
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
        btnFlash.image = UIImage(systemName: "bolt.slash")
        btnFlash.action = #selector(toggleFlash(sender:))
        navItem.leftBarButtonItem = btnFlash
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    @objc func toggleFlash(sender:UIBarButtonItem) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                btnFlash.image = UIImage(systemName: "bolt.slash")
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                    btnFlash.image = UIImage(systemName: "bolt.fill")
                } catch {
                    print(error)
                }
            }
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    //Fermeture fenêtre
    func removeSubview(){
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    
    //Button 'Close'
    @objc func buttonClicked(sender: UIBarButtonItem) {
        scanBtn.isEnabled = true
        stopSession()
    }
    
    //Arrêt capture
    func stopSession() {
        if captureSession.isRunning {
            DispatchQueue.global().async {
                self.captureSession.stopRunning()
            }
        }
        previewLayer.removeFromSuperlayer()
        removeSubview()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //Bouton 'SCANNER'
    @IBAction func tryQR(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
        scanBtn.isEnabled = false
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        //view.layer.insertSublayer(previewLayer!, below: UINavigationBar) //Or below: messageLabel.layer
        setNavigationBar()
        captureSession.startRunning()
    }
    //Téléphone non compatible
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    //SI LE CODE EST VALIDE
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            captureSession.stopRunning()
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            scanBtn.isEnabled = true
            // MARK: - Requête Firebase
            //On lie la base de donnée à la table 'qrCode'
            let refQRPromo = Database.database().reference().child("qrCode")
            //On filtre par la table 'code' et on cherche un élement qui est égal au code scanné
            let queryQRPromo = refQRPromo.queryOrdered(byChild: "code").queryEqual(toValue: stringValue) //on va chercher
            print("***")
            //On regarde ensuite si il y a un résultat
            queryQRPromo.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() { //si un résultat est trouvé
                    print(snapshot)
                    for data in (snapshot.children) {
                        let snap = data as! DataSnapshot
                        let dict = snap.value as! [String : String?]
                        let enddate = dict["enddate"] as? String
                        let end = enddate
                        let dateFormat = "dd/MM/yyyy"
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = dateFormat
                        let endDate = dateFormatter.date(from: end!)
                        let currentDate = Date()
                    
                        if endDate! < currentDate {
                            let alert = UIAlertController(title: "La promotion est expirée", message: "Ce QR code n'est plus valide" , preferredStyle: .alert)
                            self.present(alert, animated: true)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in self.stopSession()
                                self.dismiss(animated: true)
                            }))
                            
                        }
                        else {
                            //On affiche l'alrte de succés
                            let alert = UIAlertController(title: "Votre promotion est valide", message: "" , preferredStyle: .alert)
                            self.present(alert, animated: true)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in self.stopSession()
                                self.dismiss(animated: true)
                            }))
                            
                            
                            //On fait une seconde requête pour trouver si une promotion existe avec ce code QR
                            let refCodeCadeau = Database.database().reference().child("promoCode")
                            let queryQRCadeau = refCodeCadeau.queryOrdered(byChild: "qrcode").queryEqual(toValue: stringValue)
                            queryQRCadeau.observeSingleEvent(of: .value, with: { (snapshot) in
                                print(snapshot)
                                //On va fetch les données de la table dans un Objet de type codeCadeau
                                print(snapshot.childrenCount)
                                for data in (snapshot.children) {
                                    let snap = data as! DataSnapshot
                                    let dict = snap.value as! [String : String?]
                                    let code = dict["code"] as? String
                                    let enddate = dict["enddate"] as? String
                                    let marchantName = dict["marchant"] as? String
                                    let qrcode = dict["qrcode"] as? String
                                    let startdate = dict["startdate"] as? String
                                    let value = dict["value"] as? String
                                    print("le marchant est \(marchantName ?? "null")")
                                    print("Votre promotion avec le code : \(code ?? "") chez \(marchantName ?? "") commence le \(startdate ?? "") et se finit le \(enddate ?? "") avec une promotion de \(value ?? "") / info QR \(qrcode ?? "")")
                                    //Création de l'objet
                                    let newObj = codeCadeau(code: code ?? "", enddate: enddate ?? "", marchant: marchantName ?? "", qrcode: qrcode ?? "", startdate: startdate ?? "", value: value ?? "")
                                    //Ajout dans un tableau d'objet
                                    obj.append(newObj)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                                    //Sauvegarde dans le LocalStorage
                                    self.saveData()
                                }
                            })
                            { (error) in
                                print("erreur: \(error.localizedDescription)")
                            }
                            
                        }
                        
                        
                    }
                    print("** LE CODE QR EST BIEN RECONNU **")
                }
                else {
                    print("** LE CODE QR N'EST PAS RECONNU **")
                    let alert = UIAlertController(title: "Votre promotion n'existe pas", message: "Ce QR code n'est pas valide" , preferredStyle: .alert)
                    print(stringValue)
                    self.present(alert, animated: true)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in self.stopSession()
                        self.dismiss(animated: true)
                    }))
                }
            })
        }
    }
    
    func found(code: String) {
        print(code)
    }
    
    //Chargement des données depuis le LocalStorage
    func loadData() {
        do {
            obj = []
            let storedObjItem = UserDefaults.standard.object(forKey: "items_qr")
            if (storedObjItem != nil) {
                let storedItems = try JSONDecoder().decode([codeCadeau].self, from: storedObjItem as! Data)
                print("Retrieved items: \(storedItems)")
                obj = storedItems
            }
        } catch let err {
            print(err)
        }
    }
    
    //Sauvegarde des données dans le LocalStorage
    func saveData() {
        let items: [codeCadeau] = obj
        //Storing Items
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "items_qr")
            print("C'est saved")
        }
    }
    
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return false
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.bottom
    }
    
    //Portrait Mode Only
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}

