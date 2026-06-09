import { AppLayout } from './layouts/AppLayout.tsx'
import { createBrowserRouter, Route, createRoutesFromElements, RouterProvider } from 'react-router-dom'
import { HomePage } from './pages/HomePage.tsx'
import { Chemical } from './pages/Chemical.tsx'
import { Solvents } from './pages/Solvents.tsx'
import './App.css' 


export const App = () => <RouterProvider router={router} />

  const router = createBrowserRouter(
    createRoutesFromElements(
      <Route path="/" element={<AppLayout />}> 
        <Route index element={<HomePage/>} />
        <Route path="chemical" element={<Chemical />} />
        <Route path="solvents" element={<Solvents />} />
      </Route>
    )
  )