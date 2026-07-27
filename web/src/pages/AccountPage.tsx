import { Link } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { useUserData } from '../contexts/UserDataContext';
import { useTheme } from '../contexts/ThemeContext';

export function AccountPage() {
  const { currentUser, logout } = useAuth();
  const { userData } = useUserData();
  const { isDark, toggleTheme } = useTheme();

  const handleLogout = async () => {
    try {
      await logout();
    } catch (error) {
      console.error("Logout error", error);
    }
  };

  const displayName = userData?.name || currentUser?.displayName;
  const initial = displayName ? displayName.charAt(0).toUpperCase() : (currentUser?.email?.charAt(0).toUpperCase() || 'U');

  return (
    <div className="p-6 max-w-2xl mx-auto space-y-6">
      <h1 className="text-4xl font-bold mb-8">Account</h1>

      {/* Profile Card */}
      <div className="bg-gradient-to-br from-primary to-primary-dark rounded-2xl p-6 text-white shadow-lg">
        <div className="flex items-center gap-4">
          <div className="w-16 h-16 bg-white/20 rounded-full flex items-center justify-center text-2xl font-bold backdrop-blur-sm">
            {initial}
          </div>
          <div>
            {displayName ? (
              <h2 className="text-2xl font-bold">{displayName}</h2>
            ) : (
              <h2 className="text-xl font-medium italic opacity-80">No display name</h2>
            )}
            <p className="opacity-80">{currentUser?.email}</p>
          </div>
        </div>
      </div>

      {/* Settings Section */}
      <div className="bg-container-light dark:bg-container-dark rounded-2xl overflow-hidden shadow-sm">
        <Link to="/account/settings" className="flex items-center justify-between p-4 hover:bg-bright-light dark:hover:bg-bright-dark transition-colors">
          <div className="flex items-center gap-3">
            <span className="material-symbols-outlined text-gray-500">settings</span>
            <span className="font-medium">Account Settings</span>
          </div>
          <span className="material-symbols-outlined text-gray-400">chevron_right</span>
        </Link>
        <div className="h-px bg-gray-200 dark:bg-gray-800 mx-4" />
        
        <Link to="/account/info" className="flex items-center justify-between p-4 hover:bg-bright-light dark:hover:bg-bright-dark transition-colors">
          <div className="flex items-center gap-3">
            <span className="material-symbols-outlined text-gray-500">info</span>
            <span className="font-medium">Info</span>
          </div>
          <span className="material-symbols-outlined text-gray-400">chevron_right</span>
        </Link>
        <div className="h-px bg-gray-200 dark:bg-gray-800 mx-4" />
        
        <Link to="/account/currency" className="flex items-center justify-between p-4 hover:bg-bright-light dark:hover:bg-bright-dark transition-colors">
          <div className="flex items-center gap-3">
            <span className="material-symbols-outlined text-gray-500">currency_exchange</span>
            <span className="font-medium">Currency</span>
          </div>
          <div className="flex items-center gap-2 text-gray-500">
            <span>{userData?.currency || 'USD'}</span>
            <span className="material-symbols-outlined text-gray-400">chevron_right</span>
          </div>
        </Link>
        <div className="h-px bg-gray-200 dark:bg-gray-800 mx-4" />
        
        <button 
          onClick={toggleTheme}
          className="w-full flex items-center justify-between p-4 hover:bg-bright-light dark:hover:bg-bright-dark transition-colors"
        >
          <div className="flex items-center gap-3">
            <span className="material-symbols-outlined text-gray-500">
              {isDark ? 'light_mode' : 'dark_mode'}
            </span>
            <span className="font-medium">Dark Mode</span>
          </div>
          <div className={`w-12 h-6 rounded-full flex items-center transition-colors px-1 ${isDark ? 'bg-primary' : 'bg-gray-300 dark:bg-gray-600'}`}>
            <div className={`w-4 h-4 bg-white rounded-full transition-transform ${isDark ? 'translate-x-6' : 'translate-x-0'}`} />
          </div>
        </button>
      </div>

      {/* Logout Action */}
      <div className="bg-container-light dark:bg-container-dark rounded-2xl overflow-hidden shadow-sm mt-8">
        <button 
          onClick={handleLogout}
          className="w-full flex items-center gap-3 p-4 text-red-500 hover:bg-red-50 dark:hover:bg-red-500/10 transition-colors"
        >
          <span className="material-symbols-outlined">logout</span>
          <span className="font-medium">Log out</span>
        </button>
      </div>

      <div className="pt-8 text-center text-sm text-gray-500">
        (c) {new Date().getFullYear()} TwoAxis. All Rights Reserved.
      </div>
    </div>
  );
}
