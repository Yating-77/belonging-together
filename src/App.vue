<template>
  <div class="fullscreen-container">
    <div v-if="!showResults" class="row g-0 h-100">
      <!-- Left fixed image area -->
      <div class="col-md-5 d-flex align-items-center justify-content-center sidebar-container">
        <div class="position-sticky sidebar-content">
          <h1 class="text-center mb-3 page-title">Supporting Autism Families</h1>
          <p class="text-center mb-4 page-subtitle">
            Personalized recommendations based on your child's daily behaviors
          </p>
          <div class="main-image-container">
            <img 
              :src="'/scenario-' + currentScenario + '.jpg'" 
              alt="Scenario Illustration" 
              class="img-fluid main-image"
              onerror="this.src='/sleep_scenario_example.png'"
            />
          </div>
          
          <!-- Progress indicator -->
          <div class="progress-container mt-4">
            <div class="d-flex justify-content-between mb-2">
              <span class="progress-text">Scenario {{ currentScenario + 1 }}/{{ scenarios.length }}</span>
              <span class="progress-percentage">{{ Math.round(((currentScenario + 1) / scenarios.length) * 100) }}% Complete</span>
            </div>
            <div class="progress">
              <div class="progress-bar" 
                   :style="{ width: ((currentScenario + 1) / scenarios.length * 100) + '%' }">
              </div>
            </div>
            <div class="scenario-dots mt-3 d-flex justify-content-between">
              <div v-for="(scenario, index) in scenarios" :key="index" 
                   class="scenario-dot" 
                   :class="{ 'active': index <= currentScenario, 'current': index === currentScenario }"
                   @click="navigateToScenario(index)">
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Right question and options area -->
      <div class="col-md-7 d-flex align-items-center">
        <div class="card w-100 border-0 shadow-sm content-card">
          <div v-if="!currentSelectedOption" class="card-body p-md-5 p-4">
            <div class="scenario-title mb-2">
              {{ scenarios[currentScenario].title }}
            </div>
            <h3 class="mb-4 scenario-question">
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
        <div class="modal-footer">
          <button type="button" class="btn back-button" @click="resetCurrentScenario">Back to Options</button>
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
        <div class="modal-footer">
          <button type="button" class="btn back-button" @click="resetCurrentScenario">Back to Options</button>
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
        <div class="modal-footer">
          <button type="button" class="btn back-button" @click="resetCurrentScenario">Back to Options</button>
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
        <div class="modal-footer">
          <button type="button" class="btn back-button" @click="resetCurrentScenario">Back to Options</button>
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
        <div class="modal-footer">
          <button type="button" class="btn back-button" @click="resetCurrentScenario">Back to Options</button>
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
        <div class="modal-footer">
          <button type="button" class="btn back-button" @click="resetCurrentScenario">Back to Options</button>
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
        <div class="modal-footer">
          <button type="button" class="btn back-button" @click="showSummary = false">Return</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';
import SleepScene from './components/SleepScene.vue';
import DietScene from './components/DietScene.vue';
import SocialScene from './components/SocialScene.vue';
import CommunicationScene from './components/CommunicationScene.vue';
import EmotionScene from './components/EmotionScene.vue';
import SensoryScene from './components/SensoryScene.vue';
import Summary from './components/Summary.vue';

