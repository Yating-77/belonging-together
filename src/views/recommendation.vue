<template>
  <!-- loading message -->
  <div v-if="loading" class="loading-overlay">
    <div class="loading-content">
      <div class="loading-spinner"></div>
      <p class="loading-text">Preparing your personalised recommendations...</p>
      <p class="loading-subtext">Please wait a moment while we load your personalised scenarios</p>
    </div>
  </div>

  <div v-else-if="scenarios.length > 0" class="fullscreen-container">
    <MyNavBar />
    
    <!-- slide container -->
    <div class="slider-container">
      <!-- intro page -->
      <div class="slider-page" :class="{'slide-out': currentSlide !== 'intro'}">
        <!-- title -->
        <div class="main-title-container text-center py-4">
          <h1 class="mb-3 page-title">Supporting Autism Families</h1>
          <p class="mb-4 page-subtitle">
            Personalised recommendations based on your child's daily behaviors
          </p>
          
          <!-- scenecard -->
          <div class="scenarios-cards-container">
            <p class="intro-text page-subtitle">We provide support for six common scenarios:</p>
            <div class="scenarios-cards-row">
              <div class="scenario-card-item" style="cursor: pointer;" @click="jumpToScenario(0)">
                <div class="card-icon-placeholder">
                  <img src="../components/icons/sleep-icon.png" alt="Sleep Icon" class="scenario-icon">
                </div>
                <div class="card-title">Sleep Issues</div>
                <div class="card-description">Trouble falling or staying asleep?</div>
              </div>
              <div class="scenario-card-item" style="cursor: pointer;" @click="jumpToScenario(1)">
                <div class="card-icon-placeholder">
                  <img src="../components/icons/diet-icon.png" alt="Diet Icon" class="scenario-icon">
                </div>
                <div class="card-title">Diet & Nutrition</div>
                <div class="card-description">Selective eating or mealtime struggles?</div>
              </div>
              <div class="scenario-card-item" style="cursor: pointer;" @click="jumpToScenario(2)">
                <div class="card-icon-placeholder">
                  <img src="../components/icons/social-icon.png" alt="Social Icon" class="scenario-icon larger-icon">
                </div>
                <div class="card-title">Social Interaction</div>
                <div class="card-description">Find it hard to connect with peers?</div>
              </div>
            </div>
            <div class="scenarios-cards-row">
              <div class="scenario-card-item" style="cursor: pointer;" @click="jumpToScenario(3)">
                <div class="card-icon-placeholder">
                  <img src="../components/icons/communication-icon.png" alt="Communication Icon" class="scenario-icon larger-icon">
                </div>
                <div class="card-title">Communication</div>
                <div class="card-description">Limited language or unclear speech?</div>
              </div>
              <div class="scenario-card-item" style="cursor: pointer;" @click="jumpToScenario(4)">
                <div class="card-icon-placeholder">
                  <img src="../components/icons/emotion-icon.png" alt="Emotion Icon" class="scenario-icon larger-icon">
                </div>
                <div class="card-title">Emotional Management</div>
                <div class="card-description">Frequent meltdowns or aggression?</div>
              </div>
              <div class="scenario-card-item" style="cursor: pointer;" @click="jumpToScenario(5)">
                <div class="card-icon-placeholder">
                  <img src="../components/icons/sensory-icon.png" alt="Sensory Icon" class="scenario-icon larger-icon">
                </div>
                <div class="card-title">Sensory Sensitivity</div>
                <div class="card-description">Overreact to lights, sound or touch?</div>
              </div>
            </div>
            
            <!-- Attribution line -->
            <div class="attribution-line">All recommendations are sourced from <a href="https://www.betterhealth.vic.gov.au/" target="_blank"><span class="green-text">Better Health Channel</span></a></div>
          </div>
        </div>
        
        <!-- Start Journey  -->
        <div class="start-journey-section">
          <div class="container">
            <div class="row">
              <div class="col-md-6 intro-image-container">
                <img src="/scenario-start.png" alt="Start Your Journey" class="intro-image" onerror="this.src='/sleep_scenario_example.png'">
              </div>
              <div class="col-md-6 intro-content-container">
                <h2 class="intro-title">Begin Your Personalised Journey</h2>
                <p class="intro-description">
                  Take the first step towards understanding your child's unique needs. 
                  Our personalised recommendations will help you navigate the challenges of supporting a child with autism.
                </p>
                <p class="intro-description">
                  Select from the scenarios above or click the button below to start with the first scenario.
                </p>
                <button class="btn start-journey-button" @click="startJourney">
                  Start Journey
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- scene -->
      <div class="slider-page" :class="{'slide-in': currentSlide !== 'intro', 'hidden': currentSlide === 'intro'}">
        <div class="scenario-page-header">
          <!-- go back -->
          <div class="return-home-btn-container">
            <button class="btn return-home-btn" @click="returnToIntro">
              &larr; Return to Introduction
            </button>
          </div>
          
          <!-- scene title -->
          <h2 class="scenario-page-title text-center">Scenario {{ currentScenario + 1}}: {{ scenarios[currentScenario].title }}</h2>
        </div>
        
        <div v-if="!showResults" class="row g-0 h-100">
          <!-- Left fixed image area -->
          <div class="col-md-5 d-flex align-items-center justify-content-center sidebar-container">
            <div class="position-sticky sidebar-content">
              <div class="main-image-container">
                <img 
                  :src="'/scenario-' + currentScenario + '.jpg'" 
                  alt="Scenario Illustration" 
                  class="img-fluid main-image"
                  onerror="this.src='/sleep_scenario_example.png'"
                />
              </div>
              
              <!-- Progress indicator with intro dot -->
              <div class="progress-container mt-4">
                <div class="d-flex justify-content-between mb-2">
                  <span class="progress-text">Scenario {{ currentScenario + 1 }}/{{ scenarios.length }}</span>
                </div>
                <div class="progress">
                  <div class="progress-bar" 
                       :style="{ width: ((currentScenario + 1) / scenarios.length * 100) + '%' }">
                  </div>
                </div>
                <div class="scenario-dots mt-3 d-flex justify-content-between">
                  <!-- intro -->
                  <div class="scenario-dot intro-dot" 
                       :class="{ 'active': currentSlide === 'intro' }"
                       @click="returnToIntro">
                    <span class="dot-tooltip">Introduction</span>
                  </div>
                  <!-- scene-->
                  <div v-for="(scenario, index) in scenarios" :key="index" 
                       class="scenario-dot" 
                       :class="{ 'active': index <= currentScenario && currentSlide !== 'intro', 'current': index === currentScenario && currentSlide !== 'intro' }"
                       @click="navigateToScenario(index)">
                    <span class="dot-tooltip">{{ scenario.title }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Right question and options area -->
          <div class="col-md-7 d-flex align-items-center">
            <div class="card w-100 border-0 shadow-sm content-card">
              <div v-if="!currentSelectedOption" class="card-body p-md-4 p-3">
                <div class="scenario-title mb-2">
                  {{ scenarios[currentScenario].title }}
                </div>
                <h3 class="mb-3 scenario-question">
                  {{ scenarios[currentScenario].question }}
                </h3>
                
                <div class="options-container">
                  <div 
                    v-for="(opt, index) in scenarios[currentScenario].options" 
                    :key="index"
                    class="option-card my-3 p-3" 
                    :class="{'selected-option': selected === index}"
                    @click="selected = index"
                  >
                    <input class="form-check-input visually-hidden" type="radio" :id="'opt' + index" :value="index" v-model="selected">
                    <label class="form-check-label d-block" :for="'opt' + index">
                      <div class="d-flex align-items-center">
                        <div class="option-indicator me-3" :class="{'selected-indicator': selected === index}"></div>
                        <div class="option-text">{{ opt.text }}</div>
                      </div>
                    </label>
                  </div>
                  
                  <button 
                    class="btn mt-4 w-100 py-3 action-button" 
                    @click="showRecommendation" 
                    :disabled="selected === null"
                  >
                    {{ currentScenario === 0 ? 'View Sleep Scenario' : 
                      currentScenario === 1 ? 'View Diet Scenario' : 
                      currentScenario === 2 ? 'View Social Interaction Scenario' : 
                      currentScenario === 3 ? 'View Communication Scenario' : 
                      currentScenario === 4 ? 'View Emotional Management Scenario' : 
                      currentScenario === 5 ? 'View Sensory Sensitivity Scenario' : 
                      'View Recommendations' }}
                  </button>
                </div>
              </div>
              
              <div v-else class="recommendation-container card-body p-md-5 p-4">
                <div class="scenario-title mb-2">
                  {{ scenarios[currentScenario].title }}
                </div>
                <h3 class="mb-4 recommendations-heading">Professional Recommendations</h3>
                
                <div class="recommendation-content p-4 mb-4">
                  <h4 class="mb-3 recommendation-subtitle">Recommendations for "{{ currentSelectedOption.text }}"</h4>
                  
                  <div class="recommendation-cards">
                    <div v-for="(rec, i) in formatRecommendations(currentSelectedOption.recommendations)" :key="i" 
                         class="recommendation-card mb-4">
                      <div class="card-header d-flex align-items-center p-3">
                        <div class="rec-icon me-3">
                          <i class="fas fa-check-circle"></i>
                        </div>
                        <h5 class="m-0 recommendation-title">{{ rec.title }}</h5>
                      </div>
                      
                      <div class="card-body p-3">
                        <div class="content">
                          {{ rec.content }}
                        </div>
                        
                        <div v-if="rec.example" class="example mt-3 p-2">
                          <div class="example-title">Practical Application:</div>
                          <div class="example-content">{{ rec.example }}</div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                
                <div class="d-flex justify-content-between mt-4">
                  <button 
                    class="btn back-button" 
                    @click="resetCurrentScenario"
                  >
                    Choose Again
                  </button>
                  
                  <button 
                    v-if="currentScenario < scenarios.length - 1"
                    class="btn next-button" 
                    @click="navigateToNextScenario"
                  >
                    Next Scenario
                  </button>
                  
                  <button 
                    v-else
                    class="btn finish-button" 
                    @click="completeScenarios"
                  >
                    Finish
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Results Page -->
    <div v-if="showResults" class="results-container p-4">
      <div class="results-card card border-0 shadow-sm p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
          <h1 class="results-title">Thank You</h1>
          <div>
            <button class="btn handbook-button" @click="showSummary = true">
              📚 View Complete Handbook
          </button>
          </div>
        </div>
        
        <div class="thank-you-section mb-4 p-3">
          <h3 class="mb-4 text-center">To Parents</h3>
          <p class="mb-4">
            Every child is a unique universe. In their journey of growth, there may be anxiety, sensitivity, or different ways of expression.
          </p>
          <p class="mb-4">
            We hope these gentle scenarios can serve as a bridge of understanding and connection between you and your child.
          </p>
          <p class="mb-4">
            May you feel trust, strength, and love in every moment of companionship.
          </p>
          <p class="text-end mb-2">
            — Belonging Together Team ❤️
          </p>
        </div>
        
        <div class="d-flex justify-content-between mt-4">
          <button class="btn back-button" @click="backToScenarios">
            Back
          </button>
              </div>
              </div>
            </div>
            
    <!-- Sleep Scene Modal -->
    <div v-if="showSleepScene" class="sleep-scene-modal" @keydown.escape="resetCurrentScenario">
      <div class="sleep-scene-content">
        <div class="modal-header">
          <h3 class="modal-title">Scenario Scene - Sleep Issues</h3>
          <button type="button" class="close-btn" @click="resetCurrentScenario">&times;</button>
        </div>
        <div class="modal-body">
          <SleepScene 
            :option="sleepSceneOption" 
            @next-scenario="navigateToNextScenario" 
            @close-modal="resetCurrentScenario">
          </SleepScene>
        </div>
        <div class="modal-footer d-flex justify-content-between align-items-center">
          <div class="attribution-line text-left mb-0">All recommendations are sourced from <a href="https://www.betterhealth.vic.gov.au/" target="_blank"><span class="green-text">Better Health Channel</span></a></div>
          <button type="button" class="btn back-button" @click="resetCurrentScenario">Back to Scenario Options</button>
        </div>
      </div>
            </div>
            
    <!-- Diet Scene Modal -->
    <div v-if="showDietScene" class="sleep-scene-modal" @keydown.escape="resetCurrentScenario">
      <div class="sleep-scene-content">
        <div class="modal-header">
          <h3 class="modal-title">Scenario Scene - Diet Issues</h3>
          <button type="button" class="close-btn" @click="resetCurrentScenario">&times;</button>
                  </div>
        <div class="modal-body">
          <DietScene 
            :option="dietSceneOption" 
            @next-scenario="navigateToNextScenario" 
            @close-modal="resetCurrentScenario">
          </DietScene>
                </div>
        <div class="modal-footer d-flex justify-content-between align-items-center">
          <div class="attribution-line text-left mb-0">All recommendations are sourced from <a href="https://www.betterhealth.vic.gov.au/" target="_blank"><span class="green-text">Better Health Channel</span></a></div>
          <button type="button" class="btn back-button" @click="resetCurrentScenario">Back to Scenario Options</button>
              </div>
      </div>
    </div>
    
    <!-- Social Scene Modal -->
    <div v-if="showSocialScene" class="sleep-scene-modal" @keydown.escape="resetCurrentScenario">
      <div class="sleep-scene-content">
        <div class="modal-header">
          <h3 class="modal-title">Scenario Scene - Social Interaction</h3>
          <button type="button" class="close-btn" @click="resetCurrentScenario">&times;</button>
        </div>
        <div class="modal-body">
          <SocialScene 
            :option="socialSceneOption" 
            @next-scenario="navigateToNextScenario" 
            @close-modal="resetCurrentScenario">
          </SocialScene>
        </div>
        <div class="modal-footer d-flex justify-content-between align-items-center">
          <div class="attribution-line text-left mb-0">All recommendations are sourced from <a href="https://www.betterhealth.vic.gov.au/" target="_blank"><span class="green-text">Better Health Channel</span></a></div>
          <button type="button" class="btn back-button" @click="resetCurrentScenario">Back to Scenario Options</button>
            </div>
          </div>
        </div>
        
    <!-- Communication Scene Modal -->
    <div v-if="showCommunicationScene" class="sleep-scene-modal" @keydown.escape="resetCurrentScenario">
      <div class="sleep-scene-content">
        <div class="modal-header">
          <h3 class="modal-title">Scenario Scene - Communication</h3>
          <button type="button" class="close-btn" @click="resetCurrentScenario">&times;</button>
        </div>
        <div class="modal-body">
          <CommunicationScene 
            :option="communicationSceneOption" 
            @next-scenario="navigateToNextScenario" 
            @close-modal="resetCurrentScenario">
          </CommunicationScene>
      </div>
        <div class="modal-footer d-flex justify-content-between align-items-center">
          <div class="attribution-line text-left mb-0">All recommendations are sourced from <a href="https://www.betterhealth.vic.gov.au/" target="_blank"><span class="green-text">Better Health Channel</span></a></div>
          <button type="button" class="btn back-button" @click="resetCurrentScenario">Back to Scenario Options</button>
        </div>
      </div>
    </div>
    
    <!-- Emotion Scene Modal -->
    <div v-if="showEmotionScene" class="sleep-scene-modal" @keydown.escape="resetCurrentScenario">
      <div class="sleep-scene-content">
        <div class="modal-header">
          <h3 class="modal-title">Scenario Scene - Emotional Management</h3>
          <button type="button" class="close-btn" @click="resetCurrentScenario">&times;</button>
        </div>
        <div class="modal-body">
          <EmotionScene 
            :option="emotionSceneOption" 
            @next-scenario="navigateToNextScenario" 
            @close-modal="resetCurrentScenario">
          </EmotionScene>
        </div>
        <div class="modal-footer d-flex justify-content-between align-items-center">
          <div class="attribution-line text-left mb-0">All recommendations are sourced from <a href="https://www.betterhealth.vic.gov.au/" target="_blank"><span class="green-text">Better Health Channel</span></a></div>
          <button type="button" class="btn back-button" @click="resetCurrentScenario">Back to Scenario Options</button>
        </div>
      </div>
    </div>
    
    <!-- Sensory Scene Modal -->
    <div v-if="showSensoryScene" class="sleep-scene-modal" @keydown.escape="resetCurrentScenario">
      <div class="sleep-scene-content">
        <div class="modal-header">
          <h3 class="modal-title">Scenario Scene - Sensory Sensitivity</h3>
          <button type="button" class="close-btn" @click="resetCurrentScenario">&times;</button>
        </div>
        <div class="modal-body">
          <SensoryScene 
            :option="sensorySceneOption" 
            @next-scenario="navigateToNextScenario" 
            @close-modal="resetCurrentScenario">
          </SensoryScene>
        </div>
        <div class="modal-footer d-flex justify-content-between align-items-center">
          <div class="attribution-line text-left mb-0">All recommendations are sourced from <a href="https://www.betterhealth.vic.gov.au/" target="_blank"><span class="green-text">Better Health Channel</span></a></div>
          <button type="button" class="btn back-button" @click="resetCurrentScenario">Back to Scenario Options</button>
        </div>
      </div>
    </div>
    
    <!-- Summary Modal -->
    <div v-if="showSummary" class="sleep-scene-modal" @keydown.escape="showSummary = false">
      <div class="sleep-scene-content" style="max-width: 1200px; width: 95%;">
        <div class="modal-header">
          <h3 class="modal-title">Parent Handbook Generator</h3>
          <button type="button" class="close-btn" @click="showSummary = false">&times;</button>
        </div>
        <div class="modal-body">
          <Summary></Summary>
        </div>
        <div class="modal-footer d-flex justify-content-between align-items-center">
          <div class="attribution-line text-left mb-0">All recommendations are sourced from <a href="https://www.betterhealth.vic.gov.au/" target="_blank"><span class="green-text">Better Health Channel</span></a></div>
          <button type="button" class="btn back-button" @click="showSummary = false">Return</button>
        </div>
      </div>
    </div>
    <MyFooter />
  </div>
  
  <!-- no data attention -->
  <div v-else class="loading-overlay">
    <div class="loading-content">
      <div class="error-icon">⚠️</div>
      <p class="loading-text">Unable to load scenario data, please try again later</p>
      <button @click="setupDefaultScenarios" class="retry-button">Use Default Data</button>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';
import SleepScene from '../components/SleepScene.vue';
import DietScene from '../components/DietScene.vue';
import SocialScene from '../components/SocialScene.vue';
import CommunicationScene from '../components/CommunicationScene.vue';
import EmotionScene from '../components/EmotionScene.vue';
import SensoryScene from '../components/SensoryScene.vue';
import Summary from '../components/Summary.vue';
import MyFooter from '../components/test/MyFooter.vue';
import MyNavBar from '../components/test/MyNavBar.vue';

export default {
  components: {
    SleepScene,
    DietScene,
    SocialScene,
    CommunicationScene,
    EmotionScene,
    SensoryScene,
    Summary,
    MyFooter,
    MyNavBar
  },
  data() {
    return {
      selected: null,
      currentSelectedOption: null,
      currentScenario: 0,
      currentSlide: 'intro',
      showResults: false,
      showSleepScene: false,
      showDietScene: false,
      showSocialScene: false,
      showCommunicationScene: false,
      showEmotionScene: false,
      showSensoryScene: false,
      showSummary: false,
      sleepSceneOption: null,
      dietSceneOption: null,
      socialSceneOption: null,
      communicationSceneOption: null,
      emotionSceneOption: null,
      sensorySceneOption: null,
      userSelections: [],
      scenarios: [],
      loading: false,
      error: null
    };
  },
  methods: {
    // start journey - intro
    startJourney() {
      this.currentScenario = 0;
      this.selected = null;
      this.currentSelectedOption = null;
      this.currentSlide = 'scenarios';
      
      // go to the top
      this.$nextTick(() => {
        window.scrollTo({ top: 0, behavior: 'auto' });
      });
    },
    
    // go back to intro
    returnToIntro() {
      this.currentSlide = 'intro';
      
      // go to the top
      this.$nextTick(() => {
        window.scrollTo({ top: 0, behavior: 'auto' });
      });
    },
    
    // navigate to the scene
    jumpToScenario(index) {
      this.currentScenario = index;
      this.selected = null;
      this.currentSelectedOption = null;
      this.currentSlide = 'scenarios';
      
      // go to the top
      this.$nextTick(() => {
        window.scrollTo({ top: 0, behavior: 'auto' });
      });
    },
    
    // navigate to the scene
    navigateToScenario(index) {
      this.currentScenario = index;
      this.selected = null;
      this.currentSelectedOption = null;
      
      // go to the top
      this.$nextTick(() => {
        window.scrollTo({ top: 0, behavior: 'auto' });
      });
    },
    
    // Get category and questions and options from API
    async fetchCategories() {
      this.loading = true;
      this.error = null;
      
      // Loading time
      const startTime = Date.now();
      
      try {
        console.log('Starting to fetch categories and options data');
        
        // Get category
        const categoriesRes = await fetch('/api/categories');
        
        if (!categoriesRes.ok) {
          throw new Error(`Failed to fetch categories: ${categoriesRes.status} - ${categoriesRes.statusText}`);
        }
        
        let categories = await categoriesRes.json();
        console.log(`Retrieved ${categories.length} categories:`, JSON.stringify(categories));
        
        if (!categories || categories.length === 0) {
          throw new Error('No category data retrieved, please check the database');
        }
        
        // Handle duplicate data
        const uniqueTitles = new Set();
        categories = categories.filter(category => {
          if (uniqueTitles.has(category.title)) {
            return false;
          }
          uniqueTitles.add(category.title);
          return true;
        });
        
        console.log(`After removing duplicates, ${categories.length} categories remain`);
        
        // Temp scene
        const tempScenarios = [];
        
        // Get questions and options for each category
        for (const category of categories) {
          console.log(`Processing category: [ID: ${category.id}] ${category.title}`);
          
          try {
            // Get questions
            const questionsRes = await fetch(`/api/questions/${category.id}`);
            
            if (!questionsRes.ok) {
              console.error(`Failed to fetch questions for category ${category.id}: ${questionsRes.status} - ${questionsRes.statusText}`);
              continue;
            }
            
            const questions = await questionsRes.json();
            console.log(`Questions data for category ${category.id}:`, JSON.stringify(questions));
            
            if (!questions || questions.length === 0) {
              console.warn(`Category ${category.id} has no question data, skipping this category`);
              continue;
            }
            
            // Use the text from the first question as the question for this scenario
            const questionText = questions[0].text;
            console.log(`Question for category ${category.title}: ${questionText}`);
            
            // fetch the options for the category
            const optionsRes = await fetch(`/api/options/${category.id}`);
            
            if (!optionsRes.ok) {
              console.error(`Failed to fetch options for category ${category.id}: ${optionsRes.status} - ${optionsRes.statusText}`);
              continue;
            }
            
            let options = await optionsRes.json();
            console.log(`Options data for category ${category.id}:`, JSON.stringify(options));
            
            if (!options || options.length === 0) {
              console.warn(`Category ${category.id} has no options data, skipping this category`);
              continue;
            }
            
            // handle duplicate option data: remove duplicates by label
            const uniqueLabels = new Set();
            options = options.filter(option => {
              if (uniqueLabels.has(option.label)) {
                return false;
              }
              uniqueLabels.add(option.label);
              return true;
            });
            
            console.log(`After removing duplicates, retrieved ${options.length} options for category ${category.title}`);
            
            // build the scenario object
            const scenario = {
              title: category.title,
              question: questionText, // use the text retrieved from the questions table
              options: options.map(option => ({
                id: option.id, // save the option ID, for later retrieval of recommendations
                text: option.label,
                recommendations: []
              }))
            };
            
            console.log(`Scenario object constructed:`, JSON.stringify(scenario));
            
            // add to the scenarios array
            tempScenarios.push(scenario);
          } catch (error) {
            console.error(`Error when processing category ${category.id}:`, error);
            // continue to process other categories
            continue;
          }
        }
        
        // if the data is retrieved, update the scenarios array
        if (tempScenarios.length > 0) {
          this.scenarios = tempScenarios;
          console.log('Scenario data updated, retrieved', tempScenarios.length, 'scenarios');
        } else {
          console.warn('No scenario data retrieved, using default data');
          this.error = 'Could not retrieve any valid scenario data. This might be because the database does not have complete categories, questions, and options data.';
          this.setupDefaultScenarios();
        }
        
      } catch (err) {
        console.error('Failed to fetch categories and options data:', err);
        this.error = `Data loading failed: ${err.message}. Please ensure that the backend server is running and the database contains valid data.`;
        this.setupDefaultScenarios();
      } finally {
        // count the past time
        const elapsedTime = Date.now() - startTime;
        // if less than 1sec close
        const minLoadingTime = 500;
        
        if (elapsedTime < minLoadingTime) {
          const remainingTime = minLoadingTime - elapsedTime;
          console.log(`Waiting additional ${remainingTime}ms to ensure minimum loading time`);
          
          setTimeout(() => {
            this.loading = false;
          }, remainingTime);
        } else {
          this.loading = false;
        }
      }
    },
    showRecommendation() {
      this.currentSelectedOption = this.scenarios[this.currentScenario].options[this.selected];
      
      // fetch the option ID
      const optionId = this.currentSelectedOption.id;
      console.log(`Currently selected option ID: ${optionId}`);
      
      // if the option has an ID, fetch the recommendations
      if (optionId) {
        console.log(`Fetching recommendations for option ID ${optionId}`);
        this.fetchRecommendations(optionId);
      } else {
        console.warn('Current option has no ID, cannot fetch recommendation data');
      }
      
      // If it's a sleep issue scenario, directly display the SleepScene component
      if (this.currentScenario === 0) {
        this.showSleepScene = true;
        this.sleepSceneOption = this.selected;
        return;
      }
      
      // If it's a diet issue scenario, directly display the DietScene component 
      else if (this.currentScenario === 1) {
        this.showDietScene = true;
        this.dietSceneOption = this.selected;
        return;
      }
      
      // If it's a social interaction issue scenario, directly display the SocialScene component
      else if (this.currentScenario === 2) {
        this.showSocialScene = true;
        this.socialSceneOption = this.selected;
        return;
      }
      
      // If it's a communication issue scenario, directly display the CommunicationScene component
      else if (this.currentScenario === 3) {
        this.showCommunicationScene = true;
        this.communicationSceneOption = this.selected;
        return;
      }
      
      // If it's an emotional management issue scenario, directly display the EmotionScene component
      else if (this.currentScenario === 4) {
        this.showEmotionScene = true;
        this.emotionSceneOption = this.selected;
        return;
      }
      
      else if (this.currentScenario === 5) {
        this.showSensoryScene = true;
        this.sensorySceneOption = this.selected;
        return;
      }
      
      if (this.userSelections.length <= this.currentScenario) {
        this.userSelections.push({
          scenarioTitle: this.scenarios[this.currentScenario].title,
          scenarioQuestion: this.scenarios[this.currentScenario].question,
          optionText: this.currentSelectedOption.text,
          recommendations: this.currentSelectedOption.recommendations,
          scenarioIndex: this.currentScenario
        });
      } else {
        this.userSelections[this.currentScenario] = {
          scenarioTitle: this.scenarios[this.currentScenario].title,
          scenarioQuestion: this.scenarios[this.currentScenario].question,
          optionText: this.currentSelectedOption.text,
          recommendations: this.currentSelectedOption.recommendations,
          scenarioIndex: this.currentScenario
        };
      }
      window.scrollTo({ top: 0, behavior: 'smooth' });
    },
    
    async fetchRecommendations(optionId) {
      try {
        console.log(`Starting to fetch recommendations for option ID ${optionId}`);
        const response = await fetch(`/api/recommendations/${optionId}`);
        
        if (!response.ok) {
          console.error(`Failed to fetch recommendations: ${response.status}`);
          return;
        }
        
        const recommendations = await response.json();
        console.log(`Retrieved ${recommendations.length} recommendations for option ID ${optionId}:`);
        console.log(JSON.stringify(recommendations));
        
        if (this.currentSelectedOption && recommendations.length > 0) {
          this.currentSelectedOption.recommendations = recommendations;
          console.log('Updated recommendation data for current option');
        } else {
          console.warn('Cannot update recommendation data, current option is empty or no recommendations available');
        }
      } catch (error) {
        console.error('Error when fetching recommendation data:', error);
      }
    },
    resetCurrentScenario() {
      const scrollPosition = window.scrollY;
      
      this.selected = null;
      this.currentSelectedOption = null;
      this.showSleepScene = false; 
      this.showDietScene = false;
      this.showSocialScene = false; 
      this.showCommunicationScene = false; 
      this.showEmotionScene = false; 
      this.showSensoryScene = false; 
      
      this.$nextTick(() => {
        window.scrollTo({ top: scrollPosition });
      });
    },
    navigateToNextScenario() {
      const scrollPosition = window.scrollY;
      
      // Print log, for debugging
      console.log('navigateToNextScenario called');
      
      if (this.currentScenario < this.scenarios.length - 1) {
        // First close the modal window
        this.showSleepScene = false;
        this.showDietScene = false;
        this.showSocialScene = false;
        this.showCommunicationScene = false;
        this.showEmotionScene = false;
        this.showSensoryScene = false;
        
        this.currentScenario++;
        this.selected = null;
        this.currentSelectedOption = null;
        
        setTimeout(() => {
          // Force refresh view
          this.$forceUpdate();
          
          // Restore previous scroll position instead of scrolling to top
          window.scrollTo({ top: scrollPosition });
          
          // Print current scenario, for debugging
          console.log('Current scenario index:', this.currentScenario);
          console.log('Current scenario title:', this.scenarios[this.currentScenario].title);
        }, 100);
      } else {
        // If it's the last scenario, display the results page
        this.completeScenarios();
      }
    },
    completeScenarios() {
      // Add thank you message to user selections
      this.userSelections.push({
        scenarioTitle: "To Parents",
        scenarioQuestion: "Thank you for your dedication and love",
        optionText: "Message from Belonging Together",
        recommendations: []
      });
      
      // Display results page
      this.showResults = true;
      
      // hide return button
      document.querySelector('.scenario-page-header')?.classList.add('d-none');
    },
    resetAllScenarios() {
      this.currentScenario = 0;
      this.selected = null;
      this.currentSelectedOption = null;
    },
    backToScenarios() {
      this.showResults = false;
      this.resetAllScenarios();
      
      // show title and button
      document.querySelector('.scenario-page-header')?.classList.remove('d-none');
    },
    formatRecommendations(recommendations) {
      if (!recommendations || !Array.isArray(recommendations)) {
        return [];
      }
      return recommendations.map(rec => {
        if (typeof rec === 'string') {
          // If it's in string format, parse it into an object
        const parts = rec.split(':');
          return {
            title: parts[0] || '',
            content: parts[1] || rec,
            example: parts[2] || ''
          };
        }
        // If it's already in object format, return it directly
        return rec;
      });
    },
    generateSimpleTitle(recommendation) {
      // Generate a simple title from recommendation content
      const firstSentence = recommendation.split('.')[0];
      if (firstSentence.length > 15) {
        return firstSentence.substring(0, 15) + '...';
      }
      return firstSentence;
    },
    setupDefaultScenarios() {
      console.log('Using minimal default scenario data structure');
      this.scenarios = [
        {
          title: 'No Data Available',
          question: 'Cannot load scenario data from database',
          options: [
            { 
              text: 'Please check database connection and refresh the page',
              recommendations: ['Cannot load recommendation data. Please check database connection.']
            }
          ]
        }
      ];
    }
  },
  created() {
    // Fetch data when component is created
    console.log('App component created, starting to fetch data');
    this.fetchCategories();
  }
};
</script>

<style scoped>

.fullscreen-container {
  background-color: #F8EFED;
  min-height: 100vh;
  width: 100vw;
  overflow-x: hidden;
  display: flex;
  flex-direction: column;
}

.main-title-container {
  width: 100%;
  background-color: #f9f7f6;
  border-bottom: 1px solid rgba(0,0,0,0.05);
  box-shadow: 0 2px 10px rgba(0,0,0,0.03);
  padding: 1.5rem 0;
  margin-bottom: 1rem;
}

.scenarios-cards-container {
  max-width: 900px;
  margin: 1.5rem auto 0;
  padding: 0 15px;
  width: 100%;
}

.scenarios-cards-row {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  margin-bottom: 1.2rem;
  gap: 20px;
  width: 100%;
}

.scenario-card-item {
  background-color: #ffffff;
  border-radius: 12px;
  padding: 15px;
  box-shadow: 0 3px 8px rgba(0,0,0,0.1);
  width: calc(33.33% - 20px);
  height: 220px;
  display: flex;
  flex-direction: column;
  transition: all 0.3s ease;
  max-width: 280px;
  min-width: 250px;
}

.scenario-card-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 15px rgba(62, 92, 43, 0.15);
}

