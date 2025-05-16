# Autism Support Web App

This project is a Vue 3 + Vite-based web application designed to support families with autistic children.  
It provides keyword-based article search, personalized recommendations based on questionnaire responses, and a responsive UI with animations and carousels.

## Features

- Receive personalized recommendations based on your child's behavior traits  
  Parents can input specific traits such as age, communication ability, social skills, emotional regulation, and repetitive behaviors. The system provides customized suggestions tailored to their child’s needs.

- Learn effective communication strategies for daily life  
  Access articles and videos that help parents communicate more clearly with their autistic children, understand their expressions, and build stronger emotional connections.

- Search autism-related articles by keyword  
  Easily find information that’s relevant to your concerns using a smart keyword-based search function.

- View the most popular articles  
  Explore resources that have helped other parents, based on real view counts.

- Interactive article carousel for engaging browsing  
  Swipe through categorized articles in a visually friendly and responsive interface.


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
