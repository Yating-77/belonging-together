import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
// import vueDevTools from 'vite-plugin-vue-devtools' // ← 这一行可以注释或删除

export default defineConfig({
  plugins: [
    vue(),
    // vueDevTools(), // ← 这一行也要注释或删除
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    },
  },
})