export default {
  components: {
    SleepScene,
    DietScene,
    SocialScene,
    CommunicationScene,
    EmotionScene,
    SensoryScene,
    Summary
  },
  data() {
    return {
      selected: null,
      currentSelectedOption: null,
      currentScenario: 0,
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
      scenarios: [
        {
          title: 'Sleep Issues',
          question: 'How does your child typically behave at bedtime or during the night?',
          options: [
            { 
              text: 'Has difficulty falling asleep at bedtime (prolonged time to fall asleep)',
              recommendations: []
            },
            { 
              text: 'Shows significant anxiety or crying when bedtime routine changes (overly rigid bedtime routine)',
              recommendations: []
            },
            { 
              text: 'Has difficulty falling asleep when there are slight changes in the sleep environment (sensitive to sleep environment)',
              recommendations: []
            }
          ]
        },
        {
          title: 'Diet and Nutrition Issues',
          question: 'During mealtimes, how does your child typically behave?',
          options: [
            { 
              text: 'Refuses to try new foods, only eats a few specific foods (narrow food acceptance)',
              recommendations: []
            },
            { 
              text: 'Extremely sensitive to food texture or taste, leading to limited diet (sensory food aversions)',
              recommendations: []
            },
            { 
              text: 'Irregular eating times or difficulty sitting calmly at the table (poor mealtime structure)',
              recommendations: []
            }
          ]
        },
        {
          title: 'Social Interaction',
          question: 'How does your child typically interact with peers in social situations?',
          options: [
            { 
              text: 'Plays completely alone, rarely initiates contact with peers',
              recommendations: []
            },
            { 
              text: 'Willing to approach other children but doesn\'t know how to interact',
              recommendations: []
            },
            { 
              text: 'Often has conflicts with peers or difficulty cooperating',
              recommendations: []
            },
            { 
              text: 'Focuses only on preferred activities or interests',
              recommendations: []
            }
          ]
        },
        {
          title: 'Communication Issues',
          question: 'When your child wants to express needs or interests, they typically:',
          options: [
            { 
              text: 'Uses few words and expresses needs through other means (weak non-verbal expression)',
              recommendations: [
                {
                  title: 'Introduce Alternative Communication Methods',
                  content: 'If your child struggles with verbal expression, teach them other ways to communicate their needs, such as gestures and picture communication.',
                  example: 'Start by having your child point or take your hand to lead you to desired items. You can also use a Picture Exchange Communication System (PECS): prepare picture cards of common items (cup, food, bathroom), and teach your child to give you the appropriate picture when they need something.'
                },
                {
                  title: 'Provide Choices Instead of Open Questions',
                  content: 'Give your child opportunities to make choices between two options to express preferences.',
                  example: 'Instead of asking "What do you want to drink?" show two options, like milk and juice, and ask "Do you want milk or juice?" This makes communication more concrete and manageable.'
                },
                {
                  title: 'Pair Gestures with Simple Words',
                  content: 'Consistently use gestures along with simple verbal language to support communication development.',
                  example: 'When saying "more," show the sign for more, or when saying "all done," gesture with your hands. This multimodal approach creates multiple pathways for understanding and expression.'
                },
                {
                  title: 'Respond to All Communication Attempts',
                  content: 'Honor and acknowledge all of your child\'s attempts to communicate, regardless of the method.',
                  example: 'If your child points to the refrigerator, respond as if they had asked verbally: "Oh, you\'re thirsty? Let\'s get some water." This validates their communication effort and encourages continued attempts.'
                },
                {
                  title: 'Create Communication-Rich Environments',
                  content: 'Structure your home environment to encourage communication opportunities throughout the day.',
                  example: 'Place desired items in sight but out of reach, requiring your child to communicate for help. Store favorite toys in clear containers that they can see but need assistance to open.'
                }
              ]
            },
            { 
              text: 'Has language ability but often repeats common words or phrases (limited language expression)',
              recommendations: [
                {
                  title: 'Recognize Echolalia as Communication',
                  content: 'Understand that repeating words or phrases (echolalia) is often a meaningful communication attempt, not just meaningless repetition.',
                  example: 'When your child repeats "outside, outside" from a favorite show, respond as if they\'ve made a request: "You want to go outside? Let\'s put on shoes." This acknowledges their communication intent behind the repeated phrase.'
                },
                {
                  title: 'Use the Echo and Expand Technique',
                  content: 'Build on your child\'s repeated phrases by acknowledging them and adding slightly more complex language.',
                  example: 'If your child says "car go," respond with "Yes, the red car is going fast!" This validates their communication while providing a model for more complete language.'
                },
                {
                  title: 'Create Functional Communication Opportunities',
                  content: 'Set up situations where your child needs to use language functionally to get their needs met.',
                  example: 'Place a favorite toy in a clear container that\'s difficult to open, or offer a small portion of a preferred snack so they need to ask for more, creating natural communication opportunities.'
                },
                {
                  title: 'Maintain a Language Diary',
                  content: 'Keep track of repeated phrases and their apparent meanings to better understand your child\'s communication patterns.',
                  example: 'Note when your child says "blue train coming" and whether it means they want to play with trains, watch a train video, or something else. Sharing this diary with teachers and therapists creates consistent understanding.'
                },
                {
                  title: 'Celebrate Functional Language Use',
                  content: 'Provide enthusiastic feedback when your child uses language appropriately, even if it\'s a repeated phrase used in the right context.',
                  example: 'If your child has been repeating "all done" and then uses it appropriately at the end of a meal, respond with specific praise: "You told me you\'re all done eating - great talking!"'
                }
              ]
            },
            { 
              text: 'Just beginning to speak but language is confused, illogical, difficult to maintain simple conversations (weak language organization)',
              recommendations: [
                {
                  title: 'Use Visual Sequencing Supports',
                  content: 'Provide visual aids that help your child organize thoughts before speaking.',
                  example: 'Create simple comic strip conversations or picture sequences showing the beginning, middle, and end of common events. Before discussing the day at school, look at a visual schedule together first to help organize thoughts.'
                },
                {
                  title: 'Practice Physical Sentence Building',
                  content: 'Use tangible objects or cards to physically arrange sentences before speaking them.',
                  example: 'Create a set of picture cards with subjects (I, you, mom), verbs (want, see, go), and objects (ball, book, park). Have your child arrange the cards in order, then say the sentence they\'ve created.'
                },
                {
                  title: 'Implement First-Then Structure',
                  content: 'Use simple two-part sequences to help your child practice basic logical connections in language.',
                  example: 'Use "First we put on shoes, then we go outside" structure in both your language and visual supports. This helps establish basic sequential thinking that underlies organized communication.'
                },
                {
                  title: 'Model Simplified Speech',
                  content: 'Provide clear, grammatically correct but simplified speech models for your child to imitate.',
                  example: 'Instead of complex sentences, use shorter, complete sentences: "The boy is running" rather than "Look at that boy over there who\'s running so fast toward the playground." This provides an achievable language model.'
                },
                {
                  title: 'Create Storytelling Opportunities',
                  content: 'Use picture books to help your child practice sequencing events and describing actions.',
                  example: 'After reading a simple story, ask your child to retell it using the pictures. Provide prompts as needed: "What happened first? Then what happened?" This builds narrative skills that transfer to conversation.'
                }
              ]
            },
            { 
              text: 'Occasionally shows clear desire to express, but mostly struggles to show thoughts (lacks communication initiative)',
              recommendations: [
                {
                  title: 'Implement Wait Time Strategy',
                  content: 'Provide extended pause time after asking questions or during interactions, allowing your child time to formulate responses.',
                  example: 'After asking a question, silently count to 10 before speaking again or prompting further. This patient waiting signals that you expect a response and gives your child processing time.'
                },
                {
                  title: 'Celebrate Communication Initiations',
                  content: 'Provide specific, enthusiastic feedback when your child initiates communication, no matter how small.',
                  example: 'If your child unexpectedly comments on a toy, respond with "You told me about the red car! I love hearing your ideas!" This positive reinforcement encourages more spontaneous communication.'
                },
                {
                  title: 'Create Communication Temptations',
                  content: 'Arrange the environment with interesting items that might prompt your child to comment or ask questions.',
                  example: 'Place a new toy or unusual object in your child\'s play area without commenting on it. Wind up a toy but don\'t activate it. These situations naturally encourage communication initiation.'
                },
                {
                  title: 'Use Motivating Activities',
                  content: 'Incorporate your child\'s high-interest activities to encourage spontaneous communication through excitement.',
                  example: 'During activities your child loves, create unexpected problems (like missing pieces) or surprising moments that naturally prompt communication. Enthusiasm often breaks through communication reluctance.'
                },
                {
                  title: 'Build Communication Confidence',
                  content: 'Create a responsive environment where all communication attempts lead to positive outcomes.',
                  example: 'When your child makes any attempt to communicate, respond quickly and positively. This builds trust that speaking is effective and worthwhile, encouraging more frequent communication attempts.'
                }
              ]
            }
          ]
        },
        {
          title: 'Emotional and Behavioral Management',
          question: 'When facing frustration or disappointment, your child typically:',
          options: [
            { 
              text: 'Emotions quickly collapse into crying and screaming, difficult to comfort',
              recommendations: []
            },
            { 
              text: 'Often shows pushing, hitting, or throwing things as aggressive behaviors',
              recommendations: []
            },
            { 
              text: 'Tries to escape, hide, or refuse to face difficult scenarios',
              recommendations: []
            },
            { 
              text: 'Rarely expresses emotions actively, more often silent or self-enclosed',
              recommendations: []
            }
          ]
        },
        {
          title: 'Sensory Sensitivity Issues',
          question: 'Which type of sensory input does your child seem most sensitive or strongly reactive to?',
          options: [
            { 
              text: 'Easily becomes overwhelmed in noisy or bright environments (environmental stimuli sensitivity)',
              recommendations: []
            },
            { 
              text: 'Resists hair washing, nail trimming, bathing, and other daily care activities (resistance to body touch)',
              recommendations: []
            },
            { 
              text: 'Overly sensitive to certain lights, colors, or visual environments (visual stimuli sensitivity)',
              recommendations: []
            },
            { 
              text: 'Needs a lot of movement, shaking, or seeking strong sensory stimulation (sensory seeking behavior)',
              recommendations: []
            }
          ]
        }
      ]
    };
  },
  methods: {
    showRecommendation() {
      this.currentSelectedOption = this.scenarios[this.currentScenario].options[this.selected];
      
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
      
      // If it's a sensory sensitivity issue scenario, directly display the SensoryScene component
      else if (this.currentScenario === 5) {
        this.showSensoryScene = true;
        this.sensorySceneOption = this.selected;
        return;
      }
      
      // Other scenarios' original logic
      // Store the selection with index to ensure correct order
      if (this.userSelections.length <= this.currentScenario) {
        this.userSelections.push({
          scenarioTitle: this.scenarios[this.currentScenario].title,
          scenarioQuestion: this.scenarios[this.currentScenario].question,
          optionText: this.currentSelectedOption.text,
          recommendations: this.currentSelectedOption.recommendations,
          scenarioIndex: this.currentScenario // Add index to track original scenario
        });
      } else {
        this.userSelections[this.currentScenario] = {
          scenarioTitle: this.scenarios[this.currentScenario].title,
          scenarioQuestion: this.scenarios[this.currentScenario].question,
          optionText: this.currentSelectedOption.text,
          recommendations: this.currentSelectedOption.recommendations,
          scenarioIndex: this.currentScenario // Add index to track original scenario
        };
      }
      // Smooth scroll to top
      window.scrollTo({ top: 0, behavior: 'smooth' });
    },
    resetCurrentScenario() {
      this.selected = null;
      this.currentSelectedOption = null;
      this.showSleepScene = false; // Reset SleepScene display state
      this.showDietScene = false; // Reset DietScene display state
      this.showSocialScene = false; // Reset SocialScene display state
      this.showCommunicationScene = false; // Reset CommunicationScene display state
      this.showEmotionScene = false; // Reset EmotionScene display state
      this.showSensoryScene = false; // Reset SensoryScene display state
      // Smooth scroll to top
      window.scrollTo({ top: 0, behavior: 'smooth' });
    },
    navigateToScenario(index) {
      this.currentScenario = index;
      this.selected = null;
      this.currentSelectedOption = null;
      // Smooth scroll to top
      window.scrollTo({ top: 0, behavior: 'smooth' });
    },
    navigateToNextScenario() {
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
        
        // Then switch to the next scenario
        this.currentScenario++;
        this.selected = null;
        this.currentSelectedOption = null;
        
        // Add delay to ensure the modal window is fully closed before processing next step
        setTimeout(() => {
          // Force refresh view
          this.$forceUpdate();
          
          // Smooth scroll to top
          window.scrollTo({ top: 0, behavior: 'smooth' });
          
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
        recommendations: [
          {
            title: "Every child is a unique universe",
            content: "Every child is a unique universe. In their journey of growth, there may be anxiety, sensitivity, or different ways of expression.",
            example: "We hope these gentle scenarios can serve as a bridge of understanding and connection between you and your child."
          },
          {
            title: "Trust, strength, and love",
            content: "May you feel trust, strength, and love in every moment of companionship.",
            example: "— Belonging Together Team ❤️"
          }
        ]
      });
      
      // Display results page
      this.showResults = true;
    },
    resetAllScenarios() {
      this.currentScenario = 0;
      this.selected = null;
      this.currentSelectedOption = null;
      window.scrollTo({ top: 0, behavior: 'smooth' });
    },
    backToScenarios() {
      this.showResults = false;
      this.resetAllScenarios();
    },
    formatRecommendations(recommendations) {
      // If already in object array format, return directly
      if (recommendations.length > 0 && typeof recommendations[0] === 'object') {
        return recommendations;
      }
      
      // If string array, convert to object format
      return recommendations.map(rec => {
        // Try to split string to get title and content
        const parts = rec.split(':');
        if (parts.length > 1) {
          return {
            title: parts[0],
            content: parts[1],
            example: parts.length > 2 ? parts[2] : 'Try following the recommendations and observe your child\'s response, adjusting as needed for the best results.'
          };
        }
        
        // If can't split, return entire string as content
        return {
          title: this.generateSimpleTitle(rec),
          content: rec,
          example: 'Try following the recommendations and observe your child\'s response, adjusting as needed for the best results.'
        };
      });
    },
    generateSimpleTitle(recommendation) {
      // Generate a simple title from recommendation content
      const firstSentence = recommendation.split('.')[0];
      if (firstSentence.length > 15) {
        return firstSentence.substring(0, 15) + '...';
      }
      return firstSentence;
    }
  }
};
</script>

