import { useState, useEffect, useCallback } from 'react';
import { collection, query, orderBy, onSnapshot, addDoc, deleteDoc, doc, limit } from 'firebase/firestore';
import { db } from '../firebase';
import { useAuth } from '../contexts/AuthContext';
import type { Transaction } from '../types';

export function useTransactions() {
  const { currentUser } = useAuth();
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  
  const [currentLimit, setCurrentLimit] = useState(30);
  const [hasMore, setHasMore] = useState(true);

  useEffect(() => {
    if (!currentUser) {
      setTransactions([]);
      setLoading(false);
      return;
    }

    const txRef = collection(db, 'users', currentUser.uid, 'transactions');
    const q = query(txRef, orderBy('date', 'desc'), limit(currentLimit));

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
      setHasMore(txs.length >= currentLimit);
      setLoading(false);
    }, (err) => {
      console.error("Error fetching transactions:", err);
      setError(err.message);
      setLoading(false);
    });

    return () => unsubscribe();
  }, [currentUser, currentLimit]);

  const loadMore = useCallback(() => {
    setCurrentLimit(prev => prev + 30);
  }, []);

  const addTransaction = async (tx: Omit<Transaction, 'id'>) => {
    if (!currentUser) return null;
    try {
      const txRef = collection(db, 'users', currentUser.uid, 'transactions');
      const docRef = await addDoc(txRef, {
        ...tx,
        // Firestore conversion happens automatically for JS Date objects using addDoc
      });
      return docRef.id;
    } catch (err: any) {
      setError(err.message);
      throw err;
    }
  };

  const deleteTransaction = async (id: string) => {
    if (!currentUser) return;
    try {
      const docRef = doc(db, 'users', currentUser.uid, 'transactions', id);
      await deleteDoc(docRef);
    } catch (err: any) {
      setError(err.message);
      throw err;
    }
  };

  return { transactions, loading, error, addTransaction, deleteTransaction, loadMore, hasMore };
}
