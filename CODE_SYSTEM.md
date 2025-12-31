# 4-Digit Code System

## Overview

The Flowers app uses a simple 4-digit code system for user identification and pairing. No email, password, or personal information required!

## How It Works

### First Launch
1. App generates a **unique User ID** (UUID)
2. Generates a random **4-digit code** (e.g. "1234")
3. Saves User ID in **Keychain** (secure, persists across app deletions)
4. Saves code→userId mapping in **Firebase**

### Your Code
- Each user has a unique 4-digit code (0000-9999)
- Code is displayed on the home screen
- Share this code with someone to receive flowers

### Pairing with a Partner
1. Get their 4-digit code
2. Tap "Connect with Partner"
3. Enter their code
4. Start sending flowers!

### Cross-Device Support

#### Same Device
- User ID stored in **iOS Keychain**
- Survives app deletion and reinstall
- Automatically restored on launch

#### New Device
1. Open app on new device
2. Enter your old 4-digit code
3. App looks up your User ID in Firebase
4. Restores your account, streaks, and partner

## Technical Architecture

### Data Storage

#### Local (Keychain)
```
Key: userId
Value: "abc-123-def-456" (UUID)
```

**Why Keychain?**
- More secure than UserDefaults
- Survives app deletion
- Per-device storage

#### Firebase Collections

**users/{userId}**
```json
{
  "id": "abc-123-def-456",
  "code": "1234",
  "name": "You",
  "partnerId": "xyz-789",
  "streakCount": 5,
  "lastBouquetSent": 1735608123
}
```

**codes/{code}**
```json
{
  "userId": "abc-123-def-456",
  "createdAt": 1735608123
}
```

### Flow Diagrams

#### New User Flow
```
Launch App
    ↓
No User ID in Keychain?
    ↓
Generate UUID + Random Code
    ↓
Save to Keychain + Firebase
    ↓
Show Home Screen with Code
```

#### Returning User Flow
```
Launch App
    ↓
User ID found in Keychain?
    ↓
Load from UserDefaults Cache
    ↓
Sync with Firebase (background)
    ↓
Show Home Screen
```

#### Restore on New Device
```
Launch App
    ↓
User taps "Restore Account"
    ↓
Enter 4-Digit Code
    ↓
Firebase Lookup: code → userId
    ↓
Fetch User Data
    ↓
Save to Keychain
    ↓
Restored!
```

#### Pairing Flow
```
User A has Code: 1234
User B has Code: 5678
    ↓
User A enters "5678"
    ↓
Firebase: 5678 → User B's ID
    ↓
Link User A ← → User B
    ↓
Both can send flowers
```

## Security Considerations

### Strengths
✅ No passwords to leak
✅ No email addresses stored
✅ Simple and user-friendly
✅ Keychain provides secure storage
✅ 10,000 possible codes

### Limitations
⚠️ **Codes are guessable** (4 digits = 10,000 combinations)
⚠️ Anyone with your code can find your User ID
⚠️ No authentication beyond the code

### Recommendations for Production

For a production app, consider:

1. **Increase Code Length**
   ```swift
   // 6-digit code = 1,000,000 combinations
   static func generateCode() -> String {
       let code = Int.random(in: 0...999999)
       return String(format: "%06d", code)
   }
   ```

2. **Add Optional Authentication**
   - Firebase Auth for verified accounts
   - Face ID / Touch ID for local access
   - Optional password protection

3. **Rate Limiting**
   - Limit code lookup attempts
   - Prevent brute force attacks
   - Firebase rules + Cloud Functions

4. **Code Expiry**
   - Codes expire after X days
   - Force regeneration periodically
   - Adds security layer

## Code Generation

### Current Implementation
```swift
static func generateCode() -> String {
    let code = Int.random(in: 0...9999)
    return String(format: "%04d", code)
}
```

### Collision Handling
- **Probability**: With 10,000 users, ~50% chance of collision
- **Current**: No collision detection (relies on Firebase uniqueness)
- **TODO**: Add retry logic if code already exists

### Improved Generation
```swift
func generateUniqueCode() async throws -> String {
    var attempts = 0
    while attempts < 10 {
        let code = String(format: "%04d", Int.random(in: 0...9999))
        
        if try await firebaseService.isCodeAvailable(code) {
            return code
        }
        
        attempts += 1
    }
    
    throw CodeGenerationError.tooManyAttempts
}
```

## User Experience

### UX Benefits
✅ **Simple**: Just 4 digits
✅ **Shareable**: Easy to communicate
✅ **Memorable**: Short enough to remember
✅ **Fast**: No forms, no verification

### UX Considerations
- Display code prominently
- Make it easy to copy
- Show pairing status clearly
- Explain what codes are for

## Testing

### Manual Testing
1. **New User**
   - Delete app
   - Reinstall
   - Verify new code generated

2. **Pairing**
   - Create two test accounts
   - Exchange codes
   - Verify pairing works

3. **Restore**
   - Note your code
   - Delete app
   - Reinstall
   - Enter code
   - Verify data restored

### Automated Testing
```swift
func testCodeGeneration() {
    let code = User.generateCode()
    XCTAssertEqual(code.count, 4)
    XCTAssertTrue(Int(code) != nil)
    XCTAssertTrue(Int(code)! >= 0 && Int(code)! <= 9999)
}
```

## Future Enhancements

### Possible Improvements
1. **QR Codes** - Generate QR from 4-digit code
2. **Share Sheet** - Share code via Messages/AirDrop
3. **Copy Button** - One-tap copy code to clipboard
4. **Code History** - See who you've paired with
5. **Temporary Codes** - Expiring invite codes

## FAQ

**Q: What if I forget my code?**
A: Your code is always displayed on the home screen. If you lose access to your device, there's currently no recovery method.

**Q: Can I change my code?**
A: Not in the current implementation. Codes are permanent.

**Q: What if someone guesses my code?**
A: They could pair with you and send/receive flowers. Consider this when adding sensitive features.

**Q: How many users can the system support?**
A: 10,000 unique codes. After that, collisions will occur more frequently.

**Q: Is this secure enough for production?**
A: For a fun flower-sharing app, yes. For financial or sensitive data, no.

---

Last Updated: December 30, 2025

