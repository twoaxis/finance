import { Link } from 'react-router-dom';
import { useUserData } from '../contexts/UserDataContext';
import { BudgetGauge } from '../components/BudgetGauge';
import { EmptyState } from '../components/EmptyState';

export function MoneyFlowPage() {
  const { userData } = useUserData();

  return (
    <div className="p-6 max-w-4xl mx-auto space-y-8">
      <h1 className="text-4xl font-bold mb-8">Money Flow</h1>

      <div className="grid grid-cols-2 gap-6">
        <Link 
          to="/bills" 
          className="bg-container-light dark:bg-container-dark hover:bg-bright-light dark:hover:bg-bright-dark transition-colors rounded-3xl p-6 flex flex-col items-center justify-center min-h-[160px] shadow-sm border border-gray-200 dark:border-gray-800"
        >
          <div className="w-20 h-20 bg-transparent rounded-2xl flex items-center justify-center mb-4">
            <img src="/expenses.png" alt="Bills" className="w-full h-full object-contain drop-shadow-md" />
          </div>
          <h2 className="text-xl font-bold">Bills</h2>
        </Link>
        
        <Link 
          to="/liabilities" 
          className="bg-container-light dark:bg-container-dark hover:bg-bright-light dark:hover:bg-bright-dark transition-colors rounded-3xl p-6 flex flex-col items-center justify-center min-h-[160px] shadow-sm border border-gray-200 dark:border-gray-800"
        >
          <div className="w-20 h-20 bg-transparent rounded-2xl flex items-center justify-center mb-4">
            <img src="/liabilities.png" alt="Liabilities" className="w-full h-full object-contain drop-shadow-md" />
          </div>
          <h2 className="text-xl font-bold">Liabilities</h2>
        </Link>
      </div>

      <div className="mt-12 bg-container-light dark:bg-container-dark rounded-3xl p-6 shadow-sm border border-gray-200 dark:border-gray-800 hover:bg-bright-light dark:hover:bg-bright-dark transition-colors">
        <Link to="/budget" className="block">
          <div className="flex items-center justify-between mb-8">
            <h3 className="text-2xl font-bold">Budget</h3>
            <span className="material-symbols-outlined text-gray-400">chevron_right</span>
          </div>
          
          <div className="flex justify-center">
            {userData?.budget ? (
              <BudgetGauge 
                spent={userData.budget.spent} 
                limit={userData.budget.value} 
                currency={userData.currency} 
              />
            ) : (
              <EmptyState message="No budget set" icon="pie_chart" />
            )}
          </div>
        </Link>
      </div>
    </div>
  );
}
