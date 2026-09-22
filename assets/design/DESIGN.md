---
name: NegocioListo Pro
colors:
  surface: '#faf8ff'
  surface-dim: '#d2d9f4'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3ff'
  surface-container: '#eaedff'
  surface-container-high: '#e2e7ff'
  surface-container-highest: '#dae2fd'
  on-surface: '#131b2e'
  on-surface-variant: '#444651'
  inverse-surface: '#283044'
  inverse-on-surface: '#eef0ff'
  outline: '#757682'
  outline-variant: '#c5c5d3'
  surface-tint: '#4059aa'
  primary: '#00236f'
  on-primary: '#ffffff'
  primary-container: '#1e3a8a'
  on-primary-container: '#90a8ff'
  inverse-primary: '#b6c4ff'
  secondary: '#006c49'
  on-secondary: '#ffffff'
  secondary-container: '#6cf8bb'
  on-secondary-container: '#00714d'
  tertiary: '#3e2400'
  on-tertiary: '#ffffff'
  tertiary-container: '#5c3800'
  on-tertiary-container: '#ef9900'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dce1ff'
  primary-fixed-dim: '#b6c4ff'
  on-primary-fixed: '#00164e'
  on-primary-fixed-variant: '#264191'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#faf8ff'
  on-background: '#131b2e'
  surface-variant: '#dae2fd'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.025em
  display-lg-mobile:
    fontFamily: Inter
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-xl:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-xl-mobile:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.015em
  headline-lg:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: -0.005em
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0em
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0em
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
    letterSpacing: 0.005em
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.03em
  metric-display:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.03em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1.5rem
  gutter-mobile: 0.75rem
  margin: 2rem
  margin-mobile: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system establishes a high-trust, executive-grade operating environment tailored for micro-merchants, retail store operators, and independent business owners. Blending the deliberate precision of modern enterprise fintech with the physical-digital ergonomics of Apple hardware interfaces, the aesthetic balances austere financial rigor with welcoming operational clarity. 

The visual style is **Corporate / Modern** elevated by tactile subtleties: ultra-crisp hairline borders, disciplined whitespace hierarchies, and high-legibility metric displays. Designed to transition smoothly between mobile point-of-sale (POS) interactions at the counter and deep inventory reconciliation on desktop workstations, the emotional signature is composed, frictionless, and unmistakably dependable.

## Colors

The palette relies on deliberate contrast hierarchies designed to keep operational data immediately readable under harsh countertop lighting as well as standard office conditions:

- **Primary (`#1E3A8A`)**: Deep financial sapphire used for core brand presence, active states, key interactive indicators, and primary navigational structures.
- **Secondary (`#10B981`)**: Saturated emerald green strictly reserved for positive financial deltas, completed transactions, successful settlements, and live terminal states.
- **Tertiary (`#F59E0B`)**: Warm amber utilized for pending states, low inventory thresholds, required validations, and non-blocking operational alerts.
- **Neutral (`#0F172A`)**: Rich slate obsidian used for high-contrast primary typography and foreground structural layers.

### Surface Tones & Tokens
- **Canvas / Background**: `#F8FAFC` (Light Mode) / `#0B0F19` (Dark Mode)
- **Card & Sheet Surface**: `#FFFFFF` (Light Mode) / `#111827` (Dark Mode)
- **Subtle Surface (Input/Table Header)**: `#F1F5F9` (Light Mode) / `#1E293B` (Dark Mode)
- **Border Hairline**: `rgba(226, 232, 240, 0.8)` (Light Mode) / `rgba(51, 65, 85, 0.5)` (Dark Mode)
- **Muted Text**: `#64748B` (Light Mode) / `#94A3B8` (Dark Mode)
- **Critical / Error**: `#EF4444` for failed payments and destructive actions.

## Typography

Typography is powered exclusively by `Inter`, prioritizing legibility, tabular figure alignments, and precise character rhythm:

- **Tabular Figures (`tnum`)**: Enable OpenType tabular lining figures (`font-variant-numeric: tabular-nums`) across all financial tables, balance tallies, inventory counts, and timestamp logs to prevent visual jitter during live updates.
- **Metric Treatments**: `metric-display` is matched with tight negative tracking to deliver clear authority on POS dashboards and revenue analytics without requiring decorative display typefaces.
- **Hierarchy Rules**: Primary labels utilize Medium (500) and SemiBold (600) weights to separate descriptive field data from user-editable entries. Uppercase styling is strictly limited to `label-sm` with slight tracking expansions (`0.03em`).

## Layout & Spacing

The system is structured on an 8pt base grid with a 4pt sub-grid for dense POS controls:

- **Layout Structure**:
  - **Desktop (1024px+)**: 12-column responsive fluid grid with `2rem` (`32px`) margins and `1.5rem` (`24px`) gutters. Sidebar navigation remains docked with a fixed width of `260px` or a collapsed state of `72px`.
  - **Tablet (768px - 1023px)**: 8-column layout with `1.5rem` margins and `1rem` gutters. Optimized for horizontal countertop POS mounts.
  - **Mobile (< 768px)**: 4-column layout with `1rem` margins and `0.75rem` gutters, utilizing sticky top summary headers and bottom action sheets.
