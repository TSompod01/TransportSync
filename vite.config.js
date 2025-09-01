import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  build: { outDir: 'dist' },
  server: { port: 5173, strictPort: true },
  define: { 'process.env.VITE_DEV_SERVER_URL': JSON.stringify('http://localhost:5173') }
})
