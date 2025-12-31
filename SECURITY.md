# Security & Privacy

## Firebase Security

### Protected Files (NOT in Git)
- `GoogleService-Info.plist` - Contains Firebase API keys and project configuration
- This file is in `.gitignore` and will NOT be pushed to GitHub

### Firestore Security Rules

The app uses secure Firestore rules to protect user data:

#### Current Rules (`firestore.rules`):

**✅ What's Protected:**
- Users can only read/update their own user data
- Bouquets are immutable once sent (cannot be edited or deleted)
- Users can only create bouquets, not modify existing ones
- Each user can only access their own received bouquets
- Validation ensures bouquet data is complete and properly formatted

**✅ What's Allowed:**
- Creating new users (for registration)
- Sending bouquets to other users
- Reading your own received bouquets
- Reading bouquet data (for delivery confirmation)
- Marking bouquets as viewed

**❌ What's Blocked:**
- Modifying other users' data
- Deleting or editing sent bouquets
- Accessing other users' received bouquets
- Creating invalid bouquet data
- All other collections/operations

### Deploying Security Rules

To deploy the security rules to Firebase:

```bash
# Install Firebase CLI (if not already installed)
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in project (first time only)
firebase init firestore

# Deploy rules
firebase deploy --only firestore:rules
```

Or manually copy the rules from `firestore.rules` to Firebase Console:
1. Go to Firebase Console → Firestore Database → Rules
2. Copy contents of `firestore.rules`
3. Click "Publish"

## Data Privacy

### What We Store:
- **Users**: ID, name, partner ID, streak count, last bouquet date
- **Bouquets**: Flower arrangements, sender/receiver IDs, timestamps
- **Flower Data**: Color, position, rotation, mirrored state

### What We DON'T Store:
- Email addresses (not required)
- Passwords (no authentication yet)
- Location data
- Device information
- Analytics/tracking data

### Data Retention:
- Bouquets automatically expire after 24 hours
- User data persists until app is deleted
- No server-side tracking or analytics

## Local Storage

The app uses **hybrid storage**:
- **UserDefaults** for local cache (instant offline access)
- **Firebase Firestore** for cloud sync (cross-device, persistence)

All data is cached locally, so the app works offline.

## API Keys

Firebase API keys are **not secret** but are **domain-restricted**:
- Keys are in `GoogleService-Info.plist`
- Keys are restricted to your Firebase project
- Security comes from Firestore rules, not API key secrecy
- Keys are safe in client apps (by Firebase design)

However, we keep them out of Git as a best practice.

## For Developers

### Setting Up Firebase (New Clone)

1. Get `GoogleService-Info.plist` from Firebase Console
2. Add to Xcode project (Flowers target)
3. Deploy security rules: `firebase deploy --only firestore:rules`
4. Build and run

### Testing Security

Test the rules locally:
```bash
firebase emulators:start --only firestore
```

## Reporting Security Issues

If you find a security vulnerability:
1. **DO NOT** open a public GitHub issue
2. Contact the developer privately
3. Allow time for a fix before public disclosure

## Best Practices

✅ **DO:**
- Keep `GoogleService-Info.plist` private
- Deploy security rules before production
- Test bouquet sending between real users
- Monitor Firebase Console for unusual activity

❌ **DON'T:**
- Commit `GoogleService-Info.plist` to Git
- Use `allow read, write: if true;` in production
- Share your Firebase project credentials
- Deploy without testing rules first

---

Last Updated: December 30, 2025

