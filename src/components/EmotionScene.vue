<template>
  <div class="scene-container">
    <div v-if="option === null && !selectedOption">
      <h1 class="title">😢 Emotional and Behavioral Management Issues</h1>
      <p class="question">
        Which of the following best describes your child's situation when facing frustration?
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
          <img 
            :src="currentScene.image" 
            alt="Scenario illustration" 
            class="illustration" 
            :onerror="`this.onerror=null; this.src='${basePublicPath}/scenario-4.jpg';`"
          />
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
            <div v-if="loading" class="loading-indicator">
              Loading recommendations...
            </div>
          
            <div v-else-if="error" class="error-message">
              {{ error }}
            </div>
            
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
import EmotionOption0 from '@/assets/emotion-option0.png';
import EmotionOption1 from '@/assets/emotion-option1.png';
import EmotionOption2 from '@/assets/emotion-option2.png';
import EmotionOption3 from '@/assets/emotion-option3.png';

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
      basePublicPath: '',
      options: [
        {
          label: 'Option 0: Emotions quickly collapse into crying and screaming, difficult to comfort',
          title: '🫧 "Breathe — Let\'s Breathe Together"',
          parentDialogue: 'Ethan, let\'s use the "smell the flower, blow out the candle" method. Breathe in—and breathe out... Let\'s rebuild it together, okay?',
          childDialogue: '(Ethan accidentally knocked down his block tower while playing, and immediately his eyes turned red as he burst into tears. Gradually calming down, he nods and begins to rearrange the blocks)',
          advices: [],
          image: EmotionOption0
        },
        {
          label: 'Option 1: Often shows pushing, hitting, or throwing things as aggressive behaviors',
          title: '🛏️ "Hit the Pillow, Not People"',
          parentDialogue: 'Sweetie, hit this instead, not people. You were really angry just now, but you didn\'t hit your brother, you hit the cushion instead. Mom is proud of you.',
          childDialogue: '(When his brother grabbed his puzzle, Ethan raised his fist angrily. He forcefully hit the cushion several times, cried a bit, and gradually calmed down)',
          advices: [],
          image: EmotionOption1
        },
        {
          label: 'Option 2: Tries to escape, hide, or refuse to face difficult scenarios',
          title: '🚪 "Bravery Beginning at the Doorway"',
          parentDialogue: 'Today we\'re just going in to look, not getting a haircut. You came inside today, that\'s braver than last time.',
          childDialogue: '(Stopped at the sight of the hair salon, frowning. Went in and sat for a while, looking at the lights and chairs, and came out after a few minutes. Didn\'t speak, but smiled a little)',
          advices: [],
          image: EmotionOption2
        },
        {
          label: 'Option 3: Rarely expresses emotions actively, more often silent or self-enclosed',
          title: '🎨 "Feelings Drawn on Paper"',
          parentDialogue: 'Today feels like a rainy mood, right? Mom is here, and if you want to say anything, just let me know anytime.',
          childDialogue: '(Returned from school without saying a word, quietly took out drawing paper and drew a dark cloud. Nodded gently)',
          advices: [],
          image: EmotionOption3
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
      this.error = null;

      if (selectedOption.advices.length === 0) {
        try {
          this.loading = true;
          const optionId = this.selected + 13;
          console.log(`Attempting to fetch recommendation data for Emotion option ${optionId}`);
          
          const res = await fetch(`/api/recommendations/${optionId}`);
          
          if (!res.ok) {
            throw new Error(`API returned error: ${res.status}`);
          }
          
          const data = await res.json();
          console.log(`Emotion option ${optionId} received recommendation data:`, data);
          
          if (data && data.length > 0) {
            // Check if data format is as expected
            if (data[0].title && data[0].content) {
              selectedOption.advices = data.map(item => 
                `${item.title}: ${item.content}${item.example ? '\n\nExample: ' + item.example : ''}`
              );
              console.log('Converted recommendations:', selectedOption.advices);
            } else {
              throw new Error('API returned data format not as expected');
            }
          } else {
            console.warn('API returned empty data');
            selectedOption.advices = ['No relevant recommendations found. Please contact administrator to add data.'];
            this.error = 'No recommendation data found';
          }
        } catch (err) {
          console.error('Failed to fetch recommendations:', err);
          selectedOption.advices = ['Failed to fetch recommendation data. Please try again later.'];
          this.error = `Failed to fetch recommendations: ${err.message}`;
        } finally {
          this.loading = false;
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
    goToNextScenario(event) {
      console.log('EmotionScene: Triggering next-scenario event');
      
      if (event && event.currentTarget) {
        event.currentTarget.classList.add('button-clicked');
        setTimeout(() => {
          event.currentTarget.classList.remove('button-clicked');
        }, 200);
      }
      
      this.$emit('next-scenario');
      
      setTimeout(() => {
        console.log('EmotionScene: Delayed re-triggering of next-scenario event');
        this.$emit('next-scenario');
        this.$emit('close-modal');
      }, 50);
      
      this.$emit('close-modal');
    }
  },
  async created() {
    // 确定当前的基础路径
    const currentPath = window.location.pathname;
    if (currentPath.includes('/iteration1/')) {
      this.basePublicPath = '/iteration1';
    } else if (currentPath.includes('/iteration2/')) {
      this.basePublicPath = '/iteration2';
    } else {
      this.basePublicPath = '';
    }
    console.log('EmotionScene - Base public path:', this.basePublicPath);
    
    console.log('EmotionScene component created, preparing to preload recommendation data');
    
    // Preload recommendation data for each option
    for (let i = 0; i < this.options.length; i++) {
      const option = this.options[i];
      if (option.advices.length === 0) {
        try {
          const optionId = i + 13;
          console.log(`Preloading recommendations for Emotion option ${optionId}`);
          const res = await fetch(`/api/recommendations/${optionId}`);
          if (res.ok) {
            const data = await res.json();
            if (data && data.length > 0) {
              option.advices = data.map(item => 
                `${item.title}: ${item.content}${item.example ? '\n\nExample: ' + item.example : ''}`
              );
              console.log(`Emotion option ${optionId} preloaded with ${data.length} recommendations`);
            } else {
              console.warn(`Emotion option ${optionId} has no recommendation data`);
              option.advices = ['No relevant recommendations found. Please contact administrator to add data.'];
            }
          } else {
            console.error(`Failed to preload Emotion option ${optionId}: ${res.status}`);
            option.advices = ['Failed to fetch recommendation data. Please try again later.'];
          }
        } catch (err) {
          console.error(`Error when preloading recommendations for Emotion option ${i + 13}:`, err);
          option.advices = ['Failed to fetch recommendation data. Please try again later.'];
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

.button-group {
  display: flex;
  justify-content: space-around;
  margin-top: 1.5rem;
  gap: 1rem;
}

.back-btn {
  padding: 0.7rem 1.2rem;
  border: 2px solid #3e5c2b;
  border-radius: 8px;
  cursor: pointer;
  font-size: 0.95rem;
  transition: all 0.2s ease;
  flex: 1;
  max-width: 200px;
  background: white;
  color: #3e5c2b;
}

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
  position: relative;
}

.continue-btn::after {
  content: '→';
  position: absolute;
  right: 10px;
  opacity: 0;
  transition: all 0.3s ease;
}

.continue-btn:hover {
  background-color: #4d7537;
  box-shadow: 0 4px 10px rgba(77, 47, 32, 0.3);
  transform: translateY(-2px);
  padding-right: 35px;
}

.continue-btn:hover::after {
  opacity: 1;
  right: 15px;
}

.button-clicked {
  transform: scale(0.95);
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}


.loading-indicator {
  margin-bottom: 0.5rem;
  font-size: 0.9rem;
  color: #666;
}

.error-message {
  margin-bottom: 0.5rem;
  font-size: 0.9rem;
  color: #d33;
}

@media (max-width: 768px) {
  .scenario-content {
    flex-direction: column;
  }
  .image-section, .dialogue-section {
    width: 100%;
  }
}
</style>
