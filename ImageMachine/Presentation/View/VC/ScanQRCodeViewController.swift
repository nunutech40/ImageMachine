//
//  ScanQRCodeViewController.swift
//  ImageMachine
//
//  Created by mac on 16/1/22.
//

import UIKit
import MercariQRScanner

class ScanQRCodeViewController: UIViewController {

    @IBOutlet weak var scanView: QRScannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
    }
    
    func setupData() {
        scanView.configure(delegate: self)
        scanView.startRunning()
    }

}

extension ScanQRCodeViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
        scanView.stopRunning()
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        scanView.stopRunning()
        self.navigationController?.popViewController(animated: true)
    }
}

