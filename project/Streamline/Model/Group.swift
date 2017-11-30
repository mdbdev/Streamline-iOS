//
//  Group.swift
//  Streamline
//
//  Created by Vineeth Yeevani on 11/28/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import Foundation
import Firebase

class Group {
    var uids:   [String] = []
    var pids:   [String] = []
    var posts:  [Post]   = []
    var name: String!
    var gid: String!
    
    init(name: String, uids: [String], pids: [String]) {
        self.name = name
        self.uids = uids
        self.pids = pids
    }
    
    convenience init(gid: String) {
        self.init(name: "", uids: [], pids: [])
        getGroup(gid: gid) { (name, uids, pids) in
            self.name = name
            self.uids = uids
            self.pids = pids
        }
    }
    
    func getGroup(gid: String, withBlock: @escaping (String, [String], [String]) -> ()){
        self.gid = gid
        let ref = Database.database().reference().child("groups").child(gid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let value = value {
                let groupName = value["name"] as! String
                let uids = value["uids"] as! [String]
                let pids = value["pids"] as! [String]
                withBlock(groupName, uids, pids)
            }
        })
    }
}
