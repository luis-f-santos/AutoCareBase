//
//  Settings.swift
//  AutoCareBase
//
//  Created by Luis Santos on 8/23/25.
//

import Foundation
import FirebaseFirestoreSwift

struct Settings: Codable, Identifiable {
    
    @DocumentID var id: String?
    let owner_uid: String
    let primary_color: String
    let secondary_color: String
    let release: String
    let version: String

}
