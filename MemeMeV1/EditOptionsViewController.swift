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

    @IBOutlet weak var imageScaleBack: UIButton!
    @IBOutlet weak var imageScaleForward: UIButton!
    @IBOutlet weak var fontStyleBack: UIButton!
    @IBOutlet weak var fontStyleForward: UIButton!

    var imageView: UIImageView?
//    var memeFont: UIFont?
    var delegate: UpdateFontDelegate?
    
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
                    delegate?.newFontStyle = UIFont(name: "Chalkduster", size: 40)!
                    print("helvetica")
                case "Chalkduster":
                    delegate?.newFontStyle = UIFont(name: "Verdana-Bold", size: 40)!
                    print("chalk")
                default:
                    break
                }
            }
        case 2:
            print("case2")
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScaleBack.tag = 1
        imageScaleForward.tag = 2
        fontStyleBack.tag = 1
        fontStyleForward.tag = 2
    }

}
