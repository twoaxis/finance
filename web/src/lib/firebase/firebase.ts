import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { connectAuthEmulator, getAuth } from "firebase/auth";
import { connectFirestoreEmulator, getFirestore } from "firebase/firestore";
import { GoogleAuthProvider } from "firebase/auth";
const firebaseConfig = {
	apiKey: "AIzaSyDhXWp5E7LI2pUY61aJX2jDWlwoZUOQ_6Q",
	authDomain: "financial-planner-72109.firebaseapp.com",
	projectId: "financial-planner-72109",
	storageBucket: "financial-planner-72109.firebasestorage.app",
	messagingSenderId: "859455980881",
	appId: "1:859455980881:web:0a9a148fc8d9c1d9903f70",
	measurementId: "G-RMC9T9ZKSC"
};

export const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
export const analytics = getAnalytics(app);
export const googleProvider = new GoogleAuthProvider();

if(window.location.hostname === "localhost") {
	connectAuthEmulator(auth, "http://localhost:9099");
	connectFirestoreEmulator(db, "localhost", 8080);
}