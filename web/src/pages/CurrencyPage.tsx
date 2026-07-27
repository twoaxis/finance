import { useNavigate } from 'react-router-dom';
import { useUserData } from '../contexts/UserDataContext';
import { currencies } from '../utils/constants';

export function CurrencyPage() {
  const { userData, updateCurrency } = useUserData();
  const navigate = useNavigate();

  const handleSelect = async (code: string) => {
    try {
      await updateCurrency(code);
      navigate('/account');
    } catch (err) {
      console.error("Failed to update currency", err);
    }
  };

  const currentCurrency = userData?.currency || 'USD';

  return (
    <div className="p-6 max-w-2xl mx-auto h-[calc(100vh-80px)] flex flex-col">
      <div className="flex items-center gap-4 mb-6 shrink-0">
        <button onClick={() => navigate('/account')} className="p-2 -ml-2 rounded-lg hover:bg-container-light dark:hover:bg-container-dark">
          <span className="material-symbols-outlined">arrow_back</span>
        </button>
        <h1 className="text-3xl font-bold">Select Currency</h1>
      </div>

      <div className="flex-1 overflow-y-auto bg-container-light dark:bg-container-dark rounded-2xl shadow-sm">
        {Object.entries(currencies).map(([code, name], index, array) => (
          <div key={code}>
            <button 
              onClick={() => handleSelect(code)}
              className="w-full flex items-center justify-between p-4 hover:bg-bright-light dark:hover:bg-bright-dark transition-colors text-left"
            >
              <span className="font-medium">{code} - {name}</span>
              {currentCurrency === code && (
                <span className="material-symbols-outlined text-green-500">check_circle</span>
              )}
            </button>
            {index < array.length - 1 && (
              <div className="h-px bg-gray-200 dark:bg-gray-800 mx-4" />
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
