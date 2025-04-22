<template>
  <div class="scene-container">
    <div v-if="option === null && !selectedOption">
      <h1 class="title">🍽️ Diet and Nutrition Issues</h1>
      <p class="question">
        During mealtimes, how does your child typically behave?
      </p>

      <div class="option" 
           v-for="(opt, index) in options" 
           :key="index" 
           @click="selectOption(index)">
        <input type="radio" :id="'opt' + index" :value="index" v-model="selected">
        <label :for="'opt' + index">{{ opt.label }}</label>
      </div>

      <button class="view-btn" :disabled="selected === null" @click="showScene">
        View Scenario Scene
      </button>
    </div>

    <div v-else class="scenario-container">
      <h2 class="drama-title">{{ currentScene.title }}</h2>
      
      <div class="scenario-content">
        <!-- Left image area -->
        <div class="image-section">
          <img :src="currentScene.image" alt="Scenario Illustration" class="illustration" />
        </div>
        
        <!-- Right dialogue and advice area -->
        <div class="dialogue-section">
          <div class="dialogue-bubbles">
            <div class="parent-bubble">
              <span class="speaker-label parent-label">Parent:</span>
              <p>{{ currentScene.parentDialogue }}</p>
            </div>
            <div class="child-bubble">
              <span class="speaker-label child-label">Child:</span>
              <p>{{ currentScene.childDialogue }}</p>
            </div>
          </div>
          
          <div class="advice-section" v-if="!showAdvice">
            <button class="advice-btn" @click="showAdvice = true">What should I do in this situation?</button>
          </div>
          
          <div class="advice-content" v-else>
            <h3>Parent Advice</h3>
            <!-- loading -->
            <div v-if="loading" class="loading-indicator">
              Loading recommendations...
            </div>
            
            <!-- error -->
            <div v-else-if="error" class="error-message">
              {{ error }}
            </div>
            
            <!-- recommendation -->
            <p v-else>{{ currentAdvice }}</p>
            <div class="advice-progress">
              {{ adviceProgress }}
            </div>
            <div class="advice-navigation">
              <button 
                class="advice-btn" 
                @click="prevAdvice" 
                v-if="currentAdviceIndex > 0">
                &larr; Previous
              </button>
              <div v-else class="placeholder-btn"></div>
              <button 
                class="advice-btn" 
                @click="nextAdvice" 
                v-if="currentAdviceIndex < totalAdvices - 1">
                Next &rarr;
              </button>
              <div v-else class="placeholder-btn"></div>
            </div>
            
            <!-- Show continue button after reading all advice -->
            <div v-if="hasReadAllAdvice" class="next-scenario-container">
              <button class="continue-btn" @click="goToNextScenario">
                Continue to Next Scene
              </button>
            </div>
          </div>
        </div>
      </div>
      
      <div class="button-group">
        <button v-if="option === null" class="back-btn" @click="reset">Back to Options</button>
      </div>
    </div>
  </div>
</template>

<script>
import DietOption0 from '@/assets/diet-option0.png';
import DietOption1 from '@/assets/diet-option1.png';
import DietOption2 from '@/assets/diet-option2.png';
import DietOption3 from '@/assets/diet-option3.png';

