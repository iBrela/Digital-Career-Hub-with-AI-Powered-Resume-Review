# Digital Career Hub (P83 Project)

This repository contains the initial setup for the **Digital Career Hub with AI-Powered Resume Review** project.

Tech stack:

- Frontend: Next.js
- Backend: Node.js + Express
- Package manager: npm

---

# Project Structure

```
Digital-Career-Hub-with-AI-Powered-Resume-Review
├── backend
│   ├── config
│   │   └── db.js # database connection
│   ├── src
│   │   └── server.js            # backend server entry
│   ├── package.json
│   ├── nodemon.json
│   └── .env
│
├── frontend
│   ├── src
│   │   └── app
│   │       └── page.tsx
│   ├── package.json
│   └── .env.local
│
├── package.json
├── .gitignore
├── .nvmrc
└── README.md
```

---

# Folder Explanation

### backend

Contains the **Express backend server**.

Main files:

```
backend/src/server.js
backend/config/db.js
```

- `server.js` starts the backend API server  
- `db.js` handles the **database connection**

Example usage in `server.js`:

```js
const connectDB = require("../config/db");
connectDB();
```

---

### frontend

Contains the **Next.js frontend application**.

Main page:

```
frontend/src/app/page.tsx
```

The frontend communicates with the backend through API calls.

---

### Root package.json

The root `package.json` allows running frontend and backend together.

Run from the root folder:

```
npm run dev
```

This starts:

Frontend → http://localhost:3000  
Backend → http://localhost:5001  

---

# Requirements

Install the following before running the project:

- Node.js (recommended Node 24 LTS)
- npm
- Git

Check installation:

```
node -v
npm -v
git --version
```

---

# Setup Instructions

Clone the repository:

```
git clone <repo-url>
cd Digital-Career-Hub-with-AI-Powered-Resume-Review
```

Install root dependencies:

```
npm install
```

Install backend dependencies:

```
cd backend
npm install
```

Install frontend dependencies:

```
cd ../frontend
npm install
```

Return to project root:

```
cd ..
```

---

# Environment Variables

Create backend environment file:

```
backend/.env
```

Example:

```
PORT=5001
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=yourpassword
DB_NAME=digital_career_hub
```
Because the database hasn't been built, just copy the details above into the backend/.env

---

# Running the Project

From the project root run:

```
npm run dev
```

This starts both servers.

Frontend:

```
http://localhost:3000
```

Backend API:

```
http://localhost:5001
```

---

# Backend Test API

Test the backend connection:

```
http://localhost:5001/api/health
```

Expected response:

```
{
  "status": "ok",
  "message": "Backend working"
}
```

---

# Correct Startup Result

If the project runs correctly:

1. Terminal shows both servers running.
2. Open:

```
http://localhost:3000
```

3. The page should display:

```
Backend working
```

This confirms the frontend successfully connected to the backend.

---

# Port Usage

The project uses:

```
Frontend : 3000
Backend  : 5001
```

Check if ports are free before run the app.

Mac / Linux:

```
lsof -i :3000
lsof -i :5001
```

Windows:

```
netstat -ano | findstr :3000
netstat -ano | findstr :5001
```

---

# Important Notes

Do **not commit** the following files:

```
node_modules
.env
.env.local
```

These are excluded using `.gitignore`.

---

# Development Workflow

Start development:

```
npm run dev
```

Frontend updates automatically when files change.

Backend automatically restarts using **nodemon** when backend files change.

---

# Current Test Endpoint

```
GET /api/health
```

Example:

```
http://localhost:5001/api/health
```

Response:

```
{
  "status": "ok",
  "message": "Backend working"
}
```

---

# Project Status

The complete Frontend UI has been perfectly architected using Next.js 16 (App Router), Tailwind CSS v4, Lucide React, and Framer Motion!

Features integrated into the UI:
- Full English/Bangla/Spanish/Hindi localization
- Light/Dark theme switching
- Mock Resume Review interface with animations
- Mock AI Chatbot interactions
- Admin Dashboard UI
- User Career Dashboard

Next steps:
- Connect the frontend Context/API components to your live backend Express endpoints.
- Finalize the PostgreSQL logic.

