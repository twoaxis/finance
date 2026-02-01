import { useMemo, useState } from "react";
import { useAuth } from "../contexts/AuthContext";
import { db } from "../lib/firebase";
import { collection, query, orderBy, limit } from "firebase/firestore";
import { useCollection } from "../hooks/useCollection";
import { Card, CardContent } from "../components/ui/Card";
import { Button } from "../components/ui/Button";
import { Plus, ArrowUp, ArrowDown } from "lucide-react";
import { format } from "date-fns";
import { AddTransactionForm } from "../components/AddTransactionForm"; // Will implement this

// Placeholder Modal component until implemented properly
const SimpleModal = ({ isOpen, onClose, title, children }: any) => {
  if (!isOpen) return null;
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
      <div className="w-full max-w-md bg-surface-container rounded-lg shadow-xl overflow-hidden">
        <div className="flex items-center justify-between p-4 border-b border-outline">
          <h3 className="text-lg font-bold text-white">{title}</h3>
          <button onClick={onClose} className="text-on-surface-variant hover:text-white">
            &times;
          </button>
        </div>
        <div className="p-4">{children}</div>
      </div>
    </div>
  );
};

export const Transactions = () => {
  const { user } = useAuth();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [filterType, setFilterType] = useState<"all" | "income" | "expense">("all");

  const transactionsQuery = useMemo(
    () =>
      user
        ? query(collection(db, "users", user.uid, "transactions"), orderBy("date", "desc"), limit(50))
        : null,
    [user]
  );

  const { data: transactions, loading } = useCollection(transactionsQuery);

  const filteredTransactions = useMemo(() => {
    if (!transactions) return [];
    if (filterType === "all") return transactions;
    return transactions.filter((t) => t.type === filterType);
  }, [transactions, filterType]);

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "USD", // TODO: Get from user settings
    }).format(amount);
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-white">Transactions</h1>
        <Button onClick={() => setIsModalOpen(true)}>
          <Plus className="mr-2 h-4 w-4" />
          Add Transaction
        </Button>
      </div>

      {/* Filters */}
      <div className="flex space-x-2">
        <Button
          variant={filterType === "all" ? "primary" : "secondary"}
          onClick={() => setFilterType("all")}
          className="text-xs"
        >
          All
        </Button>
        <Button
          variant={filterType === "income" ? "primary" : "secondary"}
          onClick={() => setFilterType("income")}
          className="text-xs"
        >
          Income
        </Button>
        <Button
          variant={filterType === "expense" ? "primary" : "secondary"}
          onClick={() => setFilterType("expense")}
          className="text-xs"
        >
          Expense
        </Button>
      </div>

      {loading ? (
        <div className="text-center text-on-surface-variant">Loading transactions...</div>
      ) : filteredTransactions.length === 0 ? (
        <div className="text-center py-10 opacity-50">
          <p>No transactions found</p>
        </div>
      ) : (
        <div className="space-y-3">
          {filteredTransactions.map((tx: any) => (
            <Card key={tx.id} className="hover:bg-surface-bright transition-colors border-none bg-surface-container">
              <CardContent className="flex items-center justify-between p-4">
                <div className="flex items-center space-x-4">
                  <div
                    className={`rounded-full p-2 ${
                      tx.type === "income" ? "bg-green-900/50 text-green-400" : "bg-red-900/50 text-red-400"
                    }`}
                  >
                    {tx.type === "income" ? <ArrowUp className="h-5 w-5" /> : <ArrowDown className="h-5 w-5" />}
                  </div>
                  <div>
                    <p className="font-medium text-white">{tx.name || "Unknown"}</p>
                    <p className="text-xs text-on-surface-variant">
                      {tx.category || "Uncategorized"} • {tx.date?.seconds
                        ? format(new Date(tx.date.seconds * 1000), "MMM d, yyyy h:mm a")
                        : "Date Unknown"}
                    </p>
                  </div>
                </div>
                <div
                  className={`text-lg font-bold ${
                    tx.type === "income" ? "text-green-500" : "text-red-500"
                  }`}
                >
                  {tx.type === "income" ? "+" : "-"}
                  {formatCurrency(Number(tx.value) || 0)}
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      <SimpleModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title="Add Transaction"
      >
        <AddTransactionForm onClose={() => setIsModalOpen(false)} />
      </SimpleModal>
    </div>
  );
};
