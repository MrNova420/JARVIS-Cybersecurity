#!/bin/bash
set -e

echo "[1/10] Creating project structure..."
mkdir -p client/src/{components,pages,hooks,lib} \
         server/src/routes \
         tools/{nmap,sqlmap,nikto,hashcracker,packet_analysis} \
         shared \
         scripts

echo "[2/10] Creating environment files..."
cat > .env.example <<EOL
# Example environment variables
PORT=5000
MONGO_URI=mongodb://localhost:27017/jarvis
JWT_SECRET=supersecretkey
EOL

echo "[3/10] Creating tracking.json..."
cat > tracking.json <<EOL
{
  "modules": [],
  "last_updated": "$(date)"
}
EOL

echo "[4/10] Creating backend package.json..."
cat > server/package.json <<EOL
{
  "name": "jarvis-backend",
  "version": "1.0.0",
  "main": "dist/index.js",
  "scripts": {
    "dev": "ts-node-dev --respawn src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js"
  },
  "dependencies": {
    "cors": "^2.8.5",
    "dotenv": "^16.4.5",
    "express": "^4.18.2",
    "mongoose": "^8.4.1"
  },
  "devDependencies": {
    "@types/cors": "^2.8.17",
    "@types/express": "^4.17.21",
    "ts-node-dev": "^2.0.0",
    "typescript": "^5.4.3"
  }
}
EOL

echo "[5/10] Creating backend tsconfig.json..."
cat > server/tsconfig.json <<EOL
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "CommonJS",
    "outDir": "dist",
    "rootDir": "src",
    "strict": true,
    "esModuleInterop": true
  }
}
EOL

echo "[6/10] Creating backend index.ts..."
cat > server/src/index.ts <<EOL
import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';

dotenv.config();

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'JARVIS Backend Running ✅' });
});

app.listen(port, () => {
  console.log(\`Backend server running at http://localhost:\${port}\`);
});
EOL

echo "[7/10] Creating frontend package.json..."
cat > client/package.json <<EOL
{
  "name": "jarvis-frontend",
  "version": "1.0.0",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.2.1",
    "vite": "^5.2.0"
  }
}
EOL

echo "[8/10] Creating frontend entry files..."
cat > client/index.html <<EOL
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>JARVIS Cybersecurity</title>
</head>
<body>
  <div id="root"></div>
  <script type="module" src="/src/main.jsx"></script>
</body>
</html>
EOL

cat > client/src/main.jsx <<EOL
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './pages/App';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOL

cat > client/src/pages/App.jsx <<EOL
import React from 'react';

export default function App() {
  return (
    <div style={{ fontFamily: 'Arial', padding: '2rem' }}>
      <h1>🚀 JARVIS Cybersecurity Dashboard</h1>
      <p>Frontend Running ✅</p>
    </div>
  );
}
EOL

echo "[9/10] Installing dependencies..."
cd server && npm install
cd ../client && npm install
cd ..

echo "[10/10] Setup Complete ✅"
echo "To start backend: cd server && npm run dev"
echo "To start frontend: cd client && npm run dev"
