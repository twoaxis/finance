import { useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { useTransactions } from '../hooks/useTransactions';
import { useUserData } from '../contexts/UserDataContext';
import { PrimaryButton } from '../components/PrimaryButton';
import { InputField } from '../components/InputField';
import { CategoryPicker } from '../components/CategoryPicker';
import { expenseCategoryIcons, incomeCategoryIcons } from '../utils/categories';

export function QuickAddPage() {
  const [searchParams] = useSearchParams();
  const initialType = searchParams.get('type') === 'income' ? 'income' : 'expense';
  
  const navigate = useNavigate();
  const { addTransaction } = useTransactions();
  const { userData, updateBudget } = useUserData();
  
  const [type, setType] = useState<'income' | 'expense'>(initialType);
  const [amount, setAmount] = useState('');
  const [name, setName] = useState('');
  const [category, setCategory] = useState<string | null>(null);
  const [source, setSource] = useState<string | null>(null);
  const [pending, setPending] = useState(false);

  const categories = type === 'expense' ? expenseCategoryIcons : incomeCategoryIcons;
  const sources = type === 'income' ? userData?.income : userData?.balances;

  const handleSave = async () => {
    const numAmount = parseFloat(amount);
    if (!name.trim() || isNaN(numAmount) || numAmount <= 0) return;
    
    setPending(true);
    try {
      const txData: any = {
        name,
        amount: numAmount,
        type,
        date: new Date(),
      };
      
      if (category) txData.category = category;
      if (source) txData.source = source;

      await addTransaction(txData);

      // Update budget if it's an expense
      if (type === 'expense' && userData?.budget) {
        await updateBudget({
          ...userData.budget,
          spent: userData.budget.spent + numAmount
        });
      }

      navigate('/');
    } catch (err) {
      console.error("Failed to add transaction", err);
      setPending(false);
    }
  };

  return (
    <div className="p-6 max-w-2xl mx-auto space-y-6 pb-24">
      <div className="flex items-center gap-4 mb-8">
        <button onClick={() => navigate(-1)} className="p-2 -ml-2 rounded-lg hover:bg-container-light dark:hover:bg-container-dark">
          <span className="material-symbols-outlined">arrow_back</span>
        </button>
        <h1 className="text-3xl font-bold">Quick Add</h1>
      </div>

      {/* Type Toggle */}
      <div className="flex bg-container-light dark:bg-container-dark rounded-xl p-1 shadow-sm">
        <button
          className={`flex-1 py-2 rounded-lg font-medium transition-colors ${type === 'expense' ? 'bg-primary shadow text-white' : 'text-gray-500 hover:text-gray-900 dark:hover:text-white'}`}
          onClick={() => { setType('expense'); setCategory(null); setSource(null); }}
        >
          Expense
        </button>
        <button
          className={`flex-1 py-2 rounded-lg font-medium transition-colors ${type === 'income' ? 'bg-primary shadow text-white' : 'text-gray-500 hover:text-gray-900 dark:hover:text-white'}`}
          onClick={() => { setType('income'); setCategory(null); setSource(null); }}
        >
          Income
        </button>
      </div>

      <div className="space-y-6">
        <div className="flex items-end gap-2 text-4xl font-bold text-center justify-center pt-8 pb-4">
          <span className="text-gray-400 text-2xl mb-1">{userData?.currency}</span>
          <input 
            type="number" 
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            placeholder="0.00"
            className="w-full max-w-[200px] bg-transparent outline-none text-center placeholder-gray-300 dark:placeholder-gray-700"
            autoFocus
          />
        </div>

        <InputField 
          label="Name / Description" 
          value={name} 
          onChange={setName} 
          placeholder={type === 'expense' ? 'Groceries' : 'Salary'}
        />

        <div>
          <label className="block text-sm text-gray-500 mb-2 pl-1">Category</label>
          <CategoryPicker 
            categories={categories} 
            selected={category} 
            onSelect={(cat) => setCategory(category === cat ? null : cat)} 
          />
        </div>

        {sources && sources.length > 0 && (
          <div>
            <label className="block text-sm text-gray-500 mb-2 pl-1">
              {type === 'expense' ? 'From Balance' : 'To Income Source'}
            </label>
            <div className="flex flex-wrap gap-2">
              {sources.map((s) => (
                <button
                  key={s.name}
                  onClick={() => setSource(source === s.name ? null : s.name)}
                  className={`px-4 py-2 rounded-xl transition-colors text-sm font-medium border ${
                    source === s.name 
                      ? 'bg-primary text-white border-primary' 
                      : 'bg-container-light dark:bg-container-dark border-gray-200 dark:border-gray-800 hover:border-gray-300 dark:hover:border-gray-700'
                  }`}
                >
                  {s.name}
                </button>
              ))}
            </div>
          </div>
        )}
      </div>

      <div className="fixed bottom-0 left-0 right-0 p-4 bg-surface-light dark:bg-surface-dark border-t border-gray-200 dark:border-gray-800 lg:left-[280px]">
        <div className="max-w-2xl mx-auto">
          <PrimaryButton 
            text="Save Transaction" 
            onClick={handleSave} 
            disabled={pending || !amount || !name}
          />
        </div>
      </div>
    </div>
  );
}