.card-title {
  color: #4d2f20;
  font-size: 1.1rem;
  font-weight: 600;
  margin: 10px 0;
  text-align: center;
}

.card-icon-placeholder {
  height: 60px;
  margin: 5px 0 10px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.scenario-icon {
  height: 60px;
  width: 60px;
  object-fit: contain;
  display: block;
}

.scenario-card-item:nth-child(3) .scenario-icon,
.scenario-card-item:nth-child(4) .scenario-icon,
.scenario-card-item:nth-child(6) .scenario-icon {
  transform: scale(1.5);
}

.card-description {
  font-size: 0.9rem;
  color: #4d2f20;
  text-align: center;
  margin-top: auto;
  line-height: 1.3;
}

.scenario-header {
  text-align: center;
}

.current-scenario-title {
  color: #3E5C2B;
  font-size: 1.6rem;
  font-weight: 600;
}

.sidebar-container {
  position: relative;
}

.sidebar-content {
  top: 0;
  padding: 0.5rem 2rem;
}

.center-title-container {
  padding: 1rem 1.5rem;
  background-color: #f9f7f6;
  border-radius: 12px;
  box-shadow: 0 3px 10px rgba(0,0,0,0.05);
  margin-bottom: 2rem;
}

.page-title {
  color: #4d2f20;
  font-size: 2.5rem;
  font-weight: bold;
}

.page-subtitle {
  color: #4d2f20;
  font-size: 1.2rem;
}

.scenario-intro {
  max-width: 90%;
  margin: 0 auto;
}

.intro-text {
  color: #4d2f20;
  margin-bottom: 1rem;
}

.scenario-bullets-container {
  display: flex;
  flex-direction: column;
  margin-bottom: 1rem;
}

.scenario-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.8rem;
}

