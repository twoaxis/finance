import { useMemo } from "react";
import { useAuth } from "../contexts/AuthContext";
import { db } from "../lib/firebase";
import { doc } from "firebase/firestore";
import { useDocument } from "../hooks/useDocument";
import { Card, CardContent } from "../components/ui/Card";
import { Button } from "../components/ui/Button";
import { Link } from "react-router-dom";
import { FileText, Briefcase } from "lucide-react";
import { PieChart, Pie, Cell, ResponsiveContainer } from "recharts";

const formatCurrency = (amount: number, currency = "USD") => {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: currency,
  }).format(amount);
};

export const MoneyFlow = () => {
  const { user } = useAuth();
  const userDocRef = useMemo(() => (user ? doc(db, "users", user.uid) : null), [user]);
  const { data: userData } = useDocument(userDocRef);

  const budget = userData?.budget || { value: 0, spent: 0 };
  const limit = Number(budget?.value) || 0;
  const spent = Number(budget?.spent) || 0;

  const percentage = limit > 0 ? spent / limit : 0;
  const remaining = Math.max(limit - spent, 0);
  const currency = userData?.currency || "USD";

  // If spent is 0 and limit is 0, show empty
  // If spent > limit, show full red.

  const normalizedData = [
      { name: "Used", value: Math.min(spent, limit) },
      { name: "Free", value: Math.max(limit - spent, 0) }
  ];

  const COLORS = [percentage < 0.75 ? "#4ade80" : percentage < 1 ? "#fb923c" : "#ef4444", "#333"];

  return (
    <div className="space-y-8">
      <h1 className="text-3xl font-bold text-white">Money Flow</h1>

      {/* Quick Links Row */}
      <div className="flex space-x-4 overflow-x-auto pb-2">
        <Link to="/bills">
          <Card className="h-32 w-32 min-w-[8rem] cursor-pointer hover:bg-surface-bright transition-colors border-none bg-surface-container flex items-center justify-center">
            <div className="flex flex-col items-center space-y-2">
              <FileText className="h-8 w-8 text-primary" />
              <span className="font-bold text-white">Bills</span>
            </div>
          </Card>
        </Link>
        <Link to="/liabilities">
          <Card className="h-32 w-32 min-w-[8rem] cursor-pointer hover:bg-surface-bright transition-colors border-none bg-surface-container flex items-center justify-center">
             <div className="flex flex-col items-center space-y-2">
              <Briefcase className="h-8 w-8 text-primary" />
              <span className="font-bold text-white">Liabilities</span>
            </div>
          </Card>
        </Link>
      </div>

      {/* Budget Section */}
      <div className="space-y-6">
        <div className="flex items-center justify-between">
            <h2 className="text-2xl font-bold text-white">Budget</h2>
            <Link to="/budget">
                <Button variant="ghost" className="text-primary hover:text-white">Edit</Button>
            </Link>
        </div>

        {limit === 0 ? (
          <Card className="bg-surface-container border-none">
            <CardContent className="flex flex-col items-center justify-center py-10 opacity-50">
              <p className="text-on-surface-variant">No budget set</p>
            </CardContent>
          </Card>
        ) : (
          <div className="flex flex-col items-center">
            <div className="h-64 w-64 relative">
               <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie
                    data={normalizedData}
                    cx="50%"
                    cy="50%"
                    innerRadius={80}
                    outerRadius={100}
                    startAngle={90}
                    endAngle={-270}
                    dataKey="value"
                    stroke="none"
                  >
                    {normalizedData.map((_, index) => (
                      <Cell key={`cell-${index}`} fill={COLORS[index]} />
                    ))}
                  </Pie>
                </PieChart>
              </ResponsiveContainer>
              {/* Center Label Overlay */}
              <div className="absolute inset-0 flex flex-col items-center justify-center pointer-events-none">
                  <span className="text-3xl font-bold text-white">
                      {(percentage * 100).toFixed(0)}%
                  </span>
                  <span className="text-sm text-on-surface-variant">used</span>
              </div>
            </div>

            <div className="mt-8 grid grid-cols-3 gap-8 w-full max-w-md text-center">
              <div>
                <p className="text-sm text-on-surface-variant">Limit</p>
                <p className="text-lg font-bold text-white">{formatCurrency(limit, currency)}</p>
              </div>
              <div>
                <p className="text-sm text-on-surface-variant">Spent</p>
                <p className="text-lg font-bold text-white">{formatCurrency(spent, currency)}</p>
              </div>
              <div>
                <p className="text-sm text-on-surface-variant">Remaining</p>
                <p className={`text-lg font-bold ${remaining < 0 ? 'text-red-500' : 'text-green-500'}`}>
                  {formatCurrency(remaining, currency)}
                </p>
              </div>
            </div>

            {percentage >= 1 && (
                <p className="mt-4 text-red-500 font-bold">You've exceeded your budget!</p>
            )}
          </div>
        )}
      </div>
    </div>
  );
};
