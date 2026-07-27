import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useUserData } from '../contexts/UserDataContext';
import { formatMoney } from '../utils/moneyFormat';
import { PrimaryButton } from '../components/PrimaryButton';
import { InputField } from '../components/InputField';
import { Modal } from '../components/Modal';
import type { Receivable } from '../types';

export function ReceivablesPage() {
  const { userData, addReceivable, removeReceivable, updateReceivables } = useUserData();
  const navigate = useNavigate();
  
  const [modalOpen, setModalOpen] = useState(false);
  const [editingItem, setEditingItem] = useState<Receivable | null>(null);
  const [name, setName] = useState('');
  const [valueStr, setValueStr] = useState('');
  const [pending, setPending] = useState(false);

  const handleOpenAdd = () => {
    setEditingItem(null);
    setName('');
    setValueStr('');
    setModalOpen(true);
  };

  const handleOpenEdit = (item: Receivable) => {
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
        const newItems = (userData?.receivables || []).map(i => 
          i.name === editingItem.name ? { name, value: val } : i
        );
        await updateReceivables(newItems);
      } else {
        await addReceivable({ name, value: val });
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
      await removeReceivable(editingItem);
      setModalOpen(false);
    } catch (err) {
      console.error(err);
    } finally {
      setPending(false);
    }
  };

  const total = userData?.receivables.reduce((sum, item) => sum + item.value, 0) || 0;

  return (
    <div className="p-6 max-w-4xl mx-auto space-y-6 pb-24">
      <div className="flex items-center justify-between mb-8">
        <div className="flex items-center gap-4">
          <button onClick={() => navigate('/wallet')} className="p-2 -ml-2 rounded-lg hover:bg-container-light dark:hover:bg-container-dark">
            <span className="material-symbols-outlined">arrow_back</span>
          </button>
          <h1 className="text-3xl font-bold">Receivables</h1>
        </div>
        <button 
          onClick={handleOpenAdd}
          className="w-10 h-10 bg-primary text-white rounded-xl flex items-center justify-center hover:bg-primary-hover shadow-sm"
        >
          <span className="material-symbols-outlined">add</span>
        </button>
      </div>

      <div className="bg-gradient-to-br from-primary to-primary-dark rounded-3xl p-6 text-white shadow-lg mb-8">
        <h2 className="opacity-90 font-medium mb-1">Total Owed To You</h2>
        <div className="text-4xl font-bold">{formatMoney(total, userData?.currency)}</div>
      </div>

      <div className="space-y-3">
        {(userData?.receivables || []).map((item) => (
          <button
            key={item.name}
            onClick={() => handleOpenEdit(item)}
            className="w-full flex items-center justify-between p-4 bg-container-light dark:bg-container-dark hover:bg-bright-light dark:hover:bg-bright-dark rounded-2xl transition-colors shadow-sm text-left group"
          >
            <div className="flex items-center gap-4">
              <div className="w-10 h-10 bg-primary/10 text-primary rounded-full flex items-center justify-center">
                <span className="material-symbols-outlined">call_received</span>
              </div>
              <span className="font-semibold text-lg">{item.name}</span>
            </div>
            <div className="flex items-center gap-3">
              <span className="font-bold">{formatMoney(item.value, userData?.currency)}</span>
              <span className="material-symbols-outlined text-gray-400 group-hover:text-primary transition-colors">edit</span>
            </div>
          </button>
        ))}
      </div>

      <Modal isOpen={modalOpen} onClose={() => setModalOpen(false)} title={editingItem ? "Edit Receivable" : "Add Receivable"}>
        <div className="space-y-4">
          <InputField label="Name" value={name} onChange={setName} placeholder="John Doe, etc." disabled={pending} />
          <InputField label="Amount" value={valueStr} onChange={setValueStr} type="number" placeholder="0.00" disabled={pending} />
          
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
