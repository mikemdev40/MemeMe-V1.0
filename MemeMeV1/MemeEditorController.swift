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
        static let placeholderText = "Tap to edit"
        static let defaultFont = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        static let defaultScale = UIViewContentMode.ScaleAspectFit
    }
    
    //MARK: PROPERTIES
    var barSpace: UIBarButtonItem!
    var cameraButton: UIBarButtonItem!
    var albumButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    var activeTextField: UITextField?
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
    
    func shareMeme() {
      //  let share = UIActivityViewController(activityItems: [nil], applicationActivities: nil)
      //  presentViewController(share, animated: true, completion: nil)
   
    }
    
    func edit() {
        performSegueWithIdentifier("showEditOptions", sender: editButton)
    }
    
    func cancel() {
        imageView.image = nil
        topTextField.text = Constants.placeholderText
        bottomTextField.text = Constants.placeholderText
        editButton.enabled = false
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEditOptions" {
            if let eovc = segue.destinationViewController as? EditOptionsViewController {
                if let popover = eovc.popoverPresentationController {
                    popover.delegate = self
                    popover.barButtonItem = sender as? UIBarButtonItem
                    eovc.preferredContentSize = CGSize(width: 220, height: 90)
                    eovc.imageView = imageView
                    eovc.delegate = self
                }
            }
        }
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
        editButton = UIBarButtonItem(title: "EDIT", style: .Plain, target: self, action: "edit")

        toolbarItems = [barSpace, albumButton, barSpace, cameraButton, barSpace, editButton, barSpace]
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
        
        if imageView.image == nil {
            editButton.enabled = false
        } else {
            editButton.enabled = true
        }
        
        subscribeToKeyboardNotifications()

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
}

