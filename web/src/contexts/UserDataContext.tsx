import { createContext, useContext, useEffect, useState } from 'react';
import type { ReactNode } from 'react';
import { doc, onSnapshot, updateDoc, arrayUnion, arrayRemove } from 'firebase/firestore';
import { db } from '../firebase';
import { useAuth } from './AuthContext';
import type { UserData, Balance, Income, Asset, Bill, Receivable, Liability, Budget } from '../types';

interface UserDataContextType {
  userData: UserData | null;
  loading: boolean;
  addBalance: (balance: Balance) => Promise<void>;
  removeBalance: (balance: Balance) => Promise<void>;
  updateBalances: (balances: Balance[]) => Promise<void>;
  addIncome: (income: Income) => Promise<void>;
  removeIncome: (income: Income) => Promise<void>;
  updateIncome: (income: Income[]) => Promise<void>;
  addAsset: (asset: Asset) => Promise<void>;
  removeAsset: (asset: Asset) => Promise<void>;
  updateAssets: (assets: Asset[]) => Promise<void>;
  addBill: (bill: Bill) => Promise<void>;
  removeBill: (bill: Bill) => Promise<void>;
  updateBills: (bills: Bill[]) => Promise<void>;
  addReceivable: (receivable: Receivable) => Promise<void>;
  removeReceivable: (receivable: Receivable) => Promise<void>;
  updateReceivables: (receivables: Receivable[]) => Promise<void>;
  addLiability: (liability: Liability) => Promise<void>;
  removeLiability: (liability: Liability) => Promise<void>;
  updateLiabilities: (liabilities: Liability[]) => Promise<void>;
  updateBudget: (budget: Budget | null) => Promise<void>;
  updateName: (name: string) => Promise<void>;
  updateCurrency: (currency: string) => Promise<void>;
}

const UserDataContext = createContext<UserDataContextType | undefined>(undefined);

export function UserDataProvider({ children }: { children: ReactNode }) {
  const { currentUser } = useAuth();
  const [userData, setUserData] = useState<UserData | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!currentUser) {
      setUserData(null);
      setLoading(false);
      return;
    }

    const userRef = doc(db, 'users', currentUser.uid);
    const unsubscribe = onSnapshot(userRef, (docSnap) => {
      if (docSnap.exists()) {
        const data = docSnap.data();
        setUserData({
          id: docSnap.id,
          email: data.email || currentUser.email || '',
          name: data.name || '',
          photoUrl: data.photoUrl || '',
          currency: data.currency || 'USD',
          balances: data.balances || [],
          income: data.income || [],
          assets: data.assets || [],
          bills: data.bills || [],
          receivables: data.receivables || [],
          liabilities: data.liabilities || [],
          budget: data.budget || null
        });
      }
      setLoading(false);
    }, (error) => {
      console.error('Error fetching user data:', error);
      setLoading(false);
    });

    return () => unsubscribe();
  }, [currentUser]);

  const updateUserDoc = async (dataToUpdate: Partial<UserData>) => {
    if (!currentUser) return;
    const userRef = doc(db, 'users', currentUser.uid);
    await updateDoc(userRef, dataToUpdate as any);
  };

  const addArrayItem = async (field: string, item: any) => {
    if (!currentUser) return;
    const userRef = doc(db, 'users', currentUser.uid);
    await updateDoc(userRef, {
      [field]: arrayUnion(item)
    });
  };

  const removeArrayItem = async (field: string, item: any) => {
    if (!currentUser) return;
    const userRef = doc(db, 'users', currentUser.uid);
    await updateDoc(userRef, {
      [field]: arrayRemove(item)
    });
  };

  const value = {
    userData,
    loading,
    addBalance: (item: Balance) => addArrayItem('balances', item),
    removeBalance: (item: Balance) => removeArrayItem('balances', item),
    updateBalances: (items: Balance[]) => updateUserDoc({ balances: items }),
    addIncome: (item: Income) => addArrayItem('income', item),
    removeIncome: (item: Income) => removeArrayItem('income', item),
    updateIncome: (items: Income[]) => updateUserDoc({ income: items }),
    addAsset: (item: Asset) => addArrayItem('assets', item),
    removeAsset: (item: Asset) => removeArrayItem('assets', item),
    updateAssets: (items: Asset[]) => updateUserDoc({ assets: items }),
    addBill: (item: Bill) => addArrayItem('bills', item),
    removeBill: (item: Bill) => removeArrayItem('bills', item),
    updateBills: (items: Bill[]) => updateUserDoc({ bills: items }),
    addReceivable: (item: Receivable) => addArrayItem('receivables', item),
    removeReceivable: (item: Receivable) => removeArrayItem('receivables', item),
    updateReceivables: (items: Receivable[]) => updateUserDoc({ receivables: items }),
    addLiability: (item: Liability) => addArrayItem('liabilities', item),
    removeLiability: (item: Liability) => removeArrayItem('liabilities', item),
    updateLiabilities: (items: Liability[]) => updateUserDoc({ liabilities: items }),
    updateBudget: (budget: Budget | null) => updateUserDoc({ budget }),
    updateName: (name: string) => updateUserDoc({ name }),
    updateCurrency: (currency: string) => updateUserDoc({ currency }),
  };

  return (
    <UserDataContext.Provider value={value}>
      {children}
    </UserDataContext.Provider>
  );
}

export function useUserData() {
  const context = useContext(UserDataContext);
  if (context === undefined) {
    throw new Error('useUserData must be used within a UserDataProvider');
  }
  return context;
}