.scenario-item {
  color: #3E5C2B;
  font-size: 1rem;
  flex: 1;
  text-align: left;
  padding-right: 10px;
}

.main-image-container {
  text-align: center;
  padding: 0 1rem;
  transition: all 0.5s ease;
  margin-top: 0;
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: visible;
}

.main-image {
  border-radius: 15px;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
  max-height: 500px;
  object-fit: contain;
  transition: transform 0.5s ease;
  width: 100%;
  max-width: 500px;
  height: auto;
}

.progress-container {
  margin-top: 1rem;
  width: 100%;
  margin-left: auto;
  margin-right: auto;
}

.progress-text, .progress-percentage {
  color: #4d2f20;
  font-weight: 600;
}

.progress {
  height: 8px;
  background-color: #E9E9E9;
  margin-bottom: 0.5rem;
  width: 100%;
  border-radius: 4px;
}

.progress-bar {
  background-color: #3E5C2B;
  transition: width 0.5s ease;
  border-radius: 4px;
}

.scenario-dots {
  display: flex;
  justify-content: space-between;
  margin-top: 0.5rem;
  width: 100%;
}

.scenario-dot {
  width: 14px;
  height: 14px;
  border-radius: 50%;
  background-color: #D8D8D8;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  margin: 0 3px;
}

