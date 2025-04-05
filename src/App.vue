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
          question: 'Which of the following best describes your child\'s behavior at bedtime?',
          options: [
            { 
              text: 'Difficulty falling asleep (unable to quickly settle down for sleep)',
              recommendations: [
                {
                  title: 'Establish a Bedtime Routine',
                  content: 'Create a predictable bedtime process that helps your child gradually relax and prepare for sleep.',
                  example: 'For example: Bath → Pajamas → Brush teeth → Read a quiet story → Goodnight kiss → Lights out. Keep the same sequence and timing every night.'
                },
                {
                  title: 'Create a Comfortable Sleep Environment',
                  content: 'Ensure your child\'s sleep environment is comfortable and safe, which helps them fall asleep faster.',
                  example: 'Choose appropriate mattress and pillows, keep room temperature between 65-72°F (18-22°C), use a soft night light if your child is afraid of the dark.'
                },
                {
                  title: 'Limit Screen Time',
                  content: 'Avoid electronic devices at least one hour before bedtime, as blue light interferes with melatonin production.',
                  example: 'After dinner, replace TV or tablet time with quiet board games, puzzles, or drawing activities.'
                },
                {
                  title: 'Practice Relaxation Activities',
                  content: 'Engage in quiet, calming activities before bed to help your child relax physically and mentally.',
                  example: 'Listen to gentle music, practice simple breathing exercises, read or tell soothing bedtime stories.'
                },
                {
                  title: 'Increase Daytime Physical Activity',
                  content: 'Ensure your child gets plenty of outdoor activities and exercise during the day, making it easier to fall asleep after expending energy.',
                  example: 'Schedule at least 1-2 hours of outdoor play daily, such as running, biking, ball games, or playground time, but avoid vigorous exercise within 3 hours of bedtime.'
                }
              ]
            },
            { 
              text: 'Wakes up frequently during the night and has trouble falling back asleep (poor sleep continuity)',
              recommendations: [
                {
                  title: 'Maintain Consistent Sleep Environment',
                  content: 'Have your child fall asleep in a familiar environment where they will feel secure if they wake up during the night.',
                  example: 'Help your child fall asleep in their own bed, rather than on your bed or the couch. Avoid using TV or bright lights as sleep aids.'
                },
                {
                  title: 'Calmly Respond to Night Wakings',
                  content: 'When your child wakes during the night, keep interactions minimal and help them return to sleep.',
                  example: 'Quietly say "It\'s time to sleep now," gently guide your child to lie down, and avoid turning on lights, playing, or extended conversations.'
                },
                {
                  title: 'Use Comfort Items',
                  content: 'Provide items that give your child a sense of security to help them self-soothe.',
                  example: 'Use a special stuffed animal, soft blanket, or favorite pillow as a "sleep buddy" placed within easy reach.'
                },
                {
                  title: 'Create Consistent Sensory Environment',
                  content: 'Maintain consistent sound, light, and temperature in the sleep environment to reduce stimuli that might wake your child.',
                  example: 'Use a white noise machine or fan to provide consistent background sound, use blackout curtains to keep the room dark, and set the thermostat to maintain a stable temperature.'
                },
                {
                  title: 'Build Independent Sleep Skills',
                  content: 'Teach your child self-soothing skills for both falling asleep and night wakings.',
                  example: 'Gradually reduce parental intervention, from lying next to your child to just sitting in the room, and finally to briefly checking in. Encourage your child to use simple relaxation techniques like deep breathing.'
                }
              ]
            },
            { 
              text: 'Shows significant anxiety or crying when bedtime routine changes (overly rigid bedtime routine)',
              recommendations: [
                {
                  title: 'Announce Changes in Advance',
                  content: 'Before changing bedtime routines, inform your child ahead of time in a way they can understand.',
                  example: 'Use simple visual schedules or picture cards showing what will be different that night. For example: "Tonight daddy will read you a story instead of mommy."'
                },
                {
                  title: 'Introduce Changes Gradually',
                  content: 'Help your child adapt to adjustments in the bedtime routine through small steps.',
                  example: 'Start by changing less important items, like switching to a different bedtime story book; after success, try changing bath time or the location for story reading.'
                },
                {
                  title: 'Keep Core Elements Stable',
                  content: 'When changes are necessary, try to maintain key aspects of the routine unchanged to provide security.',
                  example: 'If you can\'t follow the usual bath routine, still maintain the same pajamas, teeth brushing, and story sequence, using the same language prompts: "Now it\'s time to get ready for bed."'
                },
                {
                  title: 'Create Flexibility Games',
                  content: 'Play "change games" during daytime to help your child practice adapting to small changes.',
                  example: 'During playtime, role-play different bedtime scenarios: "Today we\'re pretending we\'re traveling, and bedtime might be a bit different." Or slightly mix up the order of daily activities to help your child learn to adapt.'
                },
                {
                  title: 'Positively Reinforce Adaptive Behavior',
                  content: 'Praise and encourage your child when they successfully handle changes.',
                  example: 'Use a sticker reward system or special praise: "You were so brave tonight, even though bedtime was a little different, you stayed calm!" The next day, narrate how the child successfully adapted to the change.'
                }
              ]
            },
            { 
              text: 'Has difficulty falling asleep when there are slight changes in the sleep environment (sensitive to sleep environment)',
              recommendations: [
                {
                  title: 'Create a Portable Sleep Kit',
                  content: 'Prepare a set of familiar sleep items that can be used in different environments.',
                  example: 'Prepare a "sleep travel pack" containing your child\'s familiar pillowcase, small blanket, favorite stuffed toy, and possibly regular bedtime reading materials.'
                },
                {
                  title: 'Use Sensory Aids',
                  content: 'Utilize tools to block or regulate environmental distractions.',
                  example: 'Use a white noise machine to mask unfamiliar sounds, comfortable earplugs to reduce noise disruptions, sleep masks to adjust to light changes, or small items with familiar scents for comfort.'
                },
                {
                  title: 'Preview and Familiarize New Environments',
                  content: 'Before sleeping in a new place, help your child become familiar with the environment.',
                  example: 'Visit the new sleeping area in advance, allow your child to explore and choose where they\'ll sleep, do some enjoyable daytime activities in the new environment to build positive associations.'
                },
                {
                  title: 'Maintain Core Bedtime Routine',
                  content: 'Even in different environments, stick to key bedtime routine elements.',
                  example: 'No matter where you are, maintain the same bedtime three-step process, such as: brushing teeth, reading a story, and singing a specific lullaby, providing continuity and security through process.'
                },
                {
                  title: 'Create "Sleep Space" Boundaries',
                  content: 'Use visual or tactile cues to define the sleeping area.',
                  example: 'Use the same sheets or blanket to "mark" the sleep space, even when traveling; or use a foldable tent-style bed cover to create enclosure, reducing external environment interference.'
                }
              ]
            }
          ]
        },
        {
          title: 'Diet and Nutrition Issues',
          question: 'During mealtimes, how does your child typically behave?',
          options: [
            { 
              text: 'Refuses to try new foods, only eats a few specific foods (narrow food acceptance)',
              recommendations: [
                {
                  title: 'Introduce New Foods Gradually',
                  content: 'Use a "food bridge" strategy by placing new foods alongside familiar foods that your child enjoys.',
                  example: 'Place a small piece of carrot next to foods with similar flavors that they already like. Encourage your child to first observe, smell, or even touch the new food without forcing them to eat it.'
                },
                {
                  title: 'Repeated Exposure',
                  content: 'You may need to present foods 5-20 times before acceptance—research shows children with autism may need 10+ exposures before trying new foods.',
                  example: 'Be patient and continue offering the same new food at different meals. Acceptance typically increases gradually with continued neutral exposure.'
                },
                {
                  title: 'Provide Safety with Familiar Foods',
                  content: 'When offering new foods, make sure there are always some familiar foods on the plate.',
                  example: 'Ensure that at least half the plate contains foods you know your child will eat, so they won\'t refuse the entire meal when presented with new options.'
                }
              ]
            },
            { 
              text: 'Extremely sensitive to food texture or taste, leading to limited diet (sensory food aversions)',
              recommendations: [
                {
                  title: 'Work with Texture Preferences',
                  content: 'For children sensitive to texture, first accept the textures they can tolerate while ensuring nutritional intake. Then gradually introduce subtle texture changes.',
                  example: 'If they only eat pureed foods, try introducing minimal soft particles and gradually increase the amount. If they only eat crunchy foods, try offerings that start crunchy but become slightly softer.'
                },
                {
                  title: 'Sensory Food Play',
                  content: 'Outside of mealtimes, engage in play activities with different food textures without pressure to eat.',
                  example: 'Create games touching, squishing or sorting foods with different textures. This helps desensitize children to textures they find challenging in a low-pressure environment.'
                }
              ]
            },
            { 
              text: 'Irregular eating times or difficulty sitting calmly at the table (poor mealtime structure)',
              recommendations: [
                {
                  title: 'Establish Regular Meal Schedule',
                  content: 'Create and strictly follow a daily schedule of three meals and two snacks for your child.',
                  example: 'Children with autism typically prefer predictable routines. Fixed mealtimes help establish biological rhythms and hunger-satiety patterns. For example, breakfast at 7 AM, lunch at noon, dinner at 6 PM, with scheduled snacks in between.'
                },
                {
                  title: 'Use Visual Supports',
                  content: 'Implement visual schedules or timers to help your child understand when it\'s time to eat and when mealtime ends.',
                  example: 'Before meals, show your child a picture schedule saying, "Look, the clock is pointing to the apple, it\'s time for lunch." During meals, use a simple hourglass timer so they can see how long the meal will last.'
                }
              ]
            }
          ]
        },
        {
          title: 'Social Interaction',
          question: 'How does your child typically interact with peers in social situations?',
          options: [
            { 
              text: 'Plays completely alone, rarely initiates contact with peers',
              recommendations: [
                {
                  title: 'Begin with Parallel Play',
                  content: 'Start by having your child play alongside others using similar toys without requiring direct interaction.',
                  example: 'Arrange for playdates where children engage in similar activities side by side, such as building blocks or drawing. This creates proximity without social pressure, allowing gradual engagement at the child\'s comfort level.'
                },
                {
                  title: 'Bridge Through Shared Interests',
                  content: 'Use your child\'s interests as social connectors with peers who share similar preferences.',
                  example: 'If your child loves dinosaurs, organize a small dinosaur-themed activity with one or two other children who also like dinosaurs. The shared enthusiasm can naturally encourage interaction.'
                },
                {
                  title: 'Create Safe Social Spaces',
                  content: 'Design structured environments where social interaction feels predictable and manageable.',
                  example: 'Host mini-playgroups at home with clearly defined activities and durations. Start with 15-30 minute playdates with just one other child, gradually increasing time and participants as your child becomes comfortable.'
                },
                {
                  title: 'Honor Individual Pace',
                  content: 'Respect your child\'s need for breaks during social situations to prevent overwhelm.',
                  example: 'Create a quiet retreat area during playdates where your child can go to decompress. Teach them it\'s okay to say "I need a break" and rejoin when ready, reinforcing that social interaction can happen on their terms.'
                },
                {
                  title: 'Value Small Steps',
                  content: 'Recognize and celebrate incremental progress in social engagement, however minimal it may seem.',
                  example: 'Acknowledge when your child moves their play area closer to another child, makes eye contact, or shows interest in what others are doing: "I noticed you watched how Mia built her tower. You were being observant!"'
                }
              ]
            },
            { 
              text: 'Willing to approach other children but doesn\'t know how to interact',
              recommendations: [
                {
                  title: 'Provide Social Scripts',
                  content: 'Teach your child specific phrases to use in common social situations.',
                  example: 'Create simple cards with phrases like "Can I play?" or "My name is ___. What\'s yours?" Practice these at home, then role-play using them in real situations. Start with just 1-2 scripts before adding more.'
                },
                {
                  title: 'Use Visual Supports',
                  content: 'Create visual guides that show social interactions step by step.',
                  example: 'Make a picture sequence showing the steps of joining a game: 1) Watch what others are doing, 2) Stand nearby, 3) Say "Can I play?", 4) Wait for answer, 5) Join in or find another activity. Review this sequence before social situations.'
                },
                {
                  title: 'Practice Through Role-Play',
                  content: 'Rehearse social scenarios at home in a supportive environment.',
                  example: 'Act out playground interactions with family members. Take turns being different characters and practice both successful interactions and handling rejection appropriately. Use stuffed animals or action figures to demonstrate conversations.'
                },
                {
                  title: 'Structure Initial Interactions',
                  content: 'Create activities with clear roles that make social expectations more predictable.',
                  example: 'Organize games with defined turns and roles like "Simon Says" or simple board games. These provide natural conversation points and clear expectations for when to speak and what to do.'
                },
                {
                  title: 'Teach Observation Skills',
                  content: 'Help your child learn to read social cues by pointing them out explicitly.',
                  example: 'When watching shows together, pause to discuss: "Look, that boy is smiling. How do you think he feels?" In real situations, quietly narrate: "See how those children are taking turns pushing the swing? That\'s how they play together."'
                }
              ]
            },
            { 
              text: 'Often has conflicts with peers or difficulty cooperating',
              recommendations: [
                {
                  title: 'Teach Self-Regulation Strategies',
                  content: 'Help your child identify and manage strong emotions before they escalate to conflicts.',
                  example: 'Create a "calm down kit" with your child containing items like a stress ball, counting cards, and breathing reminder. Practice using these tools when calm, then prompt their use when you notice early signs of frustration.'
                },
                {
                  title: 'Create Visual Emotion Scales',
                  content: 'Help your child recognize emotional intensity and appropriate responses.',
                  example: 'Design a 5-point scale with your child where 1 is "calm" and 5 is "about to explode." For each level, identify physical feelings and appropriate coping strategies. Regularly check in: "Where are you on our scale right now?"'
                },
                {
                  title: 'Practice Conflict Resolution Skills',
                  content: 'Teach specific phrases and steps to resolve disagreements peacefully.',
                  example: 'Introduce a simple conflict resolution script: "I feel ___ when you ___. Could we ___?" Role-play using this script with common playground scenarios, gradually transferring these skills to real situations with gentle prompting.'
                },
                {
                  title: 'Establish Clear Expectations',
                  content: 'Create visual reminders of rules for sharing and taking turns.',
                  example: 'Make simple picture cards showing expected behaviors during playtime. Review these before social activities and keep them visible as reminders. Provide specific praise when you observe your child following these expectations.'
                },
                {
                  title: 'Teach Perspective-Taking',
                  content: 'Help your child understand others\' feelings and viewpoints.',
                  example: 'Use story books with clear emotional content to discuss how characters feel: "How do you think she felt when he took her toy?" Relate these discussions to real-life situations: "Remember when Alex felt sad when you grabbed the ball? What could you do differently next time?"'
                }
              ]
            },
            { 
              text: 'Focuses only on preferred activities or interests',
              recommendations: [
                {
                  title: 'Use Special Interests as Social Bridges',
                  content: 'Leverage your child\'s interests to create meaningful social connections.',
                  example: 'If your child loves space, find a space-themed club or organize a space-themed playdate where they can share knowledge while practicing turn-taking. Their enthusiasm becomes a strength rather than a barrier.'
                },
                {
                  title: 'Teach Topic-Sharing Skills',
                  content: 'Help your child learn how to engage others in their interests appropriately.',
                  example: 'Practice conversation scripts like: "Would you like to hear about my favorite dinosaur? I can tell you three facts, and then you can share something you like." Set a timer for "my turn to talk" and "your turn to talk" during home practice.'
                },
                {
                  title: 'Create Structured Interest-Sharing Activities',
                  content: 'Design activities where your child can showcase knowledge while following social rules.',
                  example: 'Organize a "show and tell" with clear guidelines about time limits and questions. This provides a structured way for your child to share interests while practicing listening to others.'
                },
                {
                  title: 'Develop Awareness of Others\' Engagement',
                  content: 'Help your child recognize when listeners are losing interest.',
                  example: 'Identify specific visual cues: "When people look away or start fidgeting, they might be ready to change topics." Create a visual reminder card with these cues that your child can reference during conversations.'
                },
                {
                  title: 'Gradually Expand Interests',
                  content: 'Connect your child\'s special interests to related topics that might interest peers.',
                  example: 'If your child loves trains, gradually introduce related interests like different transportation methods, engineering, or travel destinations. This broadens their interest base while honoring their original passion.'
                }
              ]
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
              recommendations: [
                {
                  title: 'Teach Emotional Regulation Techniques',
                  content: 'Introduce simple breathing exercises and calming strategies that your child can use when they feel overwhelmed by emotions.',
                  example: 'Practice "smell the flower, blow out the candle" breathing technique with your child when they are calm, so they can recall it during distress. Guide them through "5-4-3-2-1" sensory grounding by naming things they can see, touch, hear, smell, and taste.'
                },
                {
                  title: 'Create a Calm-Down Space',
                  content: 'Designate a specific area in your home where your child can go to regulate their emotions when feeling overwhelmed.',
                  example: 'Set up a corner with comfortable cushions, sensory tools like stress balls or fidget toys, and visual reminders of calming strategies. Introduce this space during calm moments and encourage its use when you notice early signs of distress.'
                },
                {
                  title: 'Use Visual Emotion Supports',
                  content: 'Provide visual aids to help your child identify and express their escalating emotions before reaching meltdown.',
                  example: 'Create an "emotional thermometer" with your child showing stages from calm to angry/upset with corresponding strategies for each level. Reference this tool regularly: "I see you\'re getting to the yellow zone, let\'s try some deep breaths."'
                }
              ]
            },
            { 
              text: 'Often shows pushing, hitting, or throwing things as aggressive behaviors',
              recommendations: [
                {
                  title: 'Provide Safe Physical Outlets',
                  content: 'Create appropriate physical alternatives for expressing intense emotions in ways that won\'t cause harm.',
                  example: 'Designate a "hitting spot" like a pillow or punching bag specifically for expressing anger. When you see aggressive behavior beginning, immediately redirect: "Hands are not for hitting people. If you\'re feeling angry, you can hit the pillow instead."'
                },
                {
                  title: 'Identify and Address Triggers',
                  content: 'Track patterns to understand what situations consistently precede aggressive behaviors.',
                  example: 'Keep a simple log noting time of day, preceding activities, and people present during incidents. Review this to identify patterns like hunger, fatigue, sensory overload, or specific social demands that may trigger aggression.'
                },
                {
                  title: 'Teach Alternative Behaviors',
                  content: 'Explicitly teach and practice appropriate responses to replace aggressive actions.',
                  example: 'Create simple social stories with pictures showing what to do when feeling angry or frustrated: "When I feel angry, I can: 1) Take three deep breaths, 2) Say \'I need space\', 3) Go to my calm corner." Practice these regularly when your child is calm.'
                }
              ]
            },
            { 
              text: 'Tries to escape, hide, or refuse to face difficult scenarios',
              recommendations: [
                {
                  title: 'Use Gradual Exposure Techniques',
                  content: 'Break challenging situations into smaller, manageable steps that your child can practice with support.',
                  example: 'If your child is afraid of haircuts, create a step-by-step approach: first just visit the salon without getting a haircut, then sit in the chair, then allow the stylist to touch their hair briefly, and so on, celebrating each small success.'
                },
                {
                  title: 'Create Predictability with Visual Supports',
                  content: 'Use visual schedules and social stories to reduce uncertainty about upcoming challenging events.',
                  example: 'Before a doctor\'s appointment, create a simple picture sequence showing each step of the visit from arrival to departure. Review this repeatedly in the days before the appointment, addressing specific worries for each step.'
                },
                {
                  title: 'Validate Feelings While Encouraging Coping',
                  content: 'Acknowledge your child\'s anxiety while expressing confidence in their ability to handle difficult situations.',
                  example: 'When your child shows avoidance, say: "I see you\'re feeling worried about going to the playground. It\'s okay to feel scared sometimes. I believe you can be brave, and I\'ll stay right beside you. What would help you feel ready to try?"'
                }
              ]
            },
            { 
              text: 'Rarely expresses emotions actively, more often silent or self-enclosed',
              recommendations: [
                {
                  title: 'Offer Alternative Expression Methods',
                  content: 'Provide non-verbal ways for your child to communicate emotions when words are difficult.',
                  example: 'Create an "emotion toolkit" with various materials for expression: drawing supplies, clay for sculpting feelings, emotion cards to point to, or a feelings journal with simple prompts. Normalize these as valid ways to communicate.'
                },
                {
                  title: 'Create Regular Check-in Routines',
                  content: 'Establish predictable times for emotion check-ins using visual supports.',
                  example: 'Implement a daily "feelings check-in" using a visual emotions chart where your child can simply point to how they\'re feeling. Start with basic emotions and gradually expand the vocabulary. Keep it low-pressure: "It\'s time for our feelings check. Can you show me which face matches how you feel today?"'
                },
                {
                  title: 'Use Indirect Communication Approaches',
                  content: 'Engage with emotions through third-party scenarios rather than direct questioning.',
                  example: 'Use stuffed animals or characters to model emotional expression: "Bear looks sad today. I wonder what happened?" This creates emotional distance that can feel safer for children who struggle with direct emotional communication.'
                }
              ]
            }
          ]
        },
        {
          title: 'Sensory Sensitivity Issues',
          question: 'Which type of sensory input does your child seem most sensitive or strongly reactive to?',
          options: [
            { 
              text: 'Easily becomes overwhelmed in noisy or bright environments (environmental stimuli sensitivity)',
              recommendations: [
                {
                  title: 'Provide Sensory Protection Tools',
                  content: 'Offer tools that allow your child to moderate sensory input in overwhelming environments.',
                  example: 'Provide noise-canceling headphones for loud environments like grocery stores, sunglasses for bright places, or earplugs for events with unpredictable sounds. Teach your child how to use these as "sensory superpowers" rather than as indicators of weakness.'
                },
                {
                  title: 'Create Environmental Previews',
                  content: 'Prepare your child for sensory-rich environments before entering them.',
                  example: 'Before going to a busy store, show pictures or videos of the location, discuss the sounds and sights they might experience, and create a plan together for how to handle overwhelming moments, such as identifying a quiet corner for breaks or using a special signal to indicate sensory distress.'
                },
                {
                  title: 'Plan Strategic Timing',
                  content: 'Visit potentially overwhelming environments during their least stimulating times.',
                  example: 'Schedule grocery shopping during early morning or late evening hours when stores are quieter and less crowded. Visit playgrounds during off-peak hours for reduced noise and activity levels. This gradual exposure helps build sensory tolerance while reducing the risk of overload.'
                }
              ]
            },
            { 
              text: 'Resists hair washing, nail trimming, bathing, and other daily care activities (resistance to body touch)',
              recommendations: [
                {
                  title: 'Break Down Tactile Tasks',
                  content: 'Divide touch-sensitive activities into smaller, more manageable steps.',
                  example: 'For haircuts, establish a gradual process: first just holding scissors near hair without cutting, then snipping one small piece, gradually building up tolerance. For bathing, try breaking the routine into separate components done on different days (hair washing separate from body washing) until tolerance increases.'
                },
                {
                  title: 'Modify Sensory Elements',
                  content: 'Adjust the sensory qualities of caregiving activities to make them more tolerable.',
                  example: 'For hair washing, try dry shampoo sometimes, use a visor to keep water off the face, or let your child hold a washcloth over their eyes. For nail trimming, try cutting after a bath when nails are softer, use clippers with less vibration, or try filing instead of cutting.'
                },
                {
                  title: 'Provide Sensory Preparation',
                  content: 'Use deep pressure or proprioceptive input before tactile tasks to help regulate the nervous system.',
                  example: 'Before difficult touch activities, offer deep pressure through firm shoulder squeezes, a tight hug, or weighted blanket time. This type of input has a calming effect on the nervous system and can make light or unexpected touch more tolerable afterward.'
                }
              ]
            },
            { 
              text: 'Overly sensitive to certain lights, colors, or visual environments (visual stimuli sensitivity)',
              recommendations: [
                {
                  title: 'Modify Lighting Environments',
                  content: 'Adjust lighting to reduce visual stress in key environments like home and school.',
                  example: 'Replace fluorescent bulbs with full-spectrum or LED lighting. Use dimmer switches in rooms where your child spends significant time. Consider light filtering solutions like window tints or curtains to control natural light intensity throughout the day.'
                },
                {
                  title: 'Create Visual Rest Zones',
                  content: 'Designate spaces with reduced visual input where your child can recover from visual overload.',
                  example: 'Set up a corner of your child\'s room or a specific area of your home with minimal visual stimulation - neutral colors, reduced patterns, and limited decorations. Keep this area organized and clutter-free as a retreat space when visual processing becomes overwhelming.'
                },
                {
                  title: 'Offer Visual Filtering Tools',
                  content: 'Provide your child with tools to selectively filter visual input in environments they cannot control.',
                  example: 'For children sensitive to bright light, offer sunglasses, caps with brims, or tinted overlays for reading. For those overwhelmed by visual complexity, provide tools to help focus attention, such as reading windows that highlight only one line of text, or workspace dividers in busy classrooms.'
                }
              ]
            },
            { 
              text: 'Needs a lot of movement, shaking, or seeking strong sensory stimulation (sensory seeking behavior)',
              recommendations: [
                {
                  title: 'Schedule Regular Movement Breaks',
                  content: 'Incorporate planned physical activity throughout your child\'s day rather than viewing movement as disruptive.',
                  example: 'Create a visual schedule that alternates seated activities with movement breaks every 20-30 minutes. These breaks might include wall push-ups, animal walks (bear crawls, crab walks), jumping jacks, or running in place - activities that can be done in small spaces while providing necessary sensory input.'
                },
                {
                  title: 'Create a Home Sensory Space',
                  content: 'Designate an area in your home where sensory-seeking behavior is not only allowed but encouraged.',
                  example: 'Set up a corner with a mini-trampoline, therapy swing, crash pad (large cushions), or climbing area. Include a variety of sensory materials like putty, weighted items, and textured objects. Make this space available for both scheduled sensory breaks and as-needed regulation.'
                },
                {
                  title: 'Incorporate Heavy Work Activities',
                  content: 'Include activities that provide resistance and deep pressure throughout your child\'s routine.',
                  example: 'Assign household chores that involve pushing, pulling, or carrying heavy objects (appropriate for your child\'s size and strength). Examples include carrying groceries, pushing a loaded laundry basket, gardening activities involving digging, or helping to move furniture during cleaning.'
                }
              ]
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



