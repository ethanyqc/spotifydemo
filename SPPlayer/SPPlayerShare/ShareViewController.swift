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
        if let attachments = extensionItem.attachments {
            for attachment in attachments{
                
                attachment.loadItem(forTypeIdentifier: contentTypeURL, options: nil, completionHandler: { (results, error) in
                    
                    guard let url = results as? URL else {
                        print("eror")
                        return
                    }
                    OperationQueue.main.addOperation {
                        print(url.absoluteString)
                    }
                    
                })
                
                
            }
        }

    }

}
