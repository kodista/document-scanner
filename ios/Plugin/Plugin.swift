import Foundation
import Capacitor
import VisionKit

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(DocumentScanner)
public class DocumentScanner: CAPPlugin {
    
    var scanner: Scanner?

    @objc func scan(_ call: CAPPluginCall) {
        let options = self.scanOptions(call: call)
        self.scanner = Scanner(fileStoragePath: bridge.getLocalUrl(), options: options) { (scanResult) in
            self.scanDone(call: call, result: scanResult)
        }
    
        DispatchQueue.main.async {
            let documentCameraViewController = VNDocumentCameraViewController()
            documentCameraViewController.delegate = self.scanner
            self.bridge.viewController.present(documentCameraViewController, animated: true)
        }
    }
    
    @objc func scanOptions(call: CAPPluginCall) -> ScanOptions {
        let quality: Int? = call.getInt("quality", 85)
        let resultTypeString: String? = call.getString("resultType", "uri")
        let textRecognitionLanguages: [String]? = call.getArray("textRecognitionLanguages", String.self)
        
        let resultType: ScanResultType
        switch (resultTypeString) {
            case "base64":
                resultType = .base64
                break;
                
            default:
                resultType = .uri
        }
        
        return ScanOptions(resultType: resultType, quality: quality!, textRecognitionLanguages: textRecognitionLanguages)
    }
    
    @objc func scanDone(call: CAPPluginCall, result: ScanResult?) {
        guard let scanResult = result else {
            call.reject("unable to perform scan")
            return
        }
        
        var callResult = ["pages": []]
        for page in scanResult.pages {
            if (page.base64 != nil) {
                callResult["pages"]!.append([
                    "base64": page.base64,
                    "text": page.text
                ])
            } else if (page.path != nil) {
                callResult["pages"]!.append([
                    "filePath": page.path,
                    "text": page.text
                ])
            } else {
                callResult["pages"]!.append([
                    "text": page.text
                ])
            }
        }
        
        call.resolve(callResult)
    }
}
