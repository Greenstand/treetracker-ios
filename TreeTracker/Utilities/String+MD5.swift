//
//  String+MD5.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 05/12/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {

    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
