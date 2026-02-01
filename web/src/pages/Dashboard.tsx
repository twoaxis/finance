import { useMemo, useState } from "react";
import { useAuth } from "../contexts/AuthContext";
import { db } from "../lib/firebase";
import { doc, collection, query, orderBy, limit } from "firebase/firestore";
import { useDocument } from "../hooks/useDocument";
import { useCollection } from "../hooks/useCollection";
import { Card, CardContent } from "../components/ui/Card";
import { Button } from "../components/ui/Button";
import { Eye, EyeOff, Plus, TrendingUp, Wallet, ArrowRight } from "lucide-react";
import { format } from "date-fns";
import { Link } from "react-router-dom";

// Helper to format currency
const formatCurrency = (amount: number, currency = "USD") => {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: currency,
  }).format(amount);
};

export const Dashboard = () => {
  const { user } = useAuth();
  const [showBalance, setShowBalance] = useState(true);

  // User Document (contains balances)
  const userDocRef = useMemo(() => (user ? doc(db, "users", user.uid) : null), [user]);
  const { data: userData } = useDocument(userDocRef);

  // Transactions Subcollection
  const transactionsQuery = useMemo(
    () =>
      user
        ? query(collection(db, "users", user.uid, "transactions"), orderBy("date", "desc"), limit(5))
        : null,
    [user]
  );
  const { data: transactions } = useCollection(transactionsQuery);

  // Calculate Total Balance
  const totalBalance = useMemo(() => {
    if (!userData?.balances) return 0;
    return userData.balances.reduce((acc: number, curr: any) => acc + (Number(curr.value) || 0), 0);
  }, [userData]);

  const currency = userData?.currency || "USD";

  return (
    <div className="space-y-6">
      {/* Top Section with Gradient Background (simulated with CSS or just a container) */}
      <div className="relative overflow-hidden rounded-xl bg-gradient-to-br from-primary to-secondary p-8 text-white shadow-lg">
        <div className="relative z-10 flex flex-col items-center justify-center space-y-4 text-center">
          <p className="text-sm font-medium opacity-90">Total Balance</p>
          <div className="flex items-center space-x-3">
            <h2 className="text-4xl font-bold tracking-tight">
              {showBalance ? formatCurrency(totalBalance, currency) : "••••••"}
            </h2>
            <button
              onClick={() => setShowBalance(!showBalance)}
              className="rounded-full p-1 hover:bg-white/10"
            >
              {showBalance ? <EyeOff className="h-5 w-5" /> : <Eye className="h-5 w-5" />}
            </button>
          </div>

          {/* Quick Actions */}
          <div className="mt-8 flex items-center justify-center space-x-4">
            <Button
              variant="secondary"
              className="bg-white/10 hover:bg-white/20 border-transparent text-white"
              onClick={() => alert("Quick Add Income - Coming Soon")}
            >
              <Plus className="mr-2 h-4 w-4" />
              Income
            </Button>
            <Button
              variant="secondary"
              className="bg-white/10 hover:bg-white/20 border-transparent text-white"
              onClick={() => alert("Quick Add Expense - Coming Soon")}
            >
              <Plus className="mr-2 h-4 w-4" />
              Expense
            </Button>
             <Button
              variant="secondary"
              className="bg-white/10 hover:bg-white/20 border-transparent text-white"
              onClick={() => alert("Analytics - Coming Soon")}
            >
              <TrendingUp className="mr-2 h-4 w-4" />
              Analytics
            </Button>
          </div>
        </div>
      </div>

      {/* Recent Transactions */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h3 className="text-lg font-semibold text-white">Recent Transactions</h3>
          <Link to="/transactions" className="flex items-center text-sm text-primary hover:underline">
            View All <ArrowRight className="ml-1 h-4 w-4" />
          </Link>
        </div>

        {transactions?.length === 0 ? (
          <Card>
             <CardContent className="flex flex-col items-center justify-center py-10 opacity-50">
                <Wallet className="h-12 w-12 mb-4" />
                <p>No recent transactions</p>
             </CardContent>
          </Card>
        ) : (
          <div className="space-y-3">
            {transactions?.map((tx: any) => (
              <Card key={tx.id} className="transition-transform hover:scale-[1.01]">
                <div className="flex items-center justify-between p-4">
                  <div className="flex items-center space-x-4">
                    <div className="rounded-full bg-surface-bright p-2 text-primary">
                       {/* Icon based on category or type */}
                       <Wallet className="h-5 w-5" />
                    </div>
                    <div>
                      <p className="font-medium text-white">{tx.name || "Unknown"}</p>
                      <p className="text-xs text-on-surface-variant">
                        {tx.date?.seconds
                          ? format(new Date(tx.date.seconds * 1000), "MMM d, yyyy h:mm a")
                          : "Date Unknown"}
                      </p>
                    </div>
                  </div>
                  <div
                    className={`text-lg font-bold ${
                      tx.type === "income" ? "text-green-500" : "text-primary"
                    }`}
                  >
                    {tx.type === "income" ? "+" : "-"}
                    {formatCurrency(Number(tx.value) || 0, currency)}
                  </div>
                </div>
              </Card>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};