.scenario-dot.active {
  background-color: #3E5C2B;
}

.scenario-dot.current {
  transform: scale(1.3);
  box-shadow: 0 0 0 3px rgba(77, 47, 32, 0.2);
}

.scenario-dot:hover .dot-tooltip {
  opacity: 1;
  visibility: visible;
}

.intro-dot {
  margin-right: 10px;
  background-color: #3E5C2B;
  width: 14px;
  height: 14px;
}

.dot-tooltip {
  position: absolute;
  top: -30px;
  left: 50%;
  transform: translateX(-50%);
  background-color: #333;
  color: white;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  white-space: nowrap;
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.3s ease;
  z-index: 10;
}

.dot-tooltip:after {
  content: '';
  position: absolute;
  top: 100%;
  left: 50%;
  margin-left: -5px;
  border-width: 5px;
  border-style: solid;
  border-color: #333 transparent transparent transparent;
}

.recommendations-heading {
  color: #4d2f20;
  font-weight: 600;
}

.recommendation-content {
  background-color: #FFFFFF;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.recommendation-subtitle {
  color: #3E5C2B;
  font-weight: 600;
}

.recommendation-cards {
  max-height: 70vh;
  overflow-y: auto;
  padding-right: 5px;
}

.recommendation-card {
  transition: all 0.3s ease;
  border-radius: 8px;
  overflow: hidden;
}

