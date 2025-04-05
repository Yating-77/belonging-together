<template>
  <div class="scene-container">
    <div v-if="option === null && !selectedOption">
      <h1 class="title">🔊 Communication and Language Issues</h1>
      <p class="question">
        Which of the following best describes your child's communication situation?
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
              <p>{{ currentScene.parentDialogue }}</p>
            </div>
            <div class="child-bubble">
              <p>{{ currentScene.childDialogue }}</p>
            </div>
          </div>
          
          <div class="advice-section" v-if="!showAdvice">
            <button class="advice-btn" @click="showAdvice = true">What should I do in this situation?</button>
          </div>
          
          <div class="advice-content" v-else>
            <h3>Parent Advice</h3>
            <p>{{ currentAdvice }}</p>
            <div class="advice-progress">
              {{ adviceProgress }}
            </div>
            <div class="advice-navigation">
              <button class="advice-btn" 
                      @click="prevAdvice" 
                      :disabled="currentAdviceIndex === 0">
                &larr; Previous
              </button>
              <button class="advice-btn" 
                      @click="nextAdvice" 
                      :disabled="currentAdviceIndex === totalAdvices - 1">
                Next &rarr;
              </button>
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
import CommunicationOption0 from '@/assets/communication-option0.png';
import CommunicationOption1 from '@/assets/communication-option1.png';
import CommunicationOption2 from '@/assets/communication-option4.png';
import CommunicationOption3 from '@/assets/communication-option3.png';

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
      options: [
        {
          label: 'Option 0: Uses few words and expresses needs through other means (weak non-verbal expression)',
          title: '✋ Small Cards Convey Wishes',
          parentDialogue: 'What would you like to eat? You can look at the picture cards to tell me.',
          childDialogue: '(Amy stares at the "cookie" card for a moment, then nods and actively takes the "cookie" card to give to mom)',
          advices: [
            '1. Introduce alternative communication systems like Picture Exchange Communication System (PECS) which uses visual cards to represent common items, activities, and needs.',
            '2. Create a personalized communication board with photographs of your child\'s favorite foods, toys, and activities that they can point to when expressing needs.',
            '3. Pair gestures with simple words consistently when communicating with your child, supporting their understanding of language while honoring their non-verbal communication.',
            '4. Respond positively to all communication attempts, whether through pointing, leading by hand, or other non-verbal methods, to encourage continued efforts.',
            '5. Gradually introduce visual choice boards for daily routines, starting with just two options and expanding as your child becomes comfortable using them.',
            '6. Consider consulting with a speech-language pathologist about technological communication aids or apps that might support your child\'s specific communication needs.'
          ],
          image: CommunicationOption0
        },
        {
          label: 'Option 1: Has language ability but often repeats common words or phrases (limited language expression)',
          title: '📢 Understanding My "Echo Words"',
          parentDialogue: 'Do you want to wear a coat to go to the park? Then let\'s put on our coats and go outside! You say: \'I want to wear a coat\'.',
          childDialogue: 'I want to wear a coat!',
          advices: [
            '1. Recognize echolalia (repeated speech) as a form of communication rather than meaningless repetition - it often indicates your child is trying to engage or express a need.',
            '2. Expand on your child\'s repeated phrases by adding meaning and context: If they say "outside" repeatedly, respond with "You want to go outside to play."',
            '3. Create opportunities for functional language by setting up situations where your child needs to request items, using visual supports as needed.',
            '4. Use the "echo and expand" technique: when your child repeats a phrase, acknowledge it and then model a slightly more complex version for them to learn.',
            '5. Avoid demanding immediate language changes; instead, model proper language consistently while accepting their current communication method.',
            '6. Celebrate when your child uses language functionally, even if it\'s a repeated phrase used appropriately in context.',
            '7. Consider a language diary to track repeated phrases and their apparent meanings, helping you understand patterns in your child\'s communication attempts.'
          ],
          image: CommunicationOption1
        },
        {
          label: 'Option 2: Just beginning to speak but language is confused, illogical, difficult to maintain simple conversations (weak language organization)',
          title: '🧠 Speaking Clearly Like Putting Together a Puzzle',
          parentDialogue: 'Was it your sister pushing the ball in the park? Oh, you mean your sister was playing with bubble balls in the park, and then the ball flew away, is that right?',
          childDialogue: 'Park... bubbles... ball... sister... push! Ball... flew away! Yes!',
          advices: [
            '1. Use visual sequencing tools like picture schedules or comic strip conversations to help your child organize their thoughts before speaking.',
            '2. Practice "sentence building" with visual supports - use picture cards for subject, verb, and object to physically arrange before speaking.',
            '3. Implement the "first-then" structure to simplify language organization: "First we go to the park, then we play on the swings."',
            '4. Model clear, simplified speech by using short, grammatically correct sentences when speaking with your child.',
            '5. Provide verbal scaffolding by offering sentence starters or filling in missing words when your child is struggling to express a complete thought.',
            '6. Create regular storytelling opportunities using picture books, asking simple questions that help your child practice sequencing events.',
            '7. Use visual supports like emotion cards alongside language to help clarify the meaning behind fragmented speech attempts.'
          ],
          image: CommunicationOption2
        },
        {
          label: 'Option 3: Occasionally shows clear desire to express, but mostly struggles to show thoughts (lacks communication initiative)',
          title: '💡 Small Questions, Big Encouragement',
          parentDialogue: 'Yes, it\'s a red balloon! Would you like to touch it? You just told mommy you wanted to see the balloon, that\'s wonderful!',
          childDialogue: 'Balloon! (Smiles and nods slightly)',
          advices: [
            '1. Create an "irresistible communication environment" by placing desired items in sight but out of reach, creating natural opportunities for your child to request them.',
            '2. Implement a "wait time" strategy - pause expectantly after asking a question or during an interaction, giving your child extra time to formulate a response.',
            '3. Celebrate every communication initiation, no matter how small, with specific praise: "You told me you wanted the ball! Great talking!"',
            '4. Introduce "sabotage" techniques in familiar routines - deliberately create a problem your child needs to communicate about (like forgetting a spoon at mealtime).',
            '5. Use highly motivating activities and special interests to encourage spontaneous communication through excitement and engagement.',
            '6. Create a communication-rich but low-pressure environment where requests are consistently honored, building trust that speaking leads to positive outcomes.',
            '7. Consider a "communication temptations" approach, strategically arranging the environment with interesting but inaccessible items that might prompt your child to initiate interaction.'
          ],
          image: CommunicationOption3
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
    showScene() {
      this.selectedOption = this.selected;
      this.showAdvice = false; 
      this.currentAdviceIndex = 0;
      this.hasViewedLastAdvice = false;
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
      console.log('CommunicationScene: Triggering next-scenario event');
      
      if (event && event.currentTarget) {
        event.currentTarget.classList.add('button-clicked');
        setTimeout(() => {
          event.currentTarget.classList.remove('button-clicked');
        }, 200);
      }
      
      this.$emit('next-scenario');
      
      setTimeout(() => {
        console.log('CommunicationScene: Delayed re-triggering of next-scenario event');
        this.$emit('next-scenario');
        this.$emit('close-modal');
      }, 50);
      
      this.$emit('close-modal');
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
  padding: 0.8rem;
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
}

/* Button Group Styles */
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

/* Responsive Design */
@media (max-width: 768px) {
  .scenario-content {
    flex-direction: column;
  }
  .image-section, .dialogue-section {
    width: 100%;
  }
}
</style>
