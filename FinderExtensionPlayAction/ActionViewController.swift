//
//  ActionViewController.swift
//  FinderExtensionPlayAction
//
//  Created by Kamaal M Farah on 11/08/2024.
//

import Cocoa
import OSLog

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ActionViewController")

class ActionViewController: NSViewController {

    @IBOutlet var myTextView: NSTextView!
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("ActionViewController")
    }

    override func loadView() {
        guard let context = extensionContext else { fatalError("Expected an extension context") }

        super.loadView()

        // Insert code here to customize the view
        let sharedItem = context.inputItems[0] as! NSExtensionItem
        if let sharedItemText = sharedItem.attributedContentText?.string, !sharedItemText.isEmpty {
            logger.info("Input string != EMPTY")
        } else {
            logger.info("Input string == EMPTY")
        }

        if context.inputItems.count > 1 {
            logger.info("There are more than 1 input items")
        } else {
            logger.info("There is exactly 1 input item")
        }

        if let attachments = sharedItem.attachments {
            if attachments.count > 1 {
                logger.info("There are more than 1 atachments items")
            } else if attachments.isEmpty {
                logger.info("There are no atachments on this item")
            } else {
                attachments[0].loadInPlaceFileRepresentation(forTypeIdentifier: "com.adobe.pdf") { url, loaded, error in
                    if error != nil {
                        logger.error("Error appeared")
                        return
                    }

                    logger.info("Was able to load attachment")
                }
                logger.info("There is exactly 1 attachment item")
            }
        }

        let text = sharedItem.attributedContentText?.string

        if let text, !text.isEmpty {
            self.myTextView.string = text
        }
    }

    @IBAction func send(_ sender: AnyObject?) {
        guard let context = extensionContext else { fatalError("Expected an extension context") }

        // Note: The extension information in the Info.plist is set to accept any type of content,
        // but this example code only handles text. You should declare the specific types to be supported by your
        // extension in the extension's Info.plist and then make sure to handle all your supported types.
        let inputFile = context.inputItems[0] as! NSExtensionItem
        inputFile.attributedContentText = self.myTextView.attributedString()

        let outputItems = [inputFile]
        context.completeRequest(returningItems: outputItems, completionHandler: nil)
    }

    @IBAction func cancel(_ sender: AnyObject?) {
        guard let context = extensionContext else { fatalError("Expected an extension context") }

        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        context.cancelRequest(withError: cancelError)
    }

}
