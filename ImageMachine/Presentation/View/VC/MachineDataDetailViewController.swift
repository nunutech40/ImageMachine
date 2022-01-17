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
import SDWebImage

class MachineDataDetailViewController: UIViewController {
    
    // OUTLET HERE
    @IBOutlet weak var machineDataId: UILabel!
    @IBOutlet weak var machineDataName: UILabel!
    @IBOutlet weak var machineDataType: UILabel!
    @IBOutlet weak var machineDataQRCode: UILabel!
    @IBOutlet weak var editNamaIcon: UIImageView!
    @IBOutlet weak var editTypeIcon: UIImageView!
    @IBOutlet weak var editQRCodeIcon: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var updateMaintenanceTxt: UITextField!
    
    // VARIABLE HERE
    var machineId: Int?
    private var disposeBag = DisposeBag()
    var viewModel: MachineDataDetailViewModel?
    var selectedAssets = [TLPHAsset]()
    var multipleSelect = false
    var selectedItems = [IndexPath]()
    var dataChanged = BehaviorRelay<[IndexPath]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInjection()
        self.setupNavBar()
        self.setupData()
        self.setupCollectionView()
        self.setupView()
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
    
    func setupRightIcon(isMultipleSelect: Bool) {
        self.multipleSelect = isMultipleSelect
        if multipleSelect {
            let itemRight = UIBarButtonItem(title: "Done Edit", style: .plain, target: self, action: #selector(rightTapNavBar))
            self.navigationItem.setRightBarButton(itemRight, animated: true)
        } else {
            let itemRight = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(rightTapNavBar))
            self.navigationItem.setRightBarButton(itemRight, animated: true)
        }
        
    }
    
    func setupData() {
        self.viewModel?.getMcahineDataById(id: "\(self.machineId ?? 0)", self)
    }
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    func setupView() {
        // setup right icon in textinput date mainetenance
        updateMaintenanceTxt.rightViewMode = .always
        let iconCalender = UIImage(named: "calender")
        updateMaintenanceTxt.rightView = UIImageView(image: iconCalender)
    }
    
