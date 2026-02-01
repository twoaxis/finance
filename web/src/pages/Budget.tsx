import { useMemo, useState, useEffect } from "react";
import { useAuth } from "../contexts/AuthContext";
import { db } from "../lib/firebase";
import { doc, updateDoc } from "firebase/firestore";
import { useDocument } from "../hooks/useDocument";
import { Card, CardContent } from "../components/ui/Card";
import { Button } from "../components/ui/Button";
import { Input } from "../components/ui/Input";

export const Budget = () => {
  const { user } = useAuth();
  const [value, setValue] = useState("");
  const [spent, setSpent] = useState("");
  const [loading, setLoading] = useState(false);

  const userDocRef = useMemo(() => (user ? doc(db, "users", user.uid) : null), [user]);
  const { data: userData } = useDocument(userDocRef);

  useEffect(() => {
    if (userData?.budget) {
      setValue(userData.budget.value.toString());
      setSpent(userData.budget.spent.toString());
    }
  }, [userData]);

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user || !userData) return;

    setLoading(true);
    try {
      const budgetLimit = parseFloat(value);
      const budgetSpent = parseFloat(spent);

      await updateDoc(userDocRef!, {
        budget: {
          value: isNaN(budgetLimit) ? 0 : budgetLimit,
          spent: isNaN(budgetSpent) ? 0 : budgetSpent,
        }
      });
      alert("Budget updated successfully!");
    } catch (error) {
      console.error("Error updating budget:", error);
      alert("Failed to update budget.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold text-white">Budget Settings</h1>

      <Card className="bg-surface-container border-none">
        <CardContent className="p-6">
          <form onSubmit={handleSave} className="space-y-4">
            <Input
              label="Monthly Budget Limit"
              type="number"
              step="0.01"
              value={value}
              onChange={(e) => setValue(e.target.value)}
              placeholder="0.00"
              required
            />
            <Input
              label="Amount Spent (Currently)"
              type="number"
              step="0.01"
              value={spent}
              onChange={(e) => setSpent(e.target.value)}
              placeholder="0.00"
              required
            />
             <p className="text-sm text-on-surface-variant">
                The "Spent" amount is automatically updated when you add expenses with "Add to Budget" checked.
                You can manually adjust it here if needed.
            </p>

            <div className="flex justify-end pt-4">
              <Button type="submit" disabled={loading}>
                {loading ? "Saving..." : "Save Budget"}
              </Button>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );
};
