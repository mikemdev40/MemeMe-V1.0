//
//  EditOptionsViewController.swift
//  MemeMeV1
//
//  Created by Michael Miller on 1/17/16.
//  Copyright © 2016 MikeMiller. All rights reserved.
//

import UIKit

class EditOptionsViewController: UIViewController {

    @IBOutlet weak var imageScaleBack: UIButton!
    @IBOutlet weak var imageScaleForward: UIButton!
    @IBOutlet weak var fontStyleBack: UIButton!
    @IBOutlet weak var fontStyleForward: UIButton!

    var imageView: UIImageView?
    var fontStyle: UIFont?
    
    @IBAction func changeImageScale(sender: UIButton) {
        switch sender.tag {
        case 1:
            if let imageView = imageView {
                switch imageView.contentMode {
                case .ScaleAspectFill:
                    imageView.contentMode = .ScaleToFill
                case .ScaleToFill:
                    imageView.contentMode = .Center
                case .Center:
                    imageView.contentMode = .ScaleAspectFit
                case .ScaleAspectFit:
                    imageView.contentMode = .ScaleAspectFill
                default:
                    break
                }
            }
        case 2:
            if let imageView = imageView {
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
        default:
            break
        }
    }
    
    @IBAction func changeFontStyle(sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScaleBack.tag = 1
        imageScaleForward.tag = 2
        fontStyleBack.tag = 1
        fontStyleForward.tag = 2
    }

}
