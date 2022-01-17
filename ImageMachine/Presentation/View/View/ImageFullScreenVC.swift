//
//  ImageFullScreenVC.swift
//  ImageMachine
//
//  Created by mac on 17/1/22.
//

import UIKit
import SDWebImage

class ImageFullScreenVC: UIViewController {

    @IBOutlet weak var contenImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var viewBack: UIView!
    
    var url: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.contenImage.sd_setImage(with: URL(string: url ?? ""), completed: nil)
        setupTap()
    }
    
    func setupTap() {
        MainHelper.onTap(self, viewBack, #selector(backImage(_:)))
    }

}

extension ImageFullScreenVC {
    
    @objc func backImage(_ uigestrure: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
