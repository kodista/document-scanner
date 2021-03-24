import {registerWebPlugin, WebPlugin} from '@capacitor/core';
import {DocumentScannerPlugin, ScanResult} from './definitions';

export class DocumentScannerWeb extends WebPlugin implements DocumentScannerPlugin {
  constructor() {
    super({
      name: 'DocumentScanner',
      platforms: ['web'],
    });
  }

  async scan(): Promise<ScanResult> {
    return {
      pages: []
    };
  }
}

const DocumentScanner = new DocumentScannerWeb();

export { DocumentScanner };

registerWebPlugin(DocumentScanner);
