//
//  ViewController.swift
//  MemeMeV1
//
//  Created by Michael Miller on 1/16/16.
//  Copyright © 2016 MikeMiller. All rights reserved.
//

import UIKit

class MemeEditorController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Meme Editor"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: nil, action: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let barSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: nil, action: nil)
        let albumButton = UIBarButtonItem(title: "Album", style: .Plain, target: nil, action: nil)
        toolbarItems = [barSpace, cameraButton, barSpace, albumButton, barSpace]
        navigationController?.setToolbarHidden(false, animated: true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

