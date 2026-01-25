# Accessibility Guidelines

TypeQuest is designed to be inclusive, ensuring that users of all abilities can master touch typing.

## 👁 Visual Accessibility

### Dynamic Type
- **Large Text Mode**: Automatically triggered for the "Senior" age group or when system settings specify large text.
- **Scaling**: UI elements (especially the typing area) use relative sizing to ensure readability at any scale.

### High Contrast
- **Color Palettes**: Contrast ratios follow WCAG 2.1 AA standards for all text elements.
- **Focus States**: High-visibility glows and outlines for selected nodes and fields.

### Color Blindness
- **Status Indicators**: Never rely on color alone. Errors are marked with underlines/strikethroughs, and success is marked with crowns or checkmarks.

## ⌨️ Input Accessibility

- **Sticky Keys Support**: Works natively with macOS/iPadOS sticky keys.
- **One-Handed Modes**: Specific lessons are optimized for left-hand only or right-hand only practice.

## 🔊 Screen Readers (VoiceOver)

- **Semantic Content**: Every custom UI component identifies itself with appropriate Accessibility Traits.
- **Live Regions**: WPM and Accuracy updates are reported in real-time or via summary announcements during pauses.
- **Keyboard Visualization**: Screen readers announce the "finger target" during intro sequences.
