import { useAuth } from "../contexts/AuthContext";
import { auth } from "../lib/firebase";
import { Card } from "../components/ui/Card";
import { Button } from "../components/ui/Button";
import { User as UserIcon, LogOut, Settings, Info, DollarSign } from "lucide-react";
import { Link, useNavigate } from "react-router-dom";

export const Account = () => {
  const { user } = useAuth();
  const navigate = useNavigate();

  const handleLogout = async () => {
    try {
      await auth.signOut();
      navigate("/onboarding");
    } catch (error) {
      console.error("Failed to log out", error);
    }
  };

  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold text-white">Account</h1>

      {/* Profile Card */}
      <Card className="bg-gradient-to-r from-primary to-secondary border-none">
        <div className="flex items-center space-x-4 p-6">
          {user?.photoURL ? (
            <img
              src={user.photoURL}
              alt="Profile"
              className="h-16 w-16 rounded-full border-2 border-white"
            />
          ) : (
            <div className="flex h-16 w-16 items-center justify-center rounded-full bg-white/20">
              <UserIcon className="h-8 w-8 text-white" />
            </div>
          )}
          <div>
            <h2 className="text-xl font-bold text-white">
              {user?.displayName || "No display name"}
            </h2>
            <p className="text-sm text-white/80">{user?.email}</p>
          </div>
        </div>
      </Card>

      {/* Settings List */}
      <div className="overflow-hidden rounded-xl bg-surface-bright">
        <div className="divide-y divide-surface-container">
          <Link
            to="/account-settings"
            className="flex w-full items-center justify-between px-6 py-4 transition-colors hover:bg-surface-container"
          >
            <div className="flex items-center space-x-3">
              <Settings className="h-5 w-5 text-on-surface-variant" />
              <span className="text-white">Account Settings</span>
            </div>
          </Link>
          <Link
            to="/info"
            className="flex w-full items-center justify-between px-6 py-4 transition-colors hover:bg-surface-container"
          >
            <div className="flex items-center space-x-3">
              <Info className="h-5 w-5 text-on-surface-variant" />
              <span className="text-white">Info</span>
            </div>
          </Link>
          <Link
            to="/currency"
            className="flex w-full items-center justify-between px-6 py-4 transition-colors hover:bg-surface-container"
          >
            <div className="flex items-center space-x-3">
              <DollarSign className="h-5 w-5 text-on-surface-variant" />
              <span className="text-white">Currency</span>
            </div>
          </Link>
        </div>
      </div>

      {/* Logout Button */}
      <Button
        onClick={handleLogout}
        variant="ghost"
        className="w-full bg-surface-bright text-red-500 hover:bg-surface-container hover:text-red-400 justify-start px-6 py-4"
      >
        <LogOut className="mr-3 h-5 w-5" />
        Log out
      </Button>

      {/* Footer */}
      <div className="text-center text-sm text-on-surface-variant">
        (c) {new Date().getFullYear()} TwoAxis. All Rights Reserved.
      </div>
    </div>
  );
};
