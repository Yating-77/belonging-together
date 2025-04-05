<template>
  <div class="scene-container">
    <div v-if="option === null && !selectedOption">
      <h1 class="title">👥 Social Interaction Issues</h1>
      <p class="question">
        Which of the following best describes your child's behavior in social situations?
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
import SocialOption0 from '@/assets/social-option0.png';
import SocialOption1 from '@/assets/social-option1.png';
import SocialOption2 from '@/assets/social-option2.png';
import SocialOption3 from '@/assets/social-option3.png';

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
          label: 'Option 0: Plays completely alone, rarely initiates contact with peers',
          title: '🐢 First Step of "Playing Side by Side"',
          parentDialogue: '(In the living room, mom smiles as she watches Ethan and the neighbor\'s child each building with blocks separately)',
          childDialogue: '(Ethan glances at the neighbor child\'s creation without speaking, but nods slightly and continues building his own)',
          advices: [
            '1. Begin with "parallel play" where children play side by side using similar toys without direct interaction, which can gradually lead to more social engagement.',
            '2. Create relaxed opportunities for social interaction by inviting one child over at a time for a structured activity your child enjoys.',
            '3. Use your child\'s interests as a bridge to social connections, arranging playdates centered around their preferred activities.',
            '4. Respect your child\'s need for breaks during social situations, allowing them to retreat to a quiet space when they feel overwhelmed.',
            '5. Observe and celebrate small social gains like shared glances or proximity tolerance, as these are important steps toward social engagement.',
            '6. Model appropriate social behaviors yourself, such as greeting others, taking turns, and showing interest in others\' activities.'
          ],
          image: SocialOption0
        },
        {
          label: 'Option 1: Willing to approach other children but doesn\'t know how to interact',
          title: '🗣️ First "Can I Play With You"',
          parentDialogue: 'Let\'s try saying—hello, can I play with you? Look, these sentences are written on the picture card.',
          childDialogue: '(Sophie looks at the picture card, slowly walks toward children playing with bubbles, and recites) Hello... can I... play with you?',
          advices: [
            '1. Provide your child with "social scripts" - simple phrases they can use in common social situations like greetings or requesting to join play.',
            '2. Use visual supports such as picture cards or social stories to help your child understand and navigate social situations step-by-step.',
            '3. Role-play common social scenarios at home before encountering them in real life, allowing practice in a comfortable environment.',
            '4. Arrange structured activities with clear roles that make social expectations more predictable for your child.',
            '5. Encourage observation skills by pointing out social interactions in books, shows, or real life: "Look how they asked to play together."',
            '6. Teach and practice the specific skill of joining play, using techniques like approaching, watching, and then making a relevant comment about the activity.'
          ],
          image: SocialOption1
        },
        {
          label: 'Option 2: Often has conflicts with peers or difficulty cooperating',
          title: '🧘 "I Need to Calm Down"',
          parentDialogue: 'I see you remembered to use the method we practiced! Deep breath, are you feeling better?',
          childDialogue: 'Stop, I need to calm down. (Returns to the puzzle table a few minutes later) Let\'s continue with the puzzle.',
          advices: [
            '1. Teach emotional regulation strategies such as deep breathing, counting to ten, or using a calming corner when frustration arises.',
            '2. Create visual emotion scales to help your child identify their feelings and appropriate coping strategies at different intensity levels.',
            '3. Practice conflict resolution skills through role-play, teaching specific phrases like "I feel... when you..." or "Can we take turns?"',
            '4. Establish clear rules for play and cooperation, perhaps using visual reminders of expectations for sharing and taking turns.',
            '5. Recognize and praise positive social behaviors immediately when they occur to reinforce these actions.',
            '6. Teach perspective-taking through direct conversation: "How do you think Jamie felt when...?" or through stories with clear emotional content.'
          ],
          image: SocialOption2
        },
        {
          label: 'Option 3: Focuses only on preferred activities or interests',
          title: '🦕 Sharing the Joy of Dinosaurs',
          parentDialogue: 'You could ask him which dinosaur is his favorite.',
          childDialogue: '(Stops his own explanation) Which one do you like? (After hearing the answer, they begin exchanging dinosaur cards)',
          advices: [
            '1. Use your child\'s special interests as a starting point for social interaction rather than discouraging them.',
            '2. Teach specific turn-taking language related to interests: "Now I\'ll tell you about my favorite dinosaur, then you can share yours."',
            '3. Create structured interest-sharing activities where your child can be the "expert" but must follow rules for including others.',
            '4. Help your child recognize when others are losing interest by pointing out non-verbal cues in a supportive way.',
            '5. Gradually expand the circle of interest by connecting your child\'s passion to related topics that might interest peers.',
            '6. Encourage flexibility by introducing small variations to favorite activities, teaching that fun can happen with slight changes.',
            '7. Arrange playdates with children who share similar interests to create natural opportunities for connection.'
          ],
          image: SocialOption3
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
    goToNextScenario() {
      console.log('SocialScene: Triggering next-scenario event');
      
      this.$emit('next-scenario');
      
      setTimeout(() => {
        console.log('SocialScene: Delayed re-triggering of next-scenario event');
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
}

.continue-btn:hover {
  background-color: #3E5C2B;
  box-shadow: 0 4px 10px rgba(77, 47, 32, 0.3);
  transform: translateY(-2px);
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