export default {
  props: {
    option: {
      type: Number,
      default: null
    }
  },
  data() {
    return {
      selected: null,
      selectedOption: null,
      showAdvice: false,
      currentAdviceIndex: 0,
      hasViewedLastAdvice: false,
      loading: false,
      error: null,
      options: [
        {
          label: 'Option 0: Refuses to try new foods, only eats a few specific foods',
          title: '🥦 "Just a tiny taste" courage',
          parentDialogue: 'Today we placed a little "dinosaur vegetable" (broccoli) next to your favorite chicken. You can just look at it or smell it first, no need to eat it if you don\'t want to.',
          childDialogue: 'I don\'t want to eat this! I don\'t like green things.',
          advices: [],
          image: DietOption0
        },
        {
          label: 'Option 1: Extremely sensitive to food texture or taste',
          title: '🍩 "Soft and crunchy adventures"',
          parentDialogue: 'It\'s a bit like the cookies you love, just a different color.',
          childDialogue: '*Licks it cautiously* It tastes strange...',
          advices: [],
          image: DietOption1
        },
        {
          label: 'Option 2: Needs toys or devices for distraction during meals',
          title: '📴 "Today we companion with food, not toys"',
          parentDialogue: 'You can play with your car after you finish eating. By the way, your teacher said your drawing of the sun was beautiful today!',
          childDialogue: 'Reluctantly starts eating while glancing at the toy car',
          advices: [],
          image: DietOption2
        },
        {
          label: 'Option 3: Irregular eating times or difficulty sitting calmly at the table',
          title: '⏰ "Racing with the little hourglass"',
          parentDialogue: 'Tick tock, the timer has started! Can you finish your bite before all the sand falls to the bottom?',
          childDialogue: 'I want to finish before the sand runs out! Takes bites while watching the timer',
          advices: [],
          image: DietOption3
        }
      ]
    };
  },
  computed: {
    currentScene() {
      return this.options[this.selectedOption || 0];
    },
    totalAdvices() {
      return this.currentScene.advices.length;
    },
    currentAdvice() {
      return this.currentScene.advices[this.currentAdviceIndex];
    },
    adviceProgress() {
      return `Advice ${this.currentAdviceIndex + 1}/${this.totalAdvices}`;
    },
    hasReadAllAdvice() {
      return this.hasViewedLastAdvice;
    }
  },
  watch: {
    option: {
      immediate: true,
      handler(val) {
        if (val !== null) {
          this.selectedOption = val;
          this.currentAdviceIndex = 0;
          this.hasViewedLastAdvice = false;
        }
      }
    },
    currentAdviceIndex(newVal) {
      // When the user views the last advice, mark all advice as read
      if (newVal === this.totalAdvices - 1) {
        this.hasViewedLastAdvice = true;
      }
    }
  },
  methods: {
    selectOption(index) {
      this.selected = index;
    },
    async showScene() {
      const selectedOption = this.options[this.selected];
      this.selectedOption = this.selected;
      this.showAdvice = false; 
      this.currentAdviceIndex = 0;
      this.hasViewedLastAdvice = false;
      this.error = null;  // Reset error state

      // Only fetch data if the advice array is empty
      if (selectedOption.advices.length === 0) {
        try {
          this.loading = true;  // Set loading state
          console.log(`Fetching recommendation data for diet option ID ${this.selected + 5}`); // Diet options start from ID 5
          
          // Note: Diet option IDs start from 5, need to add 5, because Sleep scenario uses 1-4
          const res = await fetch(`http://localhost:3000/api/recommendations/${this.selected + 5}`);
          
          if (!res.ok) {
            throw new Error(`API returned error: ${res.status}`);
          }
          
          const data = await res.json();
          console.log('Retrieved recommendation data:', data);
          
          if (data && data.length > 0) {
            // Transform API returned data into required format
            selectedOption.advices = data.map(item => 
              `${item.title}: ${item.content}\n\nExample: ${item.example}`
            );
            console.log('Transformed recommendations:', selectedOption.advices);
          } else {
            console.warn('API returned empty data');
            // Set a default message
            selectedOption.advices = ['No recommendations available for this option.'];
            this.error = 'No recommendations found for this option.';
          }
        } catch (err) {
          console.error('Failed to fetch recommendations:', err);
          // Set error message
          selectedOption.advices = ['Unable to load recommendations. Please try again later.'];
          this.error = `Failed to load recommendations: ${err.message}`;
        } finally {
          this.loading = false;  // Close loading state regardless of success or failure
        }
      }
    },
    reset() {
      this.selected = null;
      this.selectedOption = null;
      this.showAdvice = false;
      this.currentAdviceIndex = 0;
      this.hasViewedLastAdvice = false;
    },
    nextAdvice() {
      if (this.currentAdviceIndex < this.totalAdvices - 1) {
        this.currentAdviceIndex++;
      }
    },
    prevAdvice() {
      if (this.currentAdviceIndex > 0) {
        this.currentAdviceIndex--;
      }
    },
    goToNextScenario() {
      console.log('DietScene: Triggering next-scenario event');
      
      this.$emit('next-scenario');
      
      setTimeout(() => {
        console.log('DietScene: Delayed re-triggering of next-scenario event');
        this.$emit('next-scenario');
        this.$emit('close-modal');
      }, 50);
      
      this.$emit('close-modal');
    }
  },
  async created() {
    // Preload recommendation data for all options when component is created
    console.log('DietScene component created, preparing to preload recommendation data');
    for (let i = 0; i < this.options.length; i++) {
      const option = this.options[i];
      if (option.advices.length === 0) {
        try {
          // Diet options start from ID 5
          const optionId = i + 5;
          console.log(`Preloading recommendation data for diet option ${optionId}`);
          const res = await fetch(`http://localhost:3000/api/recommendations/${optionId}`);
          if (res.ok) {
            const data = await res.json();
            if (data && data.length > 0) {
              option.advices = data.map(item => 
                `${item.title}: ${item.content}\n\nExample: ${item.example}`
              );
              console.log(`Diet option ${optionId} preloaded ${data.length} recommendations`);
            } else {
              console.warn(`Diet option ${optionId} has no recommendation data`);
            }
          } else {
            console.error(`Failed to preload diet option ${optionId}: ${res.status}`);
          }
        } catch (err) {
          console.error(`Error preloading recommendations for diet option ${i + 5}:`, err);
        }
      }
    }
  }
};
</script>

