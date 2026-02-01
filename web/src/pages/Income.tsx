import { useMemo, useState } from "react";
import { useAuth } from "../contexts/AuthContext";
import { db } from "../lib/firebase";
import { doc, updateDoc } from "firebase/firestore";
import { useDocument } from "../hooks/useDocument";
import { Card, CardContent } from "../components/ui/Card";
import { Button } from "../components/ui/Button";
import { Plus, Trash2, Edit2 } from "lucide-react";
import { Input } from "../components/ui/Input";

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

export const Income = () => {
  const { user } = useAuth();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingIndex, setEditingIndex] = useState<number | null>(null);
  const [name, setName] = useState("");
  const [value, setValue] = useState("");

  const userDocRef = useMemo(() => (user ? doc(db, "users", user.uid) : null), [user]);
  const { data: userData } = useDocument(userDocRef);
  const incomeSources = userData?.income || [];

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user || !userData) return;

    const newIncome = { name, value: parseFloat(value) };
    let newIncomeList = [...incomeSources];

    if (editingIndex !== null) {
      newIncomeList[editingIndex] = newIncome;
    } else {
      newIncomeList.push(newIncome);
    }

    try {
      await updateDoc(userDocRef!, { income: newIncomeList });
      setIsModalOpen(false);
      resetForm();
    } catch (error) {
      console.error("Error saving income source:", error);
    }
  };

  const handleDelete = async (index: number) => {
    if (!user || !userData) return;
    if (!confirm("Are you sure you want to delete this income source?")) return;

    const newIncomeList = incomeSources.filter((_: any, i: number) => i !== index);
    try {
      await updateDoc(userDocRef!, { income: newIncomeList });
    } catch (error) {
      console.error("Error deleting income source:", error);
    }
  };

  const openAddModal = () => {
    setEditingIndex(null);
    resetForm();
    setIsModalOpen(true);
  };

  const openEditModal = (index: number, item: any) => {
    setEditingIndex(index);
    setName(item.name);
    setValue(item.value);
    setIsModalOpen(true);
  };

  const resetForm = () => {
    setName("");
    setValue("");
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: userData?.currency || "USD",
    }).format(amount);
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-white">Income Sources</h1>
        <Button onClick={openAddModal}>
          <Plus className="mr-2 h-4 w-4" />
          Add Source
        </Button>
      </div>

      {incomeSources.length === 0 ? (
        <div className="text-center py-10 opacity-50">
          <p>No income sources found</p>
        </div>
      ) : (
        <div className="space-y-3">
          {incomeSources.map((item: any, index: number) => (
            <Card key={index} className="hover:bg-surface-bright transition-colors border-none bg-surface-container">
              <CardContent className="flex items-center justify-between p-4">
                <div>
                  <h3 className="font-bold text-white">{item.name}</h3>
                  <p className="text-sm text-on-surface-variant">Estimated Value: {formatCurrency(item.value)}</p>
                </div>
                <div className="flex space-x-2">
                  <Button variant="ghost" size="sm" onClick={() => openEditModal(index, item)}>
                    <Edit2 className="h-4 w-4" />
                  </Button>
                  <Button variant="ghost" size="sm" className="text-red-500 hover:text-red-400" onClick={() => handleDelete(index)}>
                    <Trash2 className="h-4 w-4" />
                  </Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      <SimpleModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title={editingIndex !== null ? "Edit Income Source" : "Add Income Source"}
      >
        <form onSubmit={handleSave} className="space-y-4">
          <Input
            label="Name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="e.g. Salary"
            required
          />
          <Input
            label="Estimated Value"
            type="number"
            step="0.01"
            value={value}
            onChange={(e) => setValue(e.target.value)}
            placeholder="0.00"
            required
          />
          <div className="flex justify-end space-x-2 mt-6">
            <Button type="button" variant="ghost" onClick={() => setIsModalOpen(false)}>
              Cancel
            </Button>
            <Button type="submit">
              Save
            </Button>
          </div>
        </form>
      </SimpleModal>
    </div>
  );
};
