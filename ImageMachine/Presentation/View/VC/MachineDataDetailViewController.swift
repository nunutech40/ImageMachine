//
//  MachineDataDetailViewController.swift
//  ImageMachine
//
//  Created by mac on 15/1/22.
//

import UIKit
import RxSwift
import RxCocoa
import TLPhotoPicker
import Photos
import CoreLocation

class MachineDataDetailViewController: UIViewController {
    
    // OUTLET HERE
    @IBOutlet weak var machineDataId: UILabel!
    @IBOutlet weak var machineDataName: UILabel!
    @IBOutlet weak var machineDataType: UILabel!
    @IBOutlet weak var machineDataQRCode: UILabel!
    @IBOutlet weak var editNamaIcon: UIImageView!
    @IBOutlet weak var editTypeIcon: UIImageView!
    @IBOutlet weak var editQRCodeIcon: UIImageView!
    @IBOutlet weak var testImage: UIImageView!
    
    // VARIABLE HERE
    var machineId: Int?
    private var disposeBag = DisposeBag()
    var viewModel: MachineDataDetailViewModel?
    var selectedAssets = [TLPHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInjection()
        self.setupNavBar()
        self.setupData()
        self.setupTap()
    }
    
    func setupInjection() {
        let inject = Injection.init().provideRepository()
        self.viewModel = MachineDataDetailViewModel(repository: inject)
    }
    
    func setupNavBar() {
        self.navigationItem.title = "Machinde Data Detail"
        
        let itemRight = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(rightTapNavBar))
        self.navigationItem.setRightBarButton(itemRight, animated: true)
    }
    
    func setupData() {
        self.viewModel?.getMcahineDataById(id: "\(self.machineId ?? 0)", self)
    }
    
    func setupTap() {
        MainHelper.onTap(self, editNamaIcon, #selector(tapEditNama(_:)))
        MainHelper.onTap(self, editTypeIcon, #selector(tapEditType(_:)))
        MainHelper.onTap(self, editQRCodeIcon, #selector(tapEditQRCode(_:)))
    }
    
    @IBAction func chooseImageButton(_ sender: Any) {
        let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        var configure = TLPhotosPickerConfigure()
        configure.maxSelectedAssets = 10
        configure.allowedVideo = false
        configure.usedCameraButton = false
        viewController.configure = configure
        viewController.selectedAssets = self.selectedAssets
        
        self.present(viewController, animated: true, completion: nil)
    }
    
}

extension MachineDataDetailViewController {
    
    @objc func rightTapNavBar(_ gestureTap: UITapGestureRecognizer) {
        print("cekkk right")
    }
    
    @objc func tapEditNama(_ gesture: UITapGestureRecognizer) {
        self.inputTextAlert(message: "Edit Your Name Machine Data", placeholder: "Input New Name...", statusEdit: "name")
    }
    
    @objc func tapEditType(_ gesture: UITapGestureRecognizer) {
        self.inputTextAlert(message: "Edit Your Type Machine Data", placeholder: "Input New Type...", statusEdit: "type")
    }
    
    @objc func tapEditQRCode(_ gesture: UITapGestureRecognizer) {
        self.inputTextAlert(message: "Edit Your QRCode Machine Data", placeholder: "Input New QRCode Number", statusEdit: "qrcode")
    }
    
    
    
    func inputTextAlert(
        message: String,
        placeholder: String?,
        statusEdit: String?
    ) {
        let alert = UIAlertController(title: "Edit", message: message, preferredStyle: .alert)
        alert.addTextField { (textInput) in
            textInput.text = ""
            textInput.placeholder = placeholder
        }
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            let textFieldName = alert.textFields![0]
            
            var machineDataModel = MachineDataModel()
            machineDataModel.machineId = self.machineId ?? 0
            machineDataModel.machineName = self.viewModel?.machineDatalist[0].machineName
            machineDataModel.machineType = self.viewModel?.machineDatalist[0].machineType
            machineDataModel.machineQRCode = self.viewModel?.machineDatalist[0].machineQRCode
            
            if let strText = textFieldName.text {
                switch statusEdit {
                case "name":
                    machineDataModel.machineName = strText
                case "type":
                    machineDataModel.machineType = strText
                case "qrcode":
                    machineDataModel.machineQRCode = strText
                default:
                    print("do nothing")
                }
                self.viewModel?.updateDataById(id: "\(self.machineId ?? 0)", machineData: machineDataModel, self)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Nothing");
        }
        
        alert.addAction(OKAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension MachineDataDetailViewController: TLPhotosPickerViewControllerDelegate {
    
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets
        //self.selectedAssets[0].fullResolutionImage
        //self.testImage.image = self.selectedAssets[0].fullResolutionImage
        let urlPath = MachineDataDetailViewController.saveImageInDocumentDirectory(image: self.selectedAssets[0].fullResolutionImage!, fileName: "testImage2")
        self.testImage.image =  MachineDataDetailViewController.loadImageFromDocumentDirectory(fileName: "testImage2")
        return true
    }
    
    public static func saveImageInDocumentDirectory(image: UIImage, fileName: String) -> URL? {
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.pngData() {
            try? imageData.write(to: fileURL, options: .atomic)
            return fileURL
        }
        return nil
    }
    
    public static func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {}
        return nil
    }
}


extension PHAsset {
    
    var thumbnailImage : UIImage {
        get {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnail = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: self, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
            })
            return thumbnail
        }
    }
}
