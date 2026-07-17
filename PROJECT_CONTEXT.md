# PROJECT_CONTEXT.md

> **Version:** 1.0 (Initial Baseline)\
> **Status:** Approved Baseline\
> **Project:** Al-Maqbali Renewable Energy Interactive Showroom\
> **Document Type:** Primary Project Context (Single Source of Truth)

------------------------------------------------------------------------

# Executive Summary

Al-Maqbali Renewable Energy Interactive Showroom is an **offline-first
Flutter Android application** designed for deployment on a large
interactive touch display inside Al-Maqbali Renewable Energy Company's
showroom.

The application serves as a professional digital showroom rather than an
e-commerce platform. It enables visitors to explore the company's
renewable energy products through an intuitive catalog and receive solar
system recommendations based on their monthly electricity bill or
consumption.

The application must operate entirely offline, use only locally embedded
assets and data, and maintain a premium corporate user experience
consistent with the company's official brand identity.

------------------------------------------------------------------------

# Vision

Create a premium interactive showroom experience that enables customers
to:

-   Discover Al-Maqbali's renewable energy products.
-   Understand technical specifications easily.
-   View official catalogs and documentation.
-   Receive suitable solar system recommendations.
-   Navigate the showroom digitally without assistance.

------------------------------------------------------------------------

# Goals

## Business Goals

-   Digitize the physical showroom.
-   Improve customer engagement.
-   Standardize product presentation.
-   Assist sales representatives during demonstrations.
-   Showcase only officially supported products.

## Technical Goals

-   100% offline operation.
-   High responsiveness on 4K touch displays.
-   Maintainable Clean Architecture.
-   Low memory consumption.
-   Long-term scalability.

## UX Goals

-   Minimal learning curve.
-   Simple navigation.
-   Fast access to product information.
-   Professional enterprise appearance.
-   Arabic-first experience.

------------------------------------------------------------------------

# Scope

## Included

-   Product Catalog (Brands, Products, Product Details, Gallery, PDF
    Catalogs)
-   Solar Recommendation Calculator
-   Recommendation Results
-   Product Details Navigation

## Excluded

-   Authentication
-   Cloud services
-   Shopping cart
-   Orders
-   Prices
-   Favorites
-   Online synchronization

------------------------------------------------------------------------

# Stakeholders

-   Al-Maqbali Renewable Energy Company
-   Showroom Visitors
-   Sales Representatives
-   Company Management

------------------------------------------------------------------------

# User Types

## Visitor

Capabilities:

-   Browse products
-   View specifications
-   Open PDF catalogs
-   Use recommendation calculator

------------------------------------------------------------------------

# Business Modules

## Interactive Product Catalog

Home → Brands → Products → Product Details → PDF Catalog

## Solar Recommendation Calculator

Input → Calculation → Recommendation → Product Details

------------------------------------------------------------------------

# Supported Brands

-   Solis
-   Pylontech
-   Hithium
-   LONGi
-   Canadian Solar

------------------------------------------------------------------------

# Business Rules

-   Offline-first.
-   Assets bundled with the application.
-   Recommendations use only products available in the local catalog.
-   No prices.
-   No purchases.
-   Arabic (RTL) only.
-   Portrait only.

------------------------------------------------------------------------

# Functional Requirements

-   Home Screen
-   Brand List
-   Product List
-   Product Details
-   PDF Viewer
-   Recommendation Calculator
-   Recommendation Results

------------------------------------------------------------------------

# Non-Functional Requirements

-   Offline operation
-   Responsive UI
-   Low memory usage
-   Premium UI
-   Clean Architecture
-   RTL support
-   Maintainability

------------------------------------------------------------------------

# User Flows

## Product Browsing

Launch → Home → Brands → Products → Product Details → PDF Viewer

## Recommendation

Launch → Calculator → Input → Recommendation → Product Details

------------------------------------------------------------------------

# UI Decisions

-   Premium Enterprise UI
-   Material 3 (Customized)
-   Corporate Branding
-   Single Primary CTA
-   No Bottom Navigation
-   No Drawer
-   No Prices

------------------------------------------------------------------------

# UX Decisions

-   RTL-first
-   Large touch targets
-   Simple navigation
-   Direct product access

------------------------------------------------------------------------

# Technical Decisions

Approved:

-   Flutter
-   Android
-   Clean Architecture
-   Repository Pattern
-   Offline-first

Pending:

-   State Management
-   Dependency Injection
-   Local Storage

------------------------------------------------------------------------

# Constraints

-   Android only
-   Arabic only
-   Portrait only
-   Offline only
-   Android 11
-   2 GB RAM
-   Less than 100 products

------------------------------------------------------------------------

# Risks

-   Recommendation algorithm not finalized.
-   Product mapping rules undefined.
-   Local storage not selected.
-   State Management not selected.
-   Dependency Injection not selected.

------------------------------------------------------------------------

# Open Decisions

  ID       Decision                   Status
  -------- -------------------------- --------
  OD-001   Recommendation algorithm   Open
  OD-002   Battery selection rules    Open
  OD-003   Inverter selection rules   Open
  OD-004   Local storage format       Open
  OD-005   State Management           Open
  OD-006   Dependency Injection       Open
  OD-007   Assets structure           Open

------------------------------------------------------------------------

# Document Governance

This document is the primary reference for the project knowledge base.
