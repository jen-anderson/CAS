import { Outlet } from 'react-router-dom'
import { Header } from '../components/Header.tsx'
import { Footer } from '../components/Footer.tsx'


export const AppLayout = () => {
  return (
    <div className="app-container">
      <Header />
      <main>
        <Outlet />
      </main>
      <Footer />
    </div>
  )
}