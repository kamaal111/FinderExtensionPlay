//
//  ActionViewController.swift
//  FinderExtensionPlayAction
//
//  Created by Kamaal M Farah on 11/08/2024.
//

import Cocoa

class ActionViewController: NSViewController {

    @IBOutlet var myTextView: NSTextView!
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("ActionViewController")
    }

    override func loadView() {
        super.loadView()
    
        // Insert code here to customize the view
        NSLog("Input Items = %@", self.extensionContext!.inputItems as NSArray)
    
        let sharedItem = self.extensionContext!.inputItems[0] as! NSExtensionItem
        let text = sharedItem.attributedContentText?.string
        
        if text != nil && !text!.isEmpty {
            self.myTextView.string = text!
        }
    }

    @IBAction func send(_ sender: AnyObject?) {
        guard let context = extensionContext else { fatalError("Expected an extension context") }

        // Note: The extension information in the Info.plist is set to accept any type of content, but this example code only handles text. You should declare the specific types to be supported by your extension in the extension's Info.plist and then make sure to handle all your supported types.
        let inputFile = context.inputItems[0] as! NSExtensionItem
//        inputFile.attributedContentText = self.myTextView.attributedString()
    
        let outputItems = [inputFile]
        context.completeRequest(returningItems: outputItems, completionHandler: nil)
    }

    @IBAction func cancel(_ sender: AnyObject?) {
        guard let context = extensionContext else { fatalError("Expected an extension context") }

        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        context.cancelRequest(withError: cancelError)
    }

}
