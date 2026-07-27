import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useUserData } from '../contexts/UserDataContext';
import { useTransactions } from '../hooks/useTransactions';
import { formatMoney } from '../utils/moneyFormat';
import { getCategoryIcon } from '../utils/categories';
import { EmptyState } from '../components/EmptyState';
import { Modal } from '../components/Modal';

export function DashboardPage() {
  const { userData } = useUserData();
  const { transactions } = useTransactions();
  const navigate = useNavigate();
  
  const [balanceHidden, setBalanceHidden] = useState(false);
  const [quickAddModalOpen, setQuickAddModalOpen] = useState(false);

  const totalBalance = userData?.balances.reduce((acc, curr) => acc + curr.value, 0) || 0;
  const recentTransactions = transactions.slice(0, 30);

  return (
    <div className="p-6 max-w-4xl mx-auto space-y-8 relative">
      <div className="hidden dark:block absolute top-0 left-1/2 -translate-x-1/2 w-[600px] h-[600px] opacity-20 pointer-events-none" 
           style={{ background: 'radial-gradient(circle, var(--color-primary) 0%, transparent 60%)' }} />

      {/* Balance Header */}
      <div className="relative z-10 flex flex-col items-center pt-8 pb-4">
        <h2 className="text-gray-500 font-medium mb-2">Total balance</h2>
        <div className="flex items-center gap-4">
          <h1 className="text-5xl font-bold">
            {balanceHidden ? '••••••' : formatMoney(totalBalance, userData?.currency)}
          </h1>
          <button 
            onClick={() => setBalanceHidden(!balanceHidden)}
            className="p-2 rounded-full hover:bg-container-light dark:hover:bg-container-dark text-gray-500 transition-colors"
          >
            <span className="material-symbols-outlined">
              {balanceHidden ? 'visibility_off' : 'visibility'}
            </span>
          </button>
        </div>
      </div>

      {/* Action Buttons */}
      <div className="relative z-10 flex justify-center gap-6">
        <button 
          onClick={() => setQuickAddModalOpen(true)}
          className="flex flex-col items-center gap-2 group"
        >
          <div className="w-16 h-16 bg-primary rounded-2xl flex items-center justify-center text-white shadow-lg shadow-primary/20 group-hover:-translate-y-1 transition-transform">
            <span className="material-symbols-outlined text-3xl">add</span>
          </div>
          <span className="text-sm font-medium">Quick Add</span>
        </button>
        
        <Link to="/analytics" className="flex flex-col items-center gap-2 group">
          <div className="w-16 h-16 bg-container-light dark:bg-container-dark rounded-2xl flex items-center justify-center group-hover:-translate-y-1 transition-transform border border-gray-200 dark:border-gray-800">
            <span className="material-symbols-outlined text-3xl text-primary">analytics</span>
          </div>
          <span className="text-sm font-medium">Analytics</span>
        </Link>
        
        <Link to="/budget" className="flex flex-col items-center gap-2 group">
          <div className="w-16 h-16 bg-container-light dark:bg-container-dark rounded-2xl flex items-center justify-center group-hover:-translate-y-1 transition-transform border border-gray-200 dark:border-gray-800">
            <span className="material-symbols-outlined text-3xl text-primary">money_off</span>
          </div>
          <span className="text-sm font-medium">Budget</span>
        </Link>
      </div>

      {/* Recent Transactions */}
      <div className="relative z-10 mt-12 bg-container-light dark:bg-container-dark rounded-3xl p-6 shadow-sm border border-gray-200 dark:border-gray-800">
        <div className="flex items-center justify-between mb-6">
          <h3 className="text-xl font-bold">Recent Transactions</h3>
          <Link to="/transactions" className="p-2 rounded-full hover:bg-bright-light dark:hover:bg-bright-dark transition-colors">
            <span className="material-symbols-outlined">arrow_forward</span>
          </Link>
        </div>

        {recentTransactions.length === 0 ? (
          <EmptyState message="No transactions found" icon="receipt_long" className="py-12" />
        ) : (
          <div className="space-y-4">
            {recentTransactions.map((tx, index) => (
              <div key={tx.id}>
                <div className="flex items-center gap-4 py-2 hover:bg-bright-light dark:hover:bg-bright-dark rounded-xl px-2 transition-colors cursor-default">
                  <div className={`w-12 h-12 rounded-xl flex items-center justify-center ${
                    tx.type === 'income' ? 'bg-green-100 dark:bg-green-900/30 text-green-600' : 'bg-red-100 dark:bg-red-900/30 text-red-600'
                  }`}>
                    <span className="material-symbols-outlined">
                      {getCategoryIcon(tx.category)}
                    </span>
                  </div>
                  <div className="flex-1">
                    <h4 className="font-semibold">{tx.name}</h4>
                    <p className="text-sm text-gray-500">
                      {tx.date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })}
                    </p>
                  </div>
                  <div className={`font-bold ${tx.type === 'income' ? 'text-green-500' : 'text-red-500'}`}>
                    {tx.type === 'income' ? '+' : '-'}{formatMoney(tx.amount, userData?.currency)}
                  </div>
                </div>
                {index < recentTransactions.length - 1 && (
                  <div className="h-px bg-gray-200 dark:bg-gray-800 ml-16" />
                )}
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Quick Add Modal */}
      <Modal isOpen={quickAddModalOpen} onClose={() => setQuickAddModalOpen(false)} title="Quick Add">
        <div className="flex flex-col gap-4">
          <button 
            onClick={() => navigate('/quick-add?type=income')}
            className="flex items-center gap-4 p-4 rounded-xl bg-container-light dark:bg-container-dark hover:bg-bright-light dark:hover:bg-bright-dark transition-colors border border-primary/30"
          >
            <div className="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center text-primary">
              <span className="material-symbols-outlined">arrow_downward</span>
            </div>
            <div className="text-left">
              <h3 className="font-bold text-lg">Income</h3>
              <p className="text-sm text-gray-500">Add money to your balances</p>
            </div>
          </button>
          
          <button 
            onClick={() => navigate('/quick-add?type=expense')}
            className="flex items-center gap-4 p-4 rounded-xl bg-container-light dark:bg-container-dark hover:bg-bright-light dark:hover:bg-bright-dark transition-colors border border-primary/30"
          >
            <div className="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center text-primary">
              <span className="material-symbols-outlined">arrow_upward</span>
            </div>
            <div className="text-left">
              <h3 className="font-bold text-lg">Expense</h3>
              <p className="text-sm text-gray-500">Deduct money from your balances</p>
            </div>
          </button>
        </div>
      </Modal>
    </div>
  );
}
