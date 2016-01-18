//
//  EditOptionsViewController.swift
//  MemeMeV1
//
//  Created by Michael Miller on 1/17/16.
//  Copyright © 2016 MikeMiller. All rights reserved.
//

import UIKit

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
                    delegate?.newFontStyle = UIFont(name: "Futura-CondensedExtraBold", size: 40)!
                case "Futura-CondensedExtraBold":
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
                    delegate?.newFontStyle = UIFont(name: "Futura-CondensedExtraBold", size: 40)!
                case "Futura-CondensedExtraBold":
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
