import { useState } from 'react';
import { useTransactions } from '../hooks/useTransactions';
import { useUserData } from '../contexts/UserDataContext';
import { formatMoney } from '../utils/moneyFormat';
import { getCategoryIcon } from '../utils/categories';
import { EmptyState } from '../components/EmptyState';
import { Modal } from '../components/Modal';
import { PrimaryButton } from '../components/PrimaryButton';

export function TransactionsPage() {
  const { transactions, deleteTransaction } = useTransactions();
  const { userData } = useUserData();
  
  const [deleteId, setDeleteId] = useState<string | null>(null);

  const handleDelete = async () => {
    if (!deleteId) return;
    try {
      await deleteTransaction(deleteId);
      setDeleteId(null);
    } catch (err) {
      console.error("Failed to delete transaction", err);
    }
  };

  return (
    <div className="p-6 max-w-4xl mx-auto space-y-6">
      <h1 className="text-3xl font-bold mb-8">Transactions</h1>

      <div className="bg-container-light dark:bg-container-dark rounded-3xl overflow-hidden shadow-sm border border-gray-200 dark:border-gray-800">
        {transactions.length === 0 ? (
          <EmptyState message="No transactions recorded" icon="list_alt" className="py-20" />
        ) : (
          <div className="divide-y divide-gray-200 dark:divide-gray-800">
            {transactions.map((tx) => (
              <div key={tx.id} className="flex items-center gap-4 p-4 hover:bg-bright-light dark:hover:bg-bright-dark transition-colors group">
                <div className={`w-12 h-12 rounded-xl flex shrink-0 items-center justify-center ${
                  tx.type === 'income' ? 'bg-green-100 dark:bg-green-900/30 text-green-600' : 'bg-red-100 dark:bg-red-900/30 text-red-600'
                }`}>
                  <span className="material-symbols-outlined">
                    {getCategoryIcon(tx.category)}
                  </span>
                </div>
                <div className="flex-1 min-w-0">
                  <h4 className="font-semibold truncate">{tx.name}</h4>
                  <div className="flex items-center gap-2 text-sm text-gray-500">
                    <span>{tx.date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })}</span>
                    {tx.source && (
                      <>
                        <span>•</span>
                        <span className="truncate">{tx.source}</span>
                      </>
                    )}
                  </div>
                </div>
                <div className={`font-bold whitespace-nowrap ${tx.type === 'income' ? 'text-green-500' : 'text-red-500'}`}>
                  {tx.type === 'income' ? '+' : '-'}{formatMoney(tx.amount, userData?.currency)}
                </div>
                
                {/* Delete button (shows on hover) */}
                <button 
                  onClick={() => setDeleteId(tx.id)}
                  className="w-10 h-10 rounded-full flex shrink-0 items-center justify-center text-red-500 hover:bg-red-50 dark:hover:bg-red-900/30 opacity-0 group-hover:opacity-100 transition-all focus:opacity-100"
                >
                  <span className="material-symbols-outlined text-[20px]">delete</span>
                </button>
              </div>
            ))}
          </div>
        )}
      </div>

      <Modal isOpen={!!deleteId} onClose={() => setDeleteId(null)} title="Delete Transaction">
        <p className="mb-6 text-gray-600 dark:text-gray-400">Are you sure you want to delete this transaction? This action cannot be undone and will not refund any balances.</p>
        <div className="flex gap-4">
          <PrimaryButton text="Cancel" variant="secondary" onClick={() => setDeleteId(null)} className="flex-1" />
          <PrimaryButton text="Delete" onClick={handleDelete} className="flex-1 !bg-red-600 hover:!bg-red-700" />
        </div>
      </Modal>
    </div>
  );
}
