# Components Package

Reusable UI components, theme, and styling for the Module Architecture Mobile project.

## Overview

The `components` package provides all UI components, theme definitions, dimensions, and styling utilities used across feature modules. It ensures consistent design and reduces code duplication.

## Features

### UI Components
- **CustomLoadingButton** - Primary button with built-in loading state and throttling
- **CustomTextField** - Standard text input with validation support
- **CustomPhoneTextField** - Phone number input with country code
- **SafeAreaWithMinimum** - Safe area with minimum padding fallback
- **CustomLinearProgress** - Customizable linear progress indicator
- **CarouselSlider** - Image and content carousel

### Theme
- **ThemeColors** - Centralized color definitions (via `context.color`)
- **ThemeTextStyles** - Reusable text styles (via `context.textStyle`)
- **Themes** - Light and dark theme configurations
- **AppTheme** - App-wide theme provider

### Dimensions
- **Spacing Constants** - `kGap12`, `kGap16`, `kGap32`
- **Padding Constants** - `kPaddingAll16`, `kPaddingAll24`
- **Border Radius** - `kBorderRadius12`, `kBorderRadius16`
- **Special Widgets** - `kZeroBox`, `kDivider`, `kSpacer`

### Gap Widgets
- **Gap** - Vertical or horizontal spacing
- **SliverGap** - Gap for sliver lists

### Input Utilities
- **MaskedTextInputFormatter** - Input masking for formatted text
- **Phone formatters** - Phone number formatting utilities

## Installation

This package is part of the Module Architecture Mobile monorepo and is not published to pub.dev.

Add to your module's `pubspec.yaml`:

```yaml
dependencies:
  components:
    path: ../../packages/components
```

## Usage

### Import

```
import 'package:components/components.dart';
```

### SafeAreaWithMinimum

**MUST** use instead of `SafeArea`:

```
SafeAreaWithMinimum(
  minimum: Dimensions.kPaddingAll16,
  child: Column(
    children: [
      // Your content
    ],
  ),
)
```

### CustomLoadingButton

**MUST** use for primary buttons:

```
CustomLoadingButton(
  onPressed: () {
    // Handle tap
  },
  child: Text(
    'Submit',
    style: context.textStyle.buttonStyle,
  ),
)

// With loading state
CustomLoadingButton(
  onPressed: isLoading ? null : () {
    // Handle tap
  },
  child: Text('Submit'),
)
```

### Dimensions

**MUST** use for all spacing and padding:

```
Column(
  children: [
    Text('Hello'),
    Dimensions.kGap16, // Vertical gap
    Text('World'),
    Dimensions.kGap32,
    CustomLoadingButton(
      onPressed: () {},
      child: Text('Button'),
    ),
  ],
)

// Padding
Container(
  padding: Dimensions.kPaddingAll16,
  child: Text('Content'),
)

// Border radius
Container(
  decoration: BoxDecoration(
    borderRadius: Dimensions.kBorderRadius12,
  ),
)
```

### Theme Colors

**MUST** use via `context.color`:

```
Container(
  color: context.color.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: context.color.textPrimary),
  ),
)

// Available colors
context.color.primary
context.color.secondary
context.color.background
context.color.surface
context.color.error
context.color.textPrimary
context.color.textSecondary
context.color.border
context.color.divider
```

### Text Styles

**MUST** use via `context.textStyle`:

```
Text(
  'Heading',
  style: context.textStyle.defaultW700x24,
)

Text(
  'Body text',
  style: context.textStyle.defaultW400x14,
)

Text(
  'Custom',
  style: context.textStyle.defaultW600x16.copyWith(
    color: context.color.primary,
  ),
)

// Available text styles
context.textStyle.defaultW700x24  // Heading
context.textStyle.defaultW600x16  // Subheading
context.textStyle.defaultW400x14  // Body
context.textStyle.buttonStyle     // Button text
```

### CustomTextField

```
CustomTextField(
  controller: textController,
  hintText: 'Enter your name',
  labelText: 'Name',
  validator: (value) {
    if (value?.isEmpty ?? true) {
      return 'Name is required';
    }
    return null;
  },
)
```

### Gap Widgets

```
Column(
  children: [
    Text('First'),
    const Gap(16), // Vertical gap
    Text('Second'),
  ],
)

Row(
  children: [
    Text('Left'),
    const Gap(8), // Horizontal gap
    Text('Right'),
  ],
)

// In sliver lists
CustomScrollView(
  slivers: [
    SliverToBoxAdapter(child: Text('Item')),
    const SliverGap(16),
    SliverToBoxAdapter(child: Text('Item')),
  ],
)
```

