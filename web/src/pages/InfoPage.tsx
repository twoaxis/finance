import { useNavigate } from 'react-router-dom';

export function InfoPage() {
  const navigate = useNavigate();

  return (
    <div className="p-6 max-w-2xl mx-auto space-y-6">
      <div className="flex items-center gap-4 mb-8">
        <button onClick={() => navigate('/account')} className="p-2 -ml-2 rounded-lg hover:bg-container-light dark:hover:bg-container-dark">
          <span className="material-symbols-outlined">arrow_back</span>
        </button>
        <h1 className="text-3xl font-bold">About</h1>
      </div>

      <div className="bg-container-light dark:bg-container-dark rounded-2xl overflow-hidden shadow-sm">
        <div className="flex items-center p-4">
          <span className="material-symbols-outlined text-gray-500 mr-4">build</span>
          <div>
            <div className="font-medium text-gray-500">Version</div>
            <div>1.4.0</div>
          </div>
        </div>
        <div className="h-px bg-gray-200 dark:bg-gray-800 mx-4" />
        
        <div className="flex items-center p-4">
          <span className="material-symbols-outlined text-gray-500 mr-4">build</span>
          <div>
            <div className="font-medium text-gray-500">Build Number</div>
            <div>1</div>
          </div>
        </div>
      </div>

      <div className="pt-8 text-center text-gray-500">
        (c) {new Date().getFullYear()} TwoAxis. All Rights Reserved.
      </div>
    </div>
  );
}
