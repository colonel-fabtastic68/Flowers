# Firebase Setup Guide

This app uses Firebase for cloud data storage and real-time synchronization.

## Initial Setup (Already Done ✅)

The following steps have already been completed:

1. ✅ Firebase SDK integrated via Swift Package Manager
2. ✅ `GoogleService-Info.plist` added to the project
3. ✅ Firebase initialized in `FlowersApp.swift`
4. ✅ `FirebaseService.swift` created for data operations
5. ✅ `BouquetViewModel` updated to use Firebase

## For New Developers Cloning This Project

If you clone this project, you'll need to add your own Firebase configuration:

### Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project (or use existing)
3. Add an iOS app to your project
4. Register with bundle ID: `com.bakercobb.Flowers` (or your bundle ID)

### Step 2: Download Configuration File

1. Download `GoogleService-Info.plist` from Firebase Console
2. Add it to the `Flowers/` directory in Xcode
3. Make sure "Copy items if needed" is checked
4. Make sure it's added to the Flowers target

### Step 3: Enable Firebase Services

In the Firebase Console, enable:

1. **Firestore Database**
   - Go to Firestore Database
   - Create database in production mode
   - Choose a location close to your users

2. **Authentication** (if needed for future features)
   - Go to Authentication
   - Enable sign-in methods you want to use

### Step 4: Configure Firestore Security Rules

Add these rules in Firestore Console → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Received bouquets subcollection
      match /receivedBouquets/{bouquetId} {
        allow read: if request.auth != null && request.auth.uid == userId;
        allow write: if request.auth != null;
      }
    }
    
    // Bouquets collection - allow reads for sender/receiver
    match /bouquets/{bouquetId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## Data Structure

### Users Collection
```
/users/{userId}
  - id: String
  - name: String
  - partnerId: String?
  - streakCount: Int
  - lastBouquetSent: Timestamp
```

### Bouquets Collection
```
/bouquets/{bouquetId}
  - id: UUID
  - fromUserId: String
  - toUserId: String
  - flowers: [Flower]
  - dateSent: Date
  - expirationDate: Date
```

### User's Received Bouquets
```
/users/{userId}/receivedBouquets/{bouquetId}
  - (same structure as bouquets)
```

## Firebase Service Functions

The `FirebaseService` class provides:

- `saveUser(_:)` - Save/update user data
- `getUser(userId:)` - Fetch user data
- `sendBouquet(_:)` - Send a bouquet to partner
- `getReceivedBouquets(userId:)` - Get all received bouquets
- `getActiveBouquet(userId:)` - Get the current active bouquet
- `pairUsers(userId:partnerId:)` - Link two users as partners

## Offline Support

The app uses a **hybrid approach**:

- ✅ **UserDefaults** for local caching (fast, offline-first)
- ✅ **Firebase** for cloud sync (cross-device, persistence)
- Data loads instantly from cache, then syncs with Firebase in background

## Security Notes

⚠️ **IMPORTANT**: `GoogleService-Info.plist` is in `.gitignore` and should NEVER be committed to Git!

- This file contains your Firebase API keys
- Each developer needs their own copy
- Keep it secure and don't share publicly

## Testing

To test Firebase integration:

1. Run the app on simulator/device
2. Create a bouquet and send it
3. Check Firebase Console → Firestore Database
4. You should see data in `/users` and `/bouquets` collections

## Troubleshooting

### "No such module 'FirebaseCore'"
- Make sure Firebase packages are added via SPM
- Go to: File → Add Package Dependencies → `https://github.com/firebase/firebase-ios-sdk`

### "Missing GoogleService-Info.plist"
- Download from Firebase Console
- Add to Xcode project (not just file system)
- Ensure it's in the target

### Data not syncing
- Check internet connection
- Verify Firestore rules allow read/write
- Check Xcode console for Firebase errors

## Future Enhancements

Potential Firebase features to add:

- 🔐 Firebase Authentication for secure user accounts
- 📸 Cloud Storage for custom flower images
- 🔔 Cloud Messaging for push notifications when bouquets are received
- 📊 Analytics to track app usage
- 🔗 Dynamic Links for invite system