## Component Catalog

### Buttons
- `CustomLoadingButton` - Primary button with loading state
- Built-in throttling (prevents double-tap)
- Automatic theme application

### Text Inputs
- `CustomTextField` - Standard text field
- `CustomPhoneTextField` - Phone number input
- `MaskedTextInputFormatter` - Input masking

### Layout
- `SafeAreaWithMinimum` - Safe area wrapper
- `Gap` - Spacing widget
- `SliverGap` - Sliver spacing

### Progress Indicators
- `CustomLinearProgress` - Linear progress bar

### Carousels
- `CarouselSlider` - Image/content carousel

## Dimensions Reference

### Gaps
```
Dimensions.kGap4    // 4px gap
Dimensions.kGap8    // 8px gap
Dimensions.kGap12   // 12px gap
Dimensions.kGap16   // 16px gap
Dimensions.kGap24   // 24px gap
Dimensions.kGap32   // 32px gap
```

### Padding
```
Dimensions.kPaddingAll16   // EdgeInsets.all(16)
Dimensions.kPaddingAll24   // EdgeInsets.all(24)
```

### Border Radius
```
Dimensions.kBorderRadius8
Dimensions.kBorderRadius12
Dimensions.kBorderRadius16
Dimensions.kShapeZero  // No border radius
```

### Special Widgets
```
Dimensions.kZeroBox   // SizedBox.shrink()
Dimensions.kDivider   // Horizontal divider
Dimensions.kSpacer    // Spacer()
```

## Theme Configuration

### Accessing Theme

```
// Colors
final primaryColor = context.color.primary;

// Text styles
final headingStyle = context.textStyle.defaultW700x24;

// Color scheme (fallback)
final accentColor = context.colorScheme.secondary;
```

### Theme Structure

The theme is organized into:
- **ThemeColors** - Semantic color definitions
- **ThemeTextStyles** - Reusable text styles
- **Themes** - Light/dark theme data

## Rules

### When to Use

✅ **MUST** use for:
- All UI components and widgets
- Spacing, padding, gaps, border radius (Dimensions)
- Theme colors (context.color)
- Text styles (context.textStyle)
- SafeArea (use SafeAreaWithMinimum)
- Primary buttons (use CustomLoadingButton)

✅ **MUST** use in:
- All feature modules
- Presentation layer widgets
- Reusable components

### When NOT to Use

❌ **NEVER**:
- Create custom UI components in modules (add to `components` if reusable)
- Hardcode dimensions, colors, or text styles
- Use `SafeArea` directly (use `SafeAreaWithMinimum`)
- Use `ElevatedButton` (use `CustomLoadingButton`)
- Use `Colors.blue`, `Color(0xFF...)` (use `context.color`)
- Use inline `TextStyle(...)` (use `context.textStyle`)

## Dependencies

### Core Dependencies
- `flutter` - Flutter framework
- `gap` - Gap widget library

### Optional
- `cached_network_image` - Image caching (if using image components)

### Development Dependencies
- `flutter_test` - Testing framework
- `analysis_lints` - Linting rules

## Best Practices

1. **Always use Dimensions**: Never hardcode spacing or padding values
2. **Use theme extensions**: Access colors and text styles via `context.color` and `context.textStyle`
3. **SafeAreaWithMinimum**: Use instead of `SafeArea` for better control
4. **CustomLoadingButton**: Use for all primary action buttons
5. **Add to package**: If you create a reusable component, add it to `components` package

## Example: Complete Page

```
class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeAreaWithMinimum(
      minimum: Dimensions.kPaddingAll16,
      child: Column(
        children: [
          Text(
            'Welcome',
            style: context.textStyle.defaultW700x24.copyWith(
              color: context.color.primary,
            ),
          ),
          Dimensions.kGap16,
          CustomTextField(
            hintText: 'Enter your name',
          ),
          Dimensions.kGap24,
          SizedBox(
            width: double.infinity,
            child: CustomLoadingButton(
              onPressed: () {
                // Handle action
              },
              child: Text(
                'Continue',
                style: context.textStyle.buttonStyle,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
```

## Related Documentation

- [Flutter Rules - UI Components & Styling](../../flutter-rules.md#13-ui-components--styling)
- [Flutter Rules - Package Usage Rules](../../flutter-rules.md#14-package-usage-rules)
- [Architecture Overview](../../docs/architecture/overview.md)

## License

[Add your license here]
