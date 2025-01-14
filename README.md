# ModelVerse - LLM Powered Chat Application

ModelVerse is a Flutter-based chat application that integrates multiple Large Language Models (LLMs) like OpenAI, Gemini, and Mistral. This application allows users to interact with AI models through text and image-based prompts, making AI-powered conversations intuitive and engaging within the same chat interface.

## Features

- **Multi-Model Integration:** Seamlessly switch between OpenAI, Gemini, and Mistral models.
- **Image Analysis:** Upload images and receive intelligent descriptions or analysis (Gemini support).
- **API Key Management:** Secure API keys for each model within device without sharing in cloud.
- **Scheduled Notifications:** Engage users with AI through customizable push notifications.
- **Stylized Chat Interface:** Supports bold, italic, and heading formatting in AI responses.
- **User Authentication:** Secure sign-in and registration with Firebase Authentication.

## Screenshots

<div align="center" style="display: flex; justify-content: center; gap: 20px;">
  <div style="padding: 15px;">
    <a href="https://imgbb.com/">
      <img src="https://i.ibb.co/gjWGtQV/1-Landing-Page.png" alt="Landing Page" width="200" height="400" style="border-radius: 15px;"/>
    </a>
    <a href="https://imgbb.com/">
      <img src="https://i.ibb.co/Vj8t4Yt/4-Home-Page.png" alt="Home Page" width="200" height="400" style="border-radius: 15px;"/>
    </a>
    <a href="https://imgbb.com/">
      <img src="https://i.ibb.co/vH6NBPp/7-Chat-Screen.png" alt="Chat Screen" width="200" height="400" style="border-radius: 15px;"/>
    </a>
   </div>
</div>




## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-username/modelverse.git
   cd modelverse
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files.
   - Enable Firebase Authentication and Firestore in your Firebase Console.

4. **Set Up `.env` File:**
   Create a `.env` file in the `assets` folder and add your API keys:
   ```env
   OPENAI_API_KEY=your_openai_api_key
   GEMINI_API_KEY=your_gemini_api_key
   MISTRAL_API_KEY=your_mistral_api_key
   ```

5. **Run the App:**
   ```bash
   flutter run
   ```

## Folder Structure

```
assets/
├──images/              #App images(Landing Page image)
├──.env                 #Environment File(Store the api keys)
lib/
├── models/            # Data models (User, LLMUser)
├── screens/           # UI Screens (Home, Chat, Auth, Settings)
├── services/          # Services through app (OpenAI, Gemini, Mistral, Database, Notification)
├── shared/            # Shared UI components and constants
├── main.dart          # App entry point and checks
```

## Dependencies

- **Firebase:** Authentication and Firestore database.
- **flutter_dotenv:** For secure environment variables.
- **flutter_local_notifications:** Local push notifications.
- **google_generative_ai:** Gemini AI integration.
- **dart_openai:** OpenAI integration.
- **mistralai_client_dart:** Mistral AI integration.
- **provider:** State management.

## Usage

- **Sign In / Register**: Authenticate using email and password.
- **Add API Keys**: Navigate to Settings and securely store model API keys.
- **Chat**: Send text prompts to selected LLMs and receive responses.
- **Image Analysis**: Upload images to Gemini and get descriptive feedback.
- **Notifications**: Receive scheduled notifications to engage with AI models.

## Contributing

1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Commit your changes (`git commit -m 'Add feature'`)
4. Push to the branch (`git push origin feature-branch`)
5. Open a Pull Request


## Contact

For questions or feedback, you can contact me on shared information on my profile

---

**ModelVerse** – Chat with AI, your way! 🚀
