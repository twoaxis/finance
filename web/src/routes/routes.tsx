import { createBrowserRouter, Navigate } from "react-router";
import { ProtectedRoute } from "../guards/RouteGuards";

import { AuthPage } from "../components/pages/AuthPage";
import { DashboardPage } from "../components/pages/DashboardPage";

import { LandingCard } from "../components/organisms/LandingCard";
import { LoginCard } from "../components/organisms/LoginCard";
import { RegisterCard } from "../components/organisms/RegisterCard";

import { AUTH_ROUTES, AUTH_ROUTE_SEGMENTS } from "./authRoutes";

const routes = createBrowserRouter([
  {
    path: AUTH_ROUTES.base,
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
  {
    path: "/dashboard",
    element: <ProtectedRoute />,
    children: [
      {
        index: true,
        element: <DashboardPage />,
      },
    ],
  },
  {
    path: "*",
    element: <Navigate to={AUTH_ROUTES.base} replace />,
  },
]);

export default routes;