- **Density Modes**:
  - **Standard Density**: Applied to back-office analytics, multi-page settings, and reporting views (`space-md` to `space-lg` padding).
  - **Touch / Terminal Density**: Applied to register, scanning, and checkout flows where touch targets require a minimum height of `48px` and spacing between actionable items is at least `space-sm` (`8px`) to prevent accidental taps.

## Elevation & Depth

Visual hierarchy is maintained through dual-layer construction: hyper-delicate border strokes combined with ambient, diffused drop shadows.

- **Hairline Framing**: Surfaces use a 1px border stroke (`rgba(226, 232, 240, 0.8)`) to maintain distinct separation across light-slate canvases regardless of ambient screen glare.
- **Ambient Shadow System**:
  - **Level 0 (Flat)**: Inset controls, static form fields, and empty states. No shadow.
  - **Level 1 (Cards, Metric Blocks)**: `0 1px 3px 0 rgba(15, 23, 42, 0.04), 0 1px 2px -1px rgba(15, 23, 42, 0.03)` with matching 1px hairline border.
  - **Level 2 (Hovered Cards, Dropdowns, Flyouts)**: `0 4px 6px -1px rgba(15, 23, 42, 0.06), 0 2px 4px -2px rgba(15, 23, 42, 0.04)`.
  - **Level 3 (Modals, Slide-over Drawers, POS Pay Sheets)**: `0 20px 25px -5px rgba(15, 23, 42, 0.08), 0 8px 10px -6px rgba(15, 23, 42, 0.04)`.
- **Dark Mode Elevation**: Eliminates shadow rendering entirely in favor of progressive tonal layering: `#0B0F19` canvas base, `#111827` card layer, and `#1F2937` modal overlay, defined by `rgba(51, 65, 85, 0.5)` borders.

## Shapes

The design system maintains a consistent **Rounded (`2`)** profile with a baseline radius of `0.5rem` (`8px`), stepping up to `1rem` (`16px`) for standard cards:

- **Cards & Data Modules**: Strictly `1rem` (`16px`, `rounded-lg`). Creates the friendly, approachable look of modern consumer devices while maintaining strict grid geometry.
- **Interactive Inputs & Buttons**: Standardized at `0.5rem` (`8px`) for compact UI and `0.75rem` (`12px`) for high-touch POS buttons.
- **Badges, Status Pills & Chips**: Fully circular (`9999px`) to immediately distinguish contextual status elements from clickable cards and rectangular inputs.

## Components

### Buttons
- **Primary**: Solid `#1E3A8A` background with crisp `#FFFFFF` text. Minimum tap height `44px` on desktop, `48px` on mobile/POS. Hover: `#172554`. Active: subtle scale down (`0.98`).
- **Success / Checkout Action**: Saturated `#10B981` with white text, utilized exclusively for completion operations (e.g., "Collect $24.50", "Approve Refund"). Hover: `#059669`.
- **Secondary / Outline**: `#FFFFFF` background, `1px` border in `#E2E8F0`, text in `#0F172A`. Hover: background `#F8FAFC`, border `#CBD5E1`.
- **Ghost / Destructive**: Red tonal state `#FEF2F2` with `#DC2626` text, reserved for order voiding and critical cancellations.

### Cards & Metric Displays
- **Metric Cards**: Pure `#FFFFFF` background, `16px` border-radius, `1px` border `#E2E8F0/80`. Include metric label in `label-md` (`#64748B`), the key amount in `metric-display` (`tnum`), and a trend pill badge (emerald for gains, slate for neutral, red for decline).
- **Interactive List Cards**: Tap-friendly payment method or SKU selectors featuring a `1px` border that transitions to `2px` `#1E3A8A` on active selection.

### Form Inputs & Selectors
- **Text & Numeric Fields**: Height `44px` (`48px` for POS keypad), corner radius `8px`, border `1px` `#CBD5E1`, background `#FFFFFF`. Focus: outline none, border `#1E3A8A`, subtle ring `3px` `rgba(30, 58, 138, 0.12)`.
- **Monetary Keypad Input**: Large formatted balance inputs utilizing `display-lg` sizing with left-anchored static currency symbols (`$` or local denomination) rendered in muted `#94A3B8`.

### Chips & Status Badges
- **Status Indicators**: Compact badge components with radius `9999px`, vertical padding `2px`, horizontal padding `8px`, typography `label-sm`.
  - **Settled / Active**: `#ECFDF5` background with `#065F46` text.
  - **Pending / In Review**: `#FFFBEB` background with `#92400E` text.
  - **Failed / Overdue**: `#FEF2F2` background with `#991B1B` text.

### Selection Controls
- **Checkboxes & Radios**: `20px × 20px` surface, border `1.5px` `#CBD5E1`, radius `6px` for checkbox, `50%` for radio. Checked state: `#1E3A8A` fill with crisp white vector checkmark.

### Specialized POS Elements
- **Cart Summary Drawer**: Fixed-bottom panel for mobile devices featuring `16px` top radii, containing an itemized breakdown and a sticky full-width checkout button with integrated tactile feedback cues.