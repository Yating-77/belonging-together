<template>
    <div class="charts-page-container">
      <MyNavBar />
      
      <!-- Hero Banner Section -->
      <div class="hero-banner">
        <div class="hero-image-container">
          <img src="/insights.png" alt="Understanding Autism" class="hero-image" />
        </div>
        <div class="hero-text-overlay">
          <div class="container text-center">
            <h1 class="main-title">Understanding Autism, One Step at a Time</h1>
            <p class="main-subtitle">
              Every child's journey with autism is unique — but we've noticed some patterns that may help you understand yours.
            </p>
          </div>
        </div>
      </div>
  
      <div class="charts-content">
        <!-- 第一个图表部分 -->
        <div class="chart-section">
          <div class="container">
            <h2 class="section-title">Is Autism Becoming More Common?</h2>
            <div class="content-row">
              <div class="chart-card chart-column">
                <div class="chart-wrapper">
                  <AutismTrendChart />
                </div>
                <div class="data-source">
                  Data Source: <a href="https://data.cdc.gov/Public-Health-Surveillance/autism-prevalence-studies/9mw4-6adp/data_preview" target="_blank">Centers for Disease Control and Prevention</a>
                </div>
              </div>
              <div class="text-column">
                <div class="insight-card">
                  <div class="insight-icon">✅</div>
                  <div class="insight-content">
                    <h3 class="insight-title">Key Insight</h3>
                    <p>Autism prevalence has steadily increased across all age groups from 2015 to 2022, with the most noticeable rise among children aged 5 to 14.</p>
                  </div>
                </div>
                
                <div class="insight-card">
                  <div class="insight-icon">🧠</div>
                  <div class="insight-content">
                    <h3 class="insight-title">Did You Know?</h3>
                    <p>This trend doesn't mean autism is "spreading", it means we're getting better at recognising and supporting it.</p>
                  </div>
                </div>
                
                <div class="insight-card">
                  <div class="insight-icon">💬</div>
                  <div class="insight-content">
                    <h3 class="insight-title">What This Means for You</h3>
                    <p>For families, this highlights the importance of early observation and understanding that diagnosis is becoming more accessible and accepted.</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
  
        <!-- 第二个图表部分 -->
        <div class="chart-section alt-bg">
          <div class="container">
            <h2 class="section-title">How Does Autism Look Different Across Genders?</h2>
            <div class="content-row">
              <div class="text-column">
                <div class="insight-card">
                  <div class="insight-icon">✅</div>
                  <div class="insight-content">
                    <h3 class="insight-title">Key Insight</h3>
                    <p>Boys are diagnosed with autism at a higher rate than girls, particularly between the ages of 5 and 14.</p>
                  </div>
                </div>
                
                <div class="insight-card">
                  <div class="insight-icon">🧠</div>
                  <div class="insight-content">
                    <h3 class="insight-title">Did You Know?</h3>
                    <p>This doesn't mean girls are less likely to be autistic, it means their signs may look different or go unnoticed.</p>
                  </div>
                </div>
                
                <div class="insight-card">
                  <div class="insight-icon">💬</div>
                  <div class="insight-content">
                    <h3 class="insight-title">What This Means for You</h3>
                    <p>Understanding this helps parents of daughters recognise more subtle cues, and advocates for fairer, more inclusive support for all children.</p>
                  </div>
                </div>
              </div>
              <div class="chart-card chart-column">
                <div class="chart-wrapper">
                  <autism-gender-chart />
                </div>
                <div class="data-source">
                  Data Source: <a href="https://www.abs.gov.au/articles/autism-australia-2022" target="_blank">Australian Bureau of Statistics</a>
                </div>
              </div>
            </div>
          </div>
        </div>
  
        <!-- 第三个图表部分 -->
        <div class="chart-section">
          <div class="container">
            <h2 class="section-title">What Challenges Do Autistic Children Face?</h2>
            <div class="content-row">
              <div class="chart-card chart-column">
                <div class="chart-wrapper">
                  <autism-bar-chart />
                </div>
                <div class="data-source">
                  Data Source: <a href="https://dataresearch.ndis.gov.au/reports-and-analyses/participant-dashboards/autism" target="_blank">NDIS</a>
                </div>
              </div>
              <div class="text-column">
                <div class="insight-card">
                  <div class="insight-icon">✅</div>
                  <div class="insight-content">
                    <h3 class="insight-title">Key Insight</h3>
                    <p>Many autistic children experience difficulties with learning, emotional regulation, communication, and social behaviour. The most common challenges include delayed understanding (71.4%) and social difficulties (62.4%).</p>
                  </div>
                </div>
                
                <div class="insight-card">
                  <div class="insight-icon">🧠</div>
                  <div class="insight-content">
                    <h3 class="insight-title">Did You Know?</h3>
                    <p>These struggles are not signs of failure, they are part of the autism experience.</p>
                  </div>
                </div>
                
                <div class="insight-card">
                  <div class="insight-icon">💬</div>
                  <div class="insight-content">
                    <h3 class="insight-title">What This Means for You</h3>
                    <p>Seeing these patterns helps parents feel less isolated and more prepared to find the right tools and support.</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 呼吁行动部分 -->
        <div class="cta-section">
          <div class="container">
            <div class="cta-card">
              <h2 class="cta-title">Ready to Understand Your Child's Unique Needs?</h2>
              <p class="cta-subtitle">Every child's autism journey is different. That's why we've built a personalised recommendation tool to guide you based on real-life behaviours and challenges.</p>
              <div class="cta-button-container">
                <router-link to="/recommendation" class="cta-button">Start My Personalised Guide</router-link>
              </div>
            </div>
          </div>
        </div>
      </div>
  
      <MyFooter />
    </div>
  </template>
  <script>
  import AutismBarChart from '../components/AutismBarChart.vue';
  import AutismGenderChart from '../components/AutismGenderChart.vue';
  import AutismTrendChart from '../components/AutismTrendChart.vue';
  import MyNavBar from '../components/test/MyNavBar.vue';
  import MyFooter from '../components/test/MyFooter.vue';
  
  export default {
    components: {
      AutismBarChart,
      AutismGenderChart,
      AutismTrendChart,
      MyNavBar,
      MyFooter,
    },
    data() {
      return {
        legendColors: {
          male: '#6a89cc',
          female: '#ff6b6b'
        }
      }
    }
  }
  </script>
  <style scoped>
  .charts-page-container {
    width: 100%;
    font-family: Arial, sans-serif;
  }
  
  /* Hero Banner 样式 */
  .hero-banner {
    position: relative;
    width: 100%;
    height: 400px;
    overflow: hidden;
    margin-bottom: 0;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  .hero-image-container {
    width: 100%;
    height: 100%;
    position: absolute;
    top: 0;
    left: 0;
  }
  
  .hero-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    object-position: center 30%;
  }
  
  .hero-text-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(0, 0, 0, 0.4);
  }
  
  .main-title { 
    color: white;
    font-size: 3rem; 
    font-weight: 700; 
    margin-bottom: 1.5rem; 
    text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.7);
  }
  
  .main-subtitle { 
    color: white;
    font-size: 1.2rem; 
    margin-bottom: 0; 
    line-height: 1.6;
    max-width: 800px;
    margin-left: auto;
    margin-right: auto;
    text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.7);
  }
  
  .charts-content {
    min-height: calc(100vh - 130px);
  }
  
  .chart-section {
    padding: 80px 30px;
  }
  
  .alt-bg {
    background-color: #F8EFED;
  }
  
  .container {
    max-width: 1400px;
    margin: 0 auto;
  }
  
  .section-title {
    text-align: center;
    margin-bottom: 40px;
    font-size: 2.2rem;
    color: #4d2f20;
    font-weight: 600;
  }
  
  .content-row {
    display: flex;
    flex-wrap: wrap;
    margin: 0 -15px;
    align-items: stretch;
  }
  
  .content-row.reverse {
    flex-direction: row-reverse;
  }
  
  .chart-card {
    background-color: #ffffff;
    border-radius: 12px;
    box-shadow: 0 4px 16px rgba(0,0,0,0.1);
    overflow: hidden;
    padding: 30px;
    margin: 0 15px;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    position: relative;
    display: flex;
    flex-direction: column;
  }
  
  .chart-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 6px 20px rgba(0,0,0,0.15);
  }
  
  .chart-column {
    flex: 0 0 calc(60% - 30px);
    margin-bottom: 30px;
  }
  
  .text-column {
    flex: 0 0 calc(40% - 30px);
    margin-bottom: 30px;
  }
  
  .text-card {
    padding: 30px;
    background-color: #f9f9f9;
    border-radius: 12px;
    border-left: 4px solid #3E5C2B;
    height: 100%;
    box-shadow: 0 4px 16px rgba(0,0,0,0.1);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }
  
  .text-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 6px 20px rgba(0,0,0,0.15);
  }
  
  .text-card p {
    color: #444;
    font-size: 1.05rem;
    line-height: 1.7;
    margin-bottom: 20px;
  }
  
  .text-card p:last-child {
    margin-bottom: 0;
  }
  
  .chart-wrapper {
    flex-grow: 1;
    height: 450px;
    position: relative;
    margin-bottom: 20px;
  }
  
  .data-source {
    text-align: right;
    font-size: 0.85rem;
    color: #999;
    font-style: italic;
    margin-top: auto;
    padding-top: 15px;
  }
  
  .data-source a {
    color: #3E5C2B;
    text-decoration: none;
  }
  
  .data-source a:hover {
    text-decoration: underline;
  }
  
  @media (max-width: 992px) {
    .container {
      max-width: 100%;
    }
    .chart-section {
      padding: 60px 20px;
    }
    .cta-section {
      padding: 50px 20px 80px;
    }
    .cta-card {
      padding: 40px 30px;
      max-width: 90%;
    }
    .cta-title {
      font-size: 2rem;
    }
    .chart-card {
      padding: 25px;
      margin: 0 10px 20px;
    }
    .insight-card {
      padding: 15px;
      margin-bottom: 15px;
    }
    .insight-icon {
      font-size: 1.8rem;
      min-width: 35px;
      margin-right: 12px;
    }
    .insight-title {
      font-size: 1rem;
    }
    .text-card {
      padding: 25px;
      margin: 0 10px 20px;
    }
    .main-title {
      font-size: 2.5rem;
    }
    .main-subtitle {
      font-size: 1.1rem;
    }
    .section-title {
      font-size: 2rem;
      margin-bottom: 30px;
    }
    .chart-column, 
    .text-column {
      flex: 0 0 calc(100% - 20px);
    }
    .chart-wrapper {
      height: 400px;
      margin-bottom: 20px;
    }
    .content-row.reverse .text-column {
      order: 2;
    }
    .content-row.reverse .chart-column {
      order: 1;
    }
  }
  
  @media (max-width: 768px) {
    .chart-section {
      padding: 40px 15px;
    }
    .cta-section {
      padding: 40px 15px 70px;
    }
    .cta-card {
      padding: 30px 20px;
      max-width: 100%;
    }
    .cta-title {
      font-size: 1.7rem;
      margin-bottom: 15px;
    }
    .cta-subtitle {
      font-size: 1rem;
      margin-bottom: 30px;
    }
    .cta-button {
      font-size: 1rem;
      padding: 12px 25px;
    }
    .chart-card {
      padding: 20px;
    }
    .insight-card {
      padding: 12px;
      margin-bottom: 12px;
    }
    .insight-icon {
      font-size: 1.5rem;
      min-width: 30px;
      margin-right: 10px;
    }
    .insight-title {
      font-size: 0.95rem;
      margin-bottom: 8px;
      padding-bottom: 5px;
    }
    .insight-content p {
      font-size: 0.9rem;
      line-height: 1.5;
    }
    .text-card {
      padding: 20px;
    }
    .chart-wrapper {
      height: 350px;
    }
    .data-source {
      font-size: 0.75rem;
      margin-top: 10px;
      text-align: center;
    }
    .charts-content {
      min-height: calc(100vh - 100px);
    }
    .hero-banner {
      height: 350px;
    }
    .main-title {
      font-size: 2rem;
      margin-bottom: 1rem;
    }
    .main-subtitle {
      font-size: 1rem;
      padding: 0 15px;
    }
    .section-title {
      font-size: 1.5rem;
      margin-bottom: 25px;
    }
    .text-card p {
      font-size: 0.95rem;
      line-height: 1.6;
      margin-bottom: 15px;
    }
  }
  
  @media (max-width: 576px) {
    .hero-banner {
      height: 300px;
    }
    
    .main-title {
      font-size: 1.7rem;
      margin-bottom: 0.8rem;
    }
    
    .main-subtitle {
      font-size: 0.9rem;
    }
    
    .section-title {
      font-size: 1.4rem;
    }
    
    .chart-section {
      padding: 30px 10px;
    }
    
    .cta-section {
      padding: 30px 10px 50px;
    }
    
    .cta-card {
      padding: 25px 15px;
      border-radius: 10px;
    }
    
    .cta-title {
      font-size: 1.5rem;
    }
    
    .cta-subtitle {
      font-size: 0.9rem;
      margin-bottom: 25px;
    }
    
    .cta-button {
      width: 100%;
      padding: 12px 15px;
      font-size: 0.95rem;
    }
    
    .insight-card {
      padding: 10px;
    }
    
    .insight-icon {
      font-size: 1.3rem;
      min-width: 25px;
      margin-right: 8px;
    }
  }
  
  /* CTA Section 样式 */
  .cta-section {
    padding: 60px 30px 100px;
    background-color: #F8EFED;
    position: relative;
  }
  
  .cta-section::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(to right, #3E5C2B, #7fa65a, #3E5C2B);
  }
  
  .cta-card {
    max-width: 800px;
    margin: 0 auto;
    background-color: white;
    border-radius: 12px;
    padding: 50px;
    text-align: center;
    box-shadow: 0 6px 25px rgba(0,0,0,0.1);
    position: relative;
    z-index: 2;
  }
  
  .cta-title {
    color: #4d2f20;
    font-size: 2.2rem;
    font-weight: 700;
    margin-bottom: 20px;
  }
  
  .cta-subtitle {
    color: #555;
    font-size: 1.1rem;
    line-height: 1.6;
    margin-bottom: 40px;
    max-width: 600px;
    margin-left: auto;
    margin-right: auto;
  }
  
  .cta-button-container {
    display: flex;
    justify-content: center;
  }
  
  .cta-button {
    display: inline-block;
    background-color: #3E5C2B;
    color: white;
    font-weight: 600;
    font-size: 1.1rem;
    padding: 15px 30px;
    border-radius: 50px;
    text-decoration: none;
    transition: all 0.3s ease;
    box-shadow: 0 4px 10px rgba(62, 92, 43, 0.3);
  }
  
  .cta-button:hover {
    background-color: #4d7234;
    transform: translateY(-3px);
    box-shadow: 0 6px 15px rgba(62, 92, 43, 0.4);
  }
  
  /* 新增的洞察卡片样式 */
  .insight-card {
    display: flex;
    background-color: #ffffff;
    border-radius: 10px;
    padding: 20px;
    margin-bottom: 20px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    border-left: 4px solid #3E5C2B;
  }
  
  .insight-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 16px rgba(0,0,0,0.12);
  }
  
  .insight-icon {
    font-size: 2rem;
    margin-right: 15px;
    display: flex;
    align-items: center;
    justify-content: center;
    min-width: 40px;
  }
  
  .insight-content {
    flex: 1;
  }
  
  .insight-title {
    color: #3E5C2B;
    font-size: 1.1rem;
    font-weight: 600;
    margin-bottom: 10px;
    position: relative;
    padding-bottom: 8px;
  }
  
  .insight-title::after {
    content: "";
    position: absolute;
    bottom: 0;
    left: 0;
    width: 40px;
    height: 2px;
    background-color: #3E5C2B;
    border-radius: 1px;
  }
  
  .insight-content p {
    color: #444;
    font-size: 1rem;
    line-height: 1.6;
    margin-bottom: 0;
  }
  

  .insight-card:nth-child(1) {
    border-left-color: #4CAF50; /* 绿色 - Key Insight */
  }
  
  .insight-card:nth-child(2) {
    border-left-color: #2196F3;
  }
  
  .insight-card:nth-child(3) {
    border-left-color: #FF9800;
  }
  
  .insight-card:nth-child(1) .insight-title {
    color: #4CAF50;
  }
  
  .insight-card:nth-child(1) .insight-title::after {
    background-color: #4CAF50;
  }
  
  .insight-card:nth-child(2) .insight-title {
    color: #2196F3;
  }
  
  .insight-card:nth-child(2) .insight-title::after {
    background-color: #2196F3;
  }
  
  .insight-card:nth-child(3) .insight-title {
    color: #FF9800;
  }
  
  .insight-card:nth-child(3) .insight-title::after {
    background-color: #FF9800;
  }
  </style>
  