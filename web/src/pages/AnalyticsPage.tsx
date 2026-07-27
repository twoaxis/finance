import { useUserData } from '../contexts/UserDataContext';
import { useTransactions } from '../hooks/useTransactions';
import { formatMoney } from '../utils/moneyFormat';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Filler,
  } from 'chart.js';
import type { ChartOptions } from 'chart.js';
import { Line } from 'react-chartjs-2';

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Filler
);

export function AnalyticsPage() {
  const { userData } = useUserData();
  const { transactions } = useTransactions();

  // Calculations
  const assetsSum = userData?.assets.reduce((sum, item) => sum + item.value, 0) || 0;
  const balancesSum = userData?.balances.reduce((sum, item) => sum + item.value, 0) || 0;
  const receivablesSum = userData?.receivables.reduce((sum, item) => sum + item.value, 0) || 0;
  const netWorth = assetsSum;
  const balanceAfterReceivables = balancesSum + receivablesSum;

  // Chart Data: last 7 days of expenses
  const days = 7;
  const labels: string[] = [];
  const dataPoints: number[] = [];
  
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  for (let i = days - 1; i >= 0; i--) {
    const d = new Date(today);
    d.setDate(d.getDate() - i);
    labels.push(`${d.getDate()}/${d.getMonth() + 1}`);

    const nextDay = new Date(d);
    nextDay.setDate(nextDay.getDate() + 1);

    const dayExpense = transactions
      .filter(tx => tx.type === 'expense' && tx.date >= d && tx.date < nextDay)
      .reduce((sum, tx) => sum + tx.amount, 0);
    
    dataPoints.push(dayExpense);
  }

  const chartData = {
    labels,
    datasets: [
      {
        fill: true,
        label: 'Expenses',
        data: dataPoints,
        borderColor: '#A72222',
        backgroundColor: 'rgba(167, 34, 34, 0.2)', // Primary with opacity
        tension: 0.4,
        pointRadius: 4,
        pointBackgroundColor: '#A72222',
      },
    ],
  };

  const chartOptions: ChartOptions<'line'> = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { display: false },
      tooltip: {
        callbacks: {
          label: (context) => formatMoney(context.parsed.y || 0, userData?.currency)
        }
      }
    },
    scales: {
      y: {
        beginAtZero: true,
        grid: { color: 'rgba(128, 128, 128, 0.1)' }
      },
      x: {
        grid: { display: false }
      }
    }
  };

  return (
    <div className="p-6 max-w-4xl mx-auto space-y-8">
      <h1 className="text-3xl font-bold mb-8">Analytics</h1>

      <div className="bg-container-light dark:bg-container-dark rounded-3xl p-6 shadow-sm border border-gray-200 dark:border-gray-800">
        <h2 className="text-xl font-bold mb-6">Overview</h2>
        
        <div className="space-y-4">
          <div className="flex justify-between items-center py-2">
            <span className="text-gray-500">Net Worth</span>
            <span className="font-bold text-lg">{formatMoney(netWorth, userData?.currency)}</span>
          </div>
          <div className="h-px bg-gray-200 dark:bg-gray-800" />
          
          <div className="flex justify-between items-center py-2">
            <span className="text-gray-500">Total balance (Before receivables)</span>
            <span className="font-bold text-lg">{formatMoney(balancesSum, userData?.currency)}</span>
          </div>
          <div className="h-px bg-gray-200 dark:bg-gray-800" />
          
          <div className="flex justify-between items-center py-2">
            <span className="text-gray-500">Total receivables</span>
            <span className="font-bold text-lg text-green-500">+{formatMoney(receivablesSum, userData?.currency)}</span>
          </div>
          <div className="h-px bg-gray-200 dark:bg-gray-800" />
          
          <div className="flex justify-between items-center py-2">
            <span className="text-gray-500 font-medium">Total balance (After receivables)</span>
            <span className="font-bold text-xl text-primary">{formatMoney(balanceAfterReceivables, userData?.currency)}</span>
          </div>
        </div>
      </div>

      <div className="bg-container-light dark:bg-container-dark rounded-3xl p-6 shadow-sm border border-gray-200 dark:border-gray-800">
        <h2 className="text-xl font-bold mb-6">Expense Chart (Last 7 Days)</h2>
        <div className="h-[300px] w-full relative">
          <Line options={chartOptions} data={chartData} />
        </div>
      </div>
    </div>
  );
}
