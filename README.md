# Budget

An iOS budgeting app built with SwiftUI and MVVM. It tracks spending against a monthly budget (200,000 KSh by default), entirely on device with SwiftData.

## Screenshots

| Home | Add New Budget Item | Success | Budgets |
|---|---|---|---|
| <img src="docs/screenshots/home.png" width="200"> | <img src="docs/screenshots/add-item.png" width="200"> | <img src="docs/screenshots/success.png" width="200"> | <img src="docs/screenshots/budgets.png" width="200"> |

## Status

### Implemented

- **Home:** welcome header, gradient balance card, month filter, stacked category bar (Swift Charts) with legend, and recent transactions.
- **Add New Budget Item:** category picker, item name and allocation fields with inline validation.
- **Success:** animated check mark with confetti, item summary, and a rating sheet.
- **Budgets:** expenses grouped by category, swipe to delete, and an editable monthly budget.
- **Foundation:** custom tab bar, light and dark theme, SwiftData behind a `BudgetRepository` protocol.
- **Tests:** unit tests for the Home and Add Item view models and the SwiftData repository.

### Not yet implemented

- **Reports and Account tabs:** both show placeholder text only
- **UI tests:** none.
- **More unit tests:** `CurrencyFormatter` and `DateFormatting` 
- **Product Sans:** the font files are not in `Budget/Resources/Fonts`, so the app falls back to the system font.
- **Material Symbols:** the tab bar and bell use SF Symbols.

## Setup

1. Open `Budget.xcodeproj` in Xcode 26 or later.
2. Select an iPhone simulator running iOS 26.5 or later.
3. Run with ⌘R.

To use Product Sans, add `ProductSans-Regular.ttf` and `ProductSans-Bold.ttf` to `Budget/Resources/Fonts`. They are already registered in `Budget/Info.plist`.

## Tests

Run all tests with ⌘U, or from the command line:

```
xcodebuild test -project Budget.xcodeproj -scheme Budget -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```


