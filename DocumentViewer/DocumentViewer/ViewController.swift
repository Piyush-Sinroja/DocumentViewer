//
//  ViewController.swift
//  DocumentViewer
//
//  Created by piyush sinroja on 14/03/17.
//  Copyright © 2017 Piyush. All rights reserved.
//

import UIKit
import QuickLook

class ViewController: UIViewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate, UIDocumentInteractionControllerDelegate {

    // UITableView Outlet
    @IBOutlet weak var tblDocument: UITableView!
    
    // Object Cell
    var cellobj : cellDocumentView = cellDocumentView()
    
    // Obj UIDocumentInteractionController
    var documentController : UIDocumentInteractionController!
    
    // Obj QLPreviewController
    let qlControllerobj = QLPreviewController()
    
    // Other Properties
    var arrayURLs = [URL]()
    let arayDocNames = ["Document-Pdf.pdf", "Document-Doc.docx", "Document-Text.rtf", "Document-Image.jpeg"]
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareFileURLs()
        qlControllerobj.dataSource = self
        qlControllerobj.delegate = self
        tblDocument.reloadData()
        navigationItem.title = "DocumentView Demo"
    }
    
    // Append URL in Array
    func prepareFileURLs() {
        for file in arayDocNames {
            let fileParts = file.components(separatedBy: ".")
            if let fileURL = Bundle.main.url(forResource: fileParts[0], withExtension: fileParts[1]) {
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    arrayURLs.append(fileURL)
                }
            }
        }
    }
    
    
    /// extractAndBreakFilenameInComponents
    ///
    /// - Parameter fileURL: url
    /// - Returns: tuples
    func extractAndBreakFilenameInComponents(_ fileURL: URL) -> (fileName: String, fileExtension: String) {
        // Break the NSURL path into its components and create a new array with those components.
        let fileURLParts = fileURL.path.components(separatedBy: "/")
        
        // Get the file name from the last position of the array above.
        let fileName = fileURLParts.last
        
        // Break the file name into its components based on the period symbol (".").
        let filenameParts = fileName?.components(separatedBy: ".")
        
        // Return a tuple.
        return (filenameParts![0], filenameParts![1])
    }
    
    
    func getFileTypeFromFileExtension(_ fileExtension: String) -> String {
        var fileType = ""
        switch fileExtension {
        case "docx":
            fileType = "Microsoft Word document"
        case "pages":
            fileType = "Pages document"
        case "jpeg":
            fileType = "Image document"
        case "key":
            fileType = "Keynote document"
        case "pdf":
            fileType = "PDF document"
        default:
            fileType = "Text document"
        }
        return fileType
    }
    
    //MARK:- QLPreviewControllerDataSource
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return arrayURLs.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return arrayURLs[index] as QLPreviewItem
    }
    
    //MARK:- QLPreviewControllerDelegate
    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        tblDocument.deselectRow(at: tblDocument.indexPathForSelectedRow!, animated: true)
        print("The Preview Controller has been dismissed.")
    }
    
    //MARK:- UIDocumentInteractionControllerDelegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
         return self
    }
    
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return self.view
    }
    
    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return self.view.frame
    }
}

//MARK:- UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         cellobj = tableView.dequeueReusableCell(withIdentifier: "cellDocumentView", for: indexPath) as! cellDocumentView
        let currentFileParts = extractAndBreakFilenameInComponents(arrayURLs[indexPath.row])
        cellobj.lblName.text = currentFileParts.fileName
        cellobj.lblDetails.text = getFileTypeFromFileExtension(currentFileParts.fileExtension)
        return cellobj
    }
}

//MARK:- UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if QLPreviewController.canPreview(arrayURLs[indexPath.row] as QLPreviewItem) {
            qlControllerobj.currentPreviewItemIndex = indexPath.row
            present(qlControllerobj, animated: true, completion: nil)
        }
 
        /*
        let cell = tableView.cellForRow(at: indexPath)
        self.documentController = UIDocumentInteractionController.init(url: self.arrayURLs[indexPath.row] as URL)
        self.documentController.delegate = self
        self.documentController.presentPreview(animated: true)

        // documentController.presentOptionsMenu(from: (cell?.frame)!, in: self.view, animated: true)
        */
    }
}
