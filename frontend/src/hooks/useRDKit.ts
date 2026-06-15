import { useState, useEffect } from 'react';
import { getRDKit } from '../services/rdkitLoader.ts'

export const useRDKit = () => {
  const [rdkit, setRdkit] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getRDKit().then((instance) => {
      setRdkit(instance);
      setLoading(false);
    });
  }, []);

  return { rdkit, loading };
};