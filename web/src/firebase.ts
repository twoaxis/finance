import { initializeApp } from 'firebase/app';
import { getAuth, connectAuthEmulator } from 'firebase/auth';
import { getFirestore, connectFirestoreEmulator } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyDhXWp5E7LI2pUY61aJX2jDWlwoZUOQ_6Q",
  authDomain: "financial-planner-72109.firebaseapp.com",
  projectId: "financial-planner-72109",
  storageBucket: "financial-planner-72109.firebasestorage.app",
  messagingSenderId: "859455980881",
  appId: "1:859455980881:web:0a9a148fc8d9c1d9903f70",
  measurementId: "G-RMC9T9ZKSC"
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);

// Connect to emulators in development
if (import.meta.env.DEV) {
  connectAuthEmulator(auth, 'http://127.0.0.1:9099', { disableWarnings: true });
  connectFirestoreEmulator(db, '127.0.0.1', 8080);
}
