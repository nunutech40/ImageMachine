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
    
    var viewModel: ScanQRCodeViewModel?
    var machineId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInjection()
        self.setupData()
    }
    
    func setupInjection() {
        let inject = Injection.init().provideRepository()
        self.viewModel = ScanQRCodeViewModel(repository: inject)
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
        
        
        self.viewModel?.getMcahineDataByQrCode(qrCode: code, self, completion: { isTrue in
            
            if !isTrue {
                let alert = UIAlertController(title: "Info", message: "QR Code Not Founded", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                let destVC = MainHelper.instantiateVC(UIStoryboard(name: "Main", bundle: nil), "MachineDataDetailViewController") as! MachineDataDetailViewController
                destVC.machineId = self.viewModel?.machineDatalist[0].machineId
                self.navigationController?.pushViewController(destVC, animated: true)
            }
        })
    }
}

