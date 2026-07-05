import { useEffect, useState } from "react";
import { apiClient } from "../services/api.ts";

export const Reference = () => {
    
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  
  useEffect(() => {

  const fetchData = async () => {
    setLoading(true);
    try {
      const data = await apiClient('references');
      setData(data);
      } catch (error){
      console.error('Fetch failed:', error)
      } finally {
      setLoading(false);
      };
}

  fetchData()
  }, []) //Run once when page loads

  if (loading) return <div>Loading...</div>

  return (
    <div>
      <h1>References</h1>
      <pre>{JSON.stringify(data, null, 2)}</pre>
    </div>
  );
};
