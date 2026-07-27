export interface Balance {
  name: string;
  value: number;
}

export interface Income {
  name: string;
  value: number;
}

export interface Asset {
  name: string;
  value: number;
}

export interface Bill {
  name: string;
  value: number;
}

export interface Receivable {
  name: string;
  value: number;
}

export interface Liability {
  name: string;
  value: number;
}

export interface Budget {
  spent: number;
  value: number;
}

export interface UserData {
  id: string;
  email: string;
  name: string;
  photoUrl?: string;
  currency: string;
  balances: Balance[];
  income: Income[];
  assets: Asset[];
  bills: Bill[];
  receivables: Receivable[];
  liabilities: Liability[];
  budget: Budget | null;
}

export interface Transaction {
  id: string;
  name: string;
  amount: number;
  type: 'income' | 'expense';
  date: Date;
  category?: string;
  source?: string;
}
