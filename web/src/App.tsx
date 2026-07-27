import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './contexts/AuthContext';
import { ThemeProvider } from './contexts/ThemeContext';
import { UserDataProvider } from './contexts/UserDataContext';
import { AppLayout } from './components/AppLayout';

import { LoginPage } from './pages/auth/LoginPage';
import { SignupPage } from './pages/auth/SignupPage';
import { ForgotPasswordPage } from './pages/auth/ForgotPasswordPage';
import { OnboardingPage } from './pages/auth/OnboardingPage';
import { DashboardPage } from './pages/DashboardPage';
import { MoneyFlowPage } from './pages/MoneyFlowPage';
import { WalletPage } from './pages/WalletPage';
import { AccountPage } from './pages/AccountPage';
import { TransactionsPage } from './pages/TransactionsPage';
import { AnalyticsPage } from './pages/AnalyticsPage';
import { BudgetPage } from './pages/BudgetPage';
import { QuickAddPage } from './pages/QuickAddPage';
import { IncomePage } from './pages/IncomePage';
import { BalancesPage } from './pages/BalancesPage';
import { AssetsPage } from './pages/AssetsPage';
import { BillsPage } from './pages/BillsPage';
import { ReceivablesPage } from './pages/ReceivablesPage';
import { LiabilitiesPage } from './pages/LiabilitiesPage';
import { AccountSettingsPage } from './pages/AccountSettingsPage';
import { CurrencyPage } from './pages/CurrencyPage';
import { InfoPage } from './pages/InfoPage';

function LoadingScreen() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-surface-light dark:bg-surface-dark">
      <div className="w-16 h-16 border-4 border-primary border-t-transparent rounded-full animate-spin"></div>
    </div>
  );
}

function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { currentUser, loading } = useAuth();
  if (loading) return <LoadingScreen />;
  if (!currentUser) return <Navigate to="/onboarding" />;
  return <UserDataProvider>{children}</UserDataProvider>;
}

function PublicRoute({ children }: { children: React.ReactNode }) {
  const { currentUser, loading } = useAuth();
  if (loading) return <LoadingScreen />;
  if (currentUser) return <Navigate to="/" />;
  return <>{children}</>;
}

function AppRoutes() {
  return (
    <Routes>
      {/* Public routes */}
      <Route path="/onboarding" element={<PublicRoute><OnboardingPage /></PublicRoute>} />
      <Route path="/login" element={<PublicRoute><LoginPage /></PublicRoute>} />
      <Route path="/signup" element={<PublicRoute><SignupPage /></PublicRoute>} />
      <Route path="/forgot-password" element={<PublicRoute><ForgotPasswordPage /></PublicRoute>} />
      
      {/* Protected routes wrapped in AppLayout */}
      <Route path="/" element={<ProtectedRoute><AppLayout><DashboardPage /></AppLayout></ProtectedRoute>} />
      <Route path="/money-flow" element={<ProtectedRoute><AppLayout><MoneyFlowPage /></AppLayout></ProtectedRoute>} />
      <Route path="/wallet" element={<ProtectedRoute><AppLayout><WalletPage /></AppLayout></ProtectedRoute>} />
      <Route path="/account" element={<ProtectedRoute><AppLayout><AccountPage /></AppLayout></ProtectedRoute>} />
      <Route path="/transactions" element={<ProtectedRoute><AppLayout><TransactionsPage /></AppLayout></ProtectedRoute>} />
      <Route path="/analytics" element={<ProtectedRoute><AppLayout><AnalyticsPage /></AppLayout></ProtectedRoute>} />
      <Route path="/budget" element={<ProtectedRoute><AppLayout><BudgetPage /></AppLayout></ProtectedRoute>} />
      <Route path="/quick-add" element={<ProtectedRoute><AppLayout><QuickAddPage /></AppLayout></ProtectedRoute>} />
      <Route path="/income" element={<ProtectedRoute><AppLayout><IncomePage /></AppLayout></ProtectedRoute>} />
      <Route path="/balances" element={<ProtectedRoute><AppLayout><BalancesPage /></AppLayout></ProtectedRoute>} />
      <Route path="/assets" element={<ProtectedRoute><AppLayout><AssetsPage /></AppLayout></ProtectedRoute>} />
      <Route path="/bills" element={<ProtectedRoute><AppLayout><BillsPage /></AppLayout></ProtectedRoute>} />
      <Route path="/receivables" element={<ProtectedRoute><AppLayout><ReceivablesPage /></AppLayout></ProtectedRoute>} />
      <Route path="/liabilities" element={<ProtectedRoute><AppLayout><LiabilitiesPage /></AppLayout></ProtectedRoute>} />
      <Route path="/account/settings" element={<ProtectedRoute><AppLayout><AccountSettingsPage /></AppLayout></ProtectedRoute>} />
      <Route path="/account/currency" element={<ProtectedRoute><AppLayout><CurrencyPage /></AppLayout></ProtectedRoute>} />
      <Route path="/account/info" element={<ProtectedRoute><AppLayout><InfoPage /></AppLayout></ProtectedRoute>} />
      
      {/* Fallback */}
      <Route path="*" element={<Navigate to="/" />} />
    </Routes>
  );
}

export default function App() {
  return (
    <BrowserRouter>
      <ThemeProvider>
        <AuthProvider>
          <AppRoutes />
        </AuthProvider>
      </ThemeProvider>
    </BrowserRouter>
  );
}
