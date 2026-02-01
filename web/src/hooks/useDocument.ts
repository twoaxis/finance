import { useEffect, useState } from "react";
import { type DocumentReference, onSnapshot, type DocumentData, type DocumentSnapshot } from "firebase/firestore";

interface UseDocumentResult<T> {
  data: T | null;
  loading: boolean;
  error: Error | null;
}

export const useDocument = <T = DocumentData>(
  docRef: DocumentReference<T> | null
): UseDocumentResult<T> => {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    if (!docRef) {
      setLoading(false);
      return;
    }

    const unsubscribe = onSnapshot(
      docRef,
      (snapshot: DocumentSnapshot<T>) => {
        if (snapshot.exists()) {
          setData({ ...snapshot.data(), id: snapshot.id } as T);
        } else {
          setData(null);
        }
        setLoading(false);
      },
      (err) => {
        console.error(err);
        setError(err);
        setLoading(false);
      }
    );

    return () => unsubscribe();
  }, [docRef]); // Make sure docRef is memoized or stable

  return { data, loading, error };
};