.recommendation-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
}

.card-header {
  background-color: #F7F0ED;
  border-radius: 8px 8px 0 0;
  cursor: pointer;
}

.rec-icon {
  color: #3E5C2B;
  font-size: 1.2rem;
  flex-shrink: 0;
}

.recommendation-title {
  color: #3E5C2B;
  font-weight: 600;
  font-size: 1.1rem;
}

.card-body .content {
  font-size: 1rem;
  line-height: 1.5;
  color: #3E5C2B;
}

.example {
  background-color: #F8F8F8;
  border-left: 3px solid #3E5C2B;
  border-radius: 4px;
  font-style: italic;
  color: #4d2f20;
}

.example-title {
  font-size: 0.9rem;
  font-weight: 500;
  color: #4d2f20;
}

.example-content {
  font-size: 0.9rem;
  color: #4d2f20;
}

.results-container {
  max-width: 1000px;
  margin: 0 auto;
}

.results-card {
  background-color: #FFFFFF;
  border-radius: 15px;
}

.results-title {
  color: #4d2f20;
  font-size: 2.2rem;
  font-weight: bold;
}

.results-intro {
  background-color: #F7F0ED;
  border-radius: 10px;
}

.results-intro-title {
  color: #4d2f20;
}

.scenario-number {
  background-color: #3E5C2B;
  color: white;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  margin-right: 15px;
}

