//
//  ViewController.swift
//  MemeMeV1
//
//  Created by Michael Miller on 1/16/16.
//  Copyright © 2016 MikeMiller. All rights reserved.
//

import UIKit
import MobileCoreServices

class MemeEditorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //MARK: OUTLETS
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: PROPERTIES
    var barSpace: UIBarButtonItem!
    var cameraButton: UIBarButtonItem!
    var albumButton: UIBarButtonItem!
    var resizeButton: UIBarButtonItem!
    
    //MARK: CONSTANTS
    let memeTextAttributes = [NSStrokeColorAttributeName: UIColor.blackColor(),
        NSStrokeWidthAttributeName: -2.5,
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!]
    
    let placeholderText = "Tap to edit"
    
    //MARK: METHODS
    func pickImageFromAlbum() {
        getImage(.PhotoLibrary)
    }
    
    func takeImageWithCamera() {
        getImage(.Camera)
    }
    
    func getImage(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.mediaTypes = [kUTTypeImage as String]
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func shareMeme() {
        //TODO: share method
        print("share meme")
   
    }
    
    func resizeImage() {
        switch imageView.contentMode {
        case .ScaleAspectFill:
            imageView.contentMode = .ScaleAspectFit
        case .ScaleAspectFit:
            imageView.contentMode = .Center
        case .Center:
            imageView.contentMode = .ScaleToFill
        case .ScaleToFill:
            imageView.contentMode = .ScaleAspectFill
        default:
            break
        }
    }
    
    func cancel() {
        //TODO: cancel method
        imageView.image = nil
        topTextField.text = placeholderText
        bottomTextField.text = placeholderText
        resizeButton.enabled = false
    }
    
    func setText() {
        topTextField.borderStyle = .None
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        topTextField.adjustsFontSizeToFitWidth = true
        topTextField.minimumFontSize = 20
        
        bottomTextField.borderStyle = .None
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .Center
        bottomTextField.adjustsFontSizeToFitWidth = true
        bottomTextField.minimumFontSize = 20
        
        if topTextField.text == "" {
            topTextField.text = placeholderText
        }
        if bottomTextField.text == "" {
            bottomTextField.text = placeholderText
        }
    }
    
    //MARK: DELEGATE METHODS
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
           image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        imageView.image = image
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == placeholderText {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.text = placeholderText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: VIEW CONTROLLER METHODS
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme Editor"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareMeme")
    
        barSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        cameraButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "takeImageWithCamera")
        albumButton = UIBarButtonItem(title: "Album", style: .Plain, target: self, action: "pickImageFromAlbum")
        resizeButton = UIBarButtonItem(title: "Resize", style: .Plain, target: self, action: "resizeImage")

        toolbarItems = [barSpace, albumButton, barSpace, cameraButton, barSpace, resizeButton, barSpace]
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        albumButton.enabled = UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        setText()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if imageView.image == nil {
            resizeButton.enabled = false
        } else {
            resizeButton.enabled = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.setToolbarHidden(false, animated: true)
    }
}

