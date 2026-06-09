import { useEffect, useState } from "react";
import { supabase } from "../services/supabaseClient.ts";

const handleLogin = async () => {
  const email = import.meta.env.VITE_TEST_EMAIL
  const password = import.meta.env.VITE_TEST_PASSWORD
  
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  })

  if (error) {
    console.error("Login failed:", error.message);
  } else {
    console.log("Logged in! Session created:", data.session);
    globalThis.location.reload()
  }
};

export const Solvents = () => {
    
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  
  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      const { data: { session } } = await supabase.auth.getSession();
      console.log("My Token:", session?.access_token);
  try{
    const response = await fetch('http://127.0.0.1:54321/functions/v1/api/solvent', {//('https://ocqlpxpuczlecxcpqbna.supabase.co/functions/v1/api/solvent', {
    method: 'GET',
    headers: {
      // Pass the token here!
      'Authorization': `Bearer ${session?.access_token}`, 
      'Content-Type': 'application/json',
    }
  });

  const result = await response.json()
  setData(result);
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
      <button type="button" onClick={() => handleLogin()}>
        Log In (Dev Mode)
      </button>
      <h1>Solvents</h1>
      <pre>{JSON.stringify(data, null, 2)}</pre>
    </div>
  );
};
