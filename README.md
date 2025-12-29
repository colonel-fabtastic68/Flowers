# Bouquet - Flower Sharing App for Couples 🌸

A beautiful iOS app that lets couples design and share polygonal-style flower bouquets with each other. Each bouquet lasts 24 hours, encouraging daily connection and creativity.

## Features

### 🌷 Core Features
- **Design Custom Bouquets**: Choose from 6 different flower types (Tulip, Rose, Daisy, Lily, Iris, Sunflower)
- **6 Beautiful Colors**: Pink, Peach, Purple, Yellow, White, and Red
- **Drag & Drop Interface**: Position flowers exactly where you want them
- **24-Hour Expiration**: Bouquets expire after 24 hours to keep the streak going
- **Streak Counter**: Track how many consecutive days you've sent bouquets
- **Partner Invitations**: Send iMessage invites to connect with your significant other

### 🎨 Design
- **Polygonal Aesthetic**: Cute, low-poly art style for a modern, friendly look
- **Procedurally Generated Flowers**: All flowers are drawn using SwiftUI shapes
- **Beautiful Vase**: Each bouquet sits in a lovely teal polygonal vase
- **Smooth Animations**: Spring animations and transitions throughout

### 💕 For Couples
- **One-to-One Connection**: Each person connects with only one partner (MVP)
- **Send & Receive**: Design bouquets to send and view bouquets you've received
- **Real-time Timer**: Watch the countdown on each bouquet
- **Keep the Streak**: Send bouquets daily to maintain your connection streak

## Technical Details

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **MVVM Pattern**: Clear separation with `BouquetViewModel`
- **UserDefaults**: Local data persistence (ready for backend integration)
- **Combine**: Reactive state management

### Project Structure
```
Flowers/
├── Models/
│   ├── Flower.swift          # Flower data model
│   ├── Bouquet.swift         # Bouquet with 24h expiration
│   └── User.swift            # User and partner data
├── ViewModels/
│   └── BouquetViewModel.swift # App state management
├── Views/
│   ├── HomeView.swift         # Main screen with streak & partner info
│   ├── BouquetDesignView.swift # Flower selection and arrangement
│   ├── BouquetDisplayView.swift # View received bouquets
│   └── PolygonalFlowerView.swift # Custom flower shapes
├── ContentView.swift          # Root view
└── FlowersApp.swift          # App entry point
```

### Custom Shapes
All flowers are created using SwiftUI's `Shape` protocol:
- `TulipShape` - Classic tulip petals
- `RoseShape` - Layered rose petals
- `DaisyShape` - Petals around a center
- `LilyShape` - Star-like lily petals
- `IrisShape` - Upper and lower petals
- `SunflowerShape` - Many petals with large center
- `LeafShape` - Polygonal leaves
- `VaseShape` - Geometric vase

## How to Use

### First Time Setup
1. Open the app
2. Tap "Invite Your Partner"
3. Send an iMessage with the invitation link
4. Once connected, start designing bouquets!

### Creating a Bouquet
1. Tap "Create New Bouquet" from the home screen
2. Choose a flower type from the horizontal scroll
3. Select a color from the color palette
4. Tap a flower to add it to your bouquet
5. Drag flowers to position them perfectly
6. Long press to remove a flower
7. Tap "Send Bouquet" when you're done

### Viewing Bouquets
- Received bouquets appear on the home screen
- Tap to view full-screen with timer
- Watch the countdown to see how long until it expires
- Keep your streak going by sending new bouquets!

## Customization Guide

Want to add your own flower sprites instead of procedural shapes? Check out `SPRITES_GUIDE.md` for detailed instructions on:
- Creating polygonal graphics in Figma, Illustrator, or Blender
- Adding custom assets to Xcode
- Converting images to SwiftUI shapes
- Design tips for maintaining the aesthetic

## Future Enhancements

### Potential Features
- [ ] Push notifications when bouquet is received
- [ ] Backend integration for real-time syncing
- [ ] Bouquet history gallery
- [ ] Achievement badges
- [ ] Additional flower varieties
- [ ] Seasonal flowers
- [ ] Custom vase colors/styles
- [ ] Sound effects
- [ ] Haptic feedback
- [ ] Share bouquet screenshots
- [ ] Weekly/monthly streak milestones

### Backend Integration
The app is designed for easy backend integration:
- Replace `UserDefaults` with API calls
- Add user authentication
- Real-time bouquet delivery via push notifications
- Cloud storage for bouquet history

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+
- SwiftUI

## Privacy & Security

- User data stored locally in UserDefaults
- No analytics or tracking
- Invitation links contain only user IDs
- Ready for `.env` file integration for API keys

## Getting Started

1. Clone the repository
2. Open `Flowers.xcodeproj` in Xcode
3. Build and run on simulator or device
4. Start creating beautiful bouquets!

## License

Created by Baker Cobb - 2025

---

**Tip**: For the best experience, use this app daily with your partner to build a meaningful streak and stay connected through the language of flowers! 🌹💐🌻

