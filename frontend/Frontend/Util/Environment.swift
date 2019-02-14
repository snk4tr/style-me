//
//  Environment.swift
//  Frontend
//
//  Created by Sergey Kastryulin on 2/14/19.
//  Copyright © 2019 snk4tr. All rights reserved.
//

import Foundation

public enum PlistKey {
    case ServerURL
    case ServerPort
    case TimeoutInterval
    case ConnectionProtocol
    
    func value() -> String {
        switch self {
        case .ServerURL:
            return "server_url"
        case .ServerPort:
            return "server_port"
        case .TimeoutInterval:
            return "timeout_interval"
        case .ConnectionProtocol:
            return "protocol"
        }
    }
}
public struct Environment {
    
    fileprivate var infoDict: [String: Any]  {
        get {
            if let dict = Bundle.main.infoDictionary {
                return dict
            }else {
                fatalError("Plist file not found")
            }
        }
    }
    public func configuration(_ key: PlistKey) -> String {
        switch key {
        case .ServerURL:
            return infoDict[PlistKey.ServerURL.value()] as! String
        case .ServerPort:
            return infoDict[PlistKey.ServerPort.value()] as! String
        case .TimeoutInterval:
            return infoDict[PlistKey.TimeoutInterval.value()] as! String
        case .ConnectionProtocol:
            return infoDict[PlistKey.ConnectionProtocol.value()] as! String
        }
    }
}
