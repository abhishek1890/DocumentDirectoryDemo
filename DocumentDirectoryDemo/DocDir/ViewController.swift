//
//  ViewController.swift
//  DocDir
//
//  Created by User on 30/06/21.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var adbtn: UIButton!
    @IBOutlet weak var txtfld: UITextField!
    
    @IBOutlet weak var tblv: UITableView!
    var ary = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func adbtnactn(_ sender: Any) {
        let fileName = txtfld.text!
        self.save(text: "Some test content to write to the file",
                  toDirectory: self.documentDirectory(),
                  withFileName: fileName)
        
        print("Saved here")
        ary.append(fileName)
        tblv.reloadData()
        
        self.read(fromDocumentsWithFileName: fileName)
    }
    
    private func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask,
                                                                    true)
        return documentDirectory[0]
    }
    
    private func append(toPath path: String,
                        withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            
            return pathURL.absoluteString
        }
        
        return nil
    }
    
    private func read(fromDocumentsWithFileName fileName: String) {
        guard let filePath = self.append(toPath: self.documentDirectory(),
                                         withPathComponent: fileName) else {
                                            return
        }
        
        do {
            let savedString = try String(contentsOfFile: filePath)
            
            print(savedString)
        } catch {
            print("Error reading saved file")
        }
    }
    
    private func save(text: String,
                      toDirectory directory: String,
                      withFileName fileName: String) {
        guard let filePath = self.append(toPath: directory,
                                         withPathComponent: fileName) else {
            return
        }
        
        do {
            try text.write(toFile: filePath,
                           atomically: true,
                           encoding: .utf8)
        } catch {
            print("Error", error)
            return
        }
        
        print("Save successful")
    }
    
    func saveImageToDocumentDirectory(_ chosenImage: UIImage) -> String {
            let directoryPath =  NSHomeDirectory().appending("/Documents/")
            if !FileManager.default.fileExists(atPath: directoryPath) {
                do {
                    try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error)
                }
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddhhmmss"

            let filename = dateFormatter.string(from: Date()).appending(".jpg")
            let filepath = directoryPath.appending(filename)
            let url = NSURL.fileURL(withPath: filepath)
            do {
                try chosenImage.jpegData(compressionQuality: 1.0)?.write(to: url, options: .atomic)
                return String.init("/Documents/\(filename)")

            } catch {
                print(error)
                print("file cant not be save at path \(filepath), with error : \(error)");
                return filepath
            }
        }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ary.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = ary[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
