import Foundation
import VisionKit
import Vision

@objc enum ScanResultType: Int {
    case uri
    case base64
}

@objc class ScanOptions: NSObject {
    var quality: Int
    var resultType: ScanResultType
    var textRecognitionLanguages: [String]?
    
    init(resultType: ScanResultType, quality: Int, textRecognitionLanguages: [String]?) {
        self.resultType = resultType
        self.quality = quality
        self.textRecognitionLanguages = textRecognitionLanguages
    }
}

@objc public class ScanResult: NSObject {
    var pages: [Page]
    
    init(pages: [Page]) {
        self.pages = pages
    }
}

@objc public class Page: NSObject {
    var base64: String?
    var path: String?
    var text: String?
    
    init(base64: String) {
        self.base64 = base64
    }
    
    init(path: String) {
        self.path = path
    }
}

@objc(Scanner)
class Scanner: NSObject, VNDocumentCameraViewControllerDelegate {
    
    var options: ScanOptions
    var delegate: (ScanResult?) -> Void
    
    init(options: ScanOptions, delegate: @escaping (ScanResult?) -> Void) {
        self.options = options
        self.delegate = delegate
    }
    
    @objc func processImages(images: [UIImage]) {
        var pages: [Page] = []
        for image in images {
            guard let imageData = image.jpegData(compressionQuality: CGFloat(self.options.quality / 100)) else {
                return
            }
            
            let page: Page
            switch self.options.resultType {
                case .base64:
                    page = Page(base64: imageData.base64EncodedString())
                    break;
                    
                default:
                    do {
                        let fileUrl = self.getTempFilePath()
                        try imageData.write(to:fileUrl)
                        page = Page(path: fileUrl.absoluteString)
                    } catch {
                        return
                    }
            }
            
            guard let textRecognitionLanguages = self.options.textRecognitionLanguages else {
                pages.append(page)
                break
            }
            
            let textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
                if let results = request.results, !results.isEmpty {
                    if let requestResults = request.results as? [VNRecognizedTextObservation] {
                        page.text = self.processRecognizedText(recognizedText: requestResults)
                        pages.append(page)
                    }
                }
            })
            textRecognitionRequest.recognitionLevel = .accurate
            textRecognitionRequest.usesLanguageCorrection = true
            textRecognitionRequest.recognitionLanguages = textRecognitionLanguages
            
            let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
            do {
                try handler.perform([textRecognitionRequest])
            } catch {
            }
        }
        
        self.delegate(ScanResult(pages: pages))
    }
    
    @objc func processRecognizedText(recognizedText: [VNRecognizedTextObservation]) -> String {
        var text = ""
        // Create a full transcript to run analysis on.
        let maximumCandidates = 1
        for observation in recognizedText {
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            text += candidate.string
            text += "\n"
        }
        return text
    }
    
    @objc public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        NSLog("didFinishWith")
        controller.dismiss(animated: true) {
            DispatchQueue.global(qos: .userInitiated).async {
                var images: [UIImage] = []
                for pageNumber in 0 ..< scan.pageCount {
                    images.append(scan.imageOfPage(at: pageNumber))
                }
                self.processImages(images: images)
            }
        }
    }
    
    @objc func getTempFilePath() -> URL {
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let fileUrl = path.appendingPathComponent(UUID().uuidString + ".jpg")
        return fileUrl
    }
}
