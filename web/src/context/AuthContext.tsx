import React, { createContext, useContext, useEffect, useState } from 'react';
import {
	loginWithEmail,
	registerWithEmail,
	loginWithGoogle,
	logout,
} from '../lib/firebase/auth';
import { onAuthStateChanged } from 'firebase/auth';
import { auth } from '../lib/firebase/firebase';
import type { User } from '../types';

const AuthContext = createContext<any>(null);
export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({
	children,
}) => {
	const [user, setUser] = useState<User | null>(null);
	const [loading, setLoading] = useState(true);
	const [error, setError] = useState<string | null>(null);
	useEffect(() => {
		const unsubscribe = onAuthStateChanged(auth, (firebaseUser) => {
			if (firebaseUser) {
				setUser({
					uid: firebaseUser.uid,
					email: firebaseUser.email,
					displayName: firebaseUser.displayName,
					photoURL: firebaseUser.photoURL,
					emailVerified: firebaseUser.emailVerified,
				});
			} else {
				setUser(null);
			}
			setLoading(false);
		});

		return () => unsubscribe();
	}, []);

	const clearError = () => setError(null);
	const login = async (email: string, password: string) => {
		try {
			setError(null);
			await loginWithEmail(email, password);
		} catch (err: any) {
			setError(err.message);
		}
	};

	const register = async (email: string, password: string) => {
		try {
			setError(null);
			await registerWithEmail(email, password);
		} catch (err: any) {
			setError(err.message);
		}
	};

	const googleLogin = async () => {
		try {
			setError(null);
			await loginWithGoogle();
		} catch (err: any) {
			setError(err.message);
		}
	};

	const signOut = async () => {
		try {
			setError(null);
			await logout();
		} catch (err: any) {
			setError(err.message);
		}
	};

	return (
		<AuthContext.Provider
			value={{
				user,
				loading,
				error,
				clearError,
				login,
				register,
				googleLogin,
				signOut,
				setLoading
			}}
		>
			{children}
		</AuthContext.Provider>
	);
};

export const useAuth = (): any => {
	const ctx = useContext(AuthContext);
	return ctx;
};
