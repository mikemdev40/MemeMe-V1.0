//
//  ViewController.swift
//  MemeMeV1
//
//  Created by Michael Miller on 1/16/16.
//  Copyright © 2016 MikeMiller. All rights reserved.
//

import UIKit
import MobileCoreServices

class MemeEditorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, UpdateFontDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: CONSTANTS
    struct Constants {
        static let placeholderText = "TAP TO EDIT"
        static let defaultFont = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        static let defaultScale = UIViewContentMode.ScaleAspectFit
        static let missingTextError = "Missing text!"
        static let missingImageError = "Must have an image selected in order to create and share a meme!"
    }
    
    //MARK: PROPERTIES
    var barSpace: UIBarButtonItem!
    var cameraButton: UIBarButtonItem!
    var albumButton: UIBarButtonItem!
    var optionsButton: UIBarButtonItem!
    var activeTextField: UITextField?
    var meme: MemeObject!
    let notificationCenter = NSNotificationCenter.defaultCenter()

    var memeFont = Constants.defaultFont {
        didSet { setText() }
    }

    var newFontStyle = Constants.defaultFont {
        didSet { memeFont = newFontStyle }
    }
    
    //MARK: COMPUTED PROPERTITES
    var memeTextAttributes: [String: AnyObject] {
        return [NSStrokeColorAttributeName: UIColor.blackColor(),
            NSStrokeWidthAttributeName: -2,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: memeFont]
    }
    
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
    
    func saveMeme() {
        guard let topText = topTextField.text, let bottomText = bottomTextField.text else {
            callError(Constants.missingTextError)
            return
        }
        
        if let imageToMeme = imageView.image {
            UIGraphicsBeginImageContext(view.frame.size)
            view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
            let memedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            meme = MemeObject(topText: topText, bottomText: bottomText, originalImage: imageToMeme, memedImage: memedImage)
            
            shareMeme(meme.memedImage)
            
        } else {
            callError(Constants.missingImageError)
        }
    }
    
    func shareMeme(imageToShare: UIImage) {
        let shareVC = UIActivityViewController(activityItems: [imageToShare], applicationActivities: [])
        presentViewController(shareVC, animated: true, completion: nil)
    }
    
    func showOptions() {
        if let eovc = storyboard?.instantiateViewControllerWithIdentifier("optionsViewController") as? EditOptionsViewController {
            eovc.modalPresentationStyle = .Popover
            if let popover = eovc.popoverPresentationController {
                popover.delegate = self
                popover.barButtonItem = optionsButton
                popover.backgroundColor = UIColor.whiteColor()
                eovc.preferredContentSize = CGSize(width: 210, height: 90)
                eovc.imageView = imageView
                eovc.delegate = self
                
                presentViewController(eovc, animated: true, completion: { [unowned popover] () -> Void in
                    popover.passthroughViews = nil
                })
            }
        }
    }
    
    func cancel() {
        imageView.image = nil
        topTextField.text = Constants.placeholderText
        bottomTextField.text = Constants.placeholderText
        memeFont = Constants.defaultFont
        imageView.contentMode = Constants.defaultScale
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
            topTextField.text = Constants.placeholderText
        }
        if bottomTextField.text == "" {
            bottomTextField.text = Constants.placeholderText
        }
    }
    //method for calling errors that could be produced while audio recording
    func callError(error: String) {
        let ac = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        shiftView(notification) { return $0 - $1 }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        shiftView(notification) { return $0 + $1 }
    }
    
    func shiftView(notification: NSNotification, operation: (CGFloat, CGFloat) -> CGFloat) {
        if let tag = activeTextField?.tag {
            if tag == 2 {
                if let toolbarHeight = navigationController?.toolbar.frame.size.height {
                    view.frame.origin.y = operation(view.frame.origin.y, (getKeyboardHeight(notification) - toolbarHeight))
                }
            }
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
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
        activeTextField = textField
        if textField.text == Constants.placeholderText {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.text = Constants.placeholderText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "saveMeme")
    
        barSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        cameraButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "takeImageWithCamera")
        albumButton = UIBarButtonItem(title: "Album", style: .Plain, target: self, action: "pickImageFromAlbum")
        optionsButton = UIBarButtonItem(title: "Options", style: .Plain, target: self, action: "showOptions")

        toolbarItems = [barSpace, albumButton, barSpace, cameraButton, barSpace, optionsButton, barSpace]
        navigationController?.toolbarHidden = false
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        albumButton.enabled = UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.tag = 1
        bottomTextField.tag = 2
        
        setText()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
}

