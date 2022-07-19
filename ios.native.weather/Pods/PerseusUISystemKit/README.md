Perseus UISystemKit
======================================
[![Actions Status](https://github.com/perseusrealdeal/PerseusUISystemKit/actions/workflows/CI.yml/badge.svg)](https://github.com/perseusrealdeal/PerseusUISystemKit/actions)
![Version](https://img.shields.io/badge/Version-1.0.0-green.svg)
![Pod](https://img.shields.io/badge/Pod-1.0.0-green.svg)
[![Platforms iOS 9](https://img.shields.io/badge/Platforms-iOS%209.0-orange.svg)](https://en.wikipedia.org/wiki/IOS_9)
[![SDK UIKit](https://img.shields.io/badge/SDK-UIKit%20-blueviolet.svg)](https://developer.apple.com/documentation/uikit)
[![Swift 5.3](https://img.shields.io/badge/Swift-5.3-red.svg)](https://docs.swift.org/swift-book/RevisionHistory/RevisionHistory.html)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-informational.svg)](https://github.com/apple/swift-package-manager)
[![CocoaPods manager](https://img.shields.io/badge/CocoaPods%20Manager-compatible-informational.svg)](https://cocoapods.org)
[![License](http://img.shields.io/:License-MIT-blue.svg)](https://github.com/perseusrealdeal/PerseusUISystemKit/blob/22c836dd71cb774bf5f7ecdb5a3b22f0f87357be/LICENSE)

Have a look of demo app, source code is [here](https://github.com/perseusrealdeal/ios.darkmode.discovery.git).

[![Standalone File](https://img.shields.io/badge/Standalone%20File-available-red.svg)](https://github.com/perseusrealdeal/PerseusUISystemKit/blob/0433adec5129e2f38a0bad498bfc4d7ff273ff0b/PerseusUISystemKitSingle.swift)
[![Demo App](https://img.shields.io/badge/Demo%20App-available-ff6964.svg)](https://github.com/perseusrealdeal/ios.darkmode.discovery.git)
[![PerseusDarkMode](http://img.shields.io/:PerseusDarkMode-1.0.4-green.svg)](https://github.com/perseusrealdeal/PerseusDarkMode/tree/1.0.4)

# Table of contents

[Introductory remarks](#introductory)

Samples:

- [Sample use case of adapted color](#sample1)
- [Sample use case of a dynamic image](#sample2)

Specifications:

- [Table 1. Adapted system colors](#table1)
- [Table 2. Adapted semantic colors](#table2)

[License](#license)

# Introductory remarks <a name="introductory"></a>

Colors listed in this section, table 1 and 2, represent colors specified by [the official specification](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/color/). But, not all system colors have been started available from iOS 13.0, colors `.systemMint` and `.systemCyan` available only from iOS 15.0. RGBA details of semantic colors have been exctracted from iOS 15.4, see table 2.
- Adapted System UI library uses SDK color for sure starting from iOS 13 and the specification for early iOS releases.
- System colors `.systemMint`, `.systemCyan`, and `.systemBrown` are not available in Xcode 12.5, only starting from 13.

There is an interesting case with `.systemTeal` color. The difference between [the official specification](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/color/) and what's on the screen takes place in iOS 13, have a look of the extraction below:

| .systemTeal   | RGBA Light    | RGBA Dark     |
| :------------ | :------------ |:------------- |
| Specification | 48, 176, 199  | 64, 200, 224  |
| iOS 13.7      | 90, 200, 250  | 100, 210, 255 |
| iOS 15.4      | 48, 176, 199  | 64, 200, 224  |

One way to bridge the gap appearing with `.systemTeal` is using the customised color. Technique of customising colors is widely used in [demo app](https://github.com/perseusrealdeal/ios.darkmode.discovery.git).

In fact the actual color values provided below in table 1 and 2 may fluctuate from System release to release but for early System releases the colors adapted follow the specification as is.

# Sample Use Case of Adapted System UI <a name="sample1"></a>

```swift
import UIKit
import PerseusUISystemKit

let view = UIView()
view.backgroundColor = .systemBlue_Adapted
```

In case if a certain color of a Dark Mode sensitive color required use the line of code below:

```swift
_ = UIColor.label_Adapted.resolvedColor(with: self.traitCollection).cgColor
```

# Sample Use Case of DarkModeImageView <a name="sample2"></a>

DarkModeImageView shows a quite light implementation of a dynamic image idea that is sensetive to Dark Mode.

```swift
import UIKit
import PerseusUISystemKit

let frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 1, height: 1))
var imageView = DarkModeImageView(frame: frame)

imageView.configure(UIImage(named: "ImageNameForLight"), UIImage(named: "ImageNameForDark"))
```

Also, images for both light and dark styles can be setted up via Interface Builder using Attributes Inspector:

```swift
import UIKit
import PerseusDarkMode

public class DarkModeImageView: UIImageView
{
    @IBInspectable
    var imageLight: UIImage?
    {
        didSet
        {
            light = imageLight
            image = AppearanceService.shared.Style == .light ? light : dark
        }
    }
    
    @IBInspectable
    var imageDark : UIImage?
    {
        didSet
        {
            dark = imageDark
            image = AppearanceService.shared.Style == .light ? light : dark
        }
    }
    
    private(set) var darkModeObserver: DarkModeObserver?
    
    private(set) var light: UIImage?
    private(set) var dark: UIImage?
    
    // ...
}
```

# Table 1. Adapted system colors <a name="table1"></a>

| RGBA Light                 | RGBA Dark                  | UIKit API Adapted     |
| :------------------------- | :------------------------- | :-------------------- |
| 255, 59, 48<br>#FF3B30FF   | 255, 69, 58<br>#FF453AFF   | .systemRed_Adapted    |
| 255, 149, 0<br>#FF9500FF   | 255, 159, 10<br>#FF9F0AFF  | .systemOrange_Adapted |
| 255, 204, 0<br>#FFCC00FF   | 255, 214, 10<br>#FFD60AFF  | .systemYellow_Adapted |
| 52, 199, 89<br>#34C759FF   | 48, 209, 88<br>#30D158FF   | .systemGreen_Adapted  |
| 0, 199, 190<br>#00C7BEFF   | 102, 212, 207<br>#66D4CFFF | .systemMint_Adapted   |
| 48, 176, 199<br>#30B0C7FF  | 64, 200, 224<br>#40C8E0FF  | .systemTeal_Adapted   |
| 50, 173, 230<br>#32ADE6FF  | 100, 210, 255<br>#64D2FFFF | .systemCyan_Adapted   |
| 0, 122, 255<br>#007AFFFF   | 10, 132, 255<br>#0A84FFFF  | .systemBlue_Adapted   |
| 88, 86, 214<br>#5856D6FF   | 94, 92, 230<br>#5E5CE6FF   | .systemIndigo_Adapted |
| 175, 82, 222<br>#AF52DEFF  | 191, 90, 242<br>#BF5AF2FF  | .systemPurple_Adapted |
| 255, 45, 85<br>#FF2D55FF   | 255, 55, 95<br>#FF375FFF   | .systemPink_Adapted   |
| 162, 132, 94<br>#A2845EFF  | 172, 142, 104<br>#AC8E68FF | .systemBrown_Adapted  |
| 142, 142, 147<br>#8E8E93FF | 142, 142, 147<br>#8E8E93FF | .systemGray_Adapted   |
| 174, 174, 178<br>#AEAEB2FF | 99, 99, 102<br>#636366FF   | .systemGray2_Adapted  |
| 199, 199, 204<br>#C7C7CCFF | 72, 72, 74<br>#48484AFF    | .systemGray3_Adapted  |
| 209, 209, 214<br>#D1D1D6FF | 58, 58, 60<br>#3A3A3CFF    | .systemGray4_Adapted  |
| 229, 229, 234<br>#E5E5EAFF | 44, 44, 46<br>#2C2C2EFF    | .systemGray5_Adapted  |
| 242, 242, 247<br>#F2F2F7FF | 28, 28, 30<br>#1C1C1EFF    | .systemGray6_Adapted  |

# Table 2. Adapted semantic colors <a name="table2"></a>

| RGBA Light                     | RGBA Dark                        | UIKit API Adapted        |
| :----------------------------- | :------------------------------- | :----------------------- |
| **Foreground**                                                                               |
| `Label`                                                                                      |
| 0, 0, 0, 1<br>#000000FF        | 255, 255, 255, 1<br>#FFFFFFFF    | .label_Adapted           |
| 60, 60, 67, 0.6<br>#3C3C4399   | 235, 235, 245, 0.6<br>#EBEBF599  | .secondaryLabel_Adapted  |
| 60, 60, 67, 0.3<br>#3C3C434D   | 235, 235, 245, 0.3<br>#EBEBF54D  | .tertiaryLabel_Adapted   |
| 60, 60, 67, 0.18<br>#3C3C432E  | 235, 235, 245, 0.16<br>#EBEBF529 | .quaternaryLabel_Adapted |
| `Text`                                                                                       |
| 60, 60, 67, 0.3<br>#3C3C434D   | 235, 235, 245, 0.3<br>#EBEBF54D  | .placeholderText_Adapted |
| `Separator`                                                                                  |
| 60, 60, 67, 0.29<br>#3C3C434A  | 84, 84, 88, 0.6<br>#54545899     | .separator_Adapted       |
| 198, 198, 200, 1<br>#C6C6C8FF  | 56, 56, 58, 1<br>#38383AFF       | .opaqueSeparator_Adapted |
| `Link`                                                                                       |
| 0, 122, 255, 1<br>#007AFFFF    | 9, 132, 255, 1<br>#0984FFFF      | .link_Adapted            |
| `Fill`                                                                                       |
| 120, 120, 128, 0.2<br>#78788033  | 120, 120, 128, 0.36<br>#7878805C | .systemFill_Adapted    |
| 120, 120, 128, 0.16<br>#78788029 | 120, 120, 128, 0.32<br>#78788052 | .secondarySystemFill_Adapted     |
| 118, 118, 128, 0.12<br>#7676801F | 118, 118, 128, 0.24<br>#7676803D | .tertiarySystemFill_Adapted      |
| 116, 116, 128, 0.08<br>#74748014 | 118, 118, 128, 0.18<br>#7676802E | .quaternarySystemFill_Adapted    |
| **Background**                                                                               |
| `Standard`                                                                                   |
| 255, 255, 255, 1<br>#FFFFFFFF | 28, 28, 30, 1<br>#1C1C1EFF | .systemBackground_Adapted       |
| 242, 242, 247, 1<br>#F2F2F7FF | 44, 44, 46, 1<br>#2C2C2EFF | .secondarySystemBackground_Adapted        |
| 255, 255, 255, 1<br>#FFFFFFFF | 58, 58, 60, 1<br>#3A3A3CFF | .tertiarySystemBackground_Adapted         |
| `Grouped`                                                                                    |
| 242, 242, 247, 1<br>#F2F2F7FF | 28, 28, 30, 1<br>#1C1C1EFF | .systemGroupedBackground_Adapted          |
| 255, 255, 255, 1<br>#FFFFFFFF | 44, 44, 46, 1<br>#2C2C2EFF | .secondarySystemGroupedBackground_Adapted | 
| 242, 242, 247, 1<br>#F2F2F7FF | 58, 58, 60, 1<br>#3A3A3CFF | .tertiarySystemGroupedBackground_Adapted  |

# License <a name="license"></a>

MIT License

Copyright (c) 2022 Mikhail Zhigulin of Novosibirsk

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
