# 🎒 Emergency Kit Checklist

A Calamity Preparedness App built with Flutter and Supabase.

## Features

- ✅ Add emergency kit items
- ✅ Mark items as Ready/Not Ready
- ✅ Filter by category (Food, Water, Medicine, Tools, Documents, Clothing)
- ✅ Track preparedness percentage
- ✅ iOS-style UI design
- ✅ Responsive for mobile web

## CRUD Operations

| Operation | Description |
|-----------|-------------|
| **Create** | Add new emergency item |
| **Read** | View all items, filter by category |
| **Update** | Edit item details, toggle ready status |
| **Delete** | Remove item from checklist |

## Tech Stack

- **Frontend:** Flutter (Cupertino/iOS style)
- **Backend:** Supabase (PostgreSQL)
- **State Management:** Provider

## Quick Start

1. Setup Supabase (see `SETUP_GUIDE.md`)
2. Update `lib/config/supabase_config.dart` with your credentials
3. Run `flutter pub get`
4. Run `flutter run -d chrome`
