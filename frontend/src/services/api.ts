import { supabase } from "./supabaseClient.ts";

export const apiClient = async (path: string, options: RequestInit = {}) => {
  const { data: { session } } = await supabase.auth.getSession();

  if (!session) {
    throw new Error('No active session. Please log in')
  }
  const headers = {
    'Authorization': `Bearer ${session?.access_token}`,
    'Content-Type': 'application/json',
    ...options.headers
  }

  const response = await fetch(`http://127.0.0.1:54321/functions/v1/api/${path}`, {//('https://ocqlpxpuczlecxcpqbna.supabase.co/functions/v1/api/solvent', {
    ...options,
    headers,
  });

  if (!response.ok) throw new Error('API request failed')
  return response.json()
}


export const postData = async (path: string, body: unknown) => {
  return await apiClient(path, {
    method: 'POST',
    body: JSON.stringify(body),
  });
};