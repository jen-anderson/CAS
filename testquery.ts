import { createClient } from "npm:@supabase/supabase-js@2";
const supabase = createClient('http://localhost:54321', 'sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH');
const response = await supabase.auth.signInWithPassword({
  email: 'canteenmedal@gmail.com',
  password: 'ENWzWJ4h9CDmuiQS',
});

if (response.error) {
  console.error("Login Error:", response.error.message);
} else if (response.data?.session) {
  console.log("Success! Access Token:");
  console.log(response.data.session.access_token);
} else {
  console.log("No session returned. Check your credentials.");
}
