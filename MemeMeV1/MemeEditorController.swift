//
//  ViewController.swift
//  MemeMeV1
//
//  Created by Michael Miller on 1/16/16.
//  Copyright © 2016 MikeMiller. All rights reserved.
//

import UIKit
import MobileCoreServices

class MemeEditorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {

    //MARK: OUTLETS
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: PROPERTIES
    var barSpace: UIBarButtonItem!
    var cameraButton: UIBarButtonItem!
    var albumButton: UIBarButtonItem!
    var resizeButton: UIBarButtonItem!
    var activeTextField: UITextField?
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
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
      //  let share = UIActivityViewController(activityItems: [nil], applicationActivities: nil)
      //  presentViewController(share, animated: true, completion: nil)
   
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
    
    func edit() {
        performSegueWithIdentifier("showEditOptions", sender: resizeButton)
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
        topTextField.tag = 1
        
        bottomTextField.borderStyle = .None
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .Center
        bottomTextField.adjustsFontSizeToFitWidth = true
        bottomTextField.minimumFontSize = 20
        bottomTextField.tag = 2
        
        if topTextField.text == "" {
            topTextField.text = placeholderText
        }
        if bottomTextField.text == "" {
            bottomTextField.text = placeholderText
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
               //     let minimumSize = eovc.view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                    eovc.preferredContentSize = CGSize(width: 220, height: 90)
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
   //     resizeButton = UIBarButtonItem(title: "Resize", style: .Plain, target: self, action: "resizeImage")
        resizeButton = UIBarButtonItem(title: "EDIT", style: .Plain, target: self, action: "edit")

        toolbarItems = [barSpace, albumButton, barSpace, cameraButton, barSpace, resizeButton, barSpace]
        navigationController?.toolbarHidden = false
        
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
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
}

