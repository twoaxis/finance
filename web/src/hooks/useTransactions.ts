import { useState, useEffect } from 'react';
import { collection, query, orderBy, onSnapshot, addDoc, deleteDoc, doc } from 'firebase/firestore';
import { db } from '../firebase';
import { useAuth } from '../contexts/AuthContext';
import type { Transaction } from '../types';

export function useTransactions() {
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
    const q = query(txRef, orderBy('date', 'desc'));

    const unsubscribe = onSnapshot(q, (snapshot) => {
      const txs: Transaction[] = [];
      snapshot.forEach((doc) => {
        const data = doc.data();
        txs.push({
          id: doc.id,
          name: data.name,
          amount: data.amount,
          type: data.type,
          date: data.date.toDate(),
          category: data.category,
          source: data.source
        });
      });
      setTransactions(txs);
      setLoading(false);
    }, (err) => {
      console.error("Error fetching transactions:", err);
      setError(err.message);
      setLoading(false);
    });

    return () => unsubscribe();
  }, [currentUser]);

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

  return { transactions, loading, error, addTransaction, deleteTransaction };
}
