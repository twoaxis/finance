import React from 'react';
import {
	createBrowserRouter,
	RouterProvider,
	Navigate,
} from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import { ProtectedRoute, PublicRoute } from './guards/RouteGuards';
import { AuthPage } from './components/pages/AuthPage';
import { DashboardPage } from './components/pages/DashboardPage';
import { LandingCard } from './components/organisms/LandingCard';
import { LoginCard } from './components/organisms/LoginCard';
import { RegisterCard } from './components/organisms/RegisterCard';
import { AUTH_ROUTES, AUTH_ROUTE_SEGMENTS } from './routes/authRoutes';

const router = createBrowserRouter([
	{
		path: AUTH_ROUTES.base,
		element: <PublicRoute />,
		children: [
			{
				element: <AuthPage />,
				children: [
					{
						index: true,
						element: <LandingCard />,
					},
					{
						path: AUTH_ROUTE_SEGMENTS.login,
						element: <LoginCard />,
					},
					{
						path: AUTH_ROUTE_SEGMENTS.register,
						element: <RegisterCard />,
					},
				],
			},
		],
	},
	{
		path: '/dashboard',
		element: <ProtectedRoute />,
		children: [
			{
				index: true,
				element: <DashboardPage />,
			},
		],
	},
	{
		path: '*',
		element: <Navigate to={AUTH_ROUTES.base} replace />,
	},
]);

const App: React.FC = () => {
	return (
		<AuthProvider>
			<RouterProvider router={router} />
		</AuthProvider>
	);
};

export default App;
