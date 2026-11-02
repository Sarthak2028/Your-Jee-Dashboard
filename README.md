# Spine — Vercel + Supabase setup

## What's included
- `index.html`: Spine JEE dashboard with Supabase email/password auth.
- `api/config.js`: Vercel Function that reads the public Supabase project URL and anon/publishable key from server environment variables.
- `supabase-setup.sql`: creates the per-user JSONB data table and Row Level Security policies.

## 1. Create a Supabase project
1. Create a project at https://supabase.com/dashboard.
2. In Project Settings → API (or API Keys), copy the Project URL and the publishable/anon public key.
3. In Authentication → URL Configuration, add your deployed Vercel URL to Site URL and Redirect URLs. Add both `https://YOUR-PROJECT.vercel.app/**` and your custom domain if you use one.

## 2. Create the database table
1. Open Supabase → SQL Editor → New query.
2. Paste all of `supabase-setup.sql` and click Run.
3. Keep Row Level Security enabled. The policies ensure each signed-in user can read/write only their own row.

## 3. Add the two Vercel environment variables
In Vercel → your project → Settings → Environment Variables, add:
- `SUPABASE_URL` = your Supabase Project URL
- `SUPABASE_ANON_KEY` = your Supabase anon/public (or publishable) key

Select Production, Preview and Development as needed, save, then redeploy. The anon/public key is designed for browser use; RLS protects the table. NEVER use `service_role` or a secret key in this website.

## 4. Deploy the files
Upload the contents of this ZIP to the root of your GitHub repository connected to Vercel. The root must contain:
- `index.html`
- `api/config.js`
- `supabase-setup.sql` (for reference; it is not executed by Vercel)

Vercel detects `api/config.js` as a serverless function. No build command is required for the static HTML.

## 5. Test
1. Open the deployed URL and create an account.
2. Confirm your email if email confirmations are enabled in Supabase.
3. Sign in, add a task, then refresh.
4. Sign in on another browser/device to check cloud sync.
5. Test logout and Forgot password.

## Notes
- The first account to sign in can import the previous single-device `spine-jee` local save if it exists in that browser. That legacy save is then removed after a successful cloud write.
- Subsequent accounts start with their own data. Every account's cloud row is protected by RLS.
- Study data is synced to the database after changes (debounced by 700 ms). Keep an occasional exported backup.
- The app's separate Vault PIN is still a client-side convenience lock, not a substitute for server-side encryption. Do not store highly sensitive secrets in the Vault.
