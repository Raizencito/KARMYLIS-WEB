import { defineConfig } from 'vite'
import { resolve } from 'path'

// Sitio multipágina (routing clásico): cada HTML es una entrada.
// El catálogo carga datos vía fetch + paginación (nada de servir todo de una).

// https://vite.dev/config/
export default defineConfig({
  build: {
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'index.html'),
        catalogo: resolve(__dirname, 'catalogo.html'),
        lookbook: resolve(__dirname, 'lookbook.html'),
        nosotros: resolve(__dirname, 'nosotros.html'),
        reservas: resolve(__dirname, 'reservas.html'),
        contacto: resolve(__dirname, 'contacto.html')
      }
    }
  }
})