<style scoped>
.scene-container {
  padding: 1.5rem;
  max-width: 100%;
  margin: auto;
  font-family: 'Arial', sans-serif;
  height: calc(100% - 3rem);
  display: flex;
  flex-direction: column;
}
.title {
  font-size: 1.8rem;
  color: #4d2f20;
}
.question {
  font-size: 1.1rem;
  margin-bottom: 1.5rem;
}
.option {
  margin-bottom: 1rem;
  padding: 1rem;
  background: #fff;
  border: 2px solid #3e5c2b;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s ease;
}
.option:hover {
  background: #f0f0f0;
}
.view-btn {
  margin-top: 1rem;
  padding: 0.8rem 1.2rem;
  background: #3e5c2b;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
}
.view-btn:disabled {
  background: #aaa;
  cursor: not-allowed;
}

/* Scenario Scene Styles */
.scenario-container {
  margin-top: 0;
  flex: 1;
  display: flex;
  flex-direction: column;
}
.drama-title {
  font-size: 1.5rem;
  margin-bottom: 1.5rem;
  color: #3e5c2b;
  text-align: center;
}
.scenario-content {
  display: flex;
  gap: 2rem;
  margin-top: 1rem;
  flex: 1;
}
.image-section {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}
.dialogue-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
}
.illustration {
  width: 100%;
  max-height: 70vh;
  object-fit: contain;
  border-radius: 12px;
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

/* Dialogue Bubbles Styles */
.dialogue-bubbles {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}
.parent-bubble, .child-bubble {
  padding: 1rem;
  border-radius: 16px;
  position: relative;
  max-width: 90%;
}
.parent-bubble {
  background-color: #e8f4ea;
  align-self: flex-start;
  border-bottom-left-radius: 4px;
}
.child-bubble {
  background-color: #f4e9e8;
  align-self: flex-end;
  border-bottom-right-radius: 4px;
}
.parent-bubble p, .child-bubble p {
  margin: 0;
  font-size: 0.95rem;
  padding-left: 0.2rem;
}

.speaker-label {
  font-weight: 600;
  font-size: 0.9rem;
  margin-bottom: 0.3rem;
  display: block;
}

.parent-label {
  color: #3E5C2B;
}

.child-label {
  color: #CD5C5C;
}

/* Advice Section Styles */
.advice-section {
  margin-top: 0.8rem;
  text-align: center;
}
.advice-btn {
  padding: 0.7rem 1.2rem;
  margin: 0 0.5rem;
  background: #3E5C2B;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 0.9rem;
  transition: all 0.2s ease;
}
.advice-btn:hover {
  background: #4d7537;
  transform: translateY(-2px);
}
.advice-content {
  margin-top: 0.8rem;
  padding: 1.2rem;
  background: #f7f7f7;
  border-radius: 10px;
  border-left: 4px solid #3E5C2B;
  position: relative;
  min-height: 180px;
  display: flex;
  flex-direction: column;
}
.advice-content h3 {
  color: #3E5C2B;
  margin-top: 0;
  margin-bottom: 0.8rem;
  font-size: 1.3rem;
}
.advice-content p {
  margin: 0;
  line-height: 1.6;
  font-size: 1rem;
  flex: 1;
  padding: 0.5rem;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

.advice-progress {
  margin: 1rem 0;
  font-size: 0.9rem;
  color: #666;
  font-weight: 500;
}

.advice-navigation {
  display: flex;
  justify-content: space-between;
  margin-top: 1rem;
  width: 100%;
}

.placeholder-btn {
  width: 120px;
  visibility: hidden;
}

/* Button Group Styles */
.button-group {
  display: flex;
  justify-content: space-around;
  margin-top: 1.5rem;
  gap: 1rem;
}

.back-btn, .next-btn {
  padding: 0.7rem 1.2rem;
  border: 2px solid #3e5c2b;
  border-radius: 8px;
  cursor: pointer;
  font-size: 0.95rem;
  transition: all 0.2s ease;
  flex: 1;
  max-width: 200px;
}

.back-btn {
  background: white;
  color: #3e5c2b;
}

.next-btn {
  background: #3e5c2b;
  color: white;
  border: 2px solid #3e5c2b;
  border-radius: 8px;
  cursor: pointer;
  font-size: 1.1rem;
  transition: all 0.2s ease;
  flex: 1;
  max-width: 200px;
  font-weight: bold;
  padding: 0.8rem 1.5rem;
  box-shadow: 0 4px 8px rgba(0,0,0,0.2);
  position: relative;
  overflow: hidden;
}

.next-btn::after {
  content: "→";
  position: absolute;
  right: 15px;
  transition: all 0.3s ease;
}

.next-btn:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 12px rgba(0,0,0,0.3);
  background-color: #4d7537;
}

.next-btn:hover::after {
  right: 10px;
}

.next-btn:active {
  transform: scale(0.95);
  background-color: #2a4015;
}

.button-clicked {
  background-color: #2a4015 !important;
  transform: scale(0.95) !important;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2) !important;
}

/* Responsive Design */
@media (max-width: 768px) {
  .scenario-content {
    flex-direction: column;
  }
  .image-section, .dialogue-section {
    width: 100%;
  }
}

/* Continue to Next Scene Button Styles */
.next-scenario-container {
  margin-top: 1.5rem;
  text-align: center;
}

.continue-btn {
  background-color: #3E5C2B;
  color: white;
  font-size: 1.1rem;
  border-radius: 8px;
  transition: all 0.3s ease;
  padding: 10px 25px;
  border: 2px solid #3E5C2B;
  cursor: pointer;
  font-weight: 600;
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

.continue-btn:hover {
  background-color: #3E5C2B;
  box-shadow: 0 4px 10px rgba(77, 47, 32, 0.3);
  transform: translateY(-2px);
}

/* Loading Indicator Styles */
.loading-indicator {
  margin-bottom: 0.5rem;
  font-size: 0.9rem;
  color: #666;
}

/* Error Message Styles */
.error-message {
  margin-bottom: 0.5rem;
  font-size: 0.9rem;
  color: #d33;
}
</style>
