//
//  Lempel.swift
//  Lempel
//
//  Created by Benedikt Terhechte on 17/12/15.
//  Copyright © 2015 Benedikt Terhechte. All rights reserved.
//

import Foundation
import zlib

struct LempelSettings {
    static let chunkSize: Int32 = 1024
    static let defaultMemoryLevel: Int32 = 8
    static let defaultWindowsBits: Int32 = 15
    static let defaultWindowsBitsWithGZipHeader = 16 + LempelSettings.defaultWindowsBits
}

enum LempelError: ErrorType {
    case DataError(msg: String)
    case GzipError(msg: String)
    case SystemError(msg: String)
    
    private init(code: Int32) {
        let msg: String
        switch code {
        case Z_STREAM_ERROR:
            msg = "Stream Error: he stream structure was inconsistent (for example if next_in or next_out was NULL)"
            
        case Z_DATA_ERROR:
            msg = "Data Error: The input data was corrupted (input stream not conforming to the zlib format or incorrect check value)"
            
        case Z_MEM_ERROR:
            msg = "Mem Error: There was not enough memory."
            
        case Z_BUF_ERROR:
            msg = "Buf Error: No progress is possible or there was not enough room in the output buffer when Z_FINISH is used."
            
        case Z_VERSION_ERROR:
            msg = "Version Error"
            
        default:
            msg = "Unknown Error"
        }
        self = LempelError.GzipError(msg: "Error inflating Payload: \(msg)")
    }
}

extension NSData {
    func decompressGzip(windowBits: Int32 = LempelSettings.defaultWindowsBitsWithGZipHeader) throws -> NSData {
        guard self.length > 0
            else { return self }
        
        let zStream = UnsafeMutablePointer<z_stream>.alloc(1)
        defer {
            zStream.dealloc(1)
        }
        
        bzero(zStream, strideof(z_stream))
        
        zStream.memory.zalloc = nil
        zStream.memory.zfree = nil
        zStream.memory.opaque = nil
        zStream.memory.avail_in = UInt32(self.length)
        zStream.memory.next_in = UnsafeMutablePointer<Bytef>(self.bytes)
        
        var status: OSStatus = inflateInit2_(&zStream.memory, windowBits, ZLIB_VERSION, Int32(strideof(z_stream)))
        guard status == Z_OK
            else {
                throw LempelError.GzipError(msg: "Failed inflateInit")
        }
        
        let estimatedLength = Int(Float(self.length) * 1.5)
        
        guard let decompressedData = NSMutableData(length: estimatedLength)
            else {
                throw LempelError.SystemError(msg: "Could not allocated memory for output data")
        }
        
        repeat {
            if status == Z_BUF_ERROR || Int(zStream.memory.total_out) == decompressedData.length {
                decompressedData.increaseLengthBy(estimatedLength / 2)
            }
            
            /// zStream.next_out = (Bytef*)[decompressedData mutableBytes] + zStream.total_out;
            /// Take a pointer to the decompressed data, and move it by the total out.
            zStream.memory.next_out = UnsafeMutablePointer<Bytef>(decompressedData.mutableBytes).advancedBy(Int(zStream.memory.total_out))
            
            /// zStream.avail_out = (unsigned int)([decompressedData length] - zStream.total_out);
            /// Calculate the new length
            zStream.memory.avail_out = UInt32(UInt(decompressedData.length) - zStream.memory.total_out)
            
            //status = inflate(&zStream.memory, Z_FINISH)
            status = inflate(&zStream.memory, Z_SYNC_FLUSH)
            
        } while status == Z_OK || status == Z_BUF_ERROR
        
        inflateEnd(&zStream.memory)
        
        if status != Z_OK && status != Z_STREAM_END {
            throw LempelError(code: status)
        }
        
        decompressedData.length = Int(zStream.memory.total_out)
        
        return decompressedData
    }
}