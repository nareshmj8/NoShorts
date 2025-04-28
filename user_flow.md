User Flow (Step-by-Step)
🔹 First-Time User / New Session
Opens App → Onboarding Screen 1
→ App intro and message
→ Taps “Next”

Onboarding Screen 2
→ Shows app benefits (e.g. reduce screen time, structured learning)
→ Taps “Next”

Onboarding Screen 3
→ Google Sign-In
→ On successful login → redirected to Home Screen

Home Screen (Categories)
→ User sees 30 categories
→ Taps on any category

Topics List (40 topics)
→ User taps on a topic

Topic Detail Screen
→ Sees static 5-line description
→ Taps “Generate Plan”

Plan is generated using GPT API
→ Inputs: Category + Topic + Static Description
→ Output: 6–10 step plan with YouTube links
→ Plan saved to Supabase (real-time)

Redirected to My Plans Screen
→ Displays all user's saved plans
→ Can delete any plan
→ Free: max 3 plans/month
→ Premium: unlimited
→ Real-time sync

Settings Screen
→ Taps “Sign Out”
→ Redirected to Onboarding Screen 1

🔐 User Types Recap

User Type	Plan Limit	Sync Type
Free User	3 plans/month	Real-time sync
Premium User	Unlimited	Real-time sync