<style scoped>
/* Color variables */

/* Basic styles */
.fullscreen-container {
  background-color: #F8EFED;
  min-height: 100vh;
  width: 100vw;
  overflow-x: hidden;
  display: flex;
  flex-direction: column;
}

/* Sidebar styles */
.sidebar-container {
  position: relative;
}

.sidebar-content {
  top: 0;
  padding: 2rem;
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

/* Main image styles */
.main-image-container {
  text-align: center;
  padding: 0 1rem;
  transition: all 0.5s ease;
}

.main-image {
  border-radius: 15px;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
  max-height: 60vh;
  object-fit: cover;
  transition: transform 0.5s ease;
}

/* Progress bar styles */
.progress-container {
  margin-top: 1rem;
}

.progress-text, .progress-percentage {
  color: #4d2f20;
  font-weight: 600;
}

.progress {
  height: 8px;
  background-color: #E9E9E9;
}

.progress-bar {
  background-color: #3E5C2B;
  transition: width 0.5s ease;
}

/* Content card styles */
.content-card {
  background-color: #F8EFED;
  border-radius: 15px;
  margin: 2rem;
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

/* Option card styles */
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

/* Button styles */
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

/* Scenario dot styles */
.scenario-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background-color: #D8D8D8;
  cursor: pointer;
  transition: all 0.3s ease;
}

.scenario-dot.active {
  background-color: #3E5C2B;
}

.scenario-dot.current {
  transform: scale(1.3);
  box-shadow: 0 0 0 3px rgba(77, 47, 32, 0.2);
}

/* Recommendation styles */
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

/* Results page styles */
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

/* Scrollbar styles */
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

/* Animation */
.recommendation-container {
  animation: fadeIn 0.5s;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .row {
    flex-direction: column;
  }
  
  .main-image {
    max-height: 40vh;
    margin-bottom: 2rem;
  }
  
  .recommendation-cards {
    max-height: 50vh;
  }
}

/* Print styles */
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

/* Modal window styles */
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

/* Thank you page styles */
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

</style>



