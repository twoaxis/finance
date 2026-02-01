import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyCxA9Louij8gPQFHF4IzFXbzQr3i0NeSLA",
  authDomain: "financial-planner-72109.firebaseapp.com",
  projectId: "financial-planner-72109",
  storageBucket: "financial-planner-72109.firebasestorage.app",
  messagingSenderId: "859455980881",
  appId: "1:859455980881:web:placeholder", // Placeholder App ID, might need update if analytics required
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);

if (import.meta.env.DEV) {
  // Connect to emulators in development
  // import('firebase/auth').then(({ connectAuthEmulator }) => connectAuthEmulator(auth, "http://localhost:9099"));
  // import('firebase/firestore').then(({ connectFirestoreEmulator }) => connectFirestoreEmulator(db, "localhost", 8080));
  console.log("Firebase initialized (Development Mode)");
}

export { auth, db };
