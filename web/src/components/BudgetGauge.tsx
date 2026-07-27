import { formatMoney } from '../utils/moneyFormat';

interface BudgetGaugeProps {
  spent: number;
  limit: number;
  currency: string;
}

export function BudgetGauge({ spent, limit, currency }: BudgetGaugeProps) {
  const percent = limit > 0 ? Math.min(spent / limit, 1) : 0;
  const rawPercent = limit > 0 ? spent / limit : 0;
  
  let color = '#4ade80'; // green-400
  if (rawPercent >= 1) {
    color = '#aa0000'; // dark red from mobile
  } else if (rawPercent >= 0.75) {
    color = '#f97316'; // orange-500
  }

  // Circular progress SVG logic
  const radius = 60;
  const circumference = 2 * Math.PI * radius;
  const strokeDashoffset = circumference - percent * circumference;

  return (
    <div className="flex flex-col items-center">
      <div className="relative w-40 h-40 flex items-center justify-center mb-6">
        {/* Background circle */}
        <svg className="w-full h-full transform -rotate-90">
          <circle
            cx="80"
            cy="80"
            r={radius}
            stroke="currentColor"
            strokeWidth="20"
            fill="transparent"
            className="text-container-light dark:text-bright-dark"
          />
          {/* Progress circle */}
          <circle
            cx="80"
            cy="80"
            r={radius}
            stroke={color}
            strokeWidth="20"
            fill="transparent"
            strokeDasharray={circumference}
            strokeDashoffset={strokeDashoffset}
            strokeLinecap="round"
            className="transition-all duration-1000 ease-out"
          />
        </svg>
        <div className="absolute flex flex-col items-center justify-center">
          <span className="text-2xl font-bold">{(rawPercent * 100).toFixed(0)}%</span>
          <span className="text-sm text-gray-500">used</span>
        </div>
      </div>

      <div className="flex justify-center gap-8 md:gap-16 w-full mt-4">
        <div className="flex flex-col items-center text-center">
          <span className="text-sm text-gray-500 mb-1">Limit</span>
          <span className="font-bold text-lg">{formatMoney(limit, currency)}</span>
        </div>
        <div className="flex flex-col items-center text-center">
          <span className="text-sm text-gray-500 mb-1">Spent</span>
          <span className="font-bold text-lg">{formatMoney(spent, currency)}</span>
        </div>
        <div className="flex flex-col items-center text-center">
          <span className="text-sm text-gray-500 mb-1">Remaining</span>
          <span className="font-bold text-lg">{formatMoney(Math.max(limit - spent, 0), currency)}</span>
        </div>
      </div>
    </div>
  );
}