.scenario-result-title {
  color: #3E5C2B;
  font-weight: 600;
  margin-bottom: 0;
}

.scenario-result-question {
  color: #3E5C2B;
}

.selected-option-box {
  background-color: #F8F8F8;
  border-left: 4px solid #3E5C2B;
  border-radius: 8px;
}

.selected-option-title {
  color: #3E5C2B;
  font-weight: 600;
}

.recommendations-summary-title {
  color: #3E5C2B;
  font-weight: 600;
  margin-bottom: 15px;
}

.recommendation-item {
  background-color: #FFFFFF;
  border: 1px solid #E0E0E0;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.recommendation-item:hover {
  box-shadow: 0 4px 12px rgba(77, 47, 32, 0.1);
}

.recommendation-item-title {
  color: #3E5C2B;
  font-weight: 600;
}

.handbook-button {
  background-color: #3E5C2B;
  color: white;
  border-radius: 8px;
  transition: all 0.3s ease;
  padding: 10px 20px;
  border: none;
}

.handbook-button:hover {
  background-color: #3E5C2B;
  box-shadow: 0 4px 10px rgba(77, 47, 32, 0.3);
  transform: translateY(-2px);
}

.recommendation-cards::-webkit-scrollbar {
  width: 8px;
}

.recommendation-cards::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 10px;
}

