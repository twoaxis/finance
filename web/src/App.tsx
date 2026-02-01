import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { AuthProvider } from "./contexts/AuthContext";
import { ProtectedRoute } from "./components/ProtectedRoute";
import { Login } from "./pages/Login";
import { Signup } from "./pages/Signup";
import { Onboarding } from "./pages/Onboarding";
import { Dashboard } from "./pages/Dashboard";
import { Layout } from "./components/Layout";
import { MoneyFlow } from "./pages/MoneyFlow";
import { Wallet } from "./pages/Wallet";
import { Account } from "./pages/Account";
import { Transactions } from "./pages/Transactions";
import { Income } from "./pages/Income";
import { Balances } from "./pages/Balances";
import { Assets } from "./pages/Assets";
import { Liabilities } from "./pages/Liabilities";
import { Bills } from "./pages/Bills";
import { Budget } from "./pages/Budget";

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route path="/onboarding" element={<Onboarding />} />
          <Route path="/login" element={<Login />} />
          <Route path="/signup" element={<Signup />} />

          <Route
            path="/"
            element={
              <ProtectedRoute>
                <Layout />
              </ProtectedRoute>
            }
          >
            <Route index element={<Dashboard />} />
            <Route path="money-flow" element={<MoneyFlow />} />
            <Route path="wallet" element={<Wallet />} />
            <Route path="account" element={<Account />} />
            <Route path="transactions" element={<Transactions />} />
            <Route path="income" element={<Income />} />
            <Route path="balances" element={<Balances />} />
            <Route path="assets" element={<Assets />} />
            <Route path="liabilities" element={<Liabilities />} />
            <Route path="bills" element={<Bills />} />
            <Route path="budget" element={<Budget />} />
          </Route>

          <Route path="*" element={<Navigate to="/" />} />
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  );
}

export default App;
