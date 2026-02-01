import { useEffect, useState } from "react";
import { type CollectionReference, type Query, onSnapshot, type DocumentData, type QuerySnapshot } from "firebase/firestore";

interface UseCollectionResult<T> {
  data: T[];
  loading: boolean;
  error: Error | null;
}

export const useCollection = <T = DocumentData>(
  query: Query<T> | CollectionReference<T> | null
): UseCollectionResult<T> => {
  const [data, setData] = useState<T[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    if (!query) {
      setLoading(false);
      return;
    }

    const unsubscribe = onSnapshot(
      query,
      (snapshot: QuerySnapshot<T>) => {
        const docs = snapshot.docs.map((doc) => ({
          ...doc.data(),
          id: doc.id,
        }));
        setData(docs);
        setLoading(false);
      },
      (err) => {
        console.error(err);
        setError(err);
        setLoading(false);
      }
    );

    return () => unsubscribe();
  }, [query]); // Make sure query is memoized or stable

  return { data, loading, error };
};
