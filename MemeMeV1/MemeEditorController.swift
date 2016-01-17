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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: nil, action: nil)
    
        barSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        cameraButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "takeImageWithCamera")
        albumButton = UIBarButtonItem(title: "Album", style: .Plain, target: self, action: "pickImageFromAlbum")
        resizeButton = UIBarButtonItem(title: "Resize", style: .Plain, target: self, action: "resizeImage")

        toolbarItems = [barSpace, albumButton, barSpace, cameraButton, barSpace, resizeButton, barSpace]
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        albumButton.enabled = UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
        
        topTextField.delegate = self
        bottomTextField.delegate = self
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

