# UI_IMPLEMENTATION_GUIDE.md

> Official Guide for Converting UI Images into Flutter Screens
>
> Project: Al‑Maqbali Renewable Energy Interactive Showroom
>
> Audience: Codex, ChatGPT, AI Coding Agents

------------------------------------------------------------------------

# Objective

This document defines the mandatory workflow for implementing Flutter UI
from uploaded design images.

The AI must treat every uploaded screen image as the visual reference
while following the project's official design system and architecture.

------------------------------------------------------------------------

# Source Priority

1.  Uploaded UI image (layout & visual hierarchy)
2.  UI_DESIGN_RULES.md
3.  Mobile Design System
4.  Brand Identity
5.  PROJECT_CONTEXT.md

Higher-priority sources always override lower ones.

------------------------------------------------------------------------

# General Rules

-   Never redesign the screen.
-   Replicate layout as accurately as possible.
-   Keep RTL-first.
-   Keep Portrait-only.
-   Preserve consistency across all screens.
-   If something is unclear, record an assumption instead of inventing
    UI.

------------------------------------------------------------------------

# Image Analysis Workflow

For every uploaded image:

1.  Identify the screen purpose.
2.  Detect page sections.
3.  Identify reusable components.
4.  Identify navigation actions.
5.  Detect spacing rhythm.
6.  Detect typography hierarchy.
7.  Detect icon usage.
8.  Detect imagery.
9.  Detect colors.
10. Detect states (default, empty, loading, error).

------------------------------------------------------------------------

# Layout Rules

Always extract:

-   Safe Area
-   AppBar
-   Header
-   Content
-   Footer (if present)
-   Primary CTA
-   Secondary actions

Use consistent vertical rhythm.

------------------------------------------------------------------------

# Component Extraction

Convert repeated UI into reusable widgets.

Do not duplicate identical widgets.

------------------------------------------------------------------------

# Responsive Rules

Design primarily for: - 2160×3840 portrait

Scale proportionally for smaller Android devices without changing
hierarchy.

------------------------------------------------------------------------

# Naming Rules

Use descriptive names.

Examples:

-   HomeScreen
-   ProductCard
-   BrandGrid
-   CalculatorCard
-   RecommendationCard
-   ProductGallery
-   SpecificationTable

Avoid generic names like Widget1 or CardNew.

------------------------------------------------------------------------

# Visual Consistency Checklist

Verify:

-   Brand colors
-   Font hierarchy
-   Border radius
-   Shadows
-   Padding
-   Margins
-   Icon style
-   Button style
-   Card style
-   Image ratios

------------------------------------------------------------------------

# Missing Elements

If the image does not define an element:

-   Do not invent it.
-   Record it as an implementation assumption.
-   Keep the assumption minimal.

------------------------------------------------------------------------

# Screen Review Checklist

Before marking a screen complete:

-   Matches uploaded image.
-   RTL verified.
-   Brand identity respected.
-   Design system respected.
-   Consistent with previous screens.
-   No extra UI added.
-   No removed UI.
-   Single primary CTA.
-   No e-commerce patterns.

------------------------------------------------------------------------

# Forbidden

-   Visual redesign
-   Random spacing
-   Random colors
-   New interaction patterns
-   Different typography
-   Duplicate widgets
-   Architecture decisions inside UI implementation
-   Ignoring uploaded reference

------------------------------------------------------------------------

# Definition of Done

A screen implementation is accepted only when:

-   It visually matches the uploaded design.
-   It follows UI_DESIGN_RULES.md.
-   It follows the official Design System.
-   It remains consistent with every implemented screen.
-   No unsupported assumptions were introduced.
