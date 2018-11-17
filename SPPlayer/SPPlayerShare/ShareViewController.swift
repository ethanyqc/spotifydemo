//
//  ShareViewController.swift
//  SPPlayerShare
//
//  Created by Ethan Chen on 11/17/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAndSetContentFromContext()
        
    }
    private func fetchAndSetContentFromContext() {
        
        let extensionItem = extensionContext?.inputItems[0] as! NSExtensionItem
        let contentTypeURL = kUTTypeURL as String
        
        for attachment in extensionItem.attachments as! [NSItemProvider] {

                attachment.loadItem(forTypeIdentifier: contentTypeURL, options: nil, completionHandler: { (results, error) in
                    if let url = results as? URL? {
                        print(url?.absoluteString)
                    }
                    
                })


        }
    }

}
