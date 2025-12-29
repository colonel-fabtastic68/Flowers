# How to Add Custom Flower Images to Your App

Now that the app is working with SF Symbols placeholders, here's how to add your own beautiful flower images!

## Option 1: Using PNG Images (Easiest!)

### Step 1: Create or Find Your Flower Images

You can:
1. **Download free flower PNGs** from:
   - [Flaticon](https://www.flaticon.com) - search "geometric flower" or "low poly flower"
   - [Freepik](https://www.freepik.com) - search "polygonal flower"
   - [IconFinder](https://www.iconfinder.com) - search "flower icon"

2. **Create your own** in:
   - **Figma** (free, web-based)
   - **Canva** (free templates)
   - **Adobe Illustrator** (paid)

### Step 2: Prepare Your Images

For each flower type (Tulip, Rose, Daisy, Lily, Iris, Sunflower), you need:
- **PNG format** with transparent background
- **Square aspect ratio** (e.g., 512x512px)
- **Three resolutions** for best quality:
  - 1x: 128x128px
  - 2x: 256x256px  
  - 3x: 384x384px

### Step 3: Add to Xcode Assets

1. **Open Xcode** and select `Assets.xcassets` in the navigator
2. **Right-click** in the assets area → "New Image Set"
3. **Name it** (e.g., "TulipFlower")
4. **Drag and drop** your images:
   - 128x128 → into the "1x" slot
   - 256x256 → into the "2x" slot
   - 384x384 → into the "3x" slot

5. **Repeat** for all 6 flower types:
   - TulipFlower
   - RoseFlower
   - DaisyFlower
   - LilyFlower
   - IrisFlower
   - SunflowerFlower

### Step 4: Update the Code

Replace `SimpleFlowerView.swift` with this:

```swift
import SwiftUI

struct SimpleFlowerView: View {
    let type: FlowerType
    let color: FlowerColor
    let size: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            // Flower head with your custom image
            Image(flowerImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .foregroundColor(color.color) // This will tint the image
            
            // Stem
            Rectangle()
                .fill(Color(red: 0.45, green: 0.65, blue: 0.45))
                .frame(width: size * 0.12, height: size * 0.8)
            
            // Leaves
            HStack(spacing: size * 0.1) {
                Image(systemName: "leaf.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size * 0.3)
                    .foregroundColor(Color(red: 0.50, green: 0.70, blue: 0.50))
                    .rotationEffect(.degrees(-30))
                
                Image(systemName: "leaf.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size * 0.3)
                    .foregroundColor(Color(red: 0.45, green: 0.65, blue: 0.45))
                    .rotationEffect(.degrees(30))
            }
            .offset(y: -size * 0.4)
        }
    }
    
    private var flowerImageName: String {
        switch type {
        case .tulip: return "TulipFlower"
        case .rose: return "RoseFlower"
        case .daisy: return "DaisyFlower"
        case .lily: return "LilyFlower"
        case .iris: return "IrisFlower"
        case .sunflower: return "SunflowerFlower"
        }
    }
}
```

## Option 2: Using Colored Images (No Tinting)

If you want **separate images for each color combination** (more work, more control):

### Assets Structure:
```
Assets.xcassets/
  ├── Tulip-Pink
  ├── Tulip-Peach
  ├── Tulip-Purple
  ├── Tulip-Yellow
  ├── Tulip-White
  ├── Tulip-Red
  ├── Rose-Pink
  ├── Rose-Peach
  ... (36 total images: 6 types × 6 colors)
```

### Update Code:
```swift
private var flowerImageName: String {
    let typeString = type.rawValue
    let colorString = color.rawValue
    return "\(typeString)-\(colorString)"
}
```

## Option 3: Using SF Symbols (Current Implementation)

The app currently uses **Apple's built-in SF Symbols** which:
- ✅ Work immediately (no downloads needed)
- ✅ Scale perfectly at any size
- ✅ Support color tinting
- ❌ Less unique/custom looking

You can browse all available symbols with the **SF Symbols app**:
1. Download from [Apple Developer](https://developer.apple.com/sf-symbols/)
2. Browse 5000+ icons
3. Copy the name and use it in your code

## Tips for Best Results

### For Polygonal/Low-Poly Style:
1. **Keep it simple**: Use 8-15 polygons per petal
2. **Flat colors**: No gradients within shapes
3. **Sharp edges**: Straight lines, not curves
4. **Consistent style**: All flowers should match aesthetically

### Image Requirements:
- ✅ **Transparent background** (PNG)
- ✅ **High resolution** (at least 256x256 for 2x)
- ✅ **Centered** in the canvas
- ✅ **Consistent sizing** (similar visual weight)

### Quick Figma Tutorial:
1. Create 512x512 artboard
2. Use polygon tool (set sides to 6-8)
3. Duplicate and rotate for petals
4. Use solid colors
5. Add center circle
6. Export as PNG with transparent background

## Testing Your Images

After adding images, test by:
1. Build and run the app
2. Go to design view
3. Select different flower types
4. Check that:
   - Images load correctly
   - Colors tint properly (if using Option 1)
   - Sizing looks good
   - All 6 types appear

## Need Help?

If images don't appear:
- Check spelling in asset names
- Ensure PNG has transparent background
- Verify images are in correct slots (1x, 2x, 3x)
- Clean build folder (Cmd+Shift+K) and rebuild

The current SF Symbols implementation works great as a starting point - you can always add custom images later!

