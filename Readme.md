# Lempel

This is a simple Gzip implementation in Swift. There're already good implementations of this for Objective-C, but most require you to add Objective-C files to your project. Lempel provides a Carthage compatible framework which you can simply add to your project via the Cartfile.

Currently, only decompression of NSData is supported. I may add additional facilities (files, compression) if I end up requiring it. Otherwise, PR's are welcome.


# Installation

Add this to your cartfile:

```
github "terhechte/lempel"
```
