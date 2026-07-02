# LiftLab — Muscle Growth & Nutrition Planner

A self-contained fitness app that plans your training for optimal muscle growth, tells you
how many calories to eat, what to eat and in what portions, tracks your weight and
measurements, and **automatically adjusts your calories** based on how your weight actually
responds.

**No install, no account, no server.** Open `index.html` in any modern browser — everything
is stored locally in your browser (with JSON export/import for backups). It's also an
**installable PWA**: host it (e.g. GitHub Pages) and "Add to Home Screen" to run it like a
native app that works offline.

## Put it on your phone

The app is a single folder: `index.html` plus `manifest.webmanifest`, `sw.js`, and three
icon PNGs. Two ways to use it on a phone:

1. **Install it as an app (recommended).** Turn on GitHub Pages for this repo
   (Settings → Pages → Build from branch → pick the branch, root folder). You'll get a URL
   like `https://<user>.github.io/lol-he-/`. Open it on your phone, then:
   - **iPhone/iPad (Safari):** Share → *Add to Home Screen*.
   - **Android (Chrome):** menu → *Install app* / *Add to Home Screen* (or tap the in-app
     **📲 Install app** button on the Profile tab).
   Once installed it launches full-screen from your home screen and works offline.
2. **Just open the file.** Download `index.html` (GitHub → the file → *Raw* → save) and open
   it in your phone browser. This works but you miss offline install and the app icon.

Your data lives in the browser on each device — use **Profile → Export/Import** to move a
backup between your computer and phone.

## Features

### 🏋️ Workout planner & logger
- Evidence-based hypertrophy programs for **2–6 training days per week**
  (Full Body, Upper/Lower, U/L + PPL hybrid, Push/Pull/Legs ×2)
- Sets, rep ranges, RIR (reps in reserve) and rest times per exercise
- Scales volume to your experience level (beginner / intermediate / advanced)
- Equipment-aware: full gym, dumbbells-only, or home/minimal variants for every exercise
- Weekly sets-per-muscle audit against the 10–20 set hypertrophy guideline
- Built-in progression rules (double progression + deload guidance)
- **Session logging**: record weight × reps per set, see your last session's top set to beat
  (progressive overload), and track estimated 1RM (Epley) and volume over time
- **Rest timer** with presets (60/90/120/180 s), vibration + beep on finish

### 🍽️ Nutrition
- Calorie target from **Mifflin-St Jeor BMR × activity**, adjusted for your goal
- Choose **lose fat (cut)** or **gain muscle (lean bulk)** at a chosen pace (% body weight/week), or maintain
- Macro targets: protein by body weight (lean-mass-based when body-fat % is high), fat floor, carbs fill the rest
- **Meal plan generator**: builds each meal from a 50+ whole-food database and solves the
  portion size *per food* to hit your targets (supports omnivore / vegetarian / vegan, 3–5 meals/day)
- **Portion calculator**: pick any food and size a portion by grams, protein, or calories
- **Daily food diary**: log what you actually eat and watch it stack up against your calorie
  and macro targets, with a live "remaining today" readout
- Safety floors on calories with clear warnings

### 📈 Tracking & adaptive calories
- Daily weigh-in log with an SVG chart: daily points + **7-day trend line** + goal-weight line,
  crosshair tooltip, 30/90-day/All ranges, and a table view
- Body measurements (waist, chest, hips, arm, thigh)
- **Adaptive coach**: once you have ≥8 weigh-ins across 12+ days, a check-in compares your
  *measured* weekly rate of change (regression over recent weigh-ins) with your *target* rate
  and adjusts calories (capped at ±250 kcal per adjustment), keeping a full history
- **Water tracking** on the dashboard (metric ml / imperial oz) against a daily goal

## The math

| Quantity | Method |
|---|---|
| BMR | Mifflin-St Jeor |
| TDEE | BMR × activity multiplier (1.2–1.9) |
| Goal delta | pace (% BW/week) × 7,700 kcal per kg ÷ 7 |
| Protein | 1.8–2.2 g/kg (lean mass when BF% is high) |
| Fat | max(25% of calories, 0.5 g/kg) |
| Carbs | remaining calories |
| Trend weight | 7-day moving average |
| Measured rate | least-squares slope of recent weigh-ins (kg/week) |

## Disclaimer

Estimates only — not medical advice. Consult a professional before major diet or training
changes, especially with any health condition.
