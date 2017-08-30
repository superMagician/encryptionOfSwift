//
//  Encryption.swift
//  encryption
//
//  Created by 大姚 on 2017/8/30.
//  Copyright © 2017年 YY. All rights reserved.
//

import CryptoSwift

class Encryption: NSObject {
    
    static let key = "hYYvesbdjcdlcVUp"
    static let iv = ""
    static let salt = "DEgdrgadfsfasdbadrggasdfgosnt"
    
    //MARK: AES-ECB128加密
    public static func Endcode_AES_ECB(strToEncode:String)->String {
        // 从String 转成data
        let ps = strToEncode.data(using: String.Encoding.utf8)
        
        // byte 数组
        var encrypted: [UInt8] = []
        do {
            encrypted = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt(ps!.bytes)
        } catch AES.Error.dataPaddingRequired {
            // block size exceeded
        } catch {
            // some error
        }
        
        let encoded = NSData.init(bytes: encrypted, length: encrypted.count)
        //加密结果要用Base64转码
        return encoded.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
    }
    
    //  MARK:  AES-ECB128解密
    public static func Decode_AES_ECB(strToDecode:String)->String {
        //decode base64
        let data = NSData(base64Encoded: strToDecode, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        
        // byte 数组
        var encrypted: [UInt8] = []
        // 把data 转成byte数组
        for i in 0..<16 {
            var temp:UInt8 = 0
            data?.getBytes(&temp, range: NSRange(location: i,length:1 ))
            encrypted.append(temp)
        }
        // decode AES
        var decrypted: [UInt8] = []
        do {
            decrypted = try AES(key: key, iv: iv, blockMode:.CBC, padding: PKCS7()).decrypt(encrypted)
        } catch AES.Error.dataPaddingRequired {
            // block size exceeded
        } catch {
            // some error
        }
        
        // byte 转换成NSData
        let encoded = NSData.init(bytes: decrypted, length: decrypted.count)
        var str = ""
        //解密结果从data转成string
        str = String(data: encoded as Data, encoding: String.Encoding.utf8)!
        return str
    }
    
    //MARK: MD5 加密
    public static func MD5(codeString: String) -> String {
        // 加盐加密
        let md5String =  (codeString + salt).md5()
        return md5String
    }
}
