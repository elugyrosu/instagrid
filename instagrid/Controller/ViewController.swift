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
        let imagePicked = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicked.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicked.modalPresentationStyle = .overCurrentContext
            present(imagePicked, animated: true, completion: nil)
//            imagePicked.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate

//            imagePicked.allowsEditing = false
//            imagePicked.delegate = self


//            imagePicked.sourceType = .photoLibrary
//            present(imagePicked, animated: true, completion: nil)
//            imagePickerController(picker: imagePicked, didFinishPickingImage: images[tag], tag: tag)


        }
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

