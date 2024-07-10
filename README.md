# ChitChat App

## Overview

ChitChat is a real-time chat application built with Flutter and Firebase. It includes features such as user authentication, real-time messaging, image sharing, and push notifications. The app is designed to provide a seamless and engaging chat experience.

## Features

- **User Authentication:** Sign up and log in with email and password.
- **Real-time Messaging:** Send and receive messages instantly.
- **Image Sharing:** Share images in the chat.
- **Push Notifications:** Get notifications for new messages.
- **Voice Interactions:** Interact with the app using voice commands.
- **User Profiles:** Manage your profile picture and username.
- **Message History:** View and manage past conversations

  
## Screenshots

### Login Page
<img src="https://github.com/subashghimirey/ChitChat-App-Flutter-/assets/88834868/3a5a140f-6eb5-44d9-92b0-23a17b57b88b" alt="login page" height="200" width="100">

### Chat Screen
<img src="https://github.com/subashghimirey/ChitChat-App-Flutter-/assets/88834868/bfabb1ac-b154-4ad4-bc48-c8b2ceec6d80" alt="chat screen" height="200" width="100">

### Inbox
<img src="https://github.com/subashghimirey/ChitChat-App-Flutter-/assets/88834868/132337a3-6b0f-4453-9171-1867e9661271" alt="image sharing" height="200" width="100">

## Getting Started

### Prerequisites

- Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
- A code editor like Visual Studio Code or Android Studio.


## Firebase Services Setup

Ensure that you complete the setup for Firebase services as follows:

### Authentication
- **Set Up Email and Password Authentication:**
  - Go to the [Firebase Console](https://console.firebase.google.com/).
  - Navigate to **Authentication** > **Sign-in Method**.
  - Enable **Email/Password** and configure the sign-in options as needed.

### Firestore
- **Set Up Firestore Rules for Storing Messages:**
  - Go to **Firestore Database** > **Rules**.
  - Set up rules to manage read and write access to your Firestore collections. Here’s a basic example:

    ```plaintext
    service cloud.firestore {
      match /databases/{database}/documents {
        match /messages/{messageId} {
          allow read, write: if request.auth != null;
        }
      }
    }
    ```

### Firebase Storage
- **Configure Rules for Storing Images:**
  - Go to **Storage** > **Rules**.
  - Define rules for uploading and accessing images. Here’s a basic example:

    ```plaintext
    service firebase.storage {
      match /b/{bucket}/o {
        match /{allPaths=**} {
          allow read, write: if request.auth != null;
        }
      }
    }
    ```

### Cloud Messaging
- **Set Up Firebase Cloud Messaging for Push Notifications:**
  - Go to **Cloud Messaging** > **Settings**.
  - Generate and configure the **Server Key** and **Sender ID**.
  - Integrate Cloud Messaging with your app to handle push notifications.

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/subashghimirey/ChitChat-App-Flutter

2. **Navigate to the project directory:**
   ```sh
   cd chitchat

3. **Install Dependencies:**
   ```sh
   flutter pub get

4. **Running the App**
   ```sh
   flutter run

## Usage

### Sign Up:
- VUsers can create an account using email and password.
- After signing up, users are redirected to the login screen.

### Send Messages:
- Users can send text messages and images
- Messages are displayed in real-time.
- Send images 

### Receive Messages:
- New messages appear in real-time as they are sent.


