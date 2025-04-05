<template>
  <div class="scene-container">
    <div v-if="option === null && !selectedOption">
      <h1 class="title">👂 Sensory Sensitivity Issues</h1>
      <p class="question">
        Which of the following best describes your child's sensory sensitivity characteristics?
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
                Finish
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
import SensoryOption0 from '@/assets/sensory-option0.png';
import SensoryOption1 from '@/assets/sensory-option1.png';
import SensoryOption2 from '@/assets/sensory-option2.png';
import SensoryOption3 from '@/assets/sensory-option3.png';

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
          label: 'Option 0: Easily becomes overwhelmed in noisy or bright environments (environmental stimuli sensitivity)',
          title: '🎧 Noise-Cancelling Headphones as "Brave Equipment"',
          parentDialogue: 'Let\'s put on your "brave headphones." You\'re doing so well today, even better than last time.',
          childDialogue: '(Before going to the supermarket, Andy is already frowning. When entering the supermarket, Andy wears headphones and holds a small car toy. Despite the noisy crowd, he can quietly choose items by the shelves)',
          advices: [
            '1. Provide noise-reducing headphones or earplugs in environments your child finds overwhelming, allowing them to participate while reducing sensory input.',
            '2. Create a "sensory toolkit" with items that provide comfort (favorite small toy, stress ball, fidget spinner) that can be carried to challenging environments.',
            '3. Prepare your child in advance for noisy or busy environments with visual schedules and simple social stories that explain what to expect.',
            '4. Plan visits to potentially overwhelming places (like supermarkets) during quieter times, such as early mornings or late evenings when crowds are minimal.',
            '5. Use gradual exposure techniques, starting with brief visits to challenging environments and slowly increasing duration as your child builds tolerance.',
            '6. Identify specific sensory triggers in various environments by observing your child\'s reactions, then develop strategies to specifically address those elements.',
            '7. Teach your child to recognize their own sensory thresholds and practice self-advocacy by requesting breaks or using their sensory tools when needed.'
          ],
          image: SensoryOption0
        },
        {
          label: 'Option 1: Resists hair washing, nail trimming, bathing, and other daily care activities (resistance to body touch)',
          title: '🛁 Bath Time Can Be Gradually Adapted',
          parentDialogue: 'Today we\'ll only wash your hair, not your face, and we\'ll cover your eyes with a towel right away when we\'re done, okay? You\'re being so brave today. Next time you can try pouring the water yourself!',
          childDialogue: '(Mimi cries loudly every time she has to wash her hair. Mom gently pours water while singing her favorite song. Though Mimi frowns, she doesn\'t scream and gradually adapts to this new rhythm)',
          advices: [
            '1. Break hygiene routines into small, predictable steps that your child can anticipate, focusing on one challenging element at a time.',
            '2. Use visual schedules with pictures or simple drawings to outline each step of the process, reviewing them before beginning and tracking progress throughout.',
            '3. Provide sensory-friendly alternatives, such as dry shampoo occasionally, shower instead of bath, or bath wipes for particularly difficult days.',
            '4. Incorporate preferred elements into challenging routines, like bringing favorite waterproof toys into the bath or playing favorite music during nail trimming.',
            '5. Give your child appropriate control where possible, such as choosing water temperature, selecting which body part to wash first, or holding the nail clippers themselves.',
            '6. Use sensory preparation techniques before challenging routines, like deep pressure massage before baths or hand-warming before nail trimming to reduce tactile sensitivity.',
            '7. Celebrate small improvements with specific praise that focuses on the effort: "You kept your hand still for three nails today! That was really brave."'
          ],
          image: SensoryOption1
        },
        {
          label: 'Option 2: Overly sensitive to certain lights, colors, or visual environments (visual stimuli sensitivity)',
          title: '☀️ Changing the Light Makes the World Gentler',
          parentDialogue: 'Let\'s find a spot by the window and turn off the overhead lights, okay?',
          childDialogue: '(Emma stops as soon as she enters the art classroom. The white ceiling lights are too bright, and the collages on the wall are visually complex. She instinctively covers her eyes: "I don\'t like it here, it\'s too chaotic..." She opens the curtains to let soft natural light in and brings a light-colored cushion to place beside Emma. Emma slowly sits down. Though there are still colors around, the space before her has become fresh and gentle. She opens her sketchbook and softly begins drawing blue skies and little trees)',
          advices: [
            '1. Modify lighting environments by using natural light when possible, eliminating fluorescent lighting, or providing options for dimming lights in key spaces.',
            '2. Offer tinted glasses or visors that can reduce visual sensitivities, particularly for children bothered by fluorescent lighting or bright sunlight.',
            '3. Create designated "visual rest zones" at home with minimal visual stimulation - neutral colors, reduced patterns, and organized spaces where your child can retreat.',
            '4. Organize your child\'s workspace or play area to reduce visual clutter, using solid-colored storage containers and keeping walls relatively clear.',
            '5. When entering visually stimulating environments, provide a "preview" by showing pictures beforehand and approaching gradually, allowing time for your child to adjust.',
            '6. Consider seating positions in classrooms or other spaces that minimize visual distractions (away from windows, bulletin boards, or high-traffic areas).',
            '7. Use room dividers, curtains, or strategic furniture placement to create visually contained areas in open spaces like classrooms or family rooms.'
          ],
          image: SensoryOption2
        },
        {
          label: 'Option 3: Needs a lot of movement, rocking, or seeks intense sensory stimulation (sensory-seeking behavior)',
          title: '🏃‍♂️ A Day\'s Energy Needs Special Planning',
          parentDialogue: 'Noah, it\'s movement time. First, jump on the bouncy ball for 10 minutes, then spin a few times on the rotating chair, and finally go to the climbing wall, okay?',
          childDialogue: '(Noah has just returned home from school and starts running in circles around the sofa before even taking off his shoes, shaking his head as he runs. He\'s mumbling something but his eyes aren\'t focused. When he hears the movement plan, his expression becomes focused, and he begins each activity in sequence)',
          advices: [
            '1. Schedule regular "movement breaks" throughout your child\'s day, providing appropriate physical outlets before periods requiring sitting or focused attention.',
            '2. Create a dedicated sensory space at home with equipment like mini trampolines, therapy swings, crash pads, or climbing structures that safely meet vestibular needs.',
            '3. Introduce "heavy work" activities that provide proprioceptive input, such as carrying groceries, pushing a loaded cart, or animal walks (bear crawls, crab walks).',
            '4. Use therapy tools like weighted blankets, compression vests, or body socks that provide deep pressure input, helping to organize your child\'s sensory system.',
            '5. Collaborate with your child\'s teacher to incorporate movement into learning (standing desks, therapy ball seating, errands that involve walking).',
            '6. Establish a structured "sensory diet" with occupational therapy guidance - a personalized activity plan that provides needed sensory input throughout the day.',
            '7. Teach your child to recognize their own need for movement and develop appropriate ways to seek input (jumping jacks in the bathroom vs. running in the classroom).'
          ],
          image: SensoryOption3
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
      console.log('SensoryScene: Triggering next-scenario event');
      
      if (event && event.currentTarget) {
        event.currentTarget.classList.add('button-clicked');
        setTimeout(() => {
          if (event.currentTarget) {
            event.currentTarget.classList.remove('button-clicked');
          }
        }, 200);
      }
      
      this.$emit('next-scenario');
      
      setTimeout(() => {
        console.log('SensoryScene: Delayed re-triggering of next-scenario event');
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

/* Continue to Next Scenario Button Styles */
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
