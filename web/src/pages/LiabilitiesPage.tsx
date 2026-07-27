import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useUserData } from '../contexts/UserDataContext';
import { useTransactions } from '../hooks/useTransactions';
import { formatMoney } from '../utils/moneyFormat';
import { PrimaryButton } from '../components/PrimaryButton';
import { InputField } from '../components/InputField';
import { Modal } from '../components/Modal';
import type { Liability } from '../types';

export function LiabilitiesPage() {
  const { userData, addLiability, removeLiability, updateLiabilities, updateBalances, updateBudget } = useUserData();
  const { addTransaction } = useTransactions();
  const navigate = useNavigate();
  
  const [modalOpen, setModalOpen] = useState(false);
  const [editingItem, setEditingItem] = useState<Liability | null>(null);
  const [name, setName] = useState('');
  const [valueStr, setValueStr] = useState('');
  
  // Payment Modal State
  const [paymentModalOpen, setPaymentModalOpen] = useState(false);
  const [paymentItem, setPaymentItem] = useState<Liability | null>(null);
  const [paymentAmountStr, setPaymentAmountStr] = useState('');
  const [paymentBalance, setPaymentBalance] = useState('');
  
  const [pending, setPending] = useState(false);

  const handleOpenAdd = () => {
    setEditingItem(null);
    setName('');
    setValueStr('');
    setModalOpen(true);
  };

  const handleOpenEdit = (item: Liability) => {
    setEditingItem(item);
    setName(item.name);
    setValueStr(item.value.toString());
    setModalOpen(true);
  };

  const handleOpenPayment = (item: Liability) => {
    setPaymentItem(item);
    setPaymentAmountStr('');
    setPaymentBalance(userData?.balances?.[0]?.name || '');
    setPaymentModalOpen(true);
  };

  const handleSave = async () => {
    const val = parseFloat(valueStr);
    if (!name.trim() || isNaN(val)) return;
    
    setPending(true);
    try {
      if (editingItem) {
        const newItems = (userData?.liabilities || []).map(i => 
          i.name === editingItem.name ? { name, value: val } : i
        );
        await updateLiabilities(newItems);
      } else {
        await addLiability({ name, value: val });
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
      await removeLiability(editingItem);
      setModalOpen(false);
    } catch (err) {
      console.error(err);
    } finally {
      setPending(false);
    }
  };

  const handlePayment = async () => {
    if (!paymentItem) return;
    const amount = parseFloat(paymentAmountStr);
    if (isNaN(amount) || amount <= 0) return;

    setPending(true);
    try {
      // 1. Create Expense Transaction
      await addTransaction({
        name: `Payment for ${paymentItem.name}`,
        amount,
        type: 'expense',
        date: new Date(),
        source: paymentBalance || undefined
      });

      // 2. Deduct from Liability
      const newLiabilities = (userData?.liabilities || []).map(i => 
        i.name === paymentItem.name ? { ...i, value: Math.max(0, i.value - amount) } : i
      );
      await updateLiabilities(newLiabilities);

      // 3. Deduct from Balance (if selected)
      if (paymentBalance && userData?.balances) {
        const newBalances = userData.balances.map(b => 
          b.name === paymentBalance ? { ...b, value: Math.max(0, b.value - amount) } : b
        );
        await updateBalances(newBalances);
      }

      // 4. Update budget
      if (userData?.budget) {
        await updateBudget({
          ...userData.budget,
          spent: userData.budget.spent + amount
        });
      }

      setPaymentModalOpen(false);
    } catch (err) {
      console.error(err);
    } finally {
      setPending(false);
    }
  };

  const total = userData?.liabilities.reduce((sum, item) => sum + item.value, 0) || 0;

  return (
    <div className="p-6 max-w-4xl mx-auto space-y-6 pb-24">
      <div className="flex items-center justify-between mb-8">
        <div className="flex items-center gap-4">
          <button onClick={() => navigate('/money-flow')} className="p-2 -ml-2 rounded-lg hover:bg-container-light dark:hover:bg-container-dark">
            <span className="material-symbols-outlined">arrow_back</span>
          </button>
          <h1 className="text-3xl font-bold">Liabilities</h1>
        </div>
        <button 
          onClick={handleOpenAdd}
          className="w-10 h-10 bg-primary text-white rounded-xl flex items-center justify-center hover:bg-primary-hover shadow-sm"
        >
          <span className="material-symbols-outlined">add</span>
        </button>
      </div>

      <div className="bg-gradient-to-br from-primary to-primary-dark rounded-3xl p-6 text-white shadow-lg mb-8">
        <h2 className="opacity-90 font-medium mb-1">Total Liabilities</h2>
        <div className="text-4xl font-bold">{formatMoney(total, userData?.currency)}</div>
      </div>

      <div className="space-y-3">
        {(userData?.liabilities || []).map((item) => (
          <div
            key={item.name}
            className="w-full flex items-center justify-between p-4 bg-container-light dark:bg-container-dark rounded-2xl shadow-sm text-left group"
          >
            <div className="flex items-center gap-4 cursor-pointer" onClick={() => handleOpenEdit(item)}>
              <div className="w-10 h-10 bg-primary/10 text-primary rounded-full flex items-center justify-center">
                <span className="material-symbols-outlined">credit_card</span>
              </div>
              <span className="font-semibold text-lg hover:text-primary transition-colors">{item.name}</span>
            </div>
            <div className="flex items-center gap-4">
              <span className="font-bold">{formatMoney(item.value, userData?.currency)}</span>
              <div className="flex items-center gap-2">
                <button 
                  onClick={() => handleOpenPayment(item)}
                  className="p-2 text-primary hover:bg-primary/10 rounded-xl transition-colors flex items-center gap-1 text-sm font-medium"
                  title="Make Payment"
                >
                  <span className="material-symbols-outlined text-xl">payment</span>
                  <span className="hidden sm:inline">Pay</span>
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

      {/* Edit Modal */}
      <Modal isOpen={modalOpen} onClose={() => setModalOpen(false)} title={editingItem ? "Edit Liability" : "Add Liability"}>
        <div className="space-y-4">
          <InputField label="Name" value={name} onChange={setName} placeholder="Car Loan, Mortgage, etc." disabled={pending} />
          <InputField label="Total Amount" value={valueStr} onChange={setValueStr} type="number" placeholder="0.00" disabled={pending} />
          
          <div className="flex gap-4 pt-4">
            {editingItem && (
              <PrimaryButton text="Delete" variant="secondary" onClick={handleDelete} disabled={pending} className="flex-1 text-red-500 hover:text-red-600 hover:bg-red-50" />
            )}
            <PrimaryButton text="Save" onClick={handleSave} disabled={pending} className="flex-1" />
          </div>
        </div>
      </Modal>

      {/* Payment Modal */}
      <Modal isOpen={paymentModalOpen} onClose={() => setPaymentModalOpen(false)} title={`Pay ${paymentItem?.name}`}>
        <div className="space-y-4">
          <InputField 
            label="Payment Amount" 
            value={paymentAmountStr} 
            onChange={setPaymentAmountStr} 
            type="number" 
            placeholder="0.00" 
            disabled={pending} 
          />
          
          {userData?.balances && userData.balances.length > 0 && (
            <div>
              <label className="block text-sm text-gray-500 mb-2 pl-1">Pay From Balance</label>
              <select 
                className="w-full bg-container-light dark:bg-container-dark border border-gray-200 dark:border-gray-800 rounded-xl px-4 py-3 outline-none focus:border-primary transition-colors appearance-none"
                value={paymentBalance}
                onChange={(e) => setPaymentBalance(e.target.value)}
                disabled={pending}
              >
                <option value="">None</option>
                {userData.balances.map(b => (
                  <option key={b.name} value={b.name}>{b.name} ({formatMoney(b.value, userData.currency)})</option>
                ))}
              </select>
            </div>
          )}
          
          <div className="flex gap-4 pt-4">
            <PrimaryButton text="Cancel" variant="secondary" onClick={() => setPaymentModalOpen(false)} disabled={pending} className="flex-1" />
            <PrimaryButton text="Confirm Payment" onClick={handlePayment} disabled={pending || !paymentAmountStr} className="flex-1" />
          </div>
        </div>
      </Modal>
    </div>
  );
}
