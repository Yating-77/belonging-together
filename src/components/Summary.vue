<template>
  <div class="summary-container">
    <h1 class="summary-title">Project Summary</h1>
    
    <div id="summary-content" class="summary-content">
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
            <ul>
              <li v-for="(advice, adviceIndex) in scenario.advices" :key="adviceIndex">{{ advice }}</li>
            </ul>
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
      scenarioData: [
        {
          title: 'Sleep Issues',
          scenarios: [
            {
              title: '🌙 "Counting Stars Together"',
              image: SleepOption0,
              description: 'Timmy lies in bed, tossing and turning, unable to fall asleep. Mom walks into the room quietly, turns off the main light, turns on the night light, and sits on the edge of the bed.\n"Let\'s play a game to see who can count 10 stars and then fall asleep first, okay?"',
              advices: [
                'Maintain a consistent bedtime routine, such as regular bath and tooth brushing times, to establish a biological clock for your child.',
                'Create a comfortable sleep environment that helps your child fall asleep faster.',
                'Limit screen time, as blue light interferes with melatonin production.',
                'Engage in quiet, calming activities before bed to help your child relax physically and mentally.',
                'Ensure your child gets plenty of outdoor activities and exercise during the day, making it easier to fall asleep after expending energy.'
              ]
            },
            {
              title: '🧸 "Let\'s Sleep Together"',
              image: SleepOption1,
              description: 'In the middle of the night, Tommy wakes up for the third time, crying loudly for mom.\nMom, tired but patient, walks into the room: "Tommy, here\'s your friend Bear, he\'ll keep you company. I\'m just next door, and you\'re safe."',
              advices: [
                'Maintain a consistent sleep environment where your child will feel secure if they wake up during the night.',
                'Respond calmly to night wakings, keeping interactions minimal and helping your child return to sleep.',
                'Provide comfort items that give your child a sense of security to help them self-soothe.',
                'Create a consistent sensory environment to reduce stimuli that might wake your child.',
                'Teach your child self-soothing skills for both falling asleep and night wakings.'
              ]
            },
            {
              title: '📚 "Bedtime Story Ritual"',
              image: SleepOption2,
              description: 'Emma resists going to bed every night. Dad creates a special routine, laying out pajamas in a fun way and preparing a book.\n"Emma, it\'s story time with Mr. Rabbit! He\'s waiting to hear what happens next in our adventure book."',
              advices: [
                'Create a visual bedtime schedule with pictures showing each step of the routine, helping your child understand what comes next.',
                'Make the transition to bedtime fun and something to look forward to with special books or stuffed animals that only appear at bedtime.',
                'Keep the routine consistent every night, as children with autism thrive on predictability.',
                'Give advance warnings before bedtime (15 minutes, 10 minutes, 5 minutes) to help your child transition.',
                'Celebrate successful bedtime routines with small rewards or praise the next morning.'
              ]
            },
            {
              title: '🏕️ "First Night at Grandma\'s House"',
              image: SleepOption3,
              description: 'This bed doesn\'t feel like mine... The lights are different too...\nWe can still do our bedtime ritual here. Let\'s make this corner your special place.',
              advices: [
                'Bring familiar items such as favorite blankets, pillows, or toys to increase familiar elements in the new environment.',
                'Replicate home bedtime rituals as much as possible, maintaining the same steps and sequence.',
                'Help your child become familiar with the new environment by exploring the new room together, reducing anxiety from the unknown.',
                'Use portable white noise machines or play familiar music to mask unfamiliar sounds in the new environment.',
                'Maintain consistent sleeping schedules in the new environment, not changing bedtime due to the change in surroundings.',
                'Validate your child\'s feelings while providing security and encouragement, acknowledging that their discomfort is normal.',
                'If conditions allow, consider a gradual adaptation process, such as short stays before overnight stays, to adjust gradually.'
              ]
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
              advices: [
                'Use a "food bridge" strategy by placing new foods alongside familiar foods that your child enjoys.',
                'Research shows children with autism may need 10+ exposures before trying new foods. Be patient and continue offering the same new food at different meals.',
                'When offering new foods, make sure there are always some familiar foods on the plate.',
                'Make exploring food fun by turning it into a sensory game - smell, touch, and then taste.',
                'Use positive reinforcement and celebrate small steps, like touching or smelling a new food, even if your child doesn\'t eat it.'
              ]
            },
            {
              title: '🍽️ "Colorful Plate Design"',
              image: DietOption1,
              description: 'Mom arranges vegetables and fruits into a smiley face on Jason\'s plate. His eyes widen with interest.\n"Look, the cucumber is smiling at you! Which part would you like to try first?"',
              advices: [
                'Make food visually appealing through creative arrangements, shapes, or colors to increase interest.',
                'Allow your child to participate in food preparation, which can increase willingness to try new foods.',
                'Respect food aversions that may be related to sensory issues while gently encouraging exploration.',
                'Create positive mealtime environments without pressure or forcing food consumption.',
                'Consider food texture, temperature, and taste preferences which may be more pronounced in children with autism.'
              ]
            },
            {
              title: '🥄 "Tasting Party"',
              image: DietOption2,
              description: 'Dad sets up small portions of different foods on a tray. "Today we\'re having a tasting party! You can use this special card to rate each food - happy face, neutral face, or thinking face. No need to eat it all, just a tiny taste!"',
              advices: [
                'Introduce new foods in very small portions to make the experience less overwhelming.',
                'Use a reward system that acknowledges brave tasting attempts, not necessarily liking the food.',
                'Create a food journal with your child to track foods they\'ve tried and their reactions.',
                'Consider sensory-friendly utensils, plates, and cups that may make mealtimes more comfortable.',
                'Consult with a nutritionist who specializes in autism to address specific dietary needs and concerns.'
              ]
            },
            {
              title: '⏰ "Racing with the little hourglass"',
              image: DietOption3,
              description: 'Tick tock, the timer has started! Can you finish your bite before all the sand falls to the bottom?\nI want to finish before the sand runs out! *Takes bites while watching the timer*',
              advices: [
                'Establish a regular meal schedule with three meals and two snacks at consistent times each day.',
                'Use visual supports like timers or picture schedules to help your child understand mealtime expectations.',
                'Make mealtime engaging with gentle mealtime games that encourage appropriate eating pace and sitting.',
                'Start with realistic sitting duration goals (even just 2-3 minutes) and gradually increase the time.',
                'Ensure your child comes to the table physically ready to eat (not too tired, not too full from snacking).'
              ]
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
              advices: [
                'Start with parallel play, allowing your child to play with similar toys as others without requiring direct interaction.',
                'Build connections through shared interests, using your child\'s interests as a social bridge to peers with similar preferences.',
                'Create safe social spaces by designing structured environments where social interactions are predictable and manageable.',
                'Respect personal pace and recognize when your child needs breaks from social settings to prevent overstimulation.',
                'Value small steps by acknowledging and celebrating incremental progress in social participation, no matter how small.',
                'Facilitate initial interactions by offering specific suggestions like building a track together, rather than broad directions like "play together".',
                'Coach other children on how to approach and interact with your child in a way that feels comfortable and non-threatening.'
              ]
            },
            {
              title: '👥 "Friendship Scripts"',
              image: SocialOption1,
              description: 'Before heading to the birthday party, Mom reviews some simple phrases with Mia: "You can say \'I like your cake\' or \'Thank you for inviting me\'. If you need a break, just squeeze my hand twice."',
              advices: [
                'Practice social scripts for common situations to help your child feel prepared and confident.',
                'Develop a discreet signal system that allows your child to communicate when they\'re feeling overwhelmed.',
                'Use social stories with pictures to prepare your child for upcoming social events and explain expected behaviors.',
                'Consider shorter playdates in familiar environments before attempting larger social gatherings.',
                'Teach specific friendship skills explicitly, such as sharing, taking turns, and showing interest in others.'
              ]
            },
            {
              title: '🏠 "Structured Play Date"',
              image: SocialOption2,
              description: 'Dad has arranged the living room with three activity stations: building blocks, drawing, and a simple board game. "When Ben comes over, you can show him these three games we\'ve set up. Which one would you like to start with?"',
              advices: [
                'Plan structured activities for playdates with clear beginnings, middles, and ends to reduce social anxiety.',
                'Include activities that don\'t require constant verbal interaction, allowing for comfortable silence.',
                'Prepare your child by discussing who is coming, what they will do, and for how long.',
                'Have a quiet space ready where your child can retreat if they feel overwhelmed.',
                'Invite peers who are patient, kind, and potentially have been educated about autism.'
              ]
            },
            {
              title: '🦕 "Sharing the Joy of Dinosaurs"',
              image: SocialOption3,
              description: 'You could ask him which dinosaur is his favorite.\n(Stops his own explanation) Which one do you like? (After hearing the answer, they begin exchanging dinosaur cards)',
              advices: [
                'Use your child\'s special interests as a starting point for social interaction rather than discouraging them.',
                'Teach specific turn-taking language related to interests: "Now I\'ll tell you about my favorite dinosaur, then you can share yours."',
                'Create structured interest-sharing activities where your child can be the "expert" but must follow rules for including others.',
                'Help your child recognize when others are losing interest by pointing out non-verbal cues in a supportive way.',
                'Gradually expand the circle of interest by connecting your child\'s passion to related topics that might interest peers.',
                'Encourage flexibility by introducing small variations to favorite activities, teaching that fun can happen with slight changes.',
                'Arrange playdates with children who share similar interests to create natural opportunities for connection.'
              ]
            }
          ]
        },
        {
          title: 'Communication',
          scenarios: [
            {
              title: '✋ Small Cards Convey Wishes',
              image: CommunicationOption0,
              description: 'What would you like to eat? You can look at the picture cards to tell me.\n(Amy stares at the "cookie" card for a moment, then nods and takes the "cookie" card to give to mom)',
              advices: [
                'Introduce alternative communication systems like the Picture Exchange Communication System (PECS) that uses visual cards representing common items, activities, and needs.',
                'Offer choices rather than open-ended questions, giving your child opportunities to express preferences between two options.',
                'Pair gestures with simple words, consistently using gestures alongside simple verbal language when communicating.',
                'Acknowledge all communication attempts, regardless of the method used.',
                'Create a rich communication environment by structuring your home to encourage communication opportunities throughout the day.',
                'Be patient and allow extra time for your child to process and respond to communication exchanges.',
                'Celebrate and positively reinforce successful communication attempts to build confidence and motivation.'
              ]
            },
            {
              title: '🗣️ "First-Then Board"',
              image: CommunicationOption1,
              description: 'Mike becomes agitated when it\'s time to leave the playground. Dad pulls out a small board with two pictures. "Look Mike, first we need to go to the store, then we can have ice cream. First store, then ice cream."',
              advices: [
                'Use visual supports like First-Then boards to help your child understand sequences of activities, especially when transitioning away from preferred activities.',
                'Keep language simple and concrete, avoiding idioms, sarcasm, or abstract concepts that may be confusing.',
                'Allow extra processing time for your child to respond to questions or instructions.',
                'Support verbal communication with visual cues whenever possible.',
                'Be consistent with language across different settings and with different people in your child\'s life.'
              ]
            },
            {
              title: '📱 "Tech-Assisted Communication"',
              image: CommunicationOption3,
              description: 'Sarah uses a tablet app to tap on pictures that speak words aloud. At the doctor\'s office, she taps on the "hurt" icon and then points to her throat. The doctor nods with understanding.',
              advices: [
                'Explore communication apps designed specifically for children with autism that can grow with their developing abilities.',
                'Ensure all caregivers and educators know how to use and respond to your child\'s communication system.',
                'Practice communication in various settings and with different people to promote generalization of skills.',
                'Focus on communication function rather than form - the message is more important than how it\'s delivered.',
                'Update communication tools regularly based on your child\'s changing interests, vocabulary needs, and abilities.'
              ]
            },
            {
              title: '💡 "Small Questions, Big Encouragement"',
              image: CommunicationOption4,
              description: 'Yes, it\'s a red balloon! Would you like to touch it? You just told mommy you wanted to see the balloon, that\'s wonderful!\nBalloon! (Smiles and nods slightly)',
              advices: [
                'Create an "irresistible communication environment" by placing desired items in sight but out of reach, creating natural opportunities for your child to request them.',
                'Implement a "wait time" strategy - pause expectantly after asking a question or during an interaction, giving your child extra time to formulate a response.',
                'Celebrate every communication initiation, no matter how small, with specific praise: "You told me you wanted the ball! Great talking!"',
                'Introduce "sabotage" techniques in familiar routines - deliberately create a problem your child needs to communicate about (like forgetting a spoon at mealtime).',
                'Use highly motivating activities and special interests to encourage spontaneous communication through excitement and engagement.',
                'Create a communication-rich but low-pressure environment where requests are consistently honored, building trust that speaking leads to positive outcomes.',
                'Consider a "communication temptations" approach, strategically arranging the environment with interesting but inaccessible items that might prompt your child to initiate interaction.'
              ]
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
              advices: [
                'Teach simple breathing techniques like "smell the flower, blow the candle" to help your child regulate intense emotions during difficult moments.',
                'Create a calm-down corner at home, equipped with sensory tools like stress balls, weighted blankets, or toys that help your child calm down during emotional moments.',
                'Use visual supports like an emotions thermometer or traffic light system to help your child identify when emotions are escalating before reaching crisis point.',
                'Practice emotion regulation strategies during calm times, not just during meltdowns, to build the neural pathways needed for self-regulation.',
                'Acknowledge your child\'s feelings before attempting to solve problems: "I see you\'re feeling very upset that your tower fell down. It\'s okay to feel disappointed."',
                'Offer constructive solutions after emotional regulation: "Let\'s rebuild the tower together" provides a positive next step.',
                'Be a calm presence yourself, as children often mirror the emotional state of their caregivers.'
              ]
            },
            {
              title: '📊 "Emotion Chart"',
              image: EmotionOption1,
              description: 'Dad points to a colorful chart with different facial expressions. "Ryan, can you show me which face shows how you\'re feeling right now?" Ryan studies the chart and points to the "frustrated" face, then to his math homework.',
              advices: [
                'Create visual emotion charts that help your child identify and express their feelings when they struggle to do so verbally.',
                'Develop a shared emotional vocabulary with simple terms your child can understand and use.',
                'Read books about emotions with your child and discuss how characters feel in different situations.',
                'Validate emotions without judgment: "It\'s okay to feel angry, but we need safe ways to show anger."',
                'Work on identifying emotional triggers through pattern recognition and documenting situations that lead to emotional difficulties.'
              ]
            },
            {
              title: '⏱️ "Calm Down Timer"',
              image: EmotionOption2,
              description: 'Lisa becomes upset when it\'s time to transition to a new activity. Mom shows her a visual timer with colorful sand flowing down. "We\'ll switch activities when the blue sand reaches the bottom. You have time to prepare."',
              advices: [
                'Use visual timers to make abstract time concepts concrete and predictable, especially during transitions.',
                'Create personalized social stories about managing difficult emotions in specific situations.',
                'Develop a menu of calming strategies tailored to your child\'s preferences that they can choose from when upset.',
                'Model emotional regulation by narrating your own feelings and coping strategies: "I\'m feeling frustrated too, so I\'m going to take three deep breaths."',
                'Celebrate emotional regulation successes, recognizing when your child has successfully managed a difficult situation.',
                'Give advance warnings about transitions using both verbal cues and visual supports.',
                'Provide choices within transitions to give your child a sense of control: "When the timer finishes, would you like to put away the toys yourself or should we do it together?"'
              ]
            },
            {
              title: '🎨 "Feelings Drawn on Paper"',
              image: EmotionOption3,
              description: 'Today feels like a rainy mood, right? Mom is here, and if you want to say anything, just let me know anytime.\n(Returned from school without saying a word, quietly took out drawing paper and drew a dark cloud. Nodded gently)',
              advices: [
                'Provide alternative forms of emotional expression beyond verbal communication, such as drawing feelings, using emotion cards, or expressing through music.',
                'Create a daily "check-in" ritual using visual emotion scales or charts where your child can indicate their feelings without having to verbalize them.',
                'Use special interest areas as entry points for emotional conversations, as children often feel more comfortable discussing feelings in the context of preferred topics.',
                'Read stories featuring characters experiencing different emotions, then connect these narratives to your child\'s experiences in a gentle, non-pressuring way.',
                'Allow processing time and avoid rushing emotional conversations - children who struggle with emotional expression often need longer to formulate their responses.',
                'Maintain a predictable "emotion-safe" environment where all feelings are acknowledged as valid, creating safety for eventual emotional expression.',
                'Consider the communication environment - some children express more freely during movement activities, in darkened rooms, or when not facing their conversation partner directly.'
              ]
            }
          ]
        },
        {
          title: 'Sensory Sensitivity',
          scenarios: [
            {
              title: '🎧 Noise-Cancelling Headphones as "Brave Equipment"',
              image: SensoryOption0,
              description: 'Let\'s put on your "brave headphones." You\'re doing so well today, even better than last time.\n(Before going to the supermarket, Andy is already frowning. When entering the supermarket, Andy wears headphones and holds a small car toy. Despite the noisy crowd, he can quietly choose items by the shelves)',
              advices: [
                'Provide noise-reducing headphones or earplugs in environments your child finds overwhelming, allowing them to participate while reducing sensory input.',
                'Create a "sensory toolkit" with items that provide comfort (favorite small toys, stress balls, fidget spinners) that can be taken to challenging environments.',
                'Prepare your child in advance for noisy or busy environments using visual schedules and simple social stories that explain what to expect.',
                'Choose quieter times to visit potentially overwhelming places (like supermarkets), such as early mornings or evenings when there are fewer people.',
                'Use gradual exposure techniques, starting with brief visits to challenging environments and slowly increasing duration as your child builds tolerance.',
                'Frame adaptive tools positively, like calling headphones "brave equipment," to promote a positive self-image.',
                'Recognize and celebrate progress by acknowledging when your child handles challenging environments better than previous attempts.'
              ]
            },
            {
              title: '👕 "Comfort Clothes"',
              image: SensoryOption1,
              description: 'Mom gently offers two soft cotton shirts with all tags removed. "Daniel, would you like to wear the blue shirt or the green shirt today? Both are super soft, just how you like them."',
              advices: [
                'Remove clothing tags, opt for seamless socks, and choose fabrics based on your child\'s sensory preferences.',
                'Allow your child to participate in selecting comfortable clothes, respecting their sensory needs.',
                'Consider compression clothing or weighted vests if your child seeks deep pressure input.',
                'Be aware of how temperature affects sensory comfort - layers that can be adjusted may be helpful.',
                'Respect sensory preferences while gradually introducing small variations to help build flexibility.',
                'Offer limited choices rather than overwhelming options: "Would you like the blue shirt or the green shirt?" rather than "What do you want to wear?"',
                'Create a sensory-friendly wardrobe by selecting clothes with consistent textures, weights, and fits that your child finds comfortable.'
              ]
            },
            {
              title: '🥢 "Texture Exploration Station"',
              image: SensoryOption2,
              description: 'Dad sets up bins with different materials - rice, water beads, shaving cream, and kinetic sand. "Emily, you can choose which one you\'d like to touch today. We can start with just one finger if you want."',
              advices: [
                'Create safe sensory exploration activities at home to help your child process different textures in a controlled environment.',
                'Respect sensory aversions while gently encouraging gradual exploration at your child\'s pace.',
                'Consider occupational therapy for professional guidance on sensory integration activities.',
                'Create a sensory profile for your child, documenting sensory seekers (needing more input) and sensory avoiders (being overwhelmed by input) across all senses.',
                'Develop a sensory diet - a personalized activity plan designed to meet your child\'s sensory needs throughout the day.',
                'Start with the least challenging sensory experiences: "We can start with just one finger" shows respect for boundaries.',
                'Follow your child\'s lead and celebrate each small step in sensory exploration without pushing beyond their comfort zone.'
              ]
            },
            {
              title: '🏃‍♂️ "A Day\'s Energy Needs Special Planning"',
              image: SensoryOption3,
              description: 'Noah, it\'s movement time. First, jump on the bouncy ball for 10 minutes, then spin a few times on the rotating chair, and finally go to the climbing wall, okay?\n(Noah has just returned home from school and starts running in circles around the sofa before even taking off his shoes, shaking his head as he runs. He\'s mumbling something but his eyes aren\'t focused. When he hears the movement plan, his expression becomes focused, and he begins each activity in sequence)',
              advices: [
                'Schedule regular "movement breaks" throughout your child\'s day, providing appropriate physical outlets before periods requiring sitting or focused attention.',
                'Create a dedicated sensory space at home with equipment like mini trampolines, therapy swings, crash pads, or climbing structures that safely meet vestibular needs.',
                'Introduce "heavy work" activities that provide proprioceptive input, such as carrying groceries, pushing a loaded cart, or animal walks (bear crawls, crab walks).',
                'Use therapy tools like weighted blankets, compression vests, or body socks that provide deep pressure input, helping to organize your child\'s sensory system.',
                'Collaborate with your child\'s teacher to incorporate movement into learning (standing desks, therapy ball seating, errands that involve walking).',
                'Establish a structured "sensory diet" with occupational therapy guidance - a personalized activity plan that provides needed sensory input throughout the day.',
                'Teach your child to recognize their own need for movement and develop appropriate ways to seek input (jumping jacks in the bathroom vs. running in the classroom).'
              ]
            },
            {
              title: '🛁 "Bath Time Can Be Gradually Adapted"',
              image: SensoryOption1,
              description: 'Today we\'ll only wash your hair, not your face, and we\'ll cover your eyes with a towel right away when we\'re done, okay? You\'re being so brave today. Next time you can try pouring the water yourself!\n(Mimi cries loudly every time she has to wash her hair. Mom gently pours water while singing her favorite song. Though Mimi frowns, she doesn\'t scream and gradually adapts to this new rhythm)',
              advices: [
                'Break hygiene routines into small, predictable steps that your child can anticipate, focusing on one challenging element at a time.',
                'Use visual schedules with pictures or simple drawings to outline each step of the process, reviewing them before beginning and tracking progress throughout.',
                'Provide sensory-friendly alternatives, such as dry shampoo occasionally, shower instead of bath, or bath wipes for particularly difficult days.',
                'Incorporate preferred elements into challenging routines, like bringing favorite waterproof toys into the bath or playing favorite music during nail trimming.',
                'Give your child appropriate control where possible, such as choosing water temperature, selecting which body part to wash first, or holding the nail clippers themselves.',
                'Use sensory preparation techniques before challenging routines, like deep pressure massage before baths or hand-warming before nail trimming to reduce tactile sensitivity.',
                'Celebrate small improvements with specific praise that focuses on the effort: "You kept your hand still for three nails today! That was really brave."'
              ]
            }
          ]
        }
      ]
    };
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

/* Summary content styles */
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

.scenario-advice ul {
  padding-left: 1.5rem;
}

.scenario-advice li {
  margin-bottom: 0.6rem;
  font-size: 0.95rem;
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
