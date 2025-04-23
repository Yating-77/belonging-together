import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// 从环境变量中获取基础路径，默认为'/iteration1/'
const baseUrl = process.env.BASE_URL || '/iteration1/';
console.log(`Building with base URL: ${baseUrl}`);

export default defineConfig({
  base: baseUrl,
  plugins: [
    vue(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    },
  },
})
