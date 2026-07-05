import { createContext, useContext } from "react";
export const AuthContext = createContext({session: null})
export const useAuth = () => useContext(AuthContext)