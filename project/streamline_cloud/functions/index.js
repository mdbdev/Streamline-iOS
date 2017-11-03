// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.test = functions.https.onRequest((req, res) => {
  console.log("test");
  return res.status(200).send("testytesty");
});

//Waits for cron job from cronjob.org request and then checks the Posts data
exports.deletePosts = functions.https.onRequest((req, res) => {
  var ref = admin.database().ref('/posts/{pushId}/');
  var now = Date.now();
  var cutoff = now - 12 * 60 * 60 * 1000;
  var oldItemsQuery = ref.orderByChild('timePosted').endAt(cutoff);
  console.log("test");
  console.log(cutoff);
  return oldItemsQuery.once('value', function(snapshot) {
    // create a map with all children that need to be removed
    var updates = {};
    snapshot.forEach(function(child) {
      console.log(child.key);
      updates[child.key] = null
    });
    // execute all updates in one go and return the result to end the function
    return ref.update(updates);
    res.status(200).send("test");
  });
});
