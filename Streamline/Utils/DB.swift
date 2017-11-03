//
//  DB.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/14/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//


import Firebase

struct DB {
    static var currentUser: User!
    static var posts: [Post] = []
    // Probably add withBlock for asynch
    // Should probably pass in User type into withBlcok
    static func createUser(uid: String, username: String, withBlock: @escaping () -> ()) {
        let reference = Database.database().reference()
        checkUserExists(uid: uid) { (userExists) in
            if userExists == false {
                //This is a new user so create the user and assign them a pID of ""
                let userData = ["pid": "", "username" : username]
                reference.child("users").child(uid).setValue(userData)
            } else {
                //This is an old user so the pid is not changed
                print("Logged in User has used app before and exists in database with username \(username)")
            }
            withBlock()
        }
    }
    
    //If the user exists return true or false so the pid doesnt get overwritten on login
    static func checkUserExists(uid: String, withBlock: @escaping (Bool) -> ()){
        var userExists = false
        let reference = Database.database().reference().child("users")
        reference.observeSingleEvent(of: .value) { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                if snapshot.hasChild(uid) {
                    userExists = true
                }
            }
            withBlock(userExists)
        }
    }
    
    //Get the users pid -- method called from the USER model class
    static func retrievePID(uid: String, withBlock: @escaping (String) -> ()) {
        let reference = Database.database().reference().child("users").child(uid).child("pid")
        reference.observeSingleEvent(of: .value) { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                withBlock(snapshot.value as! String)
            }
        }
    }

    // Synchronous first time post call (we want feed view to be populated immediately)
    static func getPosts() {
        let ref = Database.database().reference().child("posts")
        var posts: [Post] = []
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let value = value {
                for (key, val) in value {
                    let key = key as! String
                    let val = val as! [String: Any]
                    let post = Post(pid: key, postDict: val)
                    posts.append(post)
                }
                DB.posts = posts
            }
        })
    }
    
    static func createPost(post: Post, user: User) {
        var ref = Database.database().reference().child("posts")
        let key = ref.childByAutoId().key
        post.pid = key
        ref = ref.child(key)
        let dict: [String: Any] = ["uid": post.uid,
                                   "username": post.username,
                                   "imageUrl": post.imageUrl,
                                   "timePosted": post.timePosted.timeIntervalSince1970,
                                   "songTitle": post.songTitle,
                                   "artist": post.artist,
                                   "trackId": post.trackId,
                                   "duration": post.duration]
        // Need to set the pid value of Post
        ref.setValue(dict)
    }
    
    static func userPost(uid: String, pid: String){
        var ref = Database.database().reference().child("users").child(uid).child("pid")
        ref.setValue(pid)
    }
}
