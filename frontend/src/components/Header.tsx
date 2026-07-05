import { handleLogin } from "../services/handleLogin.ts"

export const Header = () => {
  
  return (
  <div>
    <h2>Header</h2>
        <button type="button" onClick={() => handleLogin()}>
        Log In (Dev Mode)
      </button>
      </div>
  )
}