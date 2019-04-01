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

    var tag: Int?
    let myArray: [Style] = [.layout1, .layout2, .layout3]

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
        self.tag = tag // self = ViewController properties
        chooseImage()
    }

    func chooseImage() {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true)
        }
    }
    
    @IBAction func DidTapButton(_ sender: UIButton) {
        clearButtons()
        let tag = sender.tag
        styleButtons[tag].isSelected = true
        layoutView.style = myArray[tag]
    }
    
    private func clearButtons(){
        for button in styleButtons{
            button.isSelected = false
        }
    }
}
// MARK: - UIImagePickerController
extension ViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if info[UIImagePickerController.InfoKey.originalImage] != nil {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                guard let tag = tag else {return}
                images[tag].image = image
            }
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
