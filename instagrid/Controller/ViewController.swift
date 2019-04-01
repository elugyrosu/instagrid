//
//  ViewController.swift
//  instagrid
//
//  Created by Jordan MOREAU on 25/03/2019.
//  Copyright © 2019 Jordan MOREAU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var layoutView: LayoutView!

    @IBOutlet var styleButtons: [UIButton]!
    
    @IBOutlet var images: [UIImageView]!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addGestureRecognizer()
        
        
        
        
        
    }
    
    private func addGestureRecognizer() {
        images.forEach({$0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:))))})
        
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer){
        guard let tag = gesture.view?.tag else{return}

        chooseImage(tag: tag)
        
        
    }

    func chooseImage(tag: Int) {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
//            UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        
            imagePicker.allowsEditing = false
//            present(imagePicker, animated: true, completion: nil)
//            self.present(imagePicker, animated: true, completion: {self.imagePicker.delegate = self.images[tag] as? UIImagePickerControllerDelegate & UINavigationControllerDelegate })
//            PHPhotoLibrary.requestAuthorization { (status) in
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true)}
                images[tag] = imagePicker.
        
                
        
    }

    
    
    
    @IBAction func didTapButton1() {
        clearButtons()
        layoutView.style = .layout1
        styleButtons[0].isSelected = true
    }
    
    @IBAction func didTapButton2() {
        clearButtons()
        layoutView.style = .layout2
        styleButtons[1].isSelected = true
    }
    
    @IBAction func didTapButton3() {
        clearButtons()
        layoutView.style = .layout3
        styleButtons[2].isSelected = true
    }
    
    private func clearButtons(){
        for button in styleButtons{
            button.isSelected = false
        }
        
        
    }
    
    
}

extension ViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if info[UIImagePickerController.InfoKey.originalImage] != nil {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                guard let tag2 = picker.view?.tag else {return}
                images[tag2].image = image
            }
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
