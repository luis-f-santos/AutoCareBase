//
//  User.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/12/24.
//

import Foundation

struct User: Identifiable, Hashable, Codable {
    let id: String
    let fullName: String
    let email: String
    let address: String
    let phoneNumber: String
    let password: String
    
    //Makes property optionoal
//    var phoneNumber: String? = nil
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
    
    var shortName: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName){
            formatter.style = .short
            return formatter.string(from: components)
        }
        return ""
    }
}

extension User {
    static var MOCK_USERS: [User] = [
        .init(id: "1", fullName: "Luka Doncic", email: "luka@gmail.com", address: "Dallas,TX" , phoneNumber: "5121234", password: "aaaaaa"),
        .init(id: "2", fullName: "Kyrie Irving", email: "kyrie@gmail.com", address: "Dallas,TX", phoneNumber: "5121243", password: "ffffff"),
        .init(id: "3", fullName: "Jayson Tatum", email: "tatum@gmail.com", address: "Boston,MA", phoneNumber: "5121234", password: "jjjjjjj"),
        .init(id: "4", fullName: "Jalen Brown", email: "brown@gmail.com", address: "Boston,MA", phoneNumber: "5125123423", password: "uuuuuuu")
    ]
}
