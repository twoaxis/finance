import { useState, useMemo } from "react";
import { useAuth } from "../contexts/AuthContext";
import { db } from "../lib/firebase";
import { doc, updateDoc, collection, addDoc, Timestamp } from "firebase/firestore";
import { useDocument } from "../hooks/useDocument";
import { Button } from "./ui/Button";
import { Input } from "./ui/Input";
import { INCOME_CATEGORIES, EXPENSE_CATEGORIES } from "../constants/categories";

export const AddTransactionForm = ({ onClose }: { onClose: () => void }) => {
  const { user } = useAuth();
  const [type, setType] = useState<"income" | "expense">("income");
  const [name, setName] = useState("");
  const [value, setValue] = useState("");
  const [date, setDate] = useState(new Date().toISOString().split("T")[0]);
  const [time, setTime] = useState(new Date().toTimeString().split(" ")[0].slice(0, 5));
  const [category, setCategory] = useState("");
  const [balanceIndex, setBalanceIndex] = useState("-1");
  const [addToBudget, setAddToBudget] = useState(true);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const userDocRef = useMemo(() => (user ? doc(db, "users", user.uid) : null), [user]);
  const { data: userData } = useDocument(userDocRef);
  const balances = userData?.balances || [];
  const budget = userData?.budget;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user || !userData) return;

    setLoading(true);
    setError(null);

    try {
      const amount = parseFloat(value);
      if (isNaN(amount) || amount < 0) {
        throw new Error("Value must be a positive number.");
      }

      const dateTime = new Date(`${date}T${time}`);

      const newTransaction = {
        type,
        name,
        value: amount,
        date: Timestamp.fromDate(dateTime),
        category: category || "Other",
        source: balanceIndex !== "-1" ? balances[parseInt(balanceIndex)].name : null,
      };

      // Add to transactions
      await addDoc(collection(db, "users", user.uid, "transactions"), newTransaction);

      // Update balance if selected
      if (balanceIndex !== "-1") {
        const index = parseInt(balanceIndex);
        const currentBalance = parseFloat(balances[index].value) || 0;
        const newBalanceValue = type === "income" ? currentBalance + amount : currentBalance - amount;

        const newBalances = [...balances];
        newBalances[index] = { ...newBalances[index], value: newBalanceValue };

        await updateDoc(doc(db, "users", user.uid), { balances: newBalances });
      }

      // Update budget if expense and addToBudget is checked
      if (type === "expense" && addToBudget && budget) {
        const currentSpent = parseFloat(budget.spent) || 0;
        const newSpent = currentSpent + amount;
        await updateDoc(doc(db, "users", user.uid), {
          budget: { ...budget, spent: newSpent }
        });
      }

      onClose();
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-4">
      {/* Type Toggle */}
      <div className="flex space-x-2 mb-4">
        <Button
          type="button"
          variant={type === "income" ? "primary" : "secondary"}
          onClick={() => setType("income")}
          className="flex-1"
        >
          Income
        </Button>
        <Button
          type="button"
          variant={type === "expense" ? "primary" : "secondary"}
          onClick={() => setType("expense")}
          className="flex-1"
        >
          Expense
        </Button>
      </div>

      {error && <p className="text-red-500 text-sm">{error}</p>}

      <form onSubmit={handleSubmit} className="space-y-4">
        <Input
          label="Name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder={type === "income" ? "e.g. Salary" : "e.g. Groceries"}
          required
        />
        <Input
          label="Value"
          type="number"
          step="0.01"
          value={value}
          onChange={(e) => setValue(e.target.value)}
          placeholder="0.00"
          required
        />

        <div className="grid grid-cols-2 gap-4">
          <Input
            label="Date"
            type="date"
            value={date}
            onChange={(e) => setDate(e.target.value)}
            required
          />
           <Input
            label="Time"
            type="time"
            value={time}
            onChange={(e) => setTime(e.target.value)}
            required
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-on-surface-variant mb-1">Category</label>
          <select
            value={category}
            onChange={(e) => setCategory(e.target.value)}
            className="w-full px-4 py-2 text-white bg-surface-bright border border-outline rounded-md focus:ring-primary focus:border-primary outline-none"
          >
            <option value="">Select Category</option>
            {(type === "income" ? INCOME_CATEGORIES : EXPENSE_CATEGORIES).map((cat) => (
              <option key={cat} value={cat}>
                {cat}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label className="block text-sm font-medium text-on-surface-variant mb-1">
            {type === "income" ? "Add to Balance (Optional)" : "Deduct from Balance (Optional)"}
          </label>
          <select
            value={balanceIndex}
            onChange={(e) => setBalanceIndex(e.target.value)}
            className="w-full px-4 py-2 text-white bg-surface-bright border border-outline rounded-md focus:ring-primary focus:border-primary outline-none"
          >
            <option value="-1">{type === "income" ? "Do not add" : "Do not deduct"}</option>
            {balances.map((balance: any, index: number) => (
              <option key={index} value={index}>
                {balance.name} ({balance.value})
              </option>
            ))}
          </select>
        </div>

        {type === "expense" && budget && (
          <div className="flex items-center space-x-2">
            <input
              type="checkbox"
              id="addToBudget"
              checked={addToBudget}
              onChange={(e) => setAddToBudget(e.target.checked)}
              className="w-4 h-4 text-primary bg-surface-bright border-outline rounded focus:ring-primary"
            />
            <label htmlFor="addToBudget" className="text-sm font-medium text-white">
              Add to budget (Current spent: {budget.spent})
            </label>
          </div>
        )}

        <div className="flex justify-end space-x-2 mt-6">
          <Button type="button" variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button type="submit" disabled={loading}>
            {loading ? "Saving..." : "Save Transaction"}
          </Button>
        </div>
      </form>
    </div>
  );
};
