import {WebPlugin} from '@capacitor/core';
import {DocumentScannerPlugin, ScanResult} from './definitions';

export declare class DocumentScannerWeb extends WebPlugin implements DocumentScannerPlugin {
    constructor();
    scan(): Promise<ScanResult>;
}
declare const DocumentScanner: DocumentScannerWeb;
export { DocumentScanner };
