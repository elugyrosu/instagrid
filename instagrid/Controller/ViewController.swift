//
//  ViewController.swift
//  instagrid
//
//  Created by Jordan MOREAU on 25/03/2019.
//  Copyright © 2019 Jordan MOREAU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: UIViews connections with properties
    
    @IBOutlet weak var layoutView: LayoutView!
    @IBOutlet var styleButtons: [UIButton]!             // The three layout style buttons connected in order
    @IBOutlet var layoutViewImages: [UIImageView]!  // The four layoutView images connected in order
    @IBOutlet weak var shareStackView: UIStackView!     // Label and arrow, to hide during swipe animation
    
    var shareSwipe: UISwipeGestureRecognizer?       // Swipe gesture for sharing layoutView
    var lavanderSwipe: UISwipeGestureRecognizer?    // BONUS - Swipe gesture to change layoutView color
    var blueSwipe: UISwipeGestureRecognizer?        // BONUS - Swipe gesture to change layoutView color
    var oldYellowSwipe: UISwipeGestureRecognizer?   // BONUS - Swipe gesture to change layoutView color
    
    var imageTag: Int?                                             // used for gesture.view?.tag in layout images
    let styleArray: [Style] = [.layout1, .layout2, .layout3]       // used with sender.tag in style buttons

    // MARK: Style buttons (with sender)
    
    @IBAction func DidTapButton(_ sender: UIButton) {   // Action for the three style buttons
        cleanButtons()                          // put all selected property in false
        let tag = sender.tag
        styleButtons[tag].isSelected = true     // change the image of the button selected
        layoutView.style = styleArray[tag]      // change layout style
    }
    private func cleanButtons(){
        for button in styleButtons{
            button.isSelected = false
        }
    }
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {  // start
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        layoutView.style = .layout2
        addGestureRecognizerToImages()
        shareSwipe = UISwipeGestureRecognizer(target: self, action: #selector(shareSwipeAnimation(gesture:)))   // One swipe action/animation = One swipe direction = One swipeGestureRecognizer
        lavanderSwipe = UISwipeGestureRecognizer(target: self, action: #selector(lavanderSwipeEffect(gesture:)))
        blueSwipe = UISwipeGestureRecognizer(target: self, action: #selector(blueSwipeEffect(gesture:)))
        oldYellowSwipe = UISwipeGestureRecognizer(target: self, action: #selector(oldYellowSwipeEffect(gesture:)))
        changeSwipeDirectionWithNotification()
    }
    private func shadowOnView(){    // a simple shadow for layoutView
        layoutView.layer.shadowColor = UIColor.black.cgColor
        layoutView.layer.shadowOpacity = 0.5
        layoutView.layer.shadowOffset = CGSize.zero
        layoutView.layer.shadowRadius = 3
    }
    
    // MARK: tapGestureRecognizer for layout images
    
    private func addGestureRecognizerToImages() { // Apply TapGestureRecognizer for all layour images
        layoutViewImages.forEach({$0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:))))})
    }
    @objc func imageTapped(gesture: UIGestureRecognizer){
        guard let tag = gesture.view?.tag else{return} //
        self.imageTag = tag // self = ViewController properties
        chooseImage()
    }
    private func chooseImage() { // Use UIImagePickerController in extension
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {   // check first, Only in photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true)
        }
    }
    
    // MARK: Swipes direction with orientation observer
    
    private func changeSwipeDirectionWithNotification() {    // Use device orientation observer with notifications
        NotificationCenter.default.addObserver(self, selector: #selector(changeGestureDirection), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    @objc func changeGestureDirection(){    // modify direction for the four swipeGesture
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            shareSwipe?.direction = .left
            lavanderSwipe?.direction = .down
            blueSwipe?.direction = .right
            oldYellowSwipe?.direction = .up
        } else {
            shareSwipe?.direction = .up
            lavanderSwipe?.direction = .left
            blueSwipe?.direction = .down
            oldYellowSwipe?.direction = .right
        }
        guard let shareSwipe = shareSwipe, let whiteSwipe = lavanderSwipe, let blueSwipe = blueSwipe, let oldYellowSwipe = oldYellowSwipe  else {return}
        layoutView.addGestureRecognizer(shareSwipe) // Apply all swipes to view
        layoutView.addGestureRecognizer(whiteSwipe)
        layoutView.addGestureRecognizer(blueSwipe)
        layoutView.addGestureRecognizer(oldYellowSwipe)
    }

    // MARK: Swipes action/animation
    
    @objc func shareSwipeAnimation(gesture: UIGestureRecognizer) {
        self.shareStackView.isHidden = true
        UIView.animate(withDuration: 1.0, animations: transform)
        shareImage()
    }
    private func transform(){   // translation with orientation
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
            self.resetViews()
        }   // the layoutView respawn after share activity is complete/cancel
    }
    private func resetViews(){
        UIView.animate(withDuration: 1, animations: {
            self.layoutView.transform = .identity
            self.shareStackView.isHidden = false
        })
    }
    @objc func lavanderSwipeEffect(gesture: UIGestureRecognizer) {
        layoutView.backgroundColor = #colorLiteral(red: 0.8587709069, green: 0.8426139951, blue: 0.9519020915, alpha: 1)
    }
    @objc func blueSwipeEffect(gesture: UIGestureRecognizer) {
        layoutView.backgroundColor = #colorLiteral(red: 0.1080091074, green: 0.3894751668, blue: 0.6092520952, alpha: 1)
    }
    @objc func oldYellowSwipeEffect(gesture: UIGestureRecognizer) {
        layoutView.backgroundColor = #colorLiteral(red: 0.9699423362, green: 0.9058819421, blue: 0.7772409532, alpha: 1)
    }
}

    // MARK: - UIImagePickerController

extension ViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if info[UIImagePickerController.InfoKey.originalImage] != nil {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                guard let tag = imageTag else {return}
                layoutViewImages[tag].image = image
            }
        }
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
