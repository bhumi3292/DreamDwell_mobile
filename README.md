# DreamDwell - Complete Property Rental Platform

DreamDwell is a comprehensive property rental platform with  mobile app. The platform connects landlords and tenants for property rentals with features like property listings, booking system, payment integration, and AI-powered chatbot assistance.


DreamDwell is a comprehensive property rental platform with mobile app. The platform connects landlords and tenants for property rentals with features like property listings, booking system, payment integration, and AI-powered chatbot assistance.
>>>>>>> 58458ee (updates)
## 🏗️ Project Structure

```
DreamDwell_mobile/
└── dream_dwell/            # Flutter Mobile Application
```

## 🚀 Features

### Core Features
- **Property Management**: Add, edit, delete, and view property listings
- **User Authentication**: Secure login/signup for landlords and tenants
- **Booking System**: Schedule property visits and manage availability
- **Payment Integration**: Khalti and eSewa payment gateways
- **AI Chatbot**: Intelligent assistant for user queries
- **Favorites System**: Save and manage favorite properties
- **Real-time Chat**: Communication between landlords and tenants
- **Image/Video Upload**: Rich media support for property listings

### Platform-Specific Features
- **Web Frontend**: Responsive React.js application
- **Mobile App**: Cross-platform Flutter application
- **Backend API**: RESTful API with MongoDB database

## 🛠️ Technology Stack

### Frontend (Web)
- **React.js** - UI framework
- **Axios** - HTTP client
- **React Router** - Navigation
- **React Toastify** - Notifications
- **CryptoJS** - Payment encryption

### Mobile App
- **Flutter** - Cross-platform framework
- **Dart** - Programming language
- **BLoC Pattern** - State management
- **Dio** - HTTP client
- **GetX** - Navigation and dependency injection

### Backend
- **Node.js** - Runtime environment
- **Express.js** - Web framework
- **MongoDB** - Database
- **Mongoose** - ODM
- **JWT** - Authentication
- **Multer** - File uploads
- **Google Generative AI** - Chatbot integration

## 📱 Mobile App Features

### Architecture
- **Clean Architecture** with BLoC pattern
- **Feature-based** folder structure
- **Dependency Injection** with GetIt
- **Repository Pattern** for data management

### Key Features
- **Property Exploration**: Browse and search properties
- **Booking Management**: Schedule and manage visits
- **Payment Processing**: Integrated payment gateways
- **AI Chatbot**: Floating assistant for user support
- **User Profiles**: Manage personal information
- **Favorites**: Save and organize favorite properties

## 🔧 Setup Instructions

### Prerequisites
- Node.js (v16+)
- Flutter SDK (v3.7+)
- MongoDB
- Git

### Backend Setup
```bash
cd dreamdwell_backend
npm install
npm start
```

### Frontend Setup
```bash
cd dreamdwell_frontend
npm install
npm run dev
```

### Mobile App Setup
```bash
cd dream_dwell
flutter pub get
flutter run
```

## 🌐 API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/auth/me` - Get current user

### Properties
- `GET /api/properties` - Get all properties
- `POST /api/properties` - Create property
- `PUT /api/properties/:id` - Update property
- `DELETE /api/properties/:id` - Delete property

### Bookings
- `GET /api/bookings` - Get user bookings
- `POST /api/bookings` - Create booking
- `PUT /api/bookings/:id` - Update booking

### Payments
- `POST /api/payments/initiate` - Initiate payment
- `POST /api/payments/verify/khalti` - Verify Khalti payment
- `POST /api/payments/verify/esewa` - Verify eSewa payment

### Chatbot
- `POST /api/chatbot/query` - Send chatbot query

## 📱 Mobile App Architecture

### Folder Structure
```
lib/
├── app/                    # App configuration
├── cores/                  # Core utilities
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   ├── booking/           # Booking system
│   ├── chatbot/           # AI chatbot
│   ├── explore/           # Property exploration
│   ├── profile/           # User profiles
│   └── ...
└── main.dart              # App entry point
```

### Key Components
- **BLoC Pattern**: State management
- **Repository Pattern**: Data abstraction
- **Dependency Injection**: Service locator
- **Clean Architecture**: Separation of concerns

## 🔐 Environment Variables

### Backend (.env)
```env
MONGO_URI=mongodb://localhost:27017/dreamdwell
JWT_SECRET=your_jwt_secret
KHALTI_SECRET_KEY=your_khalti_key
ESEWA_SECRET_KEY=your_esewa_key
GOOGLE_AI_API_KEY=your_google_ai_key
```

## 🧪 Testing

### Backend Tests
```bash
cd dreamdwell_backend
npm test
```

### Mobile App Tests
```bash
cd dream_dwell
flutter test
```

## 📦 Deployment

### Backend Deployment
- Deploy to Heroku, Railway, or AWS
- Set environment variables
- Configure MongoDB Atlas

### Frontend Deployment
- Deploy to Vercel, Netlify, or AWS
- Configure API endpoints

### Mobile App Deployment
- Build APK: `flutter build apk`
- Build iOS: `flutter build ios`
- Publish to stores

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation in each module

## 🔄 Version History

- **v1.0.0** - Initial release with core features
- **v1.1.0** - Added payment integration
- **v1.2.0** - Added AI chatbot
- **v1.3.0** - Mobile app release

---

**DreamDwell** - Making property rental simple and efficient! 🏠✨
