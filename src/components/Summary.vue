<template>
  <div class="summary-container">
    <h1 class="summary-title">Project Summary</h1>
    
    <div v-if="loading" class="loading-container">
      <div class="loading-spinner"></div>
      <p>The guide content is loading, please wait...</p>
    </div>
    
    <div v-else-if="error" class="error-container">
      <p class="error-message">{{ error }}</p>
      <button class="retry-button" @click="fetchData">Retry</button>
    </div>
    
    <div v-else id="summary-content" class="summary-content">
      <!-- Summary content -->
      <div class="handbook-cover">
        <h1>Belonging Together</h1>
        <h2>Support Handbook for Parents of Children with Autism</h2>
        <div class="handbook-image">
          <img src="/handbook.png" alt="Belonging Together Handbook Cover" />
        </div>
      </div>
      
      <div class="handbook-intro">
        <h2>Foreword</h2>
        <p>
          Dear Parents:<br><br>
          Welcome to the "Belonging Together" parent support handbook. This handbook aims to help you better understand and support your child's daily needs through gentle scenarios.
          Every child is unique, and they may experience and perceive the world in different ways.
          <br><br>
          In this handbook, we provide practical strategies and advice through scenarios you might encounter in real life,
          helping you and your child face challenges in sleep, diet, social interaction, communication, emotional management, and sensory sensitivity.
          <br><br>
          We hope these scenario scenes can serve as a bridge of communication between you and your child, helping you create more moments of understanding, respect, and love.
        </p>
      </div>
      
      <!-- Scenario content will be dynamically generated here -->
      <div v-for="(category, categoryIndex) in scenarioData" :key="categoryIndex" class="scenario-section">
        <h2>{{ category.title }}</h2>
        <div v-for="(scenario, scenarioIndex) in category.scenarios" :key="scenarioIndex" class="scenario-card">
          <h3>{{ scenario.title }}</h3>
          <div class="scenario-content">
            <div class="scenario-image">
              <img :src="scenario.image" :alt="scenario.title" crossorigin="anonymous" />
            </div>
            <div class="scenario-description">
              <p>{{ scenario.description }}</p>
            </div>
          </div>
          <div class="scenario-advice">
            <h4>Parent Advice</h4>
            <div class="detailed-recommendations">
              <div v-for="(rec, recIndex) in scenario.recommendations" :key="recIndex" class="recommendation-item">
                <h5 class="recommendation-title">{{ rec.title }}</h5>
                <p class="recommendation-content">{{ rec.content }}</p>
                <div class="recommendation-example">
                  <span class="example-label">Example: </span>
                  <span>{{ rec.example }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <div class="handbook-conclusion">
        <h2>A Message to Parents</h2>
        <p>
          Each child is a unique universe. In their growth journey, there may be anxiety, sensitivity, or different ways of expression.
          <br><br>
          We hope these gentle scenarios can become a bridge of understanding and connection between you and your child.
          <br><br>
          May you feel trust, strength, and love in every moment of companionship.
          <br><br>
          — Belonging Together Team ❤️
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import SleepOption0 from '@/assets/sleep-option0.png';
import SleepOption1 from '@/assets/sleep-option1.png';
import SleepOption2 from '@/assets/sleep-option2.png';
import SleepOption3 from '@/assets/sleep-option3.png';
import DietOption0 from '@/assets/diet-option0.png';
import DietOption1 from '@/assets/diet-option1.png';
import DietOption2 from '@/assets/diet-option2.png';
import DietOption3 from '@/assets/diet-option3.png';
import SocialOption0 from '@/assets/social-option0.png';
import SocialOption1 from '@/assets/social-option1.png';
import SocialOption2 from '@/assets/social-option2.png';
import SocialOption3 from '@/assets/social-option3.png';
import CommunicationOption0 from '@/assets/communication-option0.png';
import CommunicationOption1 from '@/assets/communication-option1.png';
import CommunicationOption3 from '@/assets/communication-option3.png';
import CommunicationOption4 from '@/assets/communication-option4.png';
import EmotionOption0 from '@/assets/emotion-option0.png';
import EmotionOption1 from '@/assets/emotion-option1.png';
import EmotionOption2 from '@/assets/emotion-option2.png';
import EmotionOption3 from '@/assets/emotion-option3.png';
import SensoryOption0 from '@/assets/sensory-option0.png';
import SensoryOption1 from '@/assets/sensory-option1.png';
import SensoryOption2 from '@/assets/sensory-option2.png';
import SensoryOption3 from '@/assets/sensory-option3.png';

export default {
  data() {
    return {
      loading: false,
      error: null,
      scenarioData: [
        {
          title: 'Sleep Issues',
          scenarios: [
            {
              title: '🌙 "Counting Stars Together"',
              image: SleepOption0,
              description: 'Timmy lies in bed, tossing and turning, unable to fall asleep. Mom walks into the room quietly, turns off the main light, turns on the night light, and sits on the edge of the bed.\n"Let\'s play a game to see who can count 10 stars and then fall asleep first, okay?"',
              recommendations: []
            },
            {
              title: '🧸 "Let\'s Sleep Together"',
              image: SleepOption1,
              description: 'In the middle of the night, Tommy wakes up for the third time, crying loudly for mom.\nMom, tired but patient, walks into the room: "Tommy, here\'s your friend Bear, he\'ll keep you company. I\'m just next door, and you\'re safe."',
              recommendations: []
            },
            {
              title: '📚 "Bedtime Story Ritual"',
              image: SleepOption2,
              description: 'Emma resists going to bed every night. Dad creates a special routine, laying out pajamas in a fun way and preparing a book.\n"Emma, it\'s story time with Mr. Rabbit! He\'s waiting to hear what happens next in our adventure book."',
              recommendations: []
            },
            {
              title: '🏕️ "First Night at Grandma\'s House"',
              image: SleepOption3,
              description: 'This bed doesn\'t feel like mine... The lights are different too...\nWe can still do our bedtime ritual here. Let\'s make this corner your special place.',
              recommendations: []
            }
          ]
        },
        {
          title: 'Diet and Nutrition Issues',
          scenarios: [
            {
              title: '🥕 "Food Explorer"',
              image: DietOption0,
              description: 'Lucy looks at the carrot on her plate with a frown.\nDad smiles and says, "Today we\'re going to be food explorers! First, let\'s smell this orange treasure, then touch it with our fingers, okay?"',
              recommendations: []
            },
            {
              title: '🍽️ "Colorful Plate Design"',
              image: DietOption1,
              description: 'Mom arranges vegetables and fruits into a smiley face on Jason\'s plate. His eyes widen with interest.\n"Look, the cucumber is smiling at you! Which part would you like to try first?"',
              recommendations: []
            },
            {
              title: '📅 "Mealtime Schedule"',
              image: DietOption2,
              description: 'Lisa runs around the room as dad prepares lunch. Dad gently guides her to a colorful chart on the wall.\n"Look, it\'s 12 o\'clock. The clock is pointing to the sandwich picture. That means it\'s lunchtime!"',
              recommendations: []
            },
            {
              title: '⏰ "Racing with the little hourglass"',
              image: DietOption3,
              description: 'Tick tock, the timer has started! Can you finish your bite before all the sand falls to the bottom?\nI want to finish before the sand runs out! *Takes bites while watching the timer*',
              recommendations: []
            }
          ]
        },
        {
          title: 'Social Interaction',
          scenarios: [
            {
              title: '🎮 "Playing Games Together"',
              image: SocialOption0,
              description: 'Johnny sits in the corner of the playground, playing alone with his toy car. The teacher walks over gently, bringing another child who also likes cars.\n"Johnny, I see you have a red race car, and Alex has a blue one. Could you build a track together?"',
              recommendations: []
            },
            {
              title: '👋 "Approaching Peers"',
              image: SocialOption1,
              description: 'Emma stands at the edge of the playground, watching other children. She walks toward them but stops, unsure what to say.\nDad kneels beside her: "Remember what we practiced? You can say \'Can I play?\' Let\'s practice once more."',
              recommendations: []
            },
            {
              title: '🏠 "Structured Play Date"',
              image: SocialOption2,
              description: 'Dad has arranged the living room with three activity stations: building blocks, drawing, and a simple board game. "When Ben comes over, you can show him these three games we\'ve set up. Which one would you like to start with?"',
              recommendations: []
            },
            {
              title: '🦕 "Sharing the Joy of Dinosaurs"',
              image: SocialOption3,
              description: 'Noah talks non-stop about dinosaurs to a classmate who starts to look bored. Mom gently intervenes.\n"Noah, remember our talking timer? Let\'s let Jamie share what he likes too. You can ask, \'What do you like to play with?\'"',
              recommendations: []
            }
          ]
        },
        {
          title: 'Communication',
          scenarios: [
            {
              title: '🖼️ "Picture Communication"',
              image: CommunicationOption0,
              description: 'David\'s eyes dart around as he tries to express what he wants. Mom opens a communication book with pictures.\n"Do you want a snack? You can show me by pointing to what you\'d like."',
              recommendations: []
            },
            {
              title: '🔄 "From Echo to Expression"',
              image: CommunicationOption1,
              description: 'Mark repeats, "Outside, outside" after hearing it in a TV show. Dad responds enthusiastically, "Yes, you want to go outside! Let\'s put on your shoes and we can go to the park."',
              recommendations: []
            },
            {
              title: '📖 "Comic Strip Conversations"',
              image: CommunicationOption3,
              description: 'Jamie\'s sentences are confused, making it hard to understand the story he\'s trying to tell about school. Mom takes out paper and draws simple stick figures.\n"Let\'s draw what happened first, then what happened next."',
              recommendations: []
            },
            {
              title: '💡 "Small Questions, Big Encouragement"',
              image: CommunicationOption4,
              description: 'Lisa rarely speaks in class. Her teacher notices she\'s drawing a butterfly and kneels beside her desk. "Is that a butterfly? What color will you make the wings?" Lisa whispers, "Blue." The teacher smiles warmly, "Blue wings will look beautiful!"',
              recommendations: []
            }
          ]
        },
        {
          title: 'Emotional Management',
          scenarios: [
            {
              title: '🫧 "Let\'s Breathe Together"',
              image: EmotionOption0,
              description: 'Sam, let\'s use the "smell the flower, blow the candle" method. Breathe in—breathe out... Let\'s rebuild this tower together, okay?\n(Sam accidentally knocked over his block tower while playing. His eyes immediately welled up with tears, and he started crying loudly. Gradually calming down, he nods and begins to rearrange the blocks)',
              recommendations: []
            },
            {
              title: '📊 "Emotion Chart"',
              image: EmotionOption1,
              description: 'Dad points to a colorful chart with different facial expressions. "Ryan, can you show me which face shows how you\'re feeling right now?" Ryan studies the chart and points to the "frustrated" face, then to his math homework.',
              recommendations: []
            },
            {
              title: '⏱️ "Calm Down Timer"',
              image: EmotionOption2,
              description: 'Lisa becomes upset when it\'s time to transition to a new activity. Mom shows her a visual timer with colorful sand flowing down. "We\'ll switch activities when the blue sand reaches the bottom. You have time to prepare."',
              recommendations: []
            },
            {
              title: '🎨 "Feelings Drawn on Paper"',
              image: EmotionOption3,
              description: 'Ryan rarely shows emotions or talks about feelings. Dad notices him looking down during play.\n"Would you like to draw how you\'re feeling? Here are some colored pencils - sometimes drawing feelings helps when words are hard to find."',
              recommendations: []
            }
          ]
        },
        {
          title: 'Sensory Sensitivity',
          scenarios: [
            {
              title: '🎧 "Noise-Cancelling Headphones as \'Brave Equipment\'"',
              image: SensoryOption0,
              description: 'Andy covers his ears and starts rocking as the supermarket gets louder. Mom kneels down and gently offers his headphones.\n"Here\'s your brave equipment. These will turn down the volume so you can be comfortable while we finish shopping."',
              recommendations: []
            },
            {
              title: '🛁 "Bath Time Can Be Gradually Adapted"',
              image: SensoryOption1,
              description: 'Today we\'ll only wash your hair, not your face, and we\'ll cover your eyes with a towel right away when we\'re done, okay? You\'re being so brave today. Next time you can try pouring the water yourself!\n(Mimi cries loudly every time she has to wash her hair. Mom gently pours water while singing her favorite song. Though Mimi frowns, she doesn\'t scream and gradually adapts to this new rhythm)',
              recommendations: []
            },
            {
              title: '🕶️ "Special Sunglasses Mission"',
              image: SensoryOption2,
              description: 'Max squints and covers his eyes in the bright store lights. Mom gently hands him his sunglasses.\n"Let\'s put on your special sunglasses for our shopping mission. They\'ll protect your eyes from the bright lights so you can be my shopping detective."',
              recommendations: []
            },
            {
              title: '🏃‍♂️ "Movement Breaks"',
              image: SensoryOption3,
              description: 'Joshua starts fidgeting and rocking in his chair during homework. Mom sets a visual timer.\n"Let\'s take a 5-minute movement break. You can choose: jumping jacks, animal walks, or dancing. Then we\'ll come back to finish your math."',
              recommendations: []
            }
          ]
        }
      ]
    };
  },
  methods: {
    // Fetch recommendation data from API
    async fetchData() {
      this.loading = true;
      this.error = null;
      
      // count time
      const startTime = Date.now();
      
      try {
        console.log('Starting to fetch recommendation data for all scenarios');
        
        // For each scenario, get recommendation data in sequence
        for (let categoryIndex = 0; categoryIndex < this.scenarioData.length; categoryIndex++) {
          const category = this.scenarioData[categoryIndex];
          console.log(`Fetching recommendation data for ${category.title} category`);
          
          for (let scenarioIndex = 0; scenarioIndex < category.scenarios.length; scenarioIndex++) {
            const scenario = category.scenarios[scenarioIndex];
            
            // Calculate option ID: based on category and scenario index
            const optionId = categoryIndex * 4 + scenarioIndex + 1;
            console.log(`Fetching recommendation data for option ID ${optionId}, corresponding to ${category.title} - ${scenario.title}`);
            
            try {
              const res = await fetch(`/api/recommendations/${optionId}`);
              
              if (!res.ok) {
                console.error(`Failed to fetch data for option ID ${optionId}: ${res.status}`);
                continue;
              }
              
              const data = await res.json();
              
              if (data && data.length > 0) {
                // Assign API returned data to corresponding scenario's recommendations
                scenario.recommendations = data;
                console.log(`Option ID ${optionId} received ${data.length} recommendations`);
              } else {
                console.warn(`Option ID ${optionId} returned no recommendation data`);
              }
            } catch (err) {
              console.error(`Error fetching recommendation data for option ID ${optionId}:`, err);
            }
          }
        }
        
        console.log('All recommendation data fetching completed');
      } catch (err) {
        console.error('Error during recommendation data fetching process:', err);
        this.error = `Failed to load data: ${err.message}`;
      } finally {
        // count past time
        const elapsedTime = Date.now() - startTime;
        // less than 2 sec, close the page
        const minLoadingTime = 1000; // 1 sec
        
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
    }
  },
  // Fetch data when component is created
  async created() {
    console.log('Summary component created, preparing to fetch all recommendation data');
    await this.fetchData();
  }
};
</script>

<style scoped>
.summary-container {
  padding: 2rem;
  max-width: 1200px;
  margin: auto;
}

.summary-title {
  font-size: 2rem;
  color: #4d2f20;
  margin-bottom: 2rem;
  text-align: center;
}

.loading-container, .error-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 3rem;
  margin: 2rem auto;
  max-width: 800px;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.loading-spinner {
  width: 50px;
  height: 50px;
  border: 5px solid #f3f3f3;
  border-top: 5px solid #3E5C2B;
  border-radius: 50%;
  animation: spin 1.5s linear infinite;
  margin-bottom: 1rem;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading-container p {
  font-size: 1.1rem;
  color: #666;
}

.error-container {
  text-align: center;
}

.error-message {
  font-size: 1.1rem;
  color: #ff4d4d;
  margin-bottom: 1rem;
}

.retry-button {
  padding: 0.6rem 1.2rem;
  background-color: #3E5C2B;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-size: 1rem;
  transition: background-color 0.2s;
}

.retry-button:hover {
  background-color: #4d7234;
}

.summary-content {
  font-family: 'Arial', sans-serif;
  color: #333;
  line-height: 1.6;
  border: 1px solid #ddd;
  padding: 2rem;
  background: white;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  max-width: 800px;
  margin: 0 auto;
}

.handbook-cover {
  text-align: center;
  padding: 2rem 0;
  margin-bottom: 2rem;
  color: #3E5C2B;
}

.handbook-cover h1 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
}

.handbook-cover h2 {
  font-size: 1.5rem;
  font-weight: normal;
  margin-bottom: 2rem;
}

.handbook-image {
  width: 100%;
  max-width: 400px;
  margin: 0 auto;
  border-radius: 16px;
}

.handbook-image img {
  width: 100%;
  border-radius: 16px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.handbook-intro, .handbook-conclusion {
  padding: 1.5rem;
  margin-bottom: 2rem;
  border-radius: 8px;
  background-color: #f9f9f9;
}

.handbook-intro h2, .handbook-conclusion h2, .scenario-section h2 {
  font-size: 1.8rem;
  color: #3E5C2B;
  margin-bottom: 1.5rem;
}

.handbook-intro p, .handbook-conclusion p {
  font-size: 1rem;
  line-height: 1.6;
}

.scenario-section {
  margin-bottom: 2rem;
  padding: 1rem;
}

.scenario-card {
  margin-bottom: 2rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid #eee;
}

.scenario-card h3 {
  font-size: 1.3rem;
  color: #4d2f20;
  margin-bottom: 1rem;
}

.scenario-content {
  display: flex;
  gap: 1.5rem;
  margin-bottom: 1.5rem;
}

.scenario-image {
  flex: 1;
}

.scenario-image img {
  width: 100%;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.scenario-description {
  flex: 1;
  font-size: 1rem;
}

.scenario-advice h4 {
  font-size: 1.2rem;
  color: #3E5C2B;
  margin-bottom: 0.8rem;
}

.scenario-advice .detailed-recommendations {
  padding-left: 1.5rem;
}

.scenario-advice .recommendation-item {
  margin-bottom: 0.6rem;
  font-size: 0.95rem;
}

.scenario-advice .recommendation-title {
  font-size: 1.1rem;
  color: #4d2f20;
  margin-bottom: 0.2rem;
}

.scenario-advice .recommendation-content {
  font-size: 0.95rem;
}

.scenario-advice .recommendation-example {
  font-size: 0.9rem;
  color: #666;
}

.scenario-advice li {
  margin-bottom: 0.6rem;
  font-size: 0.95rem;
}

/* Detailed recommendations styles */
.detailed-recommendations {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.recommendation-item {
  padding: 1rem;
  background-color: #f9f9f9;
  border-radius: 8px;
  border-left: 3px solid #3E5C2B;
}

.recommendation-title {
  font-size: 1.1rem;
  color: #3E5C2B;
  margin-top: 0;
  margin-bottom: 0.5rem;
  font-weight: 600;
}

.recommendation-content {
  font-size: 0.95rem;
  margin-bottom: 0.8rem;
}

.recommendation-example {
  background-color: rgba(62, 92, 43, 0.1);
  padding: 0.8rem;
  border-radius: 6px;
  font-size: 0.9rem;
}

.example-label {
  font-weight: 600;
  color: #3E5C2B;
}

/* Responsive design */
@media (max-width: 768px) {
  .scenario-content {
    flex-direction: column;
  }
  
  .summary-content {
    padding: 1rem;
  }
  
  .handbook-cover h1 {
    font-size: 2rem;
  }
  
  .handbook-cover h2 {
    font-size: 1.2rem;
  }
}
</style>