.recommendation-cards::-webkit-scrollbar-thumb {
  background: #3E5C2B;
  border-radius: 10px;
}

.recommendation-cards::-webkit-scrollbar-thumb:hover {
  background: #5a873f;
}

.recommendation-container {
  animation: fadeIn 0.5s;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

@media (max-width: 768px) {
  .row {
    flex-direction: column;
  }
  
  .main-image {
    max-height: 350px;
    margin-bottom: 1.5rem;
    width: 90%;
  }
  
  .recommendation-cards {
    max-height: 50vh;
  }
  
  .scenarios-cards-row {
    flex-direction: column;
    align-items: center;
    gap: 20px;
  }
  
  .scenario-card-item {
    width: 100%;
    max-width: 280px;
    height: 200px;
    margin: 0;
  }
  
  .card-title {
    font-size: 1rem;
  }
  
  .card-description {
    font-size: 0.85rem;
  }
}

@media (min-width: 769px) and (max-width: 1024px) {
  .scenarios-cards-row {
    justify-content: center;
  }
  
  .scenario-card-item {
    width: calc(50% - 20px);
    max-width: 300px;
  }
}

@media print {
  .back-button {
    display: none;
  }
  
  .results-container {
    padding: 0;
    max-width: 100%;
  }
  
  .results-card {
    box-shadow: none !important;
    border: none !important;
  }
  
  body {
    font-size: 12pt;
  }
  
  h1 {
    font-size: 18pt !important;
  }
  
  h2 {
    font-size: 16pt !important;
  }
  
  h3 {
    font-size: 14pt !important;
  }
}

.sleep-scene-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.sleep-scene-content {
  background-color: #ffffff;
  width: 95%;
  height: 95vh;
  max-width: 1400px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.3);
  display: flex;
  flex-direction: column;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.5rem;
  border-bottom: 1px solid #e0e0e0;
  background-color: #F7F0ED;
}

.modal-title {
  color: #3E5C2B;
  margin: 0;
  font-size: 1.5rem;
}

.close-btn {
  background: none;
  border: none;
  font-size: 2rem;
  cursor: pointer;
  color: #4d2f20;
  transition: all 0.2s ease;
}

.close-btn:hover {
  transform: scale(1.1);
  color: #3E5C2B;
}

.modal-body {
  padding: 0;
  flex: 1;
  overflow-y: auto;
}

.modal-footer {
  padding: 1rem 1.5rem;
  border-top: 1px solid #e0e0e0;
  display: flex;
  justify-content: flex-end;
  background-color: #F7F0ED;
}

.thank-you-section {
  background-color: #f9f7f6;
  border-radius: 15px;
  border-left: 4px solid #3E5C2B;
  padding: 2rem !important;
  box-shadow: 0 3px 10px rgba(0,0,0,0.05);
}

.thank-you-section h3 {
  color: #3E5C2B;
  font-size: 1.8rem;
  font-weight: 600;
  margin-bottom: 1.5rem;
}

.thank-you-section p {
  font-size: 1.1rem;
  line-height: 1.8;
  color: #4d2f20;
}

.thank-you-section p:last-child {
  font-style: italic;
  font-weight: 500;
  color: #3E5C2B;
}

.loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.loading-content {
  background-color: #ffffff;
  padding: 2rem;
  border-radius: 10px;
  text-align: center;
}

.loading-spinner {
  margin-bottom: 1rem;
}

.loading-text {
  color: #4d2f20;
  font-size: 1.2rem;
  font-weight: 600;
}

.retry-button {
  background-color: #3E5C2B;
  color: white;
  border-radius: 8px;
  transition: all 0.3s ease;
  padding: 10px 20px;
  border: none;
}

.retry-button:hover {
  background-color: #3E5C2B;
  box-shadow: 0 4px 10px rgba(77, 47, 32, 0.3);
  transform: translateY(-2px);
}

.error-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.error-content {
  background-color: #ffffff;
  padding: 2rem;
  border-radius: 10px;
  text-align: center;
}

.error-icon {
  margin-bottom: 1rem;
}

.error-title {
  color: #4d2f20;
  font-size: 1.8rem;
  font-weight: 600;
  margin-bottom: 1.5rem;
}

.error-text {
  color: #4d2f20;
  font-size: 1.2rem;
  font-weight: 600;
}

.error-actions {
  margin-bottom: 1.5rem;
}

.default-button {
  background-color: #3E5C2B;
  color: white;
  border-radius: 8px;
  transition: all 0.3s ease;
  padding: 10px 20px;
  border: none;
  margin-left: 10px;
}

.default-button:hover {
  background-color: #3E5C2B;
  box-shadow: 0 4px 10px rgba(77, 47, 32, 0.3);
  transform: translateY(-2px);
}

.error-help {
  color: #4d2f20;
  font-size: 1.1rem;
  font-weight: 500;
  margin-bottom: 1.5rem;
}

.error-tips {
  list-style: none;
  padding: 0;
  margin: 0;
}

.error-tips li {
  color: #4d2f20;
  font-size: 1.1rem;
  font-weight: 500;
  margin-bottom: 0.5rem;
}

.error-tips li {
  color: #4d2f20;
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
  text-align: left;
}

.error-tips code {
  background-color: #f5f5f5;
  border-radius: 3px;
  font-family: monospace;
  padding: 2px 4px;
  color: #d63031;
}

.loading-subtext {
  color: #666;
  font-size: 1rem;
  margin-top: 0.5rem;
}

.icon {
  margin-right: 5px;
}

.larger-icon {
  transform: scale(1.4);
}

.attribution-line {
  text-align: center;
  font-size: 0.85rem;
  color: #666;
  margin-top: 1.5rem;
  margin-bottom: 0.5rem;
  padding: 0 15px;
}

.attribution-line a {
  color: #3E5C2B;
  text-decoration: none;
}

.attribution-line a:hover {
  text-decoration: underline;
}

.green-text {
  color: #3E5C2B;
}

/* 幻灯片相关样式 */
.slider-container {
  position: relative;
  width: 100%;
  flex: 1;
  overflow: hidden;
}

.slider-page {
  width: 100%;
  transition: transform 0.8s ease, opacity 0.8s ease;
  position: relative;
}

