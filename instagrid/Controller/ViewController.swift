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
        addGestureRecognizerToViewWithNotification()
        addGestureRecognizerToImages()
        shadowOnView()
    }
    
    private func addGestureRecognizerToImages() {
        images.forEach({$0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:))))})
    }
    @objc func imageTapped(gesture: UIGestureRecognizer){
        guard let tag = gesture.view?.tag else{return}
        self.tag = tag // self = ViewController properties
        chooseImage()
    }
    
    private func chooseImage() {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true)
        }
    }
    
    private func addGestureRecognizerToViewWithNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(addGestureRecognizerToView), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    @objc func addGestureRecognizerToView(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeUpAnimation(gesture:)))
        if UIApplication.shared.statusBarOrientation.isLandscape {
            swipe.direction = .left
        } else {
            swipe.direction = .up
        }
        layoutView.addGestureRecognizer(swipe)
    }
    @objc func swipeUpAnimation(gesture: UIGestureRecognizer) {
//        let viewPosition = CGPoint(x: self.layoutView.frame.origin.x, y: self.layoutView.frame.origin.y - 600.0)
//        layoutView.frame = CGRect(x: viewPosition.x, y: viewPosition.y, width: self.layoutView.frame.size.width, height: self.layoutView.frame.size.height)
        UIView.animate(withDuration: 1.0, animations: transform)
    }
    
    private func transform(){
        if UIDevice.current.orientation.isLandscape == true {
            layoutView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        }else{
            layoutView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
        }
    }
    
    private func shadowOnView(){
        layoutView.layer.shadowColor = UIColor.black.cgColor
        layoutView.layer.shadowOpacity = 1
        layoutView.layer.shadowOffset = CGSize.zero
        layoutView.layer.shadowRadius = 5
//        layoutView.layer.shadowPath = UIBezierPath(rect: layoutView.bounds).cgPath        // fix the shadow Better for ressources, no good for rotation
    }
    
    func shareImage(){
        let renderer = UIGraphicsImageRenderer(bounds: layoutView.layer.bounds)
        let image = renderer.image { ctx in
            layoutView.layer.render(in: ctx.cgContext)
        }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            present(vc, animated: true)
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
