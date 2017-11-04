# Streamline for iOS
This document provides an overview of the project structure and technologies used while developing Streamline for iOS.

### Project Architecture

This project follows the MVC architecture. The model classes are used by ViewControllers to interact with the database and provide information to be displayed in views. The model classes are User.swift and Post.swift. These correspond to the primary nodes of the database, which is hosted on Firebase.

### Frontend Overview

Here is a brief overview of the app flow:

* **LoginViewController**: Provides the user with the option to log in with Spotify, which either opens the Spotify app if it is on their phone, or redirects them to Safari where they can log in with their Spotify credentials.
* **FeedViewController**: Displays a public feed of songs that were added by users for the day. This VC has multiple sections:
  * **Feed**: The collection view representing the feed has cells represented by PostCollectionViewCell.swift, and includes the song name, artist, album cover, as well as the user that added the song. The feed clears every 24 hours, allowing users to add new songs each day.
  * **Now Playing**: The "Now Playing" bar at the bottom shows the user what song is currently playing, and if clicked, segues to NowPlayingViewController.
  * **New Post**: Pops up a modal (SearchView.swift) that allows users to add songs to the playlist. The user is allowed to add up to one song per day.
  * This VC also allows users to log out.
* **SearchView**: Displays a modal that allows users to add songs from Spotify, searching based on name.

### Technologies

The following CocoaPods/libraries were used in the project:
 * Spotify API: Used for authorization, adding songs, and playing songs.
 * Firebase SDK: Used for storing data regarding users and songs.
 
### Backend Overview

### Database Structure

The primary nodes of the database are User and Post, each of which has a model class (see above). User represents the different users that log in with the Spotify API on the app, and are uniquely identified by their Spotify username. Posts represent the various songs that were posted for the day (and are refreshed every 24 hours). All information regarding songs (e.g. track name, artist, album art, duration, etc.) are accessed using the Spotify API.
