import { supabase } from "./supabaseClient.ts";

export const handleLogin = async () => {
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