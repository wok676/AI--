import { defineConfig, loadEnv } from 'vite';
import react from '@vitejs/plugin-react';

// Vite 配置(宪法 §3.2 默认管理后台栈)。开发期把 /api 代理到后端,避免 CORS 摩擦。
export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '');
  return {
    plugins: [react()],
    server: {
      port: 5173,
      proxy: {
        '/api': {
          target: env.VITE_DEV_API_TARGET || 'http://localhost:3000',
          changeOrigin: true,
        },
      },
    },
  };
});
