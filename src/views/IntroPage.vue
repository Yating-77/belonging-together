<template>
    <MyNavBar />
    <div class="intro-page-container">
      <div class="intro-content">
        <h1 class="main-title">Understand. Support. Grow Together.</h1>
        <p class="main-subtitle">
            Every child is unique. Begin your journey with personalised guidance tailored to your child’s daily experiences.
        </p>
        
        <div class="flex-container">
          <div class="image-container">
            <img src="/scenario-start.png" alt="Begin Your Journey of Support" class="intro-image">
          </div>
          
          <div class="journey-section">
            <h2 class="journey-title">Begin Your Journey of Support</h2>
            <p class="journey-description">
                Ready to discover practical tips for sleep, communication, behaviour and more?
            </p>
            <p class="journey-description">
                Click below to explore six common areas where your child might need extra support, starting with gentle, relatable stories and evidence-based suggestions.
            </p>
            <router-link to="/recommendation" class="start-journey-button">
              Start Journey
            </router-link>
          </div>
        </div>
      </div>
    </div>
    <MyFooter />
  </template>
  
  <script>
  import MyNavBar from '../components/test/MyNavBar.vue'
  import MyFooter from '../components/test/MyFooter.vue'
  
  export default {
    name: 'IntroPage',
    components: {
      MyNavBar,
      MyFooter
    },
  }
  </script>
  
  <style scoped>
  .intro-page-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 100vh;
    padding: 1rem;
    text-align: center;
    background-color: #F8EFED;
  }
  
  .intro-content {
    max-width: 2000px; /* 增加容器宽度 */
    width: 80%;
    margin: 0 auto;
    padding: 3rem; /* 增加内边距 */
    background-color: rgba(255, 255, 255, 0.95);
    border-radius: 20px; /* 增加圆角 */
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15); /* 增强阴影效果 */
    animation: fadeIn 1s ease-in-out;
  }
  
  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
  }
  
  .main-title {
    color: #4d2f20;
    font-size: 2.5rem; /* 增大标题 */
    font-weight: bold;
    margin-bottom: 1rem;
  }
  
  .main-subtitle {
    color: #4d2f20;
    font-size: 1.2rem; /* 增大副标题 */
    margin-bottom: 2.5rem;
  }
  
  /* 横向布局容器 */
  .flex-container {
    display: flex;
    flex-direction: row;
    gap: 2rem;
    align-items: stretch;
    margin-top: 1rem;
  }
  
  .image-container {
    flex: 1;
    height: auto;
    overflow: hidden;
    border-radius: 15px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s ease;
    max-width: 45%;
  }
  
  .intro-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
    transition: transform 0.5s ease;
  }
  
  .image-container:hover .intro-image {
    transform: scale(1.03);
  }
  
  .journey-section {
    flex: 1;
    padding: 2rem;
    background-color: #f9f7f6;
    border-radius: 18px;
    border-left: 5px solid #3E5C2B;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
    display: flex;
    flex-direction: column;
    justify-content: center;
    text-align: left;
  }
  
  .journey-title {
    color: #3E5C2B;
    font-size: 2rem; /* 增大标题 */
    font-weight: 600;
    margin-bottom: 1.5rem;
  }
  
  .journey-description {
    color: #4d2f20;
    font-size: 1.1rem; /* 增大字体 */
    line-height: 1.7; /* 增加行高 */
    margin-bottom: 1.5rem;
  }
  
  .start-journey-button {
    display: inline-block;
    background-color: #3E5C2B;
    color: white;
    font-size: 1.4rem; /* 增大按钮字体 */
    border-radius: 12px; /* 增加圆角 */
    padding: 14px 40px; /* 增加内边距 */
    border: none;
    transition: all 0.3s ease;
    margin-top: 1.8rem;
    box-shadow: 0 4px 15px rgba(62, 92, 43, 0.3); /* 增强阴影 */
    text-decoration: none;
    letter-spacing: 0.5px; /* 添加字间距 */
    width: 230px;
  }
  
  .start-journey-button:hover {
    background-color: #4a6e34;
    transform: translateY(-4px); /* 增加悬停效果 */
    box-shadow: 0 8px 25px rgba(62, 92, 43, 0.4);
    color: white;
  }
  
  /* 响应式样式 */
  @media (max-width: 768px) {
    .main-title {
      font-size: 2.4rem;
    }
    
    .main-subtitle {
      font-size: 1.2rem;
    }
    
    .journey-title {
      font-size: 1.7rem;
    }
    
    .journey-description {
      font-size: 1.1rem;
    }
    
    .start-journey-button {
      font-size: 1.2rem;
      padding: 12px 30px;
    }
    
    .intro-content {
      padding: 2rem;
      width: 95%;
    }
    
    /* 平板设备上转为垂直排列 */
    .flex-container {
      flex-direction: column;
      gap: 1.5rem;
    }
    
    .image-container {
      max-width: 100%;
      height: 200px;
    }
    
    .journey-section {
      text-align: center;
    }
  }
  
  /* 中等屏幕：介于 769px 到 1024px 之间 */
@media (max-width: 1024px) and (min-width: 769px) {
  .intro-content {
    width: 90%;
  }

  .flex-container {
    flex-direction: column;
  }

  .image-container {
    max-width: 100%;
  }

  .journey-section {
    text-align: center;
  }
}

/* 小屏幕：手机 */
@media (max-width: 768px) {
  .intro-content {
    width: 95%;
  }

  .flex-container {
    flex-direction: column;
  }

  .image-container {
    height: 250px;
  }
}

  @media (max-width: 480px) {
    .main-title {
      font-size: 2rem;
    }
    
    .intro-content {
      padding: 1.5rem;
    }
    
    .image-container {
      height: 200px;
    }
    
    .journey-section {
      padding: 1.5rem;
    }
  }
  </style>