    func setupTap() {
        MainHelper.onTap(self, editNamaIcon, #selector(tapEditNama(_:)))
        MainHelper.onTap(self, editTypeIcon, #selector(tapEditType(_:)))
        MainHelper.onTap(self, editQRCodeIcon, #selector(tapEditQRCode(_:)))
        DateHelper.setInputView(self, self.updateMaintenanceTxt, #selector(handleDatePicker(senderUI:)))
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
    
    @IBAction func deleteImageButton(_ sender: Any) {
        
        let objc = self.viewModel?.machineDatalist.filter {
            $0.machineId == self.machineId ?? 0
        }
        
        if selectedItems.count < 1 {
            let alert = UIAlertController(title: "Info Delete", message: "Please select image for deleted", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
        } else {
            
            // get full array image
            var fullAray = objc?[0].urlPaths.map { $0 }
            
            // get data deleted image
            let deletedData = self.selectedItems.map {
                objc?[0].urlPaths[$0.row]
            }
            // get result fullaray after deleted
            fullAray = fullAray?.filter { !deletedData.contains($0) }
            
            var newMachineData = MachineDataModel()
            newMachineData.machineId = self.machineId ?? 0
            newMachineData.machineName = self.viewModel?.machineDatalist[0].machineName
            newMachineData.machineType = self.viewModel?.machineDatalist[0].machineType
            newMachineData.machineQRCode = self.viewModel?.machineDatalist[0].machineQRCode
            newMachineData.urlPaths = fullAray ?? []
            
            let alert = UIAlertController(title: "Delete", message: "Delete?", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.viewModel?.updateDataById(id: "\(self.machineId ?? 0)", machineData: newMachineData, self)
                self.selectedItems.removeAll()
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            present(alert, animated: true, completion: nil)
           
        }
    }
}

extension MachineDataDetailViewController {
    
    @objc func rightTapNavBar(_ gestureTap: UITapGestureRecognizer) {
        self.setupRightIcon(isMultipleSelect: !multipleSelect)
        collectionView.allowsMultipleSelection = self.multipleSelect
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
    
    @objc func handleDatePicker(senderUI: UIDatePicker) {
        self.updateMaintenanceTxt.text                = DateHelper.localFormatter("dd/MM/yyyy").string(from: senderUI.date)
        
        if let datePick = self.updateMaintenanceTxt.text {
            var machineDataModel = MachineDataModel()
            machineDataModel.machineId = self.machineId ?? 0
            machineDataModel.machineName = self.viewModel?.machineDatalist[0].machineName
            machineDataModel.machineType = self.viewModel?.machineDatalist[0].machineType
            machineDataModel.machineQRCode = self.viewModel?.machineDatalist[0].machineQRCode
            machineDataModel.updateAt = datePick
            self.viewModel?.updateDataById(id: "\(self.machineId ?? 0)", machineData: machineDataModel, self)
        }
        
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
            if statusEdit == "qrcode" {
                textInput.keyboardType = .numberPad
            }
        }
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            let textFieldName = alert.textFields![0]
            
            var machineDataModel = MachineDataModel()
            machineDataModel.machineId = self.machineId ?? 0
            machineDataModel.machineName = self.viewModel?.machineDatalist[0].machineName
            machineDataModel.machineType = self.viewModel?.machineDatalist[0].machineType
            machineDataModel.machineQRCode = self.viewModel?.machineDatalist[0].machineQRCode
            machineDataModel.updateAt = self.viewModel?.machineDatalist[0].updateAt ?? ""
            if let strText = textFieldName.text {
                switch statusEdit {
                case "name":
                    machineDataModel.machineName = strText
                case "type":
                    machineDataModel.machineType = strText
                case "qrcode":
                    
                    self.viewModel?.getMcahineDataByQrCode(qrCode: strText, self, completion: { isTrue in
                        if !isTrue {
                            let alert = UIAlertController(title: "Delete", message: "QR Code already in database or you not input QRCode, please insert another qrcode?", preferredStyle: UIAlertController.Style.alert)

                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                            self.present(alert, animated: true, completion: nil)
                        } else {
                            machineDataModel.machineQRCode = strText
                        }
                    })
                   
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
        let convertToPHAsset: [PHAsset] = self.selectedAssets.map{ $0.phAsset! }
        var urlPaths = [String]()
        
        var newMachineData = MachineDataModel()
        newMachineData.machineId = self.machineId ?? 0
        newMachineData.machineName = self.viewModel?.machineDatalist[0].machineName
        newMachineData.machineType = self.viewModel?.machineDatalist[0].machineType
        newMachineData.machineQRCode = self.viewModel?.machineDatalist[0].machineQRCode
        for asset: PHAsset in convertToPHAsset {
            asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (eidtingInput, info) in
                if let input = eidtingInput, let photoUrl = input.fullSizeImageURL {
                    urlPaths.append(photoUrl.absoluteString)
                    
                    newMachineData.urlPaths = urlPaths
                    self.viewModel?.updateDataById(id: "\(self.machineId ?? 0)", machineData: newMachineData, self)
                   
                }
            }
        }
        self.setupData()
        self.collectionView.reloadData()
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

extension MachineDataDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.machineDatalist[section].urlPaths.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCollectionViewCell", for: indexPath) as! MediaCollectionViewCell
        let data = self.viewModel?.machineDatalist[indexPath.section].urlPaths[indexPath.row]
        cell.mediaImage.sd_setImage(with: URL(string: data ?? ""), placeholderImage: UIImage(named: "mediaBerkas"))
        cell.configure()
        cell.mediaImage.contentMode = .scaleAspectFill
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.viewModel?.machineDatalist[indexPath.section].urlPaths[indexPath.row]
        if !multipleSelect {
            
            DispatchQueue.main.async {
                let destVc                      = MainHelper.instantiateVC(UIStoryboard(name: "Main", bundle: nil), "ImageFullScreenVC") as! ImageFullScreenVC
                destVc.modalPresentationStyle = .overFullScreen
                destVc.url = data
                self.present(destVc, animated: false, completion: nil)
            }
        } else {
            guard let item = collectionView.indexPathsForSelectedItems else {
                return
            }
            self.selectedItems = item
        }
    }
    
}

extension MachineDataDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumLineSpacing = 3
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset.right = 3
        flowLayout.sectionInset.left  = 3
        let totalspace = flowLayout.sectionInset.right + flowLayout.sectionInset.left
            + (flowLayout.minimumLineSpacing * CGFloat(1))
        let size = Int((collectionView.frame.size.width - totalspace)/4)
        let height =  Double(size)
        return CGSize(width: size, height: Int(height))
    }
}

class MediaCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var viewScreen: UIView!
    
    func configure() {
        self.viewScreen.isHidden = true
    }
    override var isSelected: Bool {
            didSet {
                if self.isSelected {
                    self.viewScreen.isHidden = false
                }
                else {
                    self.viewScreen.isHidden = true
                }
            }
        }
    
}
