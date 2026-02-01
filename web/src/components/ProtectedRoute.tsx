import { Navigate } from "react-router-dom";
import { useAuth } from "../contexts/AuthContext";

export const ProtectedRoute = ({ children }: { children: React.ReactNode }) => {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <div className="flex items-center justify-center h-screen bg-surface text-primary">
        Loading...
      </div>
    );
  }

  if (!user) {
    return <Navigate to="/onboarding" />;
  }

  return <>{children}</>;
};
