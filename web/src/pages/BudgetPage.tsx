import { useState } from 'react';
import { useUserData } from '../contexts/UserDataContext';
import { BudgetGauge } from '../components/BudgetGauge';
import { InputField } from '../components/InputField';
import { PrimaryButton } from '../components/PrimaryButton';
import { Modal } from '../components/Modal';

export function BudgetPage() {
  const { userData, updateBudget } = useUserData();
  const [modalOpen, setModalOpen] = useState(false);
  const [limitStr, setLimitStr] = useState('');
  const [pending, setPending] = useState(false);

  const handleEditOpen = () => {
    setLimitStr(userData?.budget?.value?.toString() || '');
    setModalOpen(true);
  };

  const handleSave = async () => {
    const limit = parseFloat(limitStr);
    if (isNaN(limit) || limit < 0) return;
    
    setPending(true);
    try {
      await updateBudget({
        spent: userData?.budget?.spent || 0,
        value: limit
      });
      setModalOpen(false);
    } catch (err) {
      console.error("Failed to update budget", err);
    } finally {
      setPending(false);
    }
  };

  const handleClear = async () => {
    setPending(true);
    try {
      await updateBudget(null);
      setModalOpen(false);
    } catch (err) {
      console.error("Failed to clear budget", err);
    } finally {
      setPending(false);
    }
  };

  return (
    <div className="p-6 max-w-4xl mx-auto space-y-8">
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-3xl font-bold">Budget</h1>
        <button 
          onClick={handleEditOpen}
          className="p-2 rounded-lg bg-container-light dark:bg-container-dark hover:bg-bright-light dark:hover:bg-bright-dark transition-colors"
        >
          <span className="material-symbols-outlined">edit</span>
        </button>
      </div>

      <div className="bg-container-light dark:bg-container-dark rounded-3xl p-8 flex justify-center shadow-sm border border-gray-200 dark:border-gray-800">
        {userData?.budget ? (
          <BudgetGauge 
            spent={userData.budget.spent} 
            limit={userData.budget.value} 
            currency={userData.currency} 
          />
        ) : (
          <div className="text-center space-y-4 py-12">
            <span className="material-symbols-outlined text-6xl text-gray-400">pie_chart</span>
            <p className="text-xl text-gray-500">No budget set</p>
            <PrimaryButton 
              text="Create Budget" 
              onClick={handleEditOpen} 
              className="mt-4"
            />
          </div>
        )}
      </div>

      <Modal isOpen={modalOpen} onClose={() => setModalOpen(false)} title="Set Budget">
        <div className="space-y-6">
          <InputField 
            label={`Monthly Limit (${userData?.currency || 'USD'})`}
            value={limitStr}
            onChange={setLimitStr}
            type="number"
            placeholder="0.00"
            disabled={pending}
          />
          
          <div className="flex gap-4">
            {userData?.budget && (
              <PrimaryButton 
                text="Clear" 
                variant="secondary" 
                onClick={handleClear} 
                disabled={pending}
                className="flex-1 text-red-500 hover:text-red-600"
              />
            )}
            <PrimaryButton 
              text="Save" 
              onClick={handleSave} 
              disabled={pending}
              className="flex-1"
            />
          </div>
        </div>
      </Modal>
    </div>
  );
}
