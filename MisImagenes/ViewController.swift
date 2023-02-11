//
//  ViewController.swift
//  MisImagenes
//
//  Created by Ángel González on 11/02/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imgPickCon : UIImagePickerController?
    let btnFoto = UIButton()
    let imgContainer = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imgContainer.frame = CGRect(x:0, y:50, width:view.bounds.width, height: view.bounds.height / 2)
        imgContainer.backgroundColor = .cyan.withAlphaComponent(0.5)
        view.addSubview(imgContainer)
        btnFoto.frame = CGRect(x:20, y:imgContainer.frame.maxY + 10, width:44, height
                               :44)
        btnFoto.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        btnFoto.addTarget(self, action:#selector(btnFotoTouch), for:.touchUpInside)
        view.addSubview(btnFoto)
    }

    @objc func btnFotoTouch() {
        imgPickCon = UIImagePickerController()
        imgPickCon?.delegate = self
        // si se permite la edición (recorte) de las imagenes
        imgPickCon?.allowsEditing = true
        //
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            switch AVCaptureDevice.authorizationStatus(for:.video) {
            case .authorized:self.launchIMGPC(.camera)
            case .notDetermined:AVCaptureDevice.requestAccess (for: .video) { permiso in
                                    if permiso {
                                        self.launchIMGPC(.camera)
                                    }
                                    else {
                                        self.launchIMGPC(.photoLibrary)
                                    }
                                }
            default:
                permisos()
                return
            }
        }
        else {
            self.launchIMGPC(.photoLibrary)
        }
    }
    
    func permisos () {
        let ac = UIAlertController(title: "", message:"Se requiere permiso para usar la cámara. Puede configurarlo desde settings ahora", preferredStyle: .alert)
        let action = UIAlertAction(title: "SI", style: .default) {
            alertaction in
            if let laURL = URL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.open(laURL)
            }
        }
        let action2 = UIAlertAction(title: "NO", style: .destructive)
        ac.addAction(action)
        ac.addAction(action2)
        self.present(ac, animated: true)
    }
    
    func launchIMGPC (_ type:UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            self.imgPickCon?.sourceType = type
            self.present(self.imgPickCon!, animated: true)
        }
    }
    
    // MARK: - ImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // si NO se permite la edición (recorte) de las imagenes se usaria la llave .originalImage
        if let img = info[.editedImage] as? UIImage {
            imgContainer.image = img
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        imgContainer.image = UIImage()
    }
}

