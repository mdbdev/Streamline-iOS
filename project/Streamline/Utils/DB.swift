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
    
    // Creates a user in the database
    static func createUser(uid: String, username: String, userprofile: String, withBlock: @escaping () -> ()) {
        let reference = Database.database().reference()
        checkUserExists(uid: uid) { (userExists) in
            if userExists == false {
                //This is a new user so create the user and assign them a pid of ""
                let userData = ["pid": "", "displayName" : username, "profileImageURL" : userprofile]
                reference.child("users").child(uid).setValue(userData)
                withBlock()
            } else {
                // This is an old user so the pid is not changed
                print("Logged in User has used app before and exists in database with username \(username)")
            }
        }
    }
    
    static func fetchUser(uid: String, withBlock: @escaping (User?) -> ()) {
        let reference = Database.database().reference().child("users").child(uid)
        reference.observeSingleEvent(of: .value) { (snapshot, error) in
            if snapshot.exists() {
                let user = User(uid: uid, userDict: snapshot.value as! [String: Any])
                withBlock(user)
            } else {
                withBlock(nil)
            }
        }
    }
    
    // TODO: Test this a little more
    static func updateUsername(user: User) {
        let reference = Database.database().reference().child("users").child(user.uid).child("displayName")
        reference.setValue(user.username)
    }
    
    // Checks if the user already exists in the database
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
    
    // Gets the pid of the current users post from database
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

    // Gets the posts from all users from the database
    static func getPosts(withBlock: @escaping () -> ()) {
        let ref = Database.database().reference().child("posts")
        var posts: [Post] = []
        let startDate = Date().timeIntervalSince1970 - 86400
        let query = ref.queryOrdered(byChild: "timePosted").queryStarting(atValue: startDate)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let value = value {
                for (key, val) in value {
                    let key = key as! String
                    let val = val as! [String: Any]
                    let post = Post(pid: key, postDict: val)
                    posts.append(post)
                }
                DB.posts = posts
                DB.sortPosts()
                withBlock()
            }
        })
    }
    
    //Get the posts in a group
    static func getGroupPosts(group: Group) {
        //Refreshes posts on local storage
        getPosts(withBlock: {
            //Checks if each post is contained within the group id for the specific group
            for post in DB.posts {
                if group.pids.contains(post.pid) {
                    group.posts.append(post)
                }
            }
        })
    }
    
    // Creates a post in the database
    static func createPost(post: Post, user: User) {
        var ref = Database.database().reference().child("posts")
        let key = ref.childByAutoId().key
        post.pid = key
        ref = ref.child(key)
        let dict: [String: Any] = ["uid": post.uid,
                                   "displayName": post.username,
                                   "imageUrl": post.imageUrl,
                                   "timePosted": post.timePosted,
                                   "songTitle": post.songTitle,
                                   "artist": post.artist,
                                   "trackId": post.trackId,
                                   "profileImageURL": currentUser.imageUrl]
        ref.setValue(dict)
    }
    
    // Sets the users post pid in the database
    static func userPost(uid: String, pid: String, timePosted: TimeInterval) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.child("pid").setValue(pid)
        ref.child("timePosted").setValue(timePosted)
    }
    
    // Sorts the posts by time stamp
    static func sortPosts() {
        DB.posts.sort(by: {(p1, p2) -> Bool in
            return p1.timePosted >= p2.timePosted
        })
    }
    
    static func getGIDS(withBlock: @escaping () -> ()) {
        let ref = Database.database().reference().child("users").child(DB.currentUser.uid).child("gids")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String]
            if let value = value {
                DB.currentUser.gids = value
            }
        })
    }
    
    static func getGroups(withBlock: @escaping () -> ()) {
        getGIDS(withBlock: {
            for gid in DB.currentUser.gids {
                DB.currentUser.groups.append(Group(gid: gid))
                withBlock()
            }
        })
    }
    
    static func updateGroupsPosts(withBlock: @escaping () -> ()){
        getGroups(withBlock: {
            for group in DB.currentUser.groups {
                getGroupPosts(group: group)
            }
            withBlock()
        })
    }
    
    static func createGroup(groupName: String){
        //Create the group and set the values to the random key
        var ref = Database.database().reference().child("groups")
        let key = ref.childByAutoId().key
        ref = ref.child(key)
        var dict: [String: Any] = ["name": groupName, "uid": [DB.currentUser.uid], "pids": [DB.currentUser.pid]]
        ref.setValue(dict)
        
        //Take the current list of group ids and append the new group id to it
        getGIDS(withBlock: {
            ref = Database.database().reference().child("users").child(DB.currentUser.uid).child("gids")
            DB.currentUser.gids.append(key)
            ref.setValue(DB.currentUser.gids)
        })
        
        
    }
}
