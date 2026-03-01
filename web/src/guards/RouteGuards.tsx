import React from 'react'
import { Navigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import { LoadingScreen } from '../atoms/LoadingScreen'

// ─── Protected Route ─────────────────────────────────────────
// Redirects unauthenticated users to /auth
export const ProtectedRoute: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { user, loading } = useAuth()

  if (loading) return <LoadingScreen />
  if (!user) return <Navigate to="/auth" replace />

  return <>{children}</>
}

// ─── Public Route ─────────────────────────────────────────────
// Redirects authenticated users away from auth pages to /dashboard
export const PublicRoute: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { user, loading } = useAuth()

  if (loading) return <LoadingScreen />
  if (user) return <Navigate to="/dashboard" replace />

  return <>{children}</>
}
