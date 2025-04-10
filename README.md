# Autism Support Web App

This project is a Vue 3 + Vite-based web application designed to support families with autistic children.  
It provides keyword-based article search, personalized recommendations based on questionnaire responses, and a responsive UI with animations and carousels.

## Features

- Search articles by keyword
-  View popular articles based on view count
- Receive personalized recommendations based on selected options
- Carousel display for articles (Swiper.js)
- Smooth scroll animations (AOS)
- RESTful API integration with Express and PostgreSQL backend

## Technologies Used

- Vue 3
- Vite
- Swiper.js
- AOS (Animate On Scroll)
- Axios
- Node.js + Express (for API server)
- PostgreSQL (as database)

## Recommended IDE Setup

- [Visual Studio Code](https://code.visualstudio.com/)
- [Volar](https://marketplace.visualstudio.com/items?itemName=Vue.volar) extension (recommended for Vue 3)

## Project Setup
npm install

## Compile and Hot-Reload for Development

npm run dev

## Compile and Minify for Production
npm run build

## API Overview

GET /api/articles — fetch all articles

GET /api/articles/popular — fetch top articles by view count

GET /api/articles/search?keyword=xxx — search articles

POST /api/articles/:id/view — increment view count

GET /api/recommendations/:optionId — fetch recommendations by selected option
