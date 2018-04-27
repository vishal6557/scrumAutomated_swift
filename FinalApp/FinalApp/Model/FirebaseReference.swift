//
//  FirebaseReference.swift
//  FinalApp
//
//  Created by vishal diyora on 4/26/18.
//  Copyright © 2018 vishal diyora. All rights reserved.
//

import Foundation
import Firebase

enum DatabaseReferenceEnum {
    case root
    case users(userID:String)
    
    func reference() -> DatabaseReference {
        switch self {
        case .root:
            return rootRef
        default:
            return rootRef.child(path)
        }
    }
    
    private var rootRef: DatabaseReference {
        return Database.database().reference()
    }
    
    private var path : String {
        switch self {
        case .root: return ""
        case .users(let userID):
            return "users/\(userID)"
        }
    }
}

enum StorageReferenceEnum {
    case root
    case profileImages
    
    
    func reference() -> StorageReference {
        switch self {
        case .root:
            return rootRef
        default:
            return rootRef.child(path)
        }
    }
    
    private var rootRef: StorageReference {
        return Storage.storage().reference()
    }
    
    private var path : String {
        switch self {
        case .root: return ""
        case .profileImages:
            return "profileImages"
        }
    }
}
