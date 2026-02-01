# 👕 FreshFit – Smart Outfit Recommendation App

FreshFit is a **full-stack smart wardrobe management and outfit recommendation application** that helps users decide what to wear by digitizing their wardrobe and generating color-coordinated outfits using image processing and backend logic.

It combines **backend engineering, image processing, and secure authentication** to deliver a scalable, real-world solution that can grow into an AI-powered fashion platform.

---

## 🎯 Problem Statement

Choosing what to wear daily is often time-consuming and inefficient.

- People forget what clothes they own  
- Outfits get repeated frequently  
- Colors are mismatched unintentionally  

**FreshFit solves this** by digitizing a user’s wardrobe and generating smart outfit combinations automatically.

---

## 🧠 Solution Overview

FreshFit is a **client–server based mobile application** that:

- Allows users to upload clothing items with images  
- Extracts dominant colors from images using OpenCV  
- Stores wardrobe data securely per user  
- Generates matching outfit combinations  
- Saves outfit history for future reuse  

---

## 🏗️ System Architecture

FreshFit follows a **modular and scalable architecture**:

### 📱 Frontend
- Flutter mobile application
- Consumes REST APIs
- Displays wardrobe items, outfits, and history

### 🧠 Backend
- **FastAPI (Python)**
- Modular structure:
  - Routes → API endpoints
  - Services → Business logic
  - Models → Database schema
  - Dependencies → Authentication & DB sessions

### 🗄️ Database
- SQLAlchemy ORM
- SQLite (development)
- PostgreSQL (production-ready)

### 🎨 Image Processing
- OpenCV
- Dominant color extraction
- Color normalization for outfit matching

---

## 🔐 Authentication & Security

FreshFit uses **JWT-based authentication**:

- User signup and login
- Password hashing with **bcrypt**
- JWT token issued on login
- Protected routes require valid token

### Security Benefits
- Only authenticated users access data
- Each user sees only their own wardrobe
- No hardcoded user IDs (fully dynamic)

---

## 🧥 Wardrobe Management

Users can:

- Upload clothing images
- Add metadata (category: top, bottom, shoes)
- View and delete wardrobe items

Each clothing item:
- Is linked to the authenticated user
- Stores image paths internally
- Exposes a public `image_url` for frontend usage

Images are served using FastAPI’s static file system for efficient rendering.

---

## 🎨 Outfit Generation Logic

FreshFit uses OpenCV to:

- Extract dominant colors from clothing images
- Normalize colors for consistent matching

### Outfit Logic
- Groups clothes by category
- Applies basic color compatibility rules
- Randomizes valid combinations for variety

### Extensible Design
The logic is modular and can be extended to support:
- Advanced color theory
- Occasion-based outfits
- Machine learning models

---

## 📊 Outfit History

- Generated outfits are stored in the database
- Linked using foreign keys to clothing items
- Timestamped for history tracking

Users can:
- View previously generated outfits
- Reuse favorite combinations

---

## 🧠 Key Technical Highlights

- ✅ Clean FastAPI architecture  
- ✅ JWT-secured APIs  
- ✅ OpenCV-based color detection  
- ✅ SQLAlchemy relational models  
- ✅ Flutter-ready API responses  
- ✅ Scalable and extensible backend design  

---


## 🛠️ Tech Stack

### Backend
- Python
- FastAPI
- SQLAlchemy
- JWT Authentication
- OpenCV

### Frontend
- Flutter

### Database
- SQLite
- PostgreSQL

### Tools
- Git
- GitHub
- Postman

---