.slide-out {
  transform: translateX(-100%);
  opacity: 0;
  pointer-events: none;
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
}

.slide-in {
  transform: translateX(0);
  opacity: 1;
}

.hidden {
  display: none;
}

.start-journey-section {
  background-color: #F8EFED;
  padding: 2rem 0 4rem;
  margin-top: 2rem;
}

.intro-image-container {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
}

.intro-image {
  max-width: 100%;
  border-radius: 15px;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

.intro-content-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 2rem;
}

.intro-title {
  color: #4d2f20;
  font-size: 2.2rem;
  font-weight: 600;
  margin-bottom: 1.5rem;
}

.intro-description {
  color: #4d2f20;
  font-size: 1.1rem;
  line-height: 1.6;
  margin-bottom: 1.5rem;
}

.start-journey-button {
  background-color: #3E5C2B;
  color: white;
  font-size: 1.3rem;
  padding: 12px 30px;
  border-radius: 8px;
  border: none;
  transition: all 0.3s ease;
  align-self: flex-start;
  margin-top: 1rem;
}

.start-journey-button:hover {
  background-color: #2c4320;
  transform: translateY(-3px);
  box-shadow: 0 8px 15px rgba(62, 92, 43, 0.3);
}

.return-home-btn-container {
  position: absolute;
  top: 20px;
  left: 20px;
  z-index: 10;
}

.return-home-btn {
  background-color: #5a6268;
  color: white;
  border-radius: 8px;
  transition: all 0.3s ease;
  padding: 8px 16px;
  border: none;
  font-size: 1rem;
}

.return-home-btn:hover {
  background-color: #444b52;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.15);
}

.scenario-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background-color: #D8D8D8;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
}

.scenario-dot.active {
  background-color: #3E5C2B;
}

.scenario-dot.current {
  transform: scale(1.3);
  box-shadow: 0 0 0 3px rgba(77, 47, 32, 0.2);
}

.scenario-dot:hover .dot-tooltip {
  opacity: 1;
  visibility: visible;
}

.intro-dot {
  margin-right: 10px;
  background-color: #3E5C2B;
  width: 14px;
  height: 14px;
}

.dot-tooltip {
  position: absolute;
  top: -30px;
  left: 50%;
  transform: translateX(-50%);
  background-color: #333;
  color: white;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  white-space: nowrap;
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.3s ease;
  z-index: 10;
}

.dot-tooltip:after {
  content: '';
  position: absolute;
  top: 100%;
  left: 50%;
  margin-left: -5px;
  border-width: 5px;
  border-style: solid;
  border-color: #333 transparent transparent transparent;
}

@media (max-width: 768px) {
  .intro-content-container {
    padding: 1rem;
  }
  
  .intro-title {
    font-size: 1.8rem;
    margin-top: 1rem;
  }
  
  .intro-description {
    font-size: 1rem;
  }
  
  .start-journey-button {
    font-size: 1.1rem;
    padding: 10px 20px;
    align-self: center;
  }
  
  .return-home-btn-container {
    top: 10px;
    left: 10px;
  }
  
  .return-home-btn {
    font-size: 0.85rem;
    padding: 6px 12px;
  }
}

.attribution-line.text-left {
  text-align: left;
  margin-top: 0;
}

.scenario-page-header {
  position: relative;
  width: 100%;
  padding: 0.7rem 0;
  margin-bottom: 0.5rem;
  background-color: #F8EFED;
  border-bottom: 1px solid rgba(0,0,0,0.05);
  box-shadow: 0 2px 5px rgba(0,0,0,0.03);
}

.scenario-page-title {
  color: #3E5C2B;
  font-size: 1.8rem;
  font-weight: 600;
  margin: 0;
  padding: 0.3rem 0;
}

.return-home-btn-container {
  position: absolute;
  top: 50%;
  left: 20px;
  transform: translateY(-50%);
  z-index: 10;
}

.return-home-btn {
  background-color: #5a6268;
  color: white;
  border-radius: 8px;
  transition: all 0.3s ease;
  padding: 8px 16px;
  border: none;
  font-size: 1rem;
}

.return-home-btn:hover {
  background-color: #444b52;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.15);
}

@media (max-width: 768px) {
  .scenario-page-title {
    font-size: 1.4rem;
    padding: 0.5rem 70px;
  }
  
  .return-home-btn {
    padding: 6px 12px;
    font-size: 0.85rem;
  }
}

.content-card {
  background-color: #F8EFED;
  border-radius: 15px;
  margin: 1rem 2rem 2rem;
}

.scenario-title {
  color: #4d2f20;
  font-size: 1.2rem;
  font-weight: 500;
}

.scenario-question {
  color: #4d2f20;
  font-size: 1.8rem;
  font-weight: 600;
}

.option-card {
  border-left: 4px solid #3E5C2B;
  background-color: #FFFFFF;
  border-radius: 8px;
  transition: all 0.3s ease;
  font-size: 1.2rem;
  color: #333333;
  position: relative;
  overflow: hidden;
  cursor: pointer;
}

.option-card:hover {
  transform: translateX(5px);
  background-color: #F7F0ED;
  box-shadow: 0 4px 8px rgba(77, 47, 32, 0.1);
}

.selected-option {
  background-color: #F7F0ED;
  transform: translateX(5px);
  box-shadow: 0 4px 8px rgba(77, 47, 32, 0.1);
}

.option-indicator {
  width: 20px;
  height: 20px;
  border-radius: 50%;
  border: 2px solid #4d2f20;
  flex-shrink: 0;
  position: relative;
}

.selected-indicator::after {
  content: '';
  position: absolute;
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background-color: #3E5C2B;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.option-text {
  color: #4d2f20;
}

.action-button {
  background-color: #3E5C2B;
  color: white;
  font-size: 1.2rem;
  border-radius: 8px;
  transition: all 0.3s ease;
  border: none;
}

.action-button:hover:not(:disabled) {
  background-color: #3E5C2B;
  box-shadow: 0 4px 10px rgba(77, 47, 32, 0.3);
  transform: translateY(-2px);
}

.action-button:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

.back-button {
  background-color: #5a6268;
  color: white;
  border-radius: 8px;
  transition: all 0.3s ease;
  padding: 10px 20px;
  border: none;
}

.back-button:hover {
  background-color: #444b52;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.15);
}

.next-button, .finish-button {
  background-color: #3E5C2B;
  color: white;
  font-size: 1.1rem;
  border-radius: 8px;
  transition: all 0.3s ease;
  padding: 10px 20px;
  border: none;
}

.next-button:hover, .finish-button:hover {
  background-color: #3E5C2B;
  box-shadow: 0 4px 10px rgba(77, 47, 32, 0.3);
  transform: translateY(-2px);
}

</style>



