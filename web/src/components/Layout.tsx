import { Link, Outlet, useLocation } from "react-router-dom";
import { Home, DollarSign, Wallet, User } from "lucide-react";
import { cn } from "./ui/Button";

const navigation = [
  { name: "Dashboard", href: "/", icon: Home },
  { name: "Money Flow", href: "/money-flow", icon: DollarSign },
  { name: "Wallet", href: "/wallet", icon: Wallet },
  { name: "Account", href: "/account", icon: User },
];

export const Layout = () => {
  const location = useLocation();

  return (
    <div className="flex h-screen bg-surface">
      {/* Sidebar for Desktop */}
      <aside className="hidden md:flex md:w-64 md:flex-col bg-surface-container border-r border-outline">
        <div className="flex items-center justify-center h-16 border-b border-outline">
          <img src="/assets/images/logo.png" alt="Logo" className="w-8 h-8 mr-2" />
          <span className="text-xl font-bold text-primary">TwoAxis</span>
        </div>
        <nav className="flex-1 overflow-y-auto py-4">
          <ul className="space-y-1 px-2">
            {navigation.map((item) => {
              const isActive = location.pathname === item.href;
              return (
                <li key={item.name}>
                  <Link
                    to={item.href}
                    className={cn(
                      "flex items-center px-4 py-3 text-sm font-medium rounded-md transition-colors",
                      isActive
                        ? "bg-primary text-white"
                        : "text-on-surface-variant hover:bg-surface-bright hover:text-white"
                    )}
                  >
                    <item.icon className="w-5 h-5 mr-3" />
                    {item.name}
                  </Link>
                </li>
              );
            })}
          </ul>
        </nav>
        <div className="p-4 border-t border-outline">
          <p className="text-xs text-center text-on-surface-variant">
            &copy; {new Date().getFullYear()} TwoAxis Finance
          </p>
        </div>
      </aside>

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col overflow-hidden">
        <header className="md:hidden flex items-center justify-between p-4 bg-surface-container border-b border-outline">
           <div className="flex items-center">
            <img src="/assets/images/logo.png" alt="Logo" className="w-8 h-8 mr-2" />
            <span className="text-xl font-bold text-primary">TwoAxis</span>
          </div>
        </header>

        <main className="flex-1 overflow-y-auto p-4 md:p-8 pb-20 md:pb-8">
          <Outlet />
        </main>

        {/* Bottom Navigation for Mobile */}
        <nav className="md:hidden fixed bottom-0 left-0 right-0 bg-surface-container border-t border-outline">
          <ul className="flex justify-around items-center h-16">
            {navigation.map((item) => {
              const isActive = location.pathname === item.href;
              return (
                <li key={item.name} className="flex-1">
                  <Link
                    to={item.href}
                    className={cn(
                      "flex flex-col items-center justify-center h-full w-full text-xs font-medium transition-colors",
                      isActive
                        ? "text-primary"
                        : "text-on-surface-variant hover:text-white"
                    )}
                  >
                    <item.icon className="w-6 h-6 mb-1" />
                    {item.name}
                  </Link>
                </li>
              );
            })}
          </ul>
        </nav>
      </div>
    </div>
  );
};
