//
//  ViewController.swift
//  DragAndDropApplication
//
//  Created by Naval Hasan on 13/07/20.
//  Copyright © 2020 nh10. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKUIDelegate {
    
    // #MARK: Outlets
    @IBOutlet weak var dragDropView: DragDropView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var textView: NSTextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragDropView.delegate = self
        webView.uiDelegate = self
        
    }

    
    
}

extension ViewController: DragDropViewDelegate {
    
    func dragDropView(_ dragDropView: DragDropView, droppedFileWithURL URL: URL) {
        
        let filename: NSString = URL.absoluteString as NSString
        let pathExtention = filename.pathExtension
        
        let path = URL.absoluteURL.path
        let data = NSData(contentsOfFile: path)
        
        if pathExtention == "html" {
            
            self.webView.isHidden = false
            self.textView.isHidden = true
            
            let htmlFile = URL.absoluteURL.path
            let html = try? String(contentsOfFile: htmlFile, encoding: String.Encoding.utf8)
            webView.loadHTMLString(html!, baseURL: nil)

        }
        else if let data = data as Data?{
            self.webView.isHidden = true
            self.textView.isHidden = false
            let content = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            
            guard let text = content as NSString? else {
                return showAlert()
            }
            self.textView.string = String(text)
            
            
        }
        else{
            showAlert()
        }
 
        
    }
    
    func dragDropView(_ dragDropView: DragDropView, droppedFilesWithURLs URLs: [URL]) {
        
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "Please drop only one file"
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    
    
    func showAlert() {
        let a = NSAlert()
        a.messageText = "Invalid file format."
        a.informativeText = "Unable to process, choose a text or web file"
        a.addButton(withTitle: "Ok")
        a.alertStyle = .informational
        if let window = view.window{
            a.beginSheetModal(for: window){ (modalResponse) in
                if modalResponse == .alertFirstButtonReturn {
                    print("Okay pressed")
                }
            }
        }
    }
    
    
    
}

