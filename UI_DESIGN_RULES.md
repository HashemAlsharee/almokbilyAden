# UI_DESIGN_RULES.md

> Official UI Design Reference for AI Coding Agents
>
> Project: **Al‑Maqbali Renewable Energy Interactive Showroom**
>
> Status: **Mandatory**

------------------------------------------------------------------------

# Purpose

This document is the single source of truth for designing every screen
in the application.

Whenever a new UI mockup (image) is provided, the AI must reproduce it
while remaining fully compliant with these rules.

The uploaded design image defines **layout only**. This document defines
**implementation standards**.

------------------------------------------------------------------------

# Design Philosophy

-   Premium Enterprise
-   Corporate
-   Engineering-focused
-   Modern Minimalism
-   RTL First
-   Offline First
-   Material 3 (Customized)

Never design the application like an e-commerce app.

------------------------------------------------------------------------

# Brand Identity

Follow the official Al‑Maqbali identity.

Primary: `#1F2D3D`

Secondary: `#88C5E4`

Accent: `#FFCD9C`

Background: `#F8FAFC`

Surface: `#FFFFFF`

Divider: `#E5E7EB`

Success: `#16A34A`

Warning: `#F59E0B`

Error: `#DC2626`

Never invent new brand colors.

------------------------------------------------------------------------

# Typography

Primary Font:

AT Hauss Arabic

Hierarchy:

-   Display
-   Headline
-   Title
-   Body
-   Label
-   Caption
-   Button

Weights:

-   Bold
-   SemiBold
-   Medium
-   Regular

Never mix fonts.

------------------------------------------------------------------------

# Spacing

Use an 8pt Grid.

Allowed spacing:

4 8 16 24 32 40 48 64

No arbitrary spacing values.

------------------------------------------------------------------------

# Border Radius

Buttons: 16

Cards: 20

Images: 20

Dialogs: 24

Bottom Sheets: 28

------------------------------------------------------------------------

# Shadows

Minimal only.

Hierarchy should be created using:

-   spacing
-   typography
-   size

Avoid heavy shadows.

------------------------------------------------------------------------

# Icons

Material Symbols Outlined

Consistent stroke

Minimal

Engineering style

------------------------------------------------------------------------

# Images

Allowed:

-   Real products
-   Solar panels
-   Batteries
-   Inverters
-   Engineers
-   Company projects

Avoid stock lifestyle images.

------------------------------------------------------------------------

# Screen Structure

Each screen should contain when applicable:

1.  AppBar
2.  Screen Title
3.  Optional Description
4.  Main Content
5.  Single Primary CTA

------------------------------------------------------------------------

# Component Rules

Cards

-   Large touch targets
-   Rounded corners
-   Consistent padding

Buttons

-   One primary action
-   Filled or outlined only

Inputs

-   Clear labels
-   RTL aligned
-   Large tap area

Lists

-   Consistent spacing
-   Dividers only when needed

------------------------------------------------------------------------

# Navigation

RTL only.

Portrait only.

No Bottom Navigation.

No Drawer.

Prefer direct navigation.

------------------------------------------------------------------------

# Product Rules

Never display:

-   Prices
-   Discounts
-   Shopping Cart
-   Wishlist

Always display:

-   Image
-   Name
-   Model
-   Specifications
-   PDF Catalog (if available)

------------------------------------------------------------------------

# Calculator Rules

Input:

-   Monthly Bill OR
-   Monthly Consumption

Output:

-   Recommended Capacity
-   Recommended Panels
-   Recommended Batteries
-   Recommended Inverter

Recommendations must reference existing products only.

------------------------------------------------------------------------

# Motion

Duration:

200--300ms

Allowed:

-   Fade
-   Slide
-   Scale

Animations must be subtle.

------------------------------------------------------------------------

# Accessibility

-   RTL
-   High contrast
-   Large touch targets
-   Readable typography

------------------------------------------------------------------------

# Image-to-UI Rules

Whenever a UI image is uploaded:

1.  Treat the image as the visual reference.
2.  Match layout and spacing as closely as possible.
3.  Preserve the official color palette.
4.  Preserve typography hierarchy.
5.  Do not invent missing screens.
6.  If information is missing, document assumptions instead of guessing.
7.  Maintain consistency with previous screens.

------------------------------------------------------------------------

# Consistency Rules

Every new screen must match:

-   Colors
-   Typography
-   Component sizes
-   Padding
-   Corner radius
-   Elevation
-   Navigation
-   Icons
-   Interaction patterns

------------------------------------------------------------------------

# Forbidden

-   Glassmorphism
-   Neumorphism
-   Random gradients
-   Multiple primary buttons
-   Inconsistent spacing
-   Random fonts
-   Random colors
-   Prices
-   Promotions
-   E-commerce patterns

------------------------------------------------------------------------

# Definition of Done

A screen is complete only if:

-   It matches the uploaded design.
-   It follows this document.
-   It follows the project Design System.
-   It respects the Brand Identity.
-   It is visually consistent with all previous screens.
