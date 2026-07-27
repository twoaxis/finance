import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useUserData } from '../contexts/UserDataContext';
import { useTransactions } from '../hooks/useTransactions';
import { formatMoney } from '../utils/moneyFormat';
import { PrimaryButton } from '../components/PrimaryButton';
import { InputField } from '../components/InputField';
import { Modal } from '../components/Modal';
import type { Income } from '../types';

export function IncomePage() {
  const { userData, addIncome, removeIncome, updateIncome } = useUserData();
  const { addTransaction } = useTransactions();
  const navigate = useNavigate();
  
  const [modalOpen, setModalOpen] = useState(false);
  const [editingItem, setEditingItem] = useState<Income | null>(null);
  const [name, setName] = useState('');
  const [valueStr, setValueStr] = useState('');
  const [pending, setPending] = useState(false);

  const handleOpenAdd = () => {
    setEditingItem(null);
    setName('');
    setValueStr('');
    setModalOpen(true);
  };

  const handleOpenEdit = (item: Income) => {
    setEditingItem(item);
    setName(item.name);
    setValueStr(item.value.toString());
    setModalOpen(true);
  };

  const handleSave = async () => {
    const val = parseFloat(valueStr);
    if (!name.trim() || isNaN(val)) return;
    
    setPending(true);
    try {
      if (editingItem) {
        // Find and update
        const newItems = (userData?.income || []).map(i => 
          i.name === editingItem.name ? { name, value: val } : i
        );
        await updateIncome(newItems);
      } else {
        await addIncome({ name, value: val });
      }
      setModalOpen(false);
    } catch (err) {
      console.error(err);
    } finally {
      setPending(false);
    }
  };

  const handleDelete = async () => {
    if (!editingItem) return;
    setPending(true);
    try {
      await removeIncome(editingItem);
      setModalOpen(false);
    } catch (err) {
      console.error(err);
    } finally {
      setPending(false);
    }
  };

  const total = userData?.income.reduce((sum, item) => sum + item.value, 0) || 0;

  return (
    <div className="p-6 max-w-4xl mx-auto space-y-6 pb-24">
      <div className="flex items-center justify-between mb-8">
        <div className="flex items-center gap-4">
          <button onClick={() => navigate('/wallet')} className="p-2 -ml-2 rounded-lg hover:bg-container-light dark:hover:bg-container-dark">
            <span className="material-symbols-outlined">arrow_back</span>
          </button>
          <h1 className="text-3xl font-bold">Income Sources</h1>
        </div>
        <button 
          onClick={handleOpenAdd}
          className="w-10 h-10 bg-primary text-white rounded-xl flex items-center justify-center hover:bg-primary-hover shadow-sm"
        >
          <span className="material-symbols-outlined">add</span>
        </button>
      </div>

      <div className="bg-gradient-to-br from-primary to-primary-dark rounded-3xl p-6 text-white shadow-lg mb-8">
        <h2 className="opacity-90 font-medium mb-1">Total Expected Income</h2>
        <div className="text-4xl font-bold">{formatMoney(total, userData?.currency)}</div>
      </div>

      <div className="space-y-3">
        {(userData?.income || []).map((item) => (
          <div
            key={item.name}
            className="w-full flex items-center justify-between p-4 bg-container-light dark:bg-container-dark rounded-2xl shadow-sm text-left group"
          >
            <div className="flex items-center gap-4 cursor-pointer" onClick={() => handleOpenEdit(item)}>
              <div className="w-10 h-10 bg-primary/10 text-primary rounded-full flex items-center justify-center">
                <span className="material-symbols-outlined">trending_up</span>
              </div>
              <span className="font-semibold text-lg hover:text-primary transition-colors">{item.name}</span>
            </div>
            <div className="flex items-center gap-4">
              <span className="font-bold">{formatMoney(item.value, userData?.currency)}</span>
              <div className="flex items-center gap-2">
                <button 
                  onClick={async () => {
                    if (window.confirm(`Log payout of ${formatMoney(item.value, userData?.currency)} from ${item.name}?`)) {
                      try {
                        setPending(true);
                        await addTransaction({
                          name: `Payout from ${item.name}`,
                          amount: item.value,
                          type: 'income',
                          date: new Date(),
                          source: item.name
                        });
                      } catch (err) {
                        console.error(err);
                      } finally {
                        setPending(false);
                      }
                    }
                  }}
                  className="p-2 text-green-500 hover:bg-green-50 dark:hover:bg-green-500/10 rounded-xl transition-colors flex items-center gap-1 text-sm font-medium"
                  title="Log Payout"
                  disabled={pending}
                >
                  <span className="material-symbols-outlined text-xl">payments</span>
                  <span className="hidden sm:inline">Payout</span>
                </button>
                <button 
                  onClick={() => handleOpenEdit(item)}
                  className="p-2 text-gray-400 hover:text-primary hover:bg-primary/10 rounded-xl transition-colors"
                  title="Edit"
                >
                  <span className="material-symbols-outlined text-xl">edit</span>
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>

      <Modal isOpen={modalOpen} onClose={() => setModalOpen(false)} title={editingItem ? "Edit Income Source" : "Add Income Source"}>
        <div className="space-y-4">
          <InputField label="Name" value={name} onChange={setName} placeholder="Salary" disabled={pending} />
          <InputField label="Expected Amount" value={valueStr} onChange={setValueStr} type="number" placeholder="0.00" disabled={pending} />
          
          <div className="flex gap-4 pt-4">
            {editingItem && (
              <PrimaryButton text="Delete" variant="secondary" onClick={handleDelete} disabled={pending} className="flex-1 text-red-500 hover:text-red-600 hover:bg-red-50" />
            )}
            <PrimaryButton text="Save" onClick={handleSave} disabled={pending} className="flex-1" />
          </div>
        </div>
      </Modal>
    </div>
  );
}
