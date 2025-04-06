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
      scenarioData: [
        {
          title: 'Sleep Issues',
          scenarios: [
            {
              title: '🌙 "Counting Stars Together"',
              image: SleepOption0,
              description: 'Timmy lies in bed, tossing and turning, unable to fall asleep. Mom walks into the room quietly, turns off the main light, turns on the night light, and sits on the edge of the bed.\n"Let\'s play a game to see who can count 10 stars and then fall asleep first, okay?"',
              recommendations: [
                {
                  title: 'Establish Consistent Bedtime Routine',
                  content: 'Create a regular routine before bed that remains the same each night to signal to your child\'s body that it\'s time to sleep.',
                  example: 'Follow the same sequence of activities each night: bath, brushing teeth, story, and bed. This consistency helps establish your child\'s biological clock.'
                },
                {
                  title: 'Create a Calming Environment',
                  content: 'Design a sleep space that minimizes stimulation and promotes relaxation.',
                  example: 'Use soft lighting, maintain a comfortable temperature (typically 65-70°F/18-21°C), and reduce noise. Consider a white noise machine if environmental sounds are disruptive.'
                },
                {
                  title: 'Limit Screen Time',
                  content: 'Reduce or eliminate exposure to screens (TV, tablets, phones) at least one hour before bedtime.',
                  example: 'The blue light from screens can suppress melatonin production. Replace screen time with calming activities like reading books, listening to gentle music, or quiet play.'
                },
                {
                  title: 'Incorporate Calming Activities',
                  content: 'Include relaxing activities in the bedtime routine that help transition from the day\'s stimulation to sleep.',
                  example: 'Try gentle stretching, reading a familiar book, listening to soft music, or practicing deep breathing together. For some children, a warm bath can be calming before bed.'
                },
                {
                  title: 'Use Visual Supports',
                  content: 'Provide visual cues to help your child understand and follow the bedtime routine.',
                  example: 'Create a simple picture schedule showing each step of the bedtime routine. Review this together before starting the routine and reference it as you move through each step.'
                }
              ]
            },
            {
              title: '🧸 "Let\'s Sleep Together"',
              image: SleepOption1,
              description: 'In the middle of the night, Tommy wakes up for the third time, crying loudly for mom.\nMom, tired but patient, walks into the room: "Tommy, here\'s your friend Bear, he\'ll keep you company. I\'m just next door, and you\'re safe."',
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
              title: '📚 "Bedtime Story Ritual"',
              image: SleepOption2,
              description: 'Emma resists going to bed every night. Dad creates a special routine, laying out pajamas in a fun way and preparing a book.\n"Emma, it\'s story time with Mr. Rabbit! He\'s waiting to hear what happens next in our adventure book."',
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
              title: '🏕️ "First Night at Grandma\'s House"',
              image: SleepOption3,
              description: 'This bed doesn\'t feel like mine... The lights are different too...\nWe can still do our bedtime ritual here. Let\'s make this corner your special place.',
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
          scenarios: [
            {
              title: '🥕 "Food Explorer"',
              image: DietOption0,
              description: 'Lucy looks at the carrot on her plate with a frown.\nDad smiles and says, "Today we\'re going to be food explorers! First, let\'s smell this orange treasure, then touch it with our fingers, okay?"',
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
              title: '🍽️ "Colorful Plate Design"',
              image: DietOption1,
              description: 'Mom arranges vegetables and fruits into a smiley face on Jason\'s plate. His eyes widen with interest.\n"Look, the cucumber is smiling at you! Which part would you like to try first?"',
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
              title: '📅 "Mealtime Schedule"',
              image: DietOption2,
              description: 'Lisa runs around the room as dad prepares lunch. Dad gently guides her to a colorful chart on the wall.\n"Look, it\'s 12 o\'clock. The clock is pointing to the sandwich picture. That means it\'s lunchtime!"',
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
            },
            {
              title: '⏰ "Racing with the little hourglass"',
              image: DietOption3,
              description: 'Tick tock, the timer has started! Can you finish your bite before all the sand falls to the bottom?\nI want to finish before the sand runs out! *Takes bites while watching the timer*',
              recommendations: [
                {
                  title: 'Establish a regular meal schedule',
                  content: 'Establish a regular meal schedule with three meals and two snacks at consistent times each day.',
                  example: 'Dad ensures a regular meal schedule.'
                },
                {
                  title: 'Use visual supports',
                  content: 'Use visual supports like timers or picture schedules to help your child understand mealtime expectations.',
                  example: 'Dad uses a timer to help Jason understand the expectation of finishing his meal.'
                },
                {
                  title: 'Make mealtime engaging',
                  content: 'Make mealtime engaging with gentle mealtime games that encourage appropriate eating pace and sitting.',
                  example: 'Dad plays a mealtime game with Jason.'
                },
                {
                  title: 'Start with realistic sitting duration goals',
                  content: 'Start with realistic sitting duration goals (even just 2-3 minutes) and gradually increase the time.',
                  example: 'Dad starts with a short sitting duration goal.'
                },
                {
                  title: 'Ensure physical readiness',
                  content: 'Ensure your child comes to the table physically ready to eat (not too tired, not too full from snacking).',
                  example: 'Dad ensures Jason is physically ready to eat.'
                }
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
              recommendations: [
                {
                  title: 'Start with parallel play',
                  content: 'Start with parallel play, allowing your child to play with similar toys as others without requiring direct interaction.',
                  example: 'Johnny and Alex play with their toy cars separately.'
                },
                {
                  title: 'Build connections',
                  content: 'Build connections through shared interests, using your child\'s interests as a social bridge to peers with similar preferences.',
                  example: 'Johnny and Alex build a track together.'
                },
                {
                  title: 'Create safe social spaces',
                  content: 'Create safe social spaces by designing structured environments where social interactions are predictable and manageable.',
                  example: 'The teacher creates a structured environment for the children to play together.'
                },
                {
                  title: 'Respect personal pace',
                  content: 'Respect personal pace and recognize when your child needs breaks from social settings to prevent overstimulation.',
                  example: 'The teacher allows Johnny and Alex to play at their own pace.'
                },
                {
                  title: 'Value small steps',
                  content: 'Value small steps by acknowledging and celebrating incremental progress in social participation, no matter how small.',
                  example: 'The teacher acknowledges and celebrates the progress Johnny and Alex make in building the track.'
                },
                {
                  title: 'Facilitate initial interactions',
                  content: 'Facilitate initial interactions by offering specific suggestions like building a track together, rather than broad directions like "play together".',
                  example: 'The teacher suggests building a track together.'
                },
                {
                  title: 'Coach other children',
                  content: 'Coach other children on how to approach and interact with your child in a way that feels comfortable and non-threatening.',
                  example: 'The teacher teaches other children how to interact with Johnny.'
                }
              ]
            },
            {
              title: '👋 "Approaching Peers"',
              image: SocialOption1,
              description: 'Emma stands at the edge of the playground, watching other children. She walks toward them but stops, unsure what to say.\nDad kneels beside her: "Remember what we practiced? You can say \'Can I play?\' Let\'s practice once more."',
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
              title: '🏠 "Structured Play Date"',
              image: SocialOption2,
              description: 'Dad has arranged the living room with three activity stations: building blocks, drawing, and a simple board game. "When Ben comes over, you can show him these three games we\'ve set up. Which one would you like to start with?"',
              recommendations: [
                {
                  title: 'Plan structured activities',
                  content: 'Plan structured activities for playdates with clear beginnings, middles, and ends to reduce social anxiety.',
                  example: 'Dad arranges the living room with three activity stations.'
                },
                {
                  title: 'Include activities without constant verbal interaction',
                  content: 'Include activities that don\'t require constant verbal interaction, allowing for comfortable silence.',
                  example: 'Dad arranges activities that do not require constant verbal interaction.'
                },
                {
                  title: 'Prepare your child',
                  content: 'Prepare your child by discussing who is coming, what they will do, and for how long.',
                  example: 'Dad discusses with Ben who is coming and what they will do.'
                },
                {
                  title: 'Have a quiet space ready',
                  content: 'Have a quiet space ready where your child can retreat if they feel overwhelmed.',
                  example: 'Dad has a quiet space ready for Ben.'
                },
                {
                  title: 'Invite peers',
                  content: 'Invite peers who are patient, kind, and potentially have been educated about autism.',
                  example: 'Dad invites Ben, who is patient, kind, and potentially educated about autism.'
                }
              ]
            },
            {
              title: '🦕 "Sharing the Joy of Dinosaurs"',
              image: SocialOption3,
              description: 'Noah talks non-stop about dinosaurs to a classmate who starts to look bored. Mom gently intervenes.\n"Noah, remember our talking timer? Let\'s let Jamie share what he likes too. You can ask, \'What do you like to play with?\'"',
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
          title: 'Communication',
          scenarios: [
            {
              title: '🖼️ "Picture Communication"',
              image: CommunicationOption0,
              description: 'David\'s eyes dart around as he tries to express what he wants. Mom opens a communication book with pictures.\n"Do you want a snack? You can show me by pointing to what you\'d like."',
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
              title: '🔄 "From Echo to Expression"',
              image: CommunicationOption1,
              description: 'Mark repeats, "Outside, outside" after hearing it in a TV show. Dad responds enthusiastically, "Yes, you want to go outside! Let\'s put on your shoes and we can go to the park."',
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
              title: '📖 "Comic Strip Conversations"',
              image: CommunicationOption3,
              description: 'Jamie\'s sentences are confused, making it hard to understand the story he\'s trying to tell about school. Mom takes out paper and draws simple stick figures.\n"Let\'s draw what happened first, then what happened next."',
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
              title: '💡 "Small Questions, Big Encouragement"',
              image: CommunicationOption4,
              description: 'Lisa rarely speaks in class. Her teacher notices she\'s drawing a butterfly and kneels beside her desk. "Is that a butterfly? What color will you make the wings?" Lisa whispers, "Blue." The teacher smiles warmly, "Blue wings will look beautiful!"',
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
          title: 'Emotional Management',
          scenarios: [
            {
              title: '🫧 "Let\'s Breathe Together"',
              image: EmotionOption0,
              description: 'Sam, let\'s use the "smell the flower, blow the candle" method. Breathe in—breathe out... Let\'s rebuild this tower together, okay?\n(Sam accidentally knocked over his block tower while playing. His eyes immediately welled up with tears, and he started crying loudly. Gradually calming down, he nods and begins to rearrange the blocks)',
              recommendations: [
                {
                  title: 'Teach simple breathing techniques',
                  content: 'Teach simple breathing techniques like "smell the flower, blow the candle" to help your child regulate intense emotions during difficult moments.',
                  example: 'Sam learns to breathe in and out to calm down.'
                },
                {
                  title: 'Create a calm-down corner',
                  content: 'Create a calm-down corner at home, equipped with sensory tools like stress balls, weighted blankets, or toys that help your child calm down during emotional moments.',
                  example: 'Mom creates a calm-down corner with sensory tools.'
                },
                {
                  title: 'Use visual supports',
                  content: 'Use visual supports like an emotions thermometer or traffic light system to help your child identify when emotions are escalating before reaching crisis point.',
                  example: 'Mom uses a traffic light system to help Sam identify his emotions.'
                },
                {
                  title: 'Practice emotion regulation strategies',
                  content: 'Practice emotion regulation strategies during calm times, not just during meltdowns, to build the neural pathways needed for self-regulation.',
                  example: 'Mom practices emotion regulation strategies with Sam.'
                },
                {
                  title: 'Acknowledge feelings',
                  content: 'Acknowledge your child\'s feelings before attempting to solve problems: "I see you\'re feeling very upset that your tower fell down. It\'s okay to feel disappointed."',
                  example: 'Mom acknowledges Sam\'s feelings.'
                },
                {
                  title: 'Offer constructive solutions',
                  content: 'Offer constructive solutions after emotional regulation: "Let\'s rebuild the tower together" provides a positive next step.',
                  example: 'Mom helps Sam rebuild his tower.'
                },
                {
                  title: 'Be a calm presence',
                  content: 'Be a calm presence yourself, as children often mirror the emotional state of their caregivers.',
                  example: 'Mom remains calm during Sam\'s emotional moment.'
                }
              ]
            },
            {
              title: '📊 "Emotion Chart"',
              image: EmotionOption1,
              description: 'Dad points to a colorful chart with different facial expressions. "Ryan, can you show me which face shows how you\'re feeling right now?" Ryan studies the chart and points to the "frustrated" face, then to his math homework.',
              recommendations: [
                {
                  title: 'Create visual emotion charts',
                  content: 'Create visual emotion charts that help your child identify and express their feelings when they struggle to do so verbally.',
                  example: 'Dad creates a visual emotion chart for Ryan.'
                },
                {
                  title: 'Develop a shared emotional vocabulary',
                  content: 'Develop a shared emotional vocabulary with simple terms your child can understand and use.',
                  example: 'Dad uses simple terms to help Ryan express his feelings.'
                },
                {
                  title: 'Read books about emotions',
                  content: 'Read books about emotions with your child and discuss how characters feel in different situations.',
                  example: 'Dad reads a book about emotions with Ryan and discusses the feelings of the characters.'
                },
                {
                  title: 'Validate emotions without judgment',
                  content: 'Validate emotions without judgment: "It\'s okay to feel angry, but we need safe ways to show anger."',
                  example: 'Dad validates Ryan\'s feelings without judgment.'
                },
                {
                  title: 'Work on identifying emotional triggers',
                  content: 'Work on identifying emotional triggers through pattern recognition and documenting situations that lead to emotional difficulties.',
                  example: 'Dad works on identifying emotional triggers with Ryan.'
                }
              ]
            },
            {
              title: '⏱️ "Calm Down Timer"',
              image: EmotionOption2,
              description: 'Lisa becomes upset when it\'s time to transition to a new activity. Mom shows her a visual timer with colorful sand flowing down. "We\'ll switch activities when the blue sand reaches the bottom. You have time to prepare."',
              recommendations: [
                {
                  title: 'Use visual timers',
                  content: 'Use visual timers to make abstract time concepts concrete and predictable, especially during transitions.',
                  example: 'Mom uses a visual timer to help Lisa understand the transition.'
                },
                {
                  title: 'Create personalized social stories',
                  content: 'Create personalized social stories about managing difficult emotions in specific situations.',
                  example: 'Mom creates a personalized social story for Lisa.'
                },
                {
                  title: 'Develop a menu of calming strategies',
                  content: 'Develop a menu of calming strategies tailored to your child\'s preferences that they can choose from when upset.',
                  example: 'Mom develops a menu of calming strategies for Lisa.'
                },
                {
                  title: 'Model emotional regulation',
                  content: 'Model emotional regulation by narrating your own feelings and coping strategies: "I\'m feeling frustrated too, so I\'m going to take three deep breaths."',
                  example: 'Mom models emotional regulation.'
                },
                {
                  title: 'Celebrate emotional regulation successes',
                  content: 'Celebrate emotional regulation successes, recognizing when your child has successfully managed a difficult situation.',
                  example: 'Mom celebrates Lisa\'s successful emotional regulation.'
                },
                {
                  title: 'Give advance warnings',
                  content: 'Give advance warnings about transitions using both verbal cues and visual supports.',
                  example: 'Mom gives advance warnings about the transition.'
                },
                {
                  title: 'Provide choices within transitions',
                  content: 'Provide choices within transitions to give your child a sense of control: "When the timer finishes, would you like to put away the toys yourself or should we do it together?"',
                  example: 'Mom provides choices within the transition.'
                }
              ]
            },
            {
              title: '🎨 "Feelings Drawn on Paper"',
              image: EmotionOption3,
              description: 'Ryan rarely shows emotions or talks about feelings. Dad notices him looking down during play.\n"Would you like to draw how you\'re feeling? Here are some colored pencils - sometimes drawing feelings helps when words are hard to find."',
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
          title: 'Sensory Sensitivity',
          scenarios: [
            {
              title: '🎧 "Noise-Cancelling Headphones as \'Brave Equipment\'"',
              image: SensoryOption0,
              description: 'Andy covers his ears and starts rocking as the supermarket gets louder. Mom kneels down and gently offers his headphones.\n"Here\'s your brave equipment. These will turn down the volume so you can be comfortable while we finish shopping."',
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
              title: '🛁 "Bath Time Can Be Gradually Adapted"',
              image: SensoryOption1,
              description: 'Today we\'ll only wash your hair, not your face, and we\'ll cover your eyes with a towel right away when we\'re done, okay? You\'re being so brave today. Next time you can try pouring the water yourself!\n(Mimi cries loudly every time she has to wash her hair. Mom gently pours water while singing her favorite song. Though Mimi frowns, she doesn\'t scream and gradually adapts to this new rhythm)',
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
              title: '🕶️ "Special Sunglasses Mission"',
              image: SensoryOption2,
              description: 'Max squints and covers his eyes in the bright store lights. Mom gently hands him his sunglasses.\n"Let\'s put on your special sunglasses for our shopping mission. They\'ll protect your eyes from the bright lights so you can be my shopping detective."',
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
              title: '🏃‍♂️ "Movement Breaks"',
              image: SensoryOption3,
              description: 'Joshua starts fidgeting and rocking in his chair during homework. Mom sets a visual timer.\n"Let\'s take a 5-minute movement break. You can choose: jumping jacks, animal walks, or dancing. Then we\'ll come back to finish your math."',
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
