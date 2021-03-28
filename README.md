<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h3 align="center">Document Scanner</h3>
<p align="center"><strong><code>@kodista/document-scanner</code></strong></p>
<p align="center">
  Scan documents using the ios Visions framework to correct perspective and do OCR.
</p>

<p align="center">
  <img src="https://img.shields.io/maintenance/yes/2021?style=flat-square" />
<!--
  <a href="https://github.com/kodista/document-scanner/actions?query=workflow%3A%22CI%22"><img src="https://img.shields.io/github/workflow/status/kodista/document-scanner/CI?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/@kodista/document-scanner"><img src="https://img.shields.io/npm/l/@kodista/document-scanner?style=flat-square" /></a>
<br>
  <a href="https://www.npmjs.com/package/@kodista/document-scanner"><img src="https://img.shields.io/npm/dw/@kodista/document-scanner?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/@kodista/document-scanner"><img src="https://img.shields.io/npm/v/@kodista/document-scanner?style=flat-square" /></a>
-->
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
<a href="#contributors-"><img src="https://img.shields.io/badge/all%20contributors-0-orange?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:END -->
</p>

## Maintainers

| Maintainer | GitHub | Social |
| -----------| -------| -------|
| Roman | [rspy](https://github.com/rspy) | not social ;-) |

## Installation

```bash
npm install https://github.com/kodista/document-scanner.git#release/0.0.1
npx cap sync
```

## Configuration

### iOS

For iOS you need to set a usage description in your info.plist file.

This can be done by either adding it to the Source Code directly or by using Xcode Property List inspector.

**Adding it to the source code directly**

1. Open up the Info.plist (in Xcode right-click > Open As > Source Code)
2. With `<dict></dict>` change the following

```diff
<dict>
+  <key>NSCameraUsageDescription</key>
+  <string>To be able to scan documents</string>
</dict>
```

_NOTE:_ "To be able to scan documents" can be substituted for anything you like.

**Adding it by using Xcode Property List inspector**

1. Open up the Info.plist **in Xcode** (right-click > Open As > Property List)
2. Next to "Information Property List" click on the tiny `+` button.
3. Under `key`, type "Privacy - Camera Usage Description"
4. Under `value`, type "To be able to scan documents"

_NOTE:_ "To be able to scan documents" can be substituted for anything you like.

More info here: https://developer.apple.com/documentation/bundleresources/information_property_list/nscamerausagedescription

## Usage

```typescript
const scanResult: ScanResult = await Plugins.DocumentScanner.scan({
  resultType: 'uri',
  textRecognitionLanguages: ['de-CH', 'en-US']
} as ScanOptions);
```