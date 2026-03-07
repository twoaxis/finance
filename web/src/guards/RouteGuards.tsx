import React from 'react';
import { Navigate, Outlet } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { AUTH_ROUTES } from '../routes/authRoutes';

// ─── Protected Route ─────────────────────────────────────────
// Redirects unauthenticated users to /auth
export const ProtectedRoute: React.FC<{ children?: React.ReactNode }> = ({
	children,
}) => {
	const { user } = useAuth();

	if (!user) return <Navigate to={AUTH_ROUTES.base} replace />;

	return children ? <>{children}</> : <Outlet />;
};

// ─── Public Route ─────────────────────────────────────────────
// Redirects authenticated users away from auth pages to /dashboard
export const PublicRoute: React.FC<{ children?: React.ReactNode }> = ({
	children,
}) => {
	const { user } = useAuth();

	if (user) return <Navigate to="/dashboard" replace />;

	return children ? <>{children}</> : <Outlet />;
};
