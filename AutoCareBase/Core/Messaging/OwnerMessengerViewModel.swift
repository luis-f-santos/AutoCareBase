//
//  OwnerMessengerViewModel.swift
//  AutoCareBase
//
//  Created by Luis Santos on 8/20/25.
//

import Foundation
import Firebase

@MainActor
class OwnerMessengerViewModel: ObservableObject {
    
    @Published var recentMessages = [RecentMessage]()
    
    let userId: String
    
    init(uid: String) {
        self.userId = uid
        Task {
            await fetchRecenMessages(withUserId: uid)
        }
    }
    
    private func fetchRecenMessages(withUserId fromId: String) async {

        Firestore.firestore()
            .collection("recent_messages")
            .document(fromId)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print(error)
                    print("Failed to fetch Recent Messages")
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.documentId == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    self.recentMessages.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                })
            }
    }
}


