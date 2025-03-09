# Firebase Setup for EuropeGAS

This document provides instructions for completing the Firebase setup for the EuropeGAS project.

## Project Information
- **Project Name:** EuropeGAS
- **Project ID:** europegas-dac64
- **Project Number:** 781356430405
- **App ID:** 1:781356430405:web:9a93fe41d664626f8a1f2c

## Steps to Complete Setup

### 1. Generate a Web API Key

You need to generate a Web API Key for your project. Follow these steps:

1. Go to the [Firebase Console](https://console.firebase.google.com/project/europegas-dac64/settings/general)
2. Click on the "Project settings" (gear icon) in the left sidebar
3. Go to the "General" tab
4. Scroll to the bottom to the "Your apps" section
5. If a Web app is already registered:
   - Click on it to view the configuration
   - Copy the `apiKey` value
6. If no Web app is registered:
   - Click "Add app" (</> icon)
   - Enter a nickname (e.g., "EuropeGAS Web")
   - Click "Register app"
   - Copy the `apiKey` value from the configuration shown

### 2. Update the .env File

1. Open the `.env` file in your project root
2. Replace `YOUR_API_KEY_HERE` with the API key you copied
3. If you set up Google Analytics, update the `REACT_APP_FIREBASE_MEASUREMENT_ID` value with your Google Analytics ID (starts with "G-")

Example:
```
REACT_APP_FIREBASE_API_KEY=AIzaSyBJ4Sm-cV4-uVH6A2VYySW4JWrNZ5-eR8A
```

### 3. Enable Required Firebase Services

For full functionality, enable these Firebase services:

#### Authentication
1. Go to [Firebase Authentication](https://console.firebase.google.com/project/europegas-dac64/authentication)
2. Click "Get started" or "Set up sign-in method"
3. Enable Email/Password authentication
4. (Optional) Enable other authentication methods as needed

#### Firestore Database
1. Go to [Firestore Database](https://console.firebase.google.com/project/europegas-dac64/firestore)
2. Click "Create database"
3. Choose "Start in production mode" or "Start in test mode" (for development)
4. Select a location closest to your users
5. Click "Enable"

#### Storage
1. Go to [Storage](https://console.firebase.google.com/project/europegas-dac64/storage)
2. Click "Get started"
3. Choose "Start in production mode" or "Start in test mode" (for development)
4. Select a location closest to your users
5. Click "Done"

### 4. Set Up Security Rules

Configure security rules for Firestore and Storage:

#### Firestore Rules
Go to [Firestore Rules](https://console.firebase.google.com/project/europegas-dac64/firestore/rules) and set up rules like:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow public read access to products
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
    
    // User data - only accessible by the user or admin
    match /users/{userId} {
      allow read, write: if request.auth != null && (request.auth.uid == userId || request.auth.token.admin == true);
    }
    
    // Orders - only accessible by the user who placed the order or admin
    match /orders/{orderId} {
      allow read, write: if request.auth != null && (resource.data.userId == request.auth.uid || request.auth.token.admin == true);
      allow create: if request.auth != null;
    }
  }
}
```

#### Storage Rules
Go to [Storage Rules](https://console.firebase.google.com/project/europegas-dac64/storage/rules) and set up rules like:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Product images can be read by anyone
    match /products/{allImages=**} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
    
    // User profile images
    match /users/{userId}/{allImages=**} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Using Firebase in Your Application

The Firebase configuration has been set up in these files:
- `.env` - Contains your Firebase keys and configuration
- `src/firebase/firebaseConfig.js` - Loads the configuration from environment variables
- `src/firebase/firebase.js` - Initializes Firebase services
- `src/firebase/europeGasFirebase.js` - Contains EuropeGAS-specific Firebase functions

To use Firebase in your components, import functions from `europeGasFirebase.js`:

```javascript
import { signIn, getProducts, addProduct, uploadProductImage } from '../firebase/europeGasFirebase';

// Example: Sign in a user
const handleLogin = async (email, password) => {
  try {
    const user = await signIn(email, password);
    console.log('Logged in as:', user.email);
  } catch (error) {
    console.error('Login failed:', error);
  }
};

// Example: Load products
const loadProducts = async () => {
  try {
    const products = await getProducts();
    setProducts(products);
  } catch (error) {
    console.error('Failed to load products:', error);
  }
};
```

## Support and Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Firebase Console](https://console.firebase.google.com/project/europegas-dac64)
- [Firebase React Hooks](https://github.com/CSFrequency/react-firebase-hooks) - Useful React hooks for Firebase 