import { NavLink, useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { useTheme } from '../contexts/ThemeContext';
import { useUserData } from '../contexts/UserDataContext';

interface SidebarProps {
  isOpen: boolean;
  onClose: () => void;
}

export function Sidebar({ isOpen, onClose }: SidebarProps) {
  const { logout, currentUser } = useAuth();
  const { isDark, toggleTheme } = useTheme();
  const { userData } = useUserData();
  const navigate = useNavigate();

  const handleLogout = async () => {
    try {
      await logout();
    } catch (error) {
      console.error("Logout failed:", error);
    }
  };

  const displayName = userData?.name || currentUser?.displayName;

  const navItemClass = ({ isActive }: { isActive: boolean }) => 
    `flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 ${
      isActive 
        ? 'bg-primary text-white font-medium shadow-md shadow-primary/20 scale-[1.02]' 
        : 'text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-bright-dark hover:text-gray-900 dark:hover:text-white'
    }`;

  const sidebarClasses = `fixed inset-y-0 left-0 z-40 w-[280px] bg-surface-light dark:bg-container-dark border-r border-gray-200 dark:border-gray-800 transform transition-transform duration-300 ease-in-out lg:translate-x-0 flex flex-col ${
    isOpen ? 'translate-x-0 shadow-2xl' : '-translate-x-full'
  }`;

  return (
    <>
      {/* Mobile overlay */}
      {isOpen && (
        <div 
          className="fixed inset-0 bg-black/40 backdrop-blur-sm z-30 lg:hidden"
          onClick={onClose}
        />
      )}

      <aside className={sidebarClasses}>
        {/* Header */}
        <div className="p-6 flex items-center gap-3 shrink-0">
          <img src="/logo.png" alt="TwoAxis Finance Logo" className="w-8 h-8 object-contain" />
          <span className="text-xl font-bold tracking-tight text-gray-900 dark:text-white">Finance</span>
        </div>

        {/* Scrollable Navigation */}
        <nav className="flex-1 overflow-y-auto px-4 pb-6 space-y-8 scrollbar-hide">
          {/* Main */}
          <div className="space-y-1">
            <NavLink to="/" onClick={onClose} className={navItemClass}>
              <span className="material-symbols-outlined">dashboard</span>
              <span>Dashboard</span>
            </NavLink>
            <NavLink to="/money-flow" onClick={onClose} className={navItemClass}>
              <span className="material-symbols-outlined">sync_alt</span>
              <span>Money Flow</span>
            </NavLink>
            <NavLink to="/wallet" onClick={onClose} className={navItemClass}>
              <span className="material-symbols-outlined">account_balance_wallet</span>
              <span>Wallet</span>
            </NavLink>
            <NavLink to="/quick-add" onClick={onClose} className={navItemClass}>
              <span className="material-symbols-outlined">add_circle</span>
              <span>Quick Add</span>
            </NavLink>
          </div>

          {/* Money & Assets */}
          <div>
            <div className="text-xs font-bold text-gray-400 dark:text-gray-500 uppercase tracking-wider mb-3 px-4">Financials</div>
            <div className="space-y-1">
              <NavLink to="/income" onClick={onClose} className={navItemClass}>
                <span className="material-symbols-outlined">trending_up</span>
                <span>Income Sources</span>
              </NavLink>
              <NavLink to="/balances" onClick={onClose} className={navItemClass}>
                <span className="material-symbols-outlined">account_balance</span>
                <span>Balances</span>
              </NavLink>
              <NavLink to="/bills" onClick={onClose} className={navItemClass}>
                <span className="material-symbols-outlined">receipt_long</span>
                <span>Bills</span>
              </NavLink>
              <NavLink to="/assets" onClick={onClose} className={navItemClass}>
                <span className="material-symbols-outlined">diamond</span>
                <span>Assets</span>
              </NavLink>
            </div>
          </div>

          {/* Insights */}
          <div>
            <div className="text-xs font-bold text-gray-400 dark:text-gray-500 uppercase tracking-wider mb-3 px-4">Insights</div>
            <div className="space-y-1">
              <NavLink to="/analytics" onClick={onClose} className={navItemClass}>
                <span className="material-symbols-outlined">analytics</span>
                <span>Analytics</span>
              </NavLink>
              <NavLink to="/transactions" onClick={onClose} className={navItemClass}>
                <span className="material-symbols-outlined">list_alt</span>
                <span>Transactions</span>
              </NavLink>
              <NavLink to="/budget" onClick={onClose} className={navItemClass}>
                <span className="material-symbols-outlined">pie_chart</span>
                <span>Budget</span>
              </NavLink>
            </div>
          </div>
        </nav>

        {/* Fixed Account Bottom */}
        <div className="shrink-0 p-4 border-t border-gray-100 dark:border-gray-800 bg-white dark:bg-container-dark">
          <div 
            onClick={() => {
              navigate('/account');
              onClose();
            }}
            className="flex items-center gap-3 p-3 rounded-2xl hover:bg-gray-50 dark:hover:bg-bright-dark transition-colors cursor-pointer group"
          >
            <div className="flex-1 min-w-0">
              <div className="font-bold text-gray-900 dark:text-white truncate">
                {displayName || 'User Account'}
              </div>
              <div className="text-xs text-gray-500 truncate">
                {currentUser?.email}
              </div>
            </div>
          </div>

          <div className="flex items-center justify-between px-2 mt-2">
            <button 
              onClick={toggleTheme} 
              className="flex items-center justify-center w-10 h-10 rounded-full text-gray-500 hover:text-primary hover:bg-primary/10 transition-colors"
              title="Toggle Theme"
            >
              <span className="material-symbols-outlined text-[20px]">
                {isDark ? 'light_mode' : 'dark_mode'}
              </span>
            </button>
            <button 
              onClick={() => {
                navigate('/account/settings');
                onClose();
              }}
              className="flex items-center justify-center w-10 h-10 rounded-full text-gray-500 hover:text-primary hover:bg-primary/10 transition-colors"
              title="Settings"
            >
              <span className="material-symbols-outlined text-[20px]">settings</span>
            </button>
            <button 
              onClick={handleLogout} 
              className="flex items-center justify-center w-10 h-10 rounded-full text-gray-500 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-500/10 transition-colors"
              title="Log Out"
            >
              <span className="material-symbols-outlined text-[20px]">logout</span>
            </button>
          </div>
        </div>
      </aside>
    </>
  );
}
