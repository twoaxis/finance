import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useUserData } from '../contexts/UserDataContext';
import { useTransactions } from '../hooks/useTransactions';
import { formatMoney } from '../utils/moneyFormat';
import { PrimaryButton } from '../components/PrimaryButton';
import { InputField } from '../components/InputField';
import { Modal } from '../components/Modal';
import type { Balance } from '../types';

export function BalancesPage() {
  const { userData, addBalance, removeBalance, updateBalances, updateBudget } = useUserData();
  const { addTransaction } = useTransactions();
  const navigate = useNavigate();
  
  const [modalOpen, setModalOpen] = useState(false);
  const [editingItem, setEditingItem] = useState<Balance | null>(null);
  const [name, setName] = useState('');
  const [valueStr, setValueStr] = useState('');
  
  // Payment Modal State
  const [paymentModalOpen, setPaymentModalOpen] = useState(false);
  const [paymentItem, setPaymentItem] = useState<Balance | null>(null);
  const [paymentAmountStr, setPaymentAmountStr] = useState('');
  const [paymentName, setPaymentName] = useState('');
  
  const [pending, setPending] = useState(false);

  const handleOpenAdd = () => {
    setEditingItem(null);
    setName('');
    setValueStr('');
    setModalOpen(true);
  };

  const handleOpenEdit = (item: Balance) => {
    setEditingItem(item);
    setName(item.name);
    setValueStr(item.value.toString());
    setModalOpen(true);
  };

  const handleOpenPayment = (item: Balance) => {
    setPaymentItem(item);
    setPaymentAmountStr('');
    setPaymentName('');
    setPaymentModalOpen(true);
  };

  const handleSave = async () => {
    const val = parseFloat(valueStr);
    if (!name.trim() || isNaN(val)) return;
    
    setPending(true);
    try {
      if (editingItem) {
        const newItems = (userData?.balances || []).map(i => 
          i.name === editingItem.name ? { name, value: val } : i
        );
        await updateBalances(newItems);
      } else {
        await addBalance({ name, value: val });
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
      await removeBalance(editingItem);
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
    if (isNaN(amount) || amount <= 0 || !paymentName.trim()) return;

    setPending(true);
    try {
      // 1. Create Expense Transaction
      await addTransaction({
        name: paymentName,
        amount,
        type: 'expense',
        date: new Date(),
        source: paymentItem.name
      });

      // 2. Deduct from this Balance
      const newBalances = (userData?.balances || []).map(i => 
        i.name === paymentItem.name ? { ...i, value: Math.max(0, i.value - amount) } : i
      );
      await updateBalances(newBalances);

      // 3. Update budget
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

  const total = userData?.balances.reduce((sum, item) => sum + item.value, 0) || 0;

  return (
    <div className="p-6 max-w-4xl mx-auto space-y-6 pb-24">
      <div className="flex items-center justify-between mb-8">
        <div className="flex items-center gap-4">
          <button onClick={() => navigate('/wallet')} className="p-2 -ml-2 rounded-lg hover:bg-container-light dark:hover:bg-container-dark">
            <span className="material-symbols-outlined">arrow_back</span>
          </button>
          <h1 className="text-3xl font-bold">Balances</h1>
        </div>
        <button 
          onClick={handleOpenAdd}
          className="w-10 h-10 bg-primary text-white rounded-xl flex items-center justify-center hover:bg-primary-hover shadow-sm"
        >
          <span className="material-symbols-outlined">add</span>
        </button>
      </div>

      <div className="bg-gradient-to-br from-primary to-primary-dark rounded-3xl p-6 text-white shadow-lg mb-8">
        <h2 className="opacity-90 font-medium mb-1">Total Balances</h2>
        <div className="text-4xl font-bold">{formatMoney(total, userData?.currency)}</div>
      </div>

      <div className="space-y-3">
        {(userData?.balances || []).map((item) => (
          <div
            key={item.name}
            className="w-full flex items-center justify-between p-4 bg-container-light dark:bg-container-dark rounded-2xl shadow-sm text-left group"
          >
            <div className="flex items-center gap-4 cursor-pointer" onClick={() => handleOpenEdit(item)}>
              <div className="w-10 h-10 bg-primary/10 text-primary rounded-full flex items-center justify-center">
                <span className="material-symbols-outlined">account_balance</span>
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
      <Modal isOpen={modalOpen} onClose={() => setModalOpen(false)} title={editingItem ? "Edit Balance" : "Add Balance"}>
        <div className="space-y-4">
          <InputField label="Name" value={name} onChange={setName} placeholder="Checking Account" disabled={pending} />
          <InputField label="Amount" value={valueStr} onChange={setValueStr} type="number" placeholder="0.00" disabled={pending} />
          
          <div className="flex gap-4 pt-4">
            {editingItem && (
              <PrimaryButton text="Delete" variant="secondary" onClick={handleDelete} disabled={pending} className="flex-1 text-red-500 hover:text-red-600 hover:bg-red-50" />
            )}
            <PrimaryButton text="Save" onClick={handleSave} disabled={pending} className="flex-1" />
          </div>
        </div>
      </Modal>

      {/* Payment Modal */}
      <Modal isOpen={paymentModalOpen} onClose={() => setPaymentModalOpen(false)} title={`Spend from ${paymentItem?.name}`}>
        <div className="space-y-4">
          <InputField 
            label="What did you pay for?" 
            value={paymentName} 
            onChange={setPaymentName} 
            placeholder="Groceries, Rent, etc." 
            disabled={pending} 
          />
          <InputField 
            label="Amount Spent" 
            value={paymentAmountStr} 
            onChange={setPaymentAmountStr} 
            type="number" 
            placeholder="0.00" 
            disabled={pending} 
          />
          
          <div className="flex gap-4 pt-4">
            <PrimaryButton text="Cancel" variant="secondary" onClick={() => setPaymentModalOpen(false)} disabled={pending} className="flex-1" />
            <PrimaryButton text="Log Payment" onClick={handlePayment} disabled={pending || !paymentAmountStr || !paymentName} className="flex-1" />
          </div>
        </div>
      </Modal>
    </div>
  );
}
