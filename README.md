# OMGRssParser

![OMGRssParser](https://github.com/NSObjects/OMGRssParser/blob/master/Document/Demo.gif)

[![CI Status](http://img.shields.io/travis/NSObjects/OMGRssParser.svg?style=flat)](https://travis-ci.org/NSObjects/OMGRssParser)
[![Version](https://img.shields.io/cocoapods/v/OMGRssParser.svg?style=flat)](http://cocoapods.org/pods/OMGRssParser)
[![License](https://img.shields.io/cocoapods/l/OMGRssParser.svg?style=flat)](http://cocoapods.org/pods/OMGRssParser)
[![Platform](https://img.shields.io/cocoapods/p/OMGRssParser.svg?style=flat)](http://cocoapods.org/pods/OMGRssParser)

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage
```
let rssParser = OMGRssParser(urlStr: "http://ericasadun.com/feed/")
rssParser.parse { (info, error) in
    	guard let info = info else {return}
            print(info.title)
    }
```

## Requirements
* iOS 8.0+
* Swift 3

## Installation

OMGRssParser is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "OMGRssParser"
```

## Author

NSObjects, mrqter@gmail.com

## License

OMGRssParser is available under the MIT license. See the LICENSE file for more info.


