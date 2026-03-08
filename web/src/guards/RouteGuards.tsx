import React from 'react';
import { Navigate, Outlet } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { AUTH_ROUTES } from '../routes/authRoutes';


export const ProtectedRoute: React.FC<{ children?: React.ReactNode }> = () => {
	const { user } = useAuth();

	if (!user) return <Navigate to={AUTH_ROUTES.base} replace />

	return  <Outlet />;
};

