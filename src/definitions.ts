declare module '@capacitor/core' {
  interface PluginRegistry {
    DocumentScanner: DocumentScannerPlugin;
  }
}

export declare type ScanResultType = 'uri' | 'base64';

export interface ScanOptions {
  /**
   * The quality of image to return as JPEG, from 0-100
   */
  quality?: number;

  /**
   * How the data should be returned.
   */
  resultType: ScanResultType;

  /**
   * Which languages to use for text recognition. If no language is provided, text recognition is omitted.
   */
  textRecognitionLanguages?: string[]
}

export interface ScanResult {
  pages: Page[];
}

export interface Page {
  /**
   * The base64 encoded string representation of the image, if using ScanResultType.Base64.
   */
  base64String?: string;

  /**
   * If using ScanResultType.Uri, the path will contain a full,
   * platform-specific file URL that can be read later using the Filsystem API.
   */
  filePath?: string;

  /**
   * The recognised text on the page.
   */
  text?: string;
}

export interface DocumentScannerPlugin {
  scan(options?: ScanOptions): Promise<ScanResult>;
}
