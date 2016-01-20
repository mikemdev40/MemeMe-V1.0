//
//  EditOptionsViewController.swift
//  MemeMeV1
//
//  Created by Michael Miller on 1/17/16.
//  Copyright © 2016 MikeMiller. All rights reserved.
//

import UIKit

//delegate protocol defined, which the MemeEditorController adopts; this delegatation is used to make the MemeEditorController aware of changes to the font on the popover and make changes to the main screen in real time (while the popover is still active); when the newFontStyle is set on the delegate, the main screen font selection is set to the new font selection (through a didset property observer), which promptys an update to the text field attributes
protocol UpdateFontDelegate {
    var newFontStyle: UIFont { get set}
}

class EditOptionsViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var imageScaleBack: UIButton!
    @IBOutlet weak var imageScaleForward: UIButton!
    @IBOutlet weak var fontStyleBack: UIButton!
    @IBOutlet weak var fontStyleForward: UIButton!

    //MARK: PROPERTIES
    var imageView: UIImageView?
    var delegate: UpdateFontDelegate?
    
    //MARK: METHODS
    //method that is connected to the two image scale selector buttons; one button cycles forward through five different image scale options, and the other button cycles backwards; the tags (1 and 2) for the two buttons are set in viewDidLoad
    @IBAction func changeImageScale(sender: UIButton) {
        switch sender.tag {
        case 1:
            if let imageView = imageView {
                switch imageView.contentMode {
                case .ScaleAspectFit:
                    imageView.contentMode = .ScaleToFill
                case .ScaleToFill:
                    imageView.contentMode = .ScaleAspectFill
                case .ScaleAspectFill:
                    imageView.contentMode = .Center
                case .Center:
                    imageView.contentMode = .ScaleAspectFit
                default:
                    break
                }
            }
        case 2:
            if let imageView = imageView {
                switch imageView.contentMode {
                case .ScaleAspectFit:
                    imageView.contentMode = .Center
                case .Center:
                    imageView.contentMode = .ScaleAspectFill
                case .ScaleAspectFill:
                    imageView.contentMode = .ScaleToFill
                case .ScaleToFill:
                    imageView.contentMode = .ScaleAspectFit
                default:
                    break
                }
            }
        default:
            break
        }
    }
    
    //method that is connected to the two font selector buttons; one button cycles forward through five different font options, and the other button cycles backwards; the tags (1 and 2) for the two buttons are set in viewDidLoad; the new font is set to the delegate's (MemeEditorViewController's) newFontStyle property
    @IBAction func changeFontStyle(sender: UIButton) {
        switch sender.tag {
        case 1:
            if let font = delegate?.newFontStyle {
                switch font.fontName {
                case "HelveticaNeue-CondensedBlack":
                    delegate?.newFontStyle = UIFont(name: "ChalkboardSE-Bold", size: 40)!
                case "ChalkboardSE-Bold":
                    delegate?.newFontStyle = UIFont(name: "Copperplate-Bold", size: 40)!
                case "Copperplate-Bold":
                    delegate?.newFontStyle = UIFont(name: "Courier-Bold", size: 40)!
                case "Courier-Bold":
                    delegate?.newFontStyle = UIFont(name: "Verdana-Bold", size: 40)!
                case "Verdana-Bold":
                    delegate?.newFontStyle = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
                default:
                    break
                }
            }
        case 2:
            if let font = delegate?.newFontStyle {
                switch font.fontName {
                case "HelveticaNeue-CondensedBlack":
                    delegate?.newFontStyle = UIFont(name: "Verdana-Bold", size: 40)!
                case "Verdana-Bold":
                    delegate?.newFontStyle = UIFont(name: "Courier-Bold", size: 40)!
                case "Courier-Bold":
                    delegate?.newFontStyle = UIFont(name: "Copperplate-Bold", size: 40)!
                case "Copperplate-Bold":
                    delegate?.newFontStyle = UIFont(name: "ChalkboardSE-Bold", size: 40)!
                case "ChalkboardSE-Bold":
                    delegate?.newFontStyle = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
                default:
                    break
                }
            }
        default:
            break
        }
    }
    
    //MARK: VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
            
        imageScaleBack.tag = 1
        imageScaleForward.tag = 2
        fontStyleBack.tag = 1
        fontStyleForward.tag = 2
    }

    //when the popover is about to appear, the image scale selector buttons are disabled if there is no image that has been selected (the font selector buttons are always enabled)
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if imageView?.image == nil {
            imageScaleBack.enabled = false
            imageScaleForward.enabled = false
        } else {
            imageScaleBack.enabled = true
            imageScaleForward.enabled = true
        }
    }
}
