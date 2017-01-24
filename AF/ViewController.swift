//
//  ViewController.swift
//  AF
//
//  Created by Vlad Gorbenko on 5/9/16.
//  Copyright © 2016 Vlad Gorbenko. All rights reserved.
//

import UIKit
import AFNetworking
//import ReaderFramework

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var attrL: UITextView!
    
    var manager = AFHTTPRequestOperationManager(baseURL: URL(string: "http://10.119.5.188:7001/YOLO/api/"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies where cookies.isEmpty == false{
//            for cookie in cookies {
//                print("\(cookie.name) \(cookie.value) \(cookie.expiresDate) \(cookie.domain)")
//            }
//        } else {
//            print("cookie is empty")
//        }
//        let font = UIFont(name: "Gotham Book", size: 16.0)!
//        let paragraphStyleWithSpacing           = NSMutableParagraphStyle()
//        paragraphStyleWithSpacing.lineSpacing   = 12.0 //CGFloat
//        let attributes = [NSParagraphStyleAttributeName : paragraphStyleWithSpacing, NSFontAttributeName : font]
//        let string = "THIS IS TEXT\nWITH YOU ARE YELLOW\nTHREE LINES KITTYYYYYY!!!"
//        let textWithLineSpacing = NSAttributedString(string: string, attributes: attributes)
//        self.label.attributedText = textWithLineSpacing
//        
//        let HTML = "<p>\r\n</p>\r\n<ul>\r\n    <li>Full height cargo barrier to prevent cargo from entering passenger compartment.</li>\r\n</ul>\r\n<ul>\r\n    <li>Complies with ECE-17 regulation.</li>\r\n</ul>\r\n<ul>\r\n    <li>Features a small hatch to allow longer items such as skis to be carried where suitable rear seat option is fitted.</li>\r\n</ul>\r\n<ul>\r\n    <li>Compatible with loadspace rubber mat, loadspace rigid liner, loadspace rail system and parcel shelf.</li>\r\n</ul>\r\n<ul>\r\n    <li>Not compatible with 2nd Row Business Seating.</li>\r\n</ul>\r\n<p><span style=\"font-weight: bold; text-align: center;\">Part Number:</span><span style=\"text-align: center;\">&nbsp;VPLGS0162</span></p></br><a href=\"http://vk.com\"> hello <a/>"
//        let data = HTML.dataUsingEncoding(NSUnicodeStringEncoding)!
//        self.attrL.textColor = UIColor.blackColor()
//        let text = try? NSAttributedString(data: data,
//                                           options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
//                                           documentAttributes: nil)
//        self.attrL.attributedText = text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func login() {
//        manager.POST("signin", parameters: ["email" : "vlad@farabi.ae", "password" : "qwerty"], success: { (operation, responseObject) in
//            if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
//                for cookie in cookies {
//                    print("\(cookie.name) \(cookie.value) \(cookie.expiresDate) \(cookie.domain)")
//                }
//            }
//          print("success")
//        }) { (response, error) in
//            print("failure \(error)")
//        }
    }
    
    @IBAction func logout() {
//        manager.POST("logout", parameters: nil, success: { (operation, responseObject) in
//            if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
//                for cookie in cookies {
//                    print("\(cookie.name) \(cookie.value) \(cookie.expiresDate) \(cookie.domain)")
//                }
//            }
//            print("success")
//        }) { (response, error) in
//            print("failure \(error)")
//        }
    }
    
    @IBAction func items() {
//        manager.GET("users/1/cars", parameters: nil, success: { (operation, responseObject) in
//            
//            do {
//                print(responseObject)
//            } catch {
//                print(error)
//            }
//        }) { (operation, error) in
//            print(error)
//        }
    }
    
    @IBAction func fownloadFile(_ sender: AnyObject) {
//        let manager = AFHTTPRequestOperationManager(baseURL: NSURL(string: "http://apismartphone.salik.ae"))
//        manager.requestSerializer = AFJSONRequestSerializer()
//        manager.responseSerializer = AFJSONResponseSerializer()
//        manager.responseSerializer.acceptableContentTypes?.insert("text/plain")
//        let request = manager.requestSerializer.requestWithMethod("GET", URLString: "http://apismartphone.salik.ae/Financial/StatementsPresentation", parameters: ["YearMonth" : 201608, "FileType" : 1])
//        request.addValue("mobile.salik", forHTTPHeaderField: "client-id")
////        request.addValue("ar", forHTTPHeaderField: "Accept-Language")
//        request.setValue("ar", forHTTPHeaderField: "Accept-Language")
//        request.addValue("Bearer 0d0de1cded899715e1078bdf7df132e1", forHTTPHeaderField: "Authorization")
//        request.addValue("123456", forHTTPHeaderField: "client-secret")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let operation = manager.HTTPRequestOperationWithRequest(request, success: { (operation, responseObject) in
//            print(responseObject)
//            if let content = responseObject["FileContents"] as? String {
//                if let data = NSData(base64EncodedString: content, options: []) {
//                    let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
//                    print(documents)
////                    let data = UIImageJPEGRepresentation(self, 1)
//                    let url = NSURL(fileURLWithPath: documents).URLByAppendingPathComponent("file.pdf")
//                    if data.writeToURL(url, atomically: true) == true {
//                        print("done")
//                        
//                        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as NSString
//                        let plistPath = paths.stringByAppendingPathComponent("file.pdf")
//                        
//                        let document = ReaderDocument.init(filePath: plistPath, password: "")
//                        let controller = ReaderViewController(readerDocument: document)
//                        self.presentViewController(controller, animated: true, completion: nil)
//                        
////                        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mydocument" ofType:@"pdf"];
////                        ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
////                        
////                        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
////                        readerViewController.delegate = self;
////                        
////                        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:readerViewController];
////                        
////                        [self presentViewController:navigationController animated:YES completion:nil];
//                        
//                    } else {
//                        print("not done")
//                    }
//                }
//                
//            }
//        }) { (operation, error) in
//            print(error)
//        }
//        self.manager.operationQueue.addOperation(operation)
    }
    
}

