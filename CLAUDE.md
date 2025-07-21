# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter recipes application that displays cooking recipes with ingredients and instructions. The app features a responsive design supporting mobile, tablet, and web layouts with a rich visual interface showcasing recipe ingredients and detailed cooking instructions.

## Development Commands

### Build and Run
- `flutter run` - Run the app in debug mode on connected device/emulator
- `flutter run --release` - Run the app in release mode
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app (requires macOS and Xcode)

### Development Tools
- `flutter analyze` - Run static analysis on Dart code using rules from analysis_options.yaml
- `flutter test` - Run unit and widget tests (no tests currently exist)
- `flutter pub get` - Install dependencies from pubspec.yaml
- `flutter pub upgrade` - Upgrade dependencies to latest compatible versions
- `flutter pub outdated` - Check for newer versions of dependencies
- `flutter doctor` - Check Flutter installation and environment setup
- `flutter clean` - Clean build artifacts and pub cache
- `flutter packages pub run flutter_launcher_icons:main` - Generate app icons

### Hot Reload
- Press `r` in terminal during `flutter run` for hot reload
- Press `R` in terminal for hot restart (full app restart)

## Architecture Overview

### App Structure
The app follows a layered architecture pattern:

1. **Data Layer** (`lib/model/`): JSON-based data models with serialization
2. **UI Layer** (`lib/pages/`): Screen-based organization with responsive layouts  
3. **Utilities** (`lib/utils/`): Shared utilities like color definitions
4. **Assets**: JSON data and image resources for recipes, ingredients, and menus

### Key Architectural Patterns

**Responsive Design Strategy:**
- Uses `LayoutBuilder` with breakpoints (600px mobile, 1200px tablet/desktop)
- Conditional rendering: `isMobile ? MobileWidget : TabletWidget`
- Different grid layouts for different screen sizes (3 columns tablet, 5 columns web, list on mobile)

**Data Flow:**
- JSON data loaded from `assets/data.json` using `rootBundle.loadString()`
- Models with `fromJson()` factory constructors for deserialization
- State management using StatefulWidget with `setState()`

**Navigation Pattern:**
- Uses Material `Navigator.push()` with `MaterialPageRoute`
- Hero animations for image transitions between screens
- Back navigation with custom styled back buttons

### Screen Hierarchy

**HomeScreen** (Primary screen):
- Recipe ingredient selection interface
- Displays available recipes as selectable cards
- Shows menu items for selected recipe in responsive grid/list
- Uses `CustomScrollView` with `Sliver` widgets for scrollable layout

**DetailScreen** (Secondary screen):
- Full recipe details with ingredients and instructions
- Responsive header with hero image transition
- Ingredients displayed in grid (desktop/tablet) or list (mobile)
- Instructions shown as bulleted list

### Data Models

**Recipe** → **Menu** → **Ingredient** hierarchy:
- `Recipe`: Contains name, image, and list of Menu items
- `Menu`: Individual recipes with ingredients list and cooking instructions
- `Ingredient`: Basic ingredient with name, image, and description

### Asset Organization
- `assets/data.json` - Recipe data source
- `assets/ingredient/` - Ingredient images (PNG files)
- `assets/menu/` - Recipe/menu images (JPG files)
- `assets/icon/` - App icon

## Dependencies

### Production
- `flutter` - Flutter framework
- `cupertino_icons` - iOS-style icons

### Development
- `flutter_test` - Testing framework
- `flutter_lints` - Recommended lints for Flutter projects
- `flutter_launcher_icons` - App icon generation

## Code Standards & Modern Practices

### Widget Construction
- Uses modern `super.key` instead of deprecated `Key? key` parameters
- Immutable widget fields with `final` keyword
- Const constructors where applicable for performance

### Color Management
- Custom color utilities in `lib/utils/colors.dart`
- Uses `withValues(alpha:)` instead of deprecated `withOpacity()`
- Consistent color scheme with `darkOrange` and `veryDarkOrange`

### Status Bar Configuration
- Transparent status bar with proper overlay styling
- `extendBodyBehindAppBar: true` for full-screen layouts
- SystemUiOverlayStyle configured in main app theme

### Responsive Breakpoints
- Mobile: ≤ 600px (list layouts, simplified UI)
- Tablet: 601-1200px (grid layouts with 3-5 columns)  
- Desktop/Web: > 1200px (fixed max width of 1200px, 8 column grids)

## Key Implementation Notes

When working with this codebase:
- All private widgets use underscore prefix and don't need key parameters
- Image assets follow naming pattern: `assets/ingredient/{name}.png` and `assets/menu/{name}.jpg`
- The app loads data asynchronously with `Future.delayed()` to simulate network loading
- Hero animations use image paths as tags for transitions
- Custom scroll views use Sliver widgets for performance with large lists

## Development Considerations

### Testing
- No unit or widget tests currently exist in this project
- Test directory is empty - consider adding tests for data models and widget behavior
- Integration tests would be valuable for navigation flows

### Performance
- Images are loaded directly from assets (no caching optimization)
- JSON data is loaded synchronously on app start
- Consider implementing proper error handling for asset loading failures

### Known Limitations
- Data is static (loaded from JSON file, no dynamic updates)
- No search or filtering functionality implemented
- No persistence layer (favorites, user preferences, etc.)