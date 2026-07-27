import { useState } from 'react';
import type { ReactNode } from 'react';
import { Sidebar } from './Sidebar';

interface AppLayoutProps {
  children: ReactNode;
}

export function AppLayout({ children }: AppLayoutProps) {
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);

  return (
    <div className="flex min-h-screen bg-surface-light dark:bg-surface-dark">
      <Sidebar isOpen={isSidebarOpen} onClose={() => setIsSidebarOpen(false)} />
      
      <div className="flex-1 flex flex-col lg:pl-[280px]">
        {/* Mobile Header */}
        <header className="lg:hidden flex items-center justify-between p-4 border-b border-gray-200 dark:border-gray-800 bg-surface-light dark:bg-container-dark">
          <div className="flex items-center gap-3">
            <button 
              onClick={() => setIsSidebarOpen(true)}
              className="p-2 -ml-2 rounded-lg hover:bg-container-light dark:hover:bg-bright-dark"
            >
              <span className="material-symbols-outlined">menu</span>
            </button>
            <span className="font-bold text-lg">TwoAxis Finance</span>
          </div>
        </header>

        {/* Main Content */}
        <main className="flex-1 overflow-x-hidden">
          <div className="w-full h-full max-w-5xl mx-auto">
            {children}
          </div>
        </main>
      </div>
    </div>
  );
}
