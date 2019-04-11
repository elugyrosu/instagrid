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
    
    @IBOutlet var layoutViewImages: [UIImageView]!
    var shareSwipe: UISwipeGestureRecognizer?
    var whiteSwipe: UISwipeGestureRecognizer?
    var blueSwipe: UISwipeGestureRecognizer?
    var oldYellowSwipe: UISwipeGestureRecognizer?

    var tag: Int?
    let myArray: [Style] = [.layout1, .layout2, .layout3]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addGestureRecognizerToViewWithNotification()
        addGestureRecognizerToImages()
        shadowOnView()
        shareSwipe = UISwipeGestureRecognizer(target: self, action: #selector(shareSwipeAnimation(gesture:)))
        whiteSwipe = UISwipeGestureRecognizer(target: self, action: #selector(whiteSwipeEffect(gesture:)))
        blueSwipe = UISwipeGestureRecognizer(target: self, action: #selector(blueSwipeEffect(gesture:)))
        oldYellowSwipe = UISwipeGestureRecognizer(target: self, action: #selector(oldYellowSwipeEffect(gesture:)))
    }
    
    private func addGestureRecognizerToImages() {
        layoutViewImages.forEach({$0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:))))})
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
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            shareSwipe?.direction = .left
            whiteSwipe?.direction = .down
            blueSwipe?.direction = .right
            oldYellowSwipe?.direction = .up
        } else {
            shareSwipe?.direction = .up
            whiteSwipe?.direction = .left
            blueSwipe?.direction = .down
            oldYellowSwipe?.direction = .right
        }
        guard let shareSwipe = shareSwipe, let whiteSwipe = whiteSwipe, let blueSwipe = blueSwipe, let oldYellowSwipe = oldYellowSwipe  else {return}
        layoutView.addGestureRecognizer(shareSwipe)
        layoutView.addGestureRecognizer(whiteSwipe)
        layoutView.addGestureRecognizer(blueSwipe)
        layoutView.addGestureRecognizer(oldYellowSwipe)

    }
    @objc func shareSwipeAnimation(gesture: UIGestureRecognizer) {
        UIView.animate(withDuration: 1.0, animations: transform)
        shareImage()
    }
    @objc func whiteSwipeEffect(gesture: UIGestureRecognizer) {
        layoutView.backgroundColor = #colorLiteral(red: 0.8587709069, green: 0.8426139951, blue: 0.9519020915, alpha: 1)
    }
    @objc func blueSwipeEffect(gesture: UIGestureRecognizer) {
        layoutView.backgroundColor = #colorLiteral(red: 0.1080091074, green: 0.3894751668, blue: 0.6092520952, alpha: 1)
    }
    @objc func oldYellowSwipeEffect(gesture: UIGestureRecognizer) {
        layoutView.backgroundColor = #colorLiteral(red: 0.9699423362, green: 0.9058819421, blue: 0.7772409532, alpha: 1)
    }
    
    
    
//    @objc func swipeUpAnimation(gesture: UIGestureRecognizer) {
//        UIView.animate(withDuration: 1.0,
//                       animations:{
//                        self.transform()
//        },
//                       completion:{ _ in
//                        UIView.animate(withDuration: 1.0) {
//                            self.layoutView.transform = .identity
//                        }
//        })
//        shareImage()
//    }

        
    
    private func transform(){
        if UIDevice.current.orientation.isLandscape == true {
            layoutView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        }else{
            layoutView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
        }
    }
    private func shareImage(){
        let renderer = UIGraphicsImageRenderer(bounds: layoutView.layer.bounds)
        let image = renderer.image { ctx in
            layoutView.layer.render(in: ctx.cgContext)
        }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: [])
        present(share, animated: true)
        share.completionWithItemsHandler = { activity, completed, item, error in
            self.resetLayoutView()
        }
    }                                                                   // à optimiser
    
    private func resetLayoutView(){
        UIView.animate(withDuration: 0, animations: {
            self.layoutView.transform = .identity
        })
    }

    
    private func shadowOnView(){
        layoutView.layer.shadowColor = UIColor.black.cgColor
        layoutView.layer.shadowOpacity = 0.5
        layoutView.layer.shadowOffset = CGSize.zero
        layoutView.layer.shadowRadius = 3
//        layoutView.layer.shadowPath = UIBezierPath(rect: layoutView.bounds).cgPath        // fix the shadow Better for ressources, no good for rotation
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
                layoutViewImages[tag].image = image
            }
        }
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
