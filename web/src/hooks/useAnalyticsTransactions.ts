import { useState, useEffect } from 'react';
import { collection, query, orderBy, onSnapshot, where } from 'firebase/firestore';
import { db } from '../firebase';
import { useAuth } from '../contexts/AuthContext';
import type { Transaction } from '../types';

export function useAnalyticsTransactions() {
  const { currentUser } = useAuth();
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!currentUser) {
      setTransactions([]);
      setLoading(false);
      return;
    }

    const txRef = collection(db, 'users', currentUser.uid, 'transactions');
    
    // We need 7 days of data. Let's get the start of 7 days ago.
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setHours(0, 0, 0, 0);
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 6); // 6 days ago + today = 7 days

    const q = query(
      txRef, 
      where('date', '>=', sevenDaysAgo),
      orderBy('date', 'desc')
    );

    const unsubscribe = onSnapshot(q, (snapshot) => {
      const txs: Transaction[] = [];
      snapshot.forEach((doc) => {
        const data = doc.data();
        const rawAmount = data.amount ?? data.value ?? 0;
        const amount = typeof rawAmount === 'number' ? rawAmount : (parseFloat(rawAmount) || 0);

        let date = new Date();
        if (data.date && typeof data.date.toDate === 'function') {
          date = data.date.toDate();
        } else if (data.date instanceof Date) {
          date = data.date;
        } else if (data.date) {
          date = new Date(data.date);
        }

        txs.push({
          id: doc.id,
          name: data.name || '',
          amount: amount,
          type: data.type || 'expense',
          date: date,
          category: data.category,
          source: data.source
        });
      });
      setTransactions(txs);
      setLoading(false);
    }, (err) => {
      console.error("Error fetching analytics transactions:", err);
      setError(err.message);
      setLoading(false);
    });

    return () => unsubscribe();
  }, [currentUser]);

  return { transactions, loading, error };
}
