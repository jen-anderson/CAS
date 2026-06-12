import { useEffect, useState } from 'react'
import { supabase } from './services/supabaseClient.ts'
import { createBrowserRouter, Route, createRoutesFromElements, RouterProvider } from 'react-router-dom'
import './App.css' 
import { AppLayout } from './layouts/AppLayout.tsx'
import { HomePage } from './pages/HomePage.tsx'
import { Chemical } from './pages/Chemical.tsx'
import { Solvents } from './pages/Solvents.tsx'
import { Reference } from './pages/Reference.tsx'
import { AuthContext } from './contexts/AuthContext.tsx';
import { Formula } from './pages/Formula.tsx';

  const router = createBrowserRouter(
    createRoutesFromElements(
      <Route path="/" element={<AppLayout />}> 
        <Route index element={<HomePage/>} />
        <Route path="chemical/:id" element={<Chemical />} />
        <Route path="solvents" element={<Solvents />} />
        <Route path="reference" element={<Reference />} />
        <Route path="formula" element={<Formula />} />
      </Route>
    )
  )


export const App = () => {

const [ session, setSession ] = useState(null)
const [ loading, setLoading ] = useState(true)

useEffect(() => {
  supabase.auth.getSession().then(({ data: { session } }) => {
    setSession(session);
    setLoading(false);
  });
  // Listen for changes
  const { data: { subscription } } = supabase.auth.onAuthStateChange((event, session) => {
    if (event === 'SIGNED_OUT') {
      setSession(null);
    } else if (session) {
      setSession(session);
      setLoading(false)
    }
  });
  return () => subscription.unsubscribe();
}, []);

if (loading) return <div>Initialising Auth...</div>;

return (
  <AuthContext.Provider value = {{ session }}>
    <RouterProvider router={router} />;
  </AuthContext.Provider>
  )
}