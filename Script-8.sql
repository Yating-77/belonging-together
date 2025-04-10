CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  title VARCHAR(100) NOT NULL,    -- 类别标题，如"Sleep Issues"或"Emotional and Behavioral Management"
  display_order INTEGER NOT NULL  -- 显示顺序
);

DROP TABLE questions CASCADE;


CREATE TABLE questions (
  id SERIAL PRIMARY KEY,
  category_id INTEGER NOT NULL,      -- 关联到categories表的外键
  question_text TEXT NOT NULL,       -- 问题描述，如"How does your child typically behave at bedtime?"
  display_order INTEGER NOT NULL,    -- 显示顺序
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

CREATE TABLE options (
    id SERIAL PRIMARY KEY,               -- 自增主键
    question_id INTEGER NOT NULL,        -- 关联到questions表的外键
    text TEXT NOT NULL,                  -- 选项描述，如"Has difficulty falling asleep at bedtime"
    display_order INTEGER NOT NULL,      -- 显示顺序
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

CREATE TABLE advice (
    id SERIAL PRIMARY KEY,               -- 自增主键
    option_id INTEGER NOT NULL,          -- 关联到options表的外键
    advice_text TEXT NOT NULL,           -- 建议内容
    display_order INTEGER NOT NULL,      -- 显示顺序
    FOREIGN KEY (option_id) REFERENCES options(id) ON DELETE CASCADE
);

-- 插入类别
INSERT INTO categories (title, display_order) VALUES 
('Sleep Issues', 1),
('Diet and Nutrition Issues', 2),
('Social Interaction', 3),
('Communication Issues', 4),
('Emotional and Behavioral Management', 5),
('Sensory Sensitivity Issues', 6);

-- 插入所有类别的问题
INSERT INTO questions (category_id, question_text, display_order) VALUES 
-- Sleep Issues
(1, 'How does your child typically behave at bedtime or during the night?', 1),
(2, 'During mealtimes, how does your child typically behave?', 1),
(3, 'How does your child typically interact with peers in social situations?', 1),
(4, 'When your child wants to express needs or interests, they typically:', 1),
(5, 'When facing frustration or disappointment, your child typically:', 1),
(6, 'Which type of sensory input does your child seem most sensitive or strongly reactive to?', 1);


-- 1. 插入Sleep Issues的选项
INSERT INTO options (question_id, text, display_order) VALUES 
(1, 'Has difficulty falling asleep at bedtime (prolonged time to fall asleep)', 1),
(1, 'Shows significant anxiety or crying when bedtime routine changes (overly rigid bedtime routine)', 2),
(1, 'Has difficulty falling asleep when there are slight changes in the sleep environment (sensitive to sleep environment)', 3),
(1, 'Wakes up frequently during the night and has trouble falling back asleep (poor sleep continuity)', 4);

-- 2. 插入Diet and Nutrition Issues的选项
INSERT INTO options (question_id, text, display_order) VALUES 
(2, 'Refuses to try new foods, only eats a few specific foods (narrow food acceptance)', 1),
(2, 'Extremely sensitive to food texture or taste, leading to limited diet (sensory food aversions)', 2),
(2, 'Irregular eating times or difficulty sitting calmly at the table (poor mealtime structure)', 3),
(2, 'Often prefers to eat while distracted by screens or toys (reliance on distraction during meals)', 4);

-- 3. 插入Social Interaction的选项
INSERT INTO options (question_id, text, display_order) VALUES 
(3, 'Plays completely alone, rarely initiates contact with peers', 1),
(3, 'Willing to approach other children but doesn''t know how to interact', 2),
(3, 'Often has conflicts with peers or difficulty cooperating', 3),
(3, 'Focuses only on preferred activities or interests', 4);

-- 4. 插入Communication Issues的选项
INSERT INTO options (question_id, text, display_order) VALUES 
(4, 'Uses few words and expresses needs through other means (weak non-verbal expression)', 1),
(4, 'Has language ability but often repeats common words or phrases (limited language expression)', 2),
(4, 'Just beginning to speak but language is confused, illogical, difficult to maintain simple conversations (weak language organization)', 3),
(4, 'Occasionally shows clear desire to express, but mostly struggles to show thoughts (lacks communication initiative)', 4);

-- 5. 插入Emotional and Behavioral Management的选项
INSERT INTO options (question_id, text, display_order) VALUES 
(5, 'Emotions quickly collapse into crying and screaming, difficult to comfort', 1),
(5, 'Often shows pushing, hitting, or throwing things as aggressive behaviors', 2),
(5, 'Tries to escape, hide, or refuse to face difficult scenarios', 3),
(5, 'Rarely expresses emotions actively, more often silent or self-enclosed', 4);

-- 6. 插入Sensory Sensitivity Issues的选项
INSERT INTO options (question_id, text, display_order) VALUES 
(6, 'Easily becomes overwhelmed in noisy or bright environments (environmental stimuli sensitivity)', 1),
(6, 'Resists hair washing, nail trimming, bathing, and other daily care activities (resistance to body touch)', 2),
(6, 'Overly sensitive to certain lights, colors, or visual environments (visual stimuli sensitivity)', 3),
(6, 'Needs a lot of movement, shaking, or seeking strong sensory stimulation (sensory seeking behavior)', 4);


SELECT id, question_id, text, display_order FROM options ORDER BY question_id, display_order;


-- Option 1: 对应SleepScene.vue中的Option 0: Difficulty falling asleep
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(1, 'Maintain a consistent bedtime routine, such as regular bath and tooth brushing times, to establish a biological clock for your child.', 1),
(1, 'Create a quiet, comfortable sleep environment, potentially lowering room temperature and using soft night lights.', 2),
(1, 'Teach your child simple relaxation techniques like deep breathing and progressive muscle relaxation.', 3),
(1, 'Limit electronic device use in the evening and avoid overly stimulating activities before bedtime.', 4),
(1, 'Be patient and supportive, but avoid excessive focus on sleep issues to prevent adding pressure on your child.', 5);

-- Option 2: 对应SleepScene.vue中的Option 1: Wakes up frequently and has trouble falling back asleep
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(2, 'Ensure the sleep environment is comfortable, checking factors like room temperature, noise, and lighting for stability.', 1),
(2, 'Help your child build a sense of security, perhaps placing favorite stuffed toys as "guardians" by the bed.', 2),
(2, 'Minimize interactions when they wake at night, keeping lights dim and voices soft to help them return to sleep quickly.', 3),
(2, 'Teach your child simple self-soothing techniques, such as hugging a toy or deep breathing.', 4),
(2, 'Maintain a regular schedule, including weekends, to help stabilize sleep cycles.', 5),
(2, 'If nightmares or anxiety persist, discuss the source of fears during the day and seek professional help if necessary.', 6);

-- Advice for option_id = 3: Adjusting to bedtime changes
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(3, 'Maintain core bedtime habits, keeping basic steps like brushing teeth, washing face, and reading consistent to provide stability.', 1),
(3, 'Inform children of changes in advance and explain the reasons to reduce anxiety and resistance.', 2),
(3, 'Introduce changes gradually, altering only one element at a time to allow adaptation.', 3),
(3, 'Recognize and encourage children''s efforts to adapt to changes, boosting their confidence.', 4),
(3, 'Use visual cues, such as a bedtime routine chart, to help children understand and anticipate changes.', 5),
(3, 'Allow children to retain one or two ritual elements particularly important to them, respecting their need for security.', 6);

-- Advice for option_id = 4: Coping with new environments
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(4, 'Bring familiar items such as favorite blankets, pillows, or toys to increase familiar elements in the new environment.', 1),
(4, 'Replicate home bedtime rituals as much as possible, maintaining the same steps and sequence.', 2),
(4, 'Help your child become familiar with the new environment by exploring the new room together, reducing anxiety from the unknown.', 3),
(4, 'Use portable white noise machines or play familiar music to mask unfamiliar sounds in the new environment.', 4),
(4, 'Maintain consistent sleeping schedules in the new environment, not changing bedtime due to the change in surroundings.', 5),
(4, 'Validate your child''s feelings while providing security and encouragement, acknowledging that their discomfort is normal.', 6),
(4, 'If conditions allow, consider a gradual adaptation process, such as short stays before overnight stays, to adjust gradually.', 7);



-- Option 5: 对应DietScene.vue中的Option 0: Refuses to try new foods
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(5, 'Introduce new foods gradually using a "food bridge" strategy by placing new foods alongside familiar foods that your child enjoys.', 1),
(5, 'Present foods 10-15 times before expecting acceptance — research shows children with autism may need repeated exposures before trying new foods.', 2),
(5, 'Provide safety with familiar foods by ensuring that at least half the plate contains foods you know your child will eat.', 3),
(5, 'Make food exploration playful and low-pressure by engaging with food through other senses first (touch, smell) before expecting tasting.', 4),
(5, 'Use descriptive, fun language when introducing new foods, like "dinosaur trees" for broccoli or "orange wheels" for carrot slices.', 5);

-- Option 6: 对应DietScene.vue中的Option 1: Extremely sensitive to food texture or taste
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(6, 'Work with texture preferences by first accepting the textures your child can tolerate while ensuring nutritional intake.', 1),
(6, 'Introduce texture changes gradually by starting with minimal modifications to preferred foods before making bigger changes.', 2),
(6, 'Create a food progression plan that moves slowly from totally accepted textures to slightly more challenging ones.', 3),
(6, 'Engage in sensory food play outside of mealtimes to help desensitize children to textures they find challenging.', 4),
(6, 'Consider the temperature of foods as some children may accept a specific food when warm but reject it when cold.', 5);

-- Option 7: 对应 DietScene.vue 中的 Option 2: Needs toys or devices for distraction during meals
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(7, 'Set consistent meal expectations by establishing clear rules about screen time and toys at the table.', 1),
(7, 'Create a gradual transition plan to reduce dependence on distractions during mealtimes.', 2),
(7, 'Increase social engagement during meals by sharing interesting conversation topics or gentle questions about your child''s day.', 3),
(7, 'Use visual timers or schedules to help your child understand the expected mealtime duration without distractions.', 4),
(7, 'Provide positive reinforcement for incremental improvements in focusing on mealtime without devices.', 5);

-- Option 8: 对应 DietScene.vue 中的 Option 3: Irregular eating times or difficulty sitting calmly at the table
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(8, 'Establish a regular meal schedule with three meals and two snacks at consistent times each day.', 1),
(8, 'Use visual supports like timers or picture schedules to help your child understand mealtime expectations.', 2),
(8, 'Make mealtime engaging with gentle mealtime games that encourage appropriate eating pace and sitting.', 3),
(8, 'Start with realistic sitting duration goals (even just 2-3 minutes) and gradually increase the time.', 4),
(8, 'Ensure your child comes to the table physically ready to eat (not too tired, not too full from snacking).', 5);



-- Option 9: 对应 SocialScene.vue 中的 Option 0: Plays completely alone
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(9, 'Begin with "parallel play" where children play side by side using similar toys without direct interaction, which can gradually lead to more social engagement.', 1),
(9, 'Create relaxed opportunities for social interaction by inviting one child over at a time for a structured activity your child enjoys.', 2),
(9, 'Use your child''s interests as a bridge to social connections, arranging playdates centered around their preferred activities.', 3),
(9, 'Respect your child''s need for breaks during social situations, allowing them to retreat to a quiet space when they feel overwhelmed.', 4),
(9, 'Observe and celebrate small social gains like shared glances or proximity tolerance, as these are important steps toward social engagement.', 5),
(9, 'Model appropriate social behaviors yourself, such as greeting others, taking turns, and showing interest in others'' activities.', 6);

-- Option 10: 对应SocialScene.vue中的Option 1: Willing to approach other children but doesn't know how to interact
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(10, 'Provide your child with "social scripts" - simple phrases they can use in common social situations like greetings or requesting to join play.', 1),
(10, 'Use visual supports such as picture cards or social stories to help your child understand and navigate social situations step-by-step.', 2),
(10, 'Role-play common social scenarios at home before encountering them in real life, allowing practice in a comfortable environment.', 3),
(10, 'Arrange structured activities with clear roles that make social expectations more predictable for your child.', 4),
(10, 'Encourage observation skills by pointing out social interactions in books, shows, or real life: "Look how they asked to play together."', 5),
(10, 'Teach and practice the specific skill of joining play, using techniques like approaching, watching, and then making a relevant comment about the activity.', 6);

-- Option 11: 对应SocialScene.vue中的Option 2: Often has conflicts with peers or difficulty cooperating
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(11, 'Teach emotional regulation strategies such as deep breathing, counting to ten, or using a calming corner when frustration arises.', 1),
(11, 'Create visual emotion scales to help your child identify their feelings and appropriate coping strategies at different intensity levels.', 2),
(11, 'Practice conflict resolution skills through role-play, teaching specific phrases like "I feel... when you..." or "Can we take turns?"', 3),
(11, 'Establish clear rules for play and cooperation, perhaps using visual reminders of expectations for sharing and taking turns.', 4),
(11, 'Recognize and praise positive social behaviors immediately when they occur to reinforce these actions.', 5),
(11, 'Teach perspective-taking through direct conversation: "How do you think Jamie felt when...?" or through stories with clear emotional content.', 6);

-- Option 12: 对应 SocialScene.vue 中的 Option 3: Focuses only on preferred activities or interests
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(12, 'Use your child''s special interests as a starting point for social interaction rather than discouraging them.', 1),
(12, 'Teach specific turn-taking language related to interests: "Now I''ll tell you about my favorite dinosaur, then you can share yours."', 2),
(12, 'Create structured interest-sharing activities where your child can be the "expert" but must follow rules for including others.', 3),
(12, 'Help your child recognize when others are losing interest by pointing out non-verbal cues in a supportive way.', 4),
(12, 'Gradually expand the circle of interest by connecting your child''s passion to related topics that might interest peers.', 5),
(12, 'Encourage flexibility by introducing small variations to favorite activities, teaching that fun can happen with slight changes.', 6),
(12, 'Arrange playdates with children who share similar interests to create natural opportunities for connection.', 7);


-- Option 13: Uses few words and expresses needs through other means
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(13, 'Introduce alternative communication systems like Picture Exchange Communication System (PECS) which uses visual cards to represent common items, activities, and needs.', 1),
(13, 'Create a personalized communication board with photographs of your child''s favorite foods, toys, and activities that they can point to when expressing needs.', 2),
(13, 'Pair gestures with simple words consistently when communicating with your child, supporting their understanding of language while honoring their non-verbal communication.', 3),
(13, 'Respond positively to all communication attempts, whether through pointing, leading by hand, or other non-verbal methods, to encourage continued efforts.', 4),
(13, 'Gradually introduce visual choice boards for daily routines, starting with just two options and expanding as your child becomes comfortable using them.', 5),
(13, 'Consider consulting with a speech-language pathologist about technological communication aids or apps that might support your child''s specific communication needs.', 6);

-- Option 14: Has language ability but often repeats common words or phrases
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(14, 'Recognize echolalia (repeated speech) as a form of communication rather than meaningless repetition - it often indicates your child is trying to engage or express a need.', 1),
(14, 'Expand on your child''s repeated phrases by adding meaning and context: If they say "outside" repeatedly, respond with "You want to go outside to play."', 2),
(14, 'Create opportunities for functional language by setting up situations where your child needs to request items, using visual supports as needed.', 3),
(14, 'Use the "echo and expand" technique: when your child repeats a phrase, acknowledge it and then model a slightly more complex version for them to learn.', 4),
(14, 'Avoid demanding immediate language changes; instead, model proper language consistently while accepting their current communication method.', 5),
(14, 'Celebrate when your child uses language functionally, even if it''s a repeated phrase used appropriately in context.', 6),
(14, 'Consider a language diary to track repeated phrases and their apparent meanings, helping you understand patterns in your child''s communication attempts.', 7);

-- Option 15: Just beginning to speak but language is confused
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(15, 'Use visual sequencing tools like picture schedules or comic strip conversations to help your child organize their thoughts before speaking.', 1),
(15, 'Practice "sentence building" with visual supports - use picture cards for subject, verb, and object to physically arrange before speaking.', 2),
(15, 'Implement the "first-then" structure to simplify language organization: "First we go to the park, then we play on the swings."', 3),
(15, 'Model clear, simplified speech by using short, grammatically correct sentences when speaking with your child.', 4),
(15, 'Provide verbal scaffolding by offering sentence starters or filling in missing words when your child is struggling to express a complete thought.', 5),
(15, 'Create regular storytelling opportunities using picture books, asking simple questions that help your child practice sequencing events.', 6),
(15, 'Use visual supports like emotion cards alongside language to help clarify the meaning behind fragmented speech attempts.', 7);

-- Option 16: Occasionally shows clear desire to express
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(16, 'Create an "irresistible communication environment" by placing desired items in sight but out of reach, creating natural opportunities for your child to request them.', 1),
(16, 'Implement a "wait time" strategy - pause expectantly after asking a question or during an interaction, giving your child extra time to formulate a response.', 2),
(16, 'Celebrate every communication initiation, no matter how small, with specific praise: "You told me you wanted the ball! Great talking!"', 3),
(16, 'Introduce "sabotage" techniques in familiar routines - deliberately create a problem your child needs to communicate about (like forgetting a spoon at mealtime).', 4),
(16, 'Use highly motivating activities and special interests to encourage spontaneous communication through excitement and engagement.', 5),
(16, 'Create a communication-rich but low-pressure environment where requests are consistently honored, building trust that speaking leads to positive outcomes.', 6),
(16, 'Consider a "communication temptations" approach, strategically arranging the environment with interesting but inaccessible items that might prompt your child to initiate interaction.', 7);


-- Option 17: Emotions quickly collapse into crying and screaming
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(17, 'Teach simple breathing techniques like "smell the flower, blow out the candle" to help your child regulate intense emotions in the moment of distress.', 1),
(17, 'Create a calm-down corner in your home with sensory tools like stress balls, weighted blankets, or fidget toys that can help soothe your child during emotional moments.', 2),
(17, 'Use visual supports such as emotion thermometers or traffic light systems to help your child identify their escalating emotions before they reach crisis point.', 3),
(17, 'Practice emotional regulation strategies during calm times, not just during meltdowns, to build the neural pathways needed for self-regulation.', 4),
(17, 'Validate your child''s feelings before attempting to solve the problem: "I see you''re really upset that your tower fell. It''s okay to feel frustrated."', 5),
(17, 'Maintain your own calm presence during your child''s emotional storms - your regulated state helps co-regulate their nervous system.', 6),
(17, 'Develop a consistent response pattern for meltdowns that your child can predict, creating a sense of safety even during emotional turmoil.', 7);

-- Option 18: Shows pushing, hitting, or throwing things
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(18, 'Create safe physical outlets for aggression such as a designated "anger corner" with pillows to punch, stress balls to squeeze, or a mini trampoline for jumping.', 1),
(18, 'Recognize and intervene during the early signs of frustration before aggressive behavior occurs, redirecting your child to appropriate coping strategies.', 2),
(18, 'Use explicit social stories with clear visuals to teach alternative behaviors to hitting, such as asking for help, using words, or moving away.', 3),
(18, 'Implement a consistent, calm response to aggressive incidents that focuses on safety first, followed by brief, clear feedback about the behavior.', 4),
(18, 'Provide immediate and enthusiastic positive reinforcement when your child uses appropriate alternatives to aggression, even if the attempt is imperfect.', 5),
(18, 'Analyze the patterns behind aggressive behaviors to identify triggers, which might include sensory overload, communication frustration, or difficulty with transitions.', 6),
(18, 'Teach emotion vocabulary and recognition to help your child express feelings verbally instead of physically, using picture cards as visual supports.', 7);

-- Option 19: Tries to escape, hide, or refuse to face difficult scenarios
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(19, 'Break challenging situations into tiny, manageable steps using a "gradual exposure ladder" approach, celebrating success at each small level.', 1),
(19, 'Create visual supports such as social stories or picture schedules that prepare your child for potentially challenging situations by removing uncertainty.', 2),
(19, 'Implement a "brave moments" reward system that recognizes effort rather than outcome, emphasizing that courage means trying even when feeling scared.', 3),
(19, 'Use role-play with stuffed animals, toys, or pretend play to rehearse difficult scenarios in a safe, controlled environment before facing them in real life.', 4),
(19, 'Teach specific coping phrases your child can use when feeling overwhelmed, such as "I need a break" or "This is hard, but I can try."', 5),
(19, 'Respect your child''s pace while gently encouraging forward movement - pushing too hard can increase anxiety and resistance to future attempts.', 6),
(19, 'Model healthy approaches to challenges by verbalizing your own process: "This looks difficult. I feel nervous, but I''m going to take a deep breath and try."', 7);

-- Option 20: Rarely expresses emotions actively
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(20, 'Provide alternative forms of emotional expression beyond verbal communication, such as drawing feelings, using emotion cards, or expressing through music.', 1),
(20, 'Create a daily "check-in" ritual using visual emotion scales or charts where your child can indicate their feelings without having to verbalize them.', 2),
(20, 'Use special interest areas as entry points for emotional conversations, as children often feel more comfortable discussing feelings in the context of preferred topics.', 3),
(20, 'Read stories featuring characters experiencing different emotions, then connect these narratives to your child''s experiences in a gentle, non-pressuring way.', 4),
(20, 'Allow processing time and avoid rushing emotional conversations - children who struggle with emotional expression often need longer to formulate their responses.', 5),
(20, 'Maintain a predictable "emotion-safe" environment where all feelings are acknowledged as valid, creating safety for eventual emotional expression.', 6),
(20, 'Consider the communication environment - some children express more freely during movement activities, in darkened rooms, or when not facing their conversation partner directly.', 7);


-- Option 21: Easily becomes overwhelmed in noisy or bright environments
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(21, 'Provide noise-reducing headphones or earplugs in environments your child finds overwhelming, allowing them to participate while reducing sensory input.', 1),
(21, 'Create a "sensory toolkit" with items that provide comfort (favorite small toy, stress ball, fidget spinner) that can be carried to challenging environments.', 2),
(21, 'Prepare your child in advance for noisy or busy environments with visual schedules and simple social stories that explain what to expect.', 3),
(21, 'Plan visits to potentially overwhelming places (like supermarkets) during quieter times, such as early mornings or late evenings when crowds are minimal.', 4),
(21, 'Use gradual exposure techniques, starting with brief visits to challenging environments and slowly increasing duration as your child builds tolerance.', 5),
(21, 'Identify specific sensory triggers in various environments by observing your child''s reactions, then develop strategies to specifically address those elements.', 6),
(21, 'Teach your child to recognize their own sensory thresholds and practice self-advocacy by requesting breaks or using their sensory tools when needed.', 7);

-- Option 22: Resists hair washing, nail trimming, bathing, and other daily care activities
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(22, 'Break hygiene routines into small, predictable steps that your child can anticipate, focusing on one challenging element at a time.', 1),
(22, 'Use visual schedules with pictures or simple drawings to outline each step of the process, reviewing them before beginning and tracking progress throughout.', 2),
(22, 'Provide sensory-friendly alternatives, such as dry shampoo occasionally, shower instead of bath, or bath wipes for particularly difficult days.', 3),
(22, 'Incorporate preferred elements into challenging routines, like bringing favorite waterproof toys into the bath or playing favorite music during nail trimming.', 4),
(22, 'Give your child appropriate control where possible, such as choosing water temperature, selecting which body part to wash first, or holding the nail clippers themselves.', 5),
(22, 'Use sensory preparation techniques before challenging routines, like deep pressure massage before baths or hand-warming before nail trimming to reduce tactile sensitivity.', 6),
(22, 'Celebrate small improvements with specific praise that focuses on the effort: "You kept your hand still for three nails today! That was really brave."', 7);

-- Option 23: Overly sensitive to certain lights, colors, or visual environments
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(23, 'Modify lighting environments by using natural light when possible, eliminating fluorescent lighting, or providing options for dimming lights in key spaces.', 1),
(23, 'Offer tinted glasses or visors that can reduce visual sensitivities, particularly for children bothered by fluorescent lighting or bright sunlight.', 2),
(23, 'Create designated "visual rest zones" at home with minimal visual stimulation - neutral colors, reduced patterns, and organized spaces where your child can retreat.', 3),
(23, 'Organize your child''s workspace or play area to reduce visual clutter, using solid-colored storage containers and keeping walls relatively clear.', 4),
(23, 'When entering visually stimulating environments, provide a "preview" by showing pictures beforehand and approaching gradually, allowing time for your child to adjust.', 5),
(23, 'Consider seating positions in classrooms or other spaces that minimize visual distractions (away from windows, bulletin boards, or high-traffic areas).', 6),
(23, 'Use room dividers, curtains, or strategic furniture placement to create visually contained areas in open spaces like classrooms or family rooms.', 7);

-- Option 24: Needs a lot of movement, rocking, or seeks intense sensory stimulation
INSERT INTO advice (option_id, advice_text, display_order) VALUES 
(24, 'Schedule regular "movement breaks" throughout your child''s day, providing appropriate physical outlets before periods requiring sitting or focused attention.', 1),
(24, 'Create a dedicated sensory space at home with equipment like mini trampolines, therapy swings, crash pads, or climbing structures that safely meet vestibular needs.', 2),
(24, 'Introduce "heavy work" activities that provide proprioceptive input, such as carrying groceries, pushing a loaded cart, or animal walks (bear crawls, crab walks).', 3),
(24, 'Use therapy tools like weighted blankets, compression vests, or body socks that provide deep pressure input, helping to organize your child''s sensory system.', 4),
(24, 'Collaborate with your child''s teacher to incorporate movement into learning (standing desks, therapy ball seating, errands that involve walking).', 5),
(24, 'Establish a structured "sensory diet" with occupational therapy guidance - a personalized activity plan that provides needed sensory input throughout the day.', 6),
(24, 'Teach your child to recognize their own need for movement and develop appropriate ways to seek input (jumping jacks in the bathroom vs. running in the classroom).', 7);



-- 创建推荐表
CREATE TABLE recommendations (
    id SERIAL PRIMARY KEY,
    option_id INTEGER NOT NULL,            -- 关联选项ID
    title VARCHAR(255) NOT NULL,           -- 推荐标题
    content TEXT NOT NULL,                 -- 推荐内容
    example TEXT NOT NULL,                 -- 实例
    display_order INTEGER NOT NULL,        -- 显示顺序
    FOREIGN KEY (option_id) REFERENCES options(id)
);

-- 为表添加索引以提高查询性能
CREATE INDEX idx_recommendations_option_id ON recommendations(option_id);


-- 1. Sleep Issues - Option 1: Difficulty falling asleep
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(1, 'Establish Consistent Bedtime Routine', 'Create a regular routine before bed that remains the same each night to signal to your child''s body that it''s time to sleep.', 'Follow the same sequence of activities each night: bath, brushing teeth, story, and bed. This consistency helps establish your child''s biological clock.', 1),
(1, 'Create a Calming Environment', 'Design a sleep space that minimizes stimulation and promotes relaxation.', 'Use soft lighting, maintain a comfortable temperature (typically 65-70°F/18-21°C), and reduce noise. Consider a white noise machine if environmental sounds are disruptive.', 2),
(1, 'Limit Screen Time', 'Reduce or eliminate exposure to screens (TV, tablets, phones) at least one hour before bedtime.', 'The blue light from screens can suppress melatonin production. Replace screen time with calming activities like reading books, listening to gentle music, or quiet play.', 3),
(1, 'Incorporate Calming Activities', 'Include relaxing activities in the bedtime routine that help transition from the day''s stimulation to sleep.', 'Try gentle stretching, reading a familiar book, listening to soft music, or practicing deep breathing together. For some children, a warm bath can be calming before bed.', 4),
(1, 'Use Visual Supports', 'Provide visual cues to help your child understand and follow the bedtime routine.', 'Create a simple picture schedule showing each step of the bedtime routine. Review this together before starting the routine and reference it as you move through each step.', 5);

-- 2. Sleep Issues - Option 2: Wakes up frequently during the night
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(2, 'Maintain Consistent Sleep Environment', 'Have your child fall asleep in a familiar environment where they will feel secure if they wake up during the night.', 'Help your child fall asleep in their own bed, rather than on your bed or the couch. Avoid using TV or bright lights as sleep aids.', 1),
(2, 'Calmly Respond to Night Wakings', 'When your child wakes during the night, keep interactions minimal and help them return to sleep.', 'Quietly say "It''s time to sleep now," gently guide your child to lie down, and avoid turning on lights, playing, or extended conversations.', 2),
(2, 'Use Comfort Items', 'Provide items that give your child a sense of security to help them self-soothe.', 'Use a special stuffed animal, soft blanket, or favorite pillow as a "sleep buddy" placed within easy reach.', 3),
(2, 'Create Consistent Sensory Environment', 'Maintain consistent sound, light, and temperature in the sleep environment to reduce stimuli that might wake your child.', 'Use a white noise machine or fan to provide consistent background sound, use blackout curtains to keep the room dark, and set the thermostat to maintain a stable temperature.', 4),
(2, 'Build Independent Sleep Skills', 'Teach your child self-soothing skills for both falling asleep and night wakings.', 'Gradually reduce parental intervention, from lying next to your child to just sitting in the room, and finally to briefly checking in. Encourage your child to use simple relaxation techniques like deep breathing.', 5);

-- 3. Sleep Issues - Option 3: Anxiety when bedtime routine changes
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(3, 'Announce Changes in Advance', 'Before changing bedtime routines, inform your child ahead of time in a way they can understand.', 'Use simple visual schedules or picture cards showing what will be different that night. For example: "Tonight daddy will read you a story instead of mommy."', 1),
(3, 'Introduce Changes Gradually', 'Help your child adapt to adjustments in the bedtime routine through small steps.', 'Start by changing less important items, like switching to a different bedtime story book; after success, try changing bath time or the location for story reading.', 2),
(3, 'Keep Core Elements Stable', 'When changes are necessary, try to maintain key aspects of the routine unchanged to provide security.', 'If you can''t follow the usual bath routine, still maintain the same pajamas, teeth brushing, and story sequence, using the same language prompts: "Now it''s time to get ready for bed."', 3),
(3, 'Create Flexibility Games', 'Play "change games" during daytime to help your child practice adapting to small changes.', 'During playtime, role-play different bedtime scenarios: "Today we''re pretending we''re traveling, and bedtime might be a bit different." Or slightly mix up the order of daily activities to help your child learn to adapt.', 4),
(3, 'Positively Reinforce Adaptive Behavior', 'Praise and encourage your child when they successfully handle changes.', 'Use a sticker reward system or special praise: "You were so brave tonight, even though bedtime was a little different, you stayed calm!" The next day, narrate how the child successfully adapted to the change.', 5);

-- 4. Sleep Issues - Option 4: Sensitive to sleep environment
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(4, 'Create a Portable Sleep Kit', 'Prepare a set of familiar sleep items that can be used in different environments.', 'Prepare a "sleep travel pack" containing your child''s familiar pillowcase, small blanket, favorite stuffed toy, and possibly regular bedtime reading materials.', 1),
(4, 'Use Sensory Aids', 'Utilize tools to block or regulate environmental distractions.', 'Use a white noise machine to mask unfamiliar sounds, comfortable earplugs to reduce noise disruptions, sleep masks to adjust to light changes, or small items with familiar scents for comfort.', 2),
(4, 'Preview and Familiarize New Environments', 'Before sleeping in a new place, help your child become familiar with the environment.', 'Visit the new sleeping area in advance, allow your child to explore and choose where they''ll sleep, do some enjoyable daytime activities in the new environment to build positive associations.', 3),
(4, 'Maintain Core Bedtime Routine', 'Even in different environments, stick to key bedtime routine elements.', 'No matter where you are, maintain the same bedtime three-step process, such as: brushing teeth, reading a story, and singing a specific lullaby, providing continuity and security through process.', 4),
(4, 'Create "Sleep Space" Boundaries', 'Use visual or tactile cues to define the sleeping area.', 'Use the same sheets or blanket to "mark" the sleep space, even when traveling; or use a foldable tent-style bed cover to create enclosure, reducing external environment interference.', 5);

-- 5. Diet and Nutrition Issues - Option 5: Refuses to try new foods
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(5, 'Introduce New Foods Gradually', 'Use a "food bridge" strategy by placing new foods alongside familiar foods that your child enjoys.', 'Place a small piece of carrot next to foods with similar flavors that they already like. Encourage your child to first observe, smell, or even touch the new food without forcing them to eat it.', 1),
(5, 'Repeated Exposure', 'You may need to present foods 5-20 times before acceptance—research shows children with autism may need 10+ exposures before trying new foods.', 'Be patient and continue offering the same new food at different meals. Acceptance typically increases gradually with continued neutral exposure.', 2),
(5, 'Provide Safety with Familiar Foods', 'When offering new foods, make sure there are always some familiar foods on the plate.', 'Ensure that at least half the plate contains foods you know your child will eat, so they won''t refuse the entire meal when presented with new options.', 3),
(5, 'Make Exploring Food Fun', 'Turn food exploration into a sensory game.', 'Make exploring food fun by turning it into a sensory game - smell, touch, and then taste.', 4),
(5, 'Use Positive Reinforcement', 'Celebrate small steps.', 'Use positive reinforcement and celebrate small steps, like touching or smelling a new food, even if your child doesn''t eat it.', 5);

-- 6. Diet and Nutrition Issues - Option 6: Extremely sensitive to food texture or taste
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(6, 'Work with Texture Preferences', 'For children sensitive to texture, first accept the textures they can tolerate while ensuring nutritional intake. Then gradually introduce subtle texture changes.', 'If they only eat pureed foods, try introducing minimal soft particles and gradually increase the amount. If they only eat crunchy foods, try offerings that start crunchy but become slightly softer.', 1),
(6, 'Sensory Food Play', 'Outside of mealtimes, engage in play activities with different food textures without pressure to eat.', 'Create games touching, squishing or sorting foods with different textures. This helps desensitize children to textures they find challenging in a low-pressure environment.', 2),
(6, 'Make Food Visually Appealing', 'Present food in attractive arrangements.', 'Make food visually appealing through creative arrangements, shapes, or colors to increase interest.', 3),
(6, 'Allow Food Preparation Participation', 'Include your child in food preparation.', 'Allow your child to participate in food preparation, which can increase willingness to try new foods.', 4),
(6, 'Respect Sensory Aversions', 'Be understanding of texture sensitivities.', 'Respect food aversions that may be related to sensory issues while gently encouraging exploration.', 5);

-- 7. Diet and Nutrition Issues - Option 7: Irregular eating times or difficulty sitting calmly at the table
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(7, 'Establish Regular Meal Schedule', 'Create and strictly follow a daily schedule of three meals and two snacks for your child.', 'Children with autism typically prefer predictable routines. Fixed mealtimes help establish biological rhythms and hunger-satiety patterns. For example, breakfast at 7 AM, lunch at noon, dinner at 6 PM, with scheduled snacks in between.', 1),
(7, 'Use Visual Supports', 'Implement visual schedules or timers to help your child understand when it''s time to eat and when mealtime ends.', 'Before meals, show your child a picture schedule saying, "Look, the clock is pointing to the apple, it''s time for lunch." During meals, use a simple hourglass timer so they can see how long the meal will last.', 2),
(7, 'Create Comfortable Seating', 'Ensure proper seating for your child.', 'Create a comfortable seating arrangement, considering sensory needs such as chair height, foot support, and surrounding space.', 3),
(7, 'Set Realistic Expectations', 'Start with achievable goals.', 'Start with short mealtime expectations and gradually increase duration as your child builds tolerance.', 4),
(7, 'Allow Self-Regulation Tools', 'Permit appropriate fidgeting.', 'Consider allowing fidget toys or sensory tools that don''t interfere with eating to help with self-regulation at the table.', 5);

-- 8. Diet and Nutrition Issues - Option 8: Often prefers to eat while distracted by screens or toys
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(8, 'Establish a regular meal schedule', 'Establish a regular meal schedule with three meals and two snacks at consistent times each day.', 'Dad ensures a regular meal schedule.', 1),
(8, 'Use visual supports', 'Use visual supports like timers or picture schedules to help your child understand mealtime expectations.', 'Dad uses a timer to help Jason understand the expectation of finishing his meal.', 2),
(8, 'Make mealtime engaging', 'Make mealtime engaging with gentle mealtime games that encourage appropriate eating pace and sitting.', 'Dad plays a mealtime game with Jason.', 3),
(8, 'Start with realistic sitting duration goals', 'Start with realistic sitting duration goals (even just 2-3 minutes) and gradually increase the time.', 'Dad starts with a short sitting duration goal.', 4),
(8, 'Ensure physical readiness', 'Ensure your child comes to the table physically ready to eat (not too tired, not too full from snacking).', 'Dad ensures Jason is physically ready to eat.', 5);

-- 9. Social Interaction - Option 9: Plays completely alone
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(9, 'Start with parallel play', 'Start with parallel play, allowing your child to play with similar toys as others without requiring direct interaction.', 'Johnny and Alex play with their toy cars separately.', 1),
(9, 'Build connections', 'Build connections through shared interests, using your child''s interests as a social bridge to peers with similar preferences.', 'Johnny and Alex build a track together.', 2),
(9, 'Create safe social spaces', 'Create safe social spaces by designing structured environments where social interactions are predictable and manageable.', 'The teacher creates a structured environment for the children to play together.', 3),
(9, 'Respect personal pace', 'Respect personal pace and recognize when your child needs breaks from social settings to prevent overstimulation.', 'The teacher allows Johnny and Alex to play at their own pace.', 4),
(9, 'Value small steps', 'Value small steps by acknowledging and celebrating incremental progress in social participation, no matter how small.', 'The teacher acknowledges and celebrates the progress Johnny and Alex make in building the track.', 5),
(9, 'Facilitate initial interactions', 'Facilitate initial interactions by offering specific suggestions like building a track together, rather than broad directions like "play together".', 'The teacher suggests building a track together.', 6),
(9, 'Coach other children', 'Coach other children on how to approach and interact with your child in a way that feels comfortable and non-threatening.', 'The teacher teaches other children how to interact with Johnny.', 7);

-- 10. Social Interaction - Option 10: Doesn't know how to interact with other children
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(10, 'Provide Social Scripts', 'Teach your child specific phrases to use in common social situations.', 'Create simple cards with phrases like "Can I play?" or "My name is ___. What''s yours?" Practice these at home, then role-play using them in real situations. Start with just 1-2 scripts before adding more.', 1),
(10, 'Use Visual Supports', 'Create visual guides that show social interactions step by step.', 'Make a picture sequence showing the steps of joining a game: 1) Watch what others are doing, 2) Stand nearby, 3) Say "Can I play?", 4) Wait for answer, 5) Join in or find another activity. Review this sequence before social situations.', 2),
(10, 'Practice Through Role-Play', 'Rehearse social scenarios at home in a supportive environment.', 'Act out playground interactions with family members. Take turns being different characters and practice both successful interactions and handling rejection appropriately. Use stuffed animals or action figures to demonstrate conversations.', 3),
(10, 'Structure Initial Interactions', 'Create activities with clear roles that make social expectations more predictable.', 'Organize games with defined turns and roles like "Simon Says" or simple board games. These provide natural conversation points and clear expectations for when to speak and what to do.', 4),
(10, 'Teach Observation Skills', 'Help your child learn to read social cues by pointing them out explicitly.', 'When watching shows together, pause to discuss: "Look, that boy is smiling. How do you think he feels?" In real situations, quietly narrate: "See how those children are taking turns pushing the swing? That''s how they play together."', 5);

-- 11. Social Interaction - Option 11: Often has conflicts with peers
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(11, 'Plan structured activities', 'Plan structured activities for playdates with clear beginnings, middles, and ends to reduce social anxiety.', 'Dad arranges the living room with three activity stations.', 1),
(11, 'Include activities without constant verbal interaction', 'Include activities that don''t require constant verbal interaction, allowing for comfortable silence.', 'Dad arranges activities that do not require constant verbal interaction.', 2),
(11, 'Prepare your child', 'Prepare your child by discussing who is coming, what they will do, and for how long.', 'Dad discusses with Ben who is coming and what they will do.', 3),
(11, 'Have a quiet space ready', 'Have a quiet space ready where your child can retreat if they feel overwhelmed.', 'Dad has a quiet space ready for Ben.', 4),
(11, 'Invite peers', 'Invite peers who are patient, kind, and potentially have been educated about autism.', 'Dad invites Ben, who is patient, kind, and potentially educated about autism.', 5);

-- 12. Social Interaction - Option 12: Focuses only on preferred activities
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(12, 'Use Special Interests as Social Bridges', 'Leverage your child''s interests to create meaningful social connections.', 'If your child loves space, find a space-themed club or organize a space-themed playdate where they can share knowledge while practicing turn-taking. Their enthusiasm becomes a strength rather than a barrier.', 1),
(12, 'Teach Topic-Sharing Skills', 'Help your child learn how to engage others in their interests appropriately.', 'Practice conversation scripts like: "Would you like to hear about my favorite dinosaur? I can tell you three facts, and then you can share something you like." Set a timer for "my turn to talk" and "your turn to talk" during home practice.', 2),
(12, 'Create Structured Interest-Sharing Activities', 'Design activities where your child can showcase knowledge while following social rules.', 'Organize a "show and tell" with clear guidelines about time limits and questions. This provides a structured way for your child to share interests while practicing listening to others.', 3),
(12, 'Develop Awareness of Others'' Engagement', 'Help your child recognize when listeners are losing interest.', 'Identify specific visual cues: "When people look away or start fidgeting, they might be ready to change topics." Create a visual reminder card with these cues that your child can reference during conversations.', 4),
(12, 'Gradually Expand Interests', 'Connect your child''s special interests to related topics that might interest peers.', 'If your child loves trains, gradually introduce related interests like different transportation methods, engineering, or travel destinations. This broadens their interest base while honoring their original passion.', 5);

-- 13. Communication - Option 13: Uses few words and expresses needs through other means
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(13, 'Introduce Alternative Communication Methods', 'If your child struggles with verbal expression, teach them other ways to communicate their needs, such as gestures and picture communication.', 'Start by having your child point or take your hand to lead you to desired items. You can also use a Picture Exchange Communication System (PECS): prepare picture cards of common items (cup, food, bathroom), and teach your child to give you the appropriate picture when they need something.', 1),
(13, 'Provide Choices Instead of Open Questions', 'Give your child opportunities to make choices between two options to express preferences.', 'Instead of asking "What do you want to drink?" show two options, like milk and juice, and ask "Do you want milk or juice?" This makes communication more concrete and manageable.', 2),
(13, 'Pair Gestures with Simple Words', 'Consistently use gestures along with simple verbal language to support communication development.', 'When saying "more," show the sign for more, or when saying "all done," gesture with your hands. This multimodal approach creates multiple pathways for understanding and expression.', 3),
(13, 'Respond to All Communication Attempts', 'Honor and acknowledge all of your child''s attempts to communicate, regardless of the method.', 'If your child points to the refrigerator, respond as if they had asked verbally: "Oh, you''re thirsty? Let''s get some water." This validates their communication effort and encourages continued attempts.', 4),
(13, 'Create Communication-Rich Environments', 'Structure your home environment to encourage communication opportunities throughout the day.', 'Place desired items in sight but out of reach, requiring your child to communicate for help. Store favorite toys in clear containers that they can see but need assistance to open.', 5);

-- 14. Communication - Option 14: Has language ability but often repeats words or phrases
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(14, 'Recognize Echolalia as Communication', 'Understand that repeating words or phrases (echolalia) is often a meaningful communication attempt, not just meaningless repetition.', 'When your child repeats "outside, outside" from a favorite show, respond as if they''ve made a request: "You want to go outside? Let''s put on shoes." This acknowledges their communication intent behind the repeated phrase.', 1),
(14, 'Use the Echo and Expand Technique', 'Build on your child''s repeated phrases by acknowledging them and adding slightly more complex language.', 'If your child says "car go," respond with "Yes, the red car is going fast!" This validates their communication while providing a model for more complete language.', 2),
(14, 'Create Functional Communication Opportunities', 'Set up situations where your child needs to use language functionally to get their needs met.', 'Place a favorite toy in a clear container that''s difficult to open, or offer a small portion of a preferred snack so they need to ask for more, creating natural communication opportunities.', 3),
(14, 'Maintain a Language Diary', 'Keep track of repeated phrases and their apparent meanings to better understand your child''s communication patterns.', 'Note when your child says "blue train coming" and whether it means they want to play with trains, watch a train video, or something else. Sharing this diary with teachers and therapists creates consistent understanding.', 4),
(14, 'Celebrate Functional Language Use', 'Provide enthusiastic feedback when your child uses language appropriately, even if it''s a repeated phrase used in the right context.', 'If your child has been repeating "all done" and then uses it appropriately at the end of a meal, respond with specific praise: "You told me you''re all done eating - great talking!"', 5);

-- 15. Communication - Option 15: Language is confused, illogical, difficult to maintain simple conversations
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(15, 'Use Visual Sequencing Supports', 'Provide visual aids that help your child organize thoughts before speaking.', 'Create simple comic strip conversations or picture sequences showing the beginning, middle, and end of common events. Before discussing the day at school, look at a visual schedule together first to help organize thoughts.', 1),
(15, 'Practice Physical Sentence Building', 'Use tangible objects or cards to physically arrange sentences before speaking them.', 'Create a set of picture cards with subjects (I, you, mom), verbs (want, see, go), and objects (ball, book, park). Have your child arrange the cards in order, then say the sentence they''ve created.', 2),
(15, 'Implement First-Then Structure', 'Use simple two-part sequences to help your child practice basic logical connections in language.', 'Use "First we put on shoes, then we go outside" structure in both your language and visual supports. This helps establish basic sequential thinking that underlies organized communication.', 3),
(15, 'Model Simplified Speech', 'Provide clear, grammatically correct but simplified speech models for your child to imitate.', 'Instead of complex sentences, use shorter, complete sentences: "The boy is running" rather than "Look at that boy over there who''s running so fast toward the playground." This provides an achievable language model.', 4),
(15, 'Create Storytelling Opportunities', 'Use picture books to help your child practice sequencing events and describing actions.', 'After reading a simple story, ask your child to retell it using the pictures. Provide prompts as needed: "What happened first? Then what happened?" This builds narrative skills that transfer to conversation.', 5);

-- 16. Communication - Option 16: Lacks communication initiative
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(16, 'Implement Wait Time Strategy', 'Provide extended pause time after asking questions or during interactions, allowing your child time to formulate responses.', 'After asking a question, silently count to 10 before speaking again or prompting further. This patient waiting signals that you expect a response and gives your child processing time.', 1),
(16, 'Celebrate Communication Initiations', 'Provide specific, enthusiastic feedback when your child initiates communication, no matter how small.', 'If your child unexpectedly comments on a toy, respond with "You told me about the red car! I love hearing your ideas!" This positive reinforcement encourages more spontaneous communication.', 2),
(16, 'Create Communication Temptations', 'Arrange the environment with interesting items that might prompt your child to comment or ask questions.', 'Place a new toy or unusual object in your child''s play area without commenting on it. Wind up a toy but don''t activate it. These situations naturally encourage communication initiation.', 3),
(16, 'Use Motivating Activities', 'Incorporate your child''s high-interest activities to encourage spontaneous communication through excitement.', 'During activities your child loves, create unexpected problems (like missing pieces) or surprising moments that naturally prompt communication. Enthusiasm often breaks through communication reluctance.', 4),
(16, 'Build Communication Confidence', 'Create a responsive environment where all communication attempts lead to positive outcomes.', 'When your child makes any attempt to communicate, respond quickly and positively. This builds trust that speaking is effective and worthwhile, encouraging more frequent communication attempts.', 5);

-- 17. Emotional Management - Option 17: Emotions quickly collapse into crying and screaming
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(17, 'Teach simple breathing techniques', 'Teach simple breathing techniques like "smell the flower, blow the candle" to help your child regulate intense emotions during difficult moments.', 'Sam learns to breathe in and out to calm down.', 1),
(17, 'Create a calm-down corner', 'Create a calm-down corner at home, equipped with sensory tools like stress balls, weighted blankets, or toys that help your child calm down during emotional moments.', 'Mom creates a calm-down corner with sensory tools.', 2),
(17, 'Use visual supports', 'Use visual supports like an emotions thermometer or traffic light system to help your child identify when emotions are escalating before reaching crisis point.', 'Mom uses a traffic light system to help Sam identify his emotions.', 3),
(17, 'Practice emotion regulation strategies', 'Practice emotion regulation strategies during calm times, not just during meltdowns, to build the neural pathways needed for self-regulation.', 'Mom practices emotion regulation strategies with Sam.', 4),
(17, 'Acknowledge feelings', 'Acknowledge your child''s feelings before attempting to solve problems: "I see you''re feeling very upset that your tower fell down. It''s okay to feel disappointed."', 'Mom acknowledges Sam''s feelings.', 5),
(17, 'Offer constructive solutions', 'Offer constructive solutions after emotional regulation: "Let''s rebuild the tower together" provides a positive next step.', 'Mom helps Sam rebuild his tower.', 6),
(17, 'Be a calm presence', 'Be a calm presence yourself, as children often mirror the emotional state of their caregivers.', 'Mom remains calm during Sam''s emotional moment.', 7);

-- 18. Emotional Management - Option 18: Shows aggressive behaviors
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(18, 'Create visual emotion charts', 'Create visual emotion charts that help your child identify and express their feelings when they struggle to do so verbally.', 'Dad creates a visual emotion chart for Ryan.', 1),
(18, 'Develop a shared emotional vocabulary', 'Develop a shared emotional vocabulary with simple terms your child can understand and use.', 'Dad uses simple terms to help Ryan express his feelings.', 2),
(18, 'Read books about emotions', 'Read books about emotions with your child and discuss how characters feel in different situations.', 'Dad reads a book about emotions with Ryan and discusses the feelings of the characters.', 3),
(18, 'Validate emotions without judgment', 'Validate emotions without judgment: "It''s okay to feel angry, but we need safe ways to show anger."', 'Dad validates Ryan''s feelings without judgment.', 4),
(18, 'Work on identifying emotional triggers', 'Work on identifying emotional triggers through pattern recognition and documenting situations that lead to emotional difficulties.', 'Dad works on identifying emotional triggers with Ryan.', 5);

-- 19. Emotional Management - Option 19: Tries to escape difficult scenarios
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(19, 'Use visual timers', 'Use visual timers to make abstract time concepts concrete and predictable, especially during transitions.', 'Mom uses a visual timer to help Lisa understand the transition.', 1),
(19, 'Create personalized social stories', 'Create personalized social stories about managing difficult emotions in specific situations.', 'Mom creates a personalized social story for Lisa.', 2),
(19, 'Develop a menu of calming strategies', 'Develop a menu of calming strategies tailored to your child''s preferences that they can choose from when upset.', 'Mom develops a menu of calming strategies for Lisa.', 3),
(19, 'Model emotional regulation', 'Model emotional regulation by narrating your own feelings and coping strategies: "I''m feeling frustrated too, so I''m going to take three deep breaths."', 'Mom models emotional regulation.', 4),
(19, 'Celebrate emotional regulation successes', 'Celebrate emotional regulation successes, recognizing when your child has successfully managed a difficult situation.', 'Mom celebrates Lisa''s successful emotional regulation.', 5),
(19, 'Give advance warnings', 'Give advance warnings about transitions using both verbal cues and visual supports.', 'Mom gives advance warnings about the transition.', 6),
(19, 'Provide choices within transitions', 'Provide choices within transitions to give your child a sense of control: "When the timer finishes, would you like to put away the toys yourself or should we do it together?"', 'Mom provides choices within the transition.', 7);

-- 20. Emotional Management - Option 20: Rarely expresses emotions
INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(20, 'Offer Alternative Expression Methods', 'Provide non-verbal ways for your child to communicate emotions when words are difficult.', 'Create an "emotion toolkit" with various materials for expression: drawing supplies, clay for sculpting feelings, emotion cards to point to, or a feelings journal with simple prompts. Normalize these as valid ways to communicate.', 1),
(20, 'Create Regular Check-in Routines', 'Establish predictable times for emotion check-ins using visual supports.', 'Implement a daily "feelings check-in" using a visual emotions chart where your child can simply point to how they''re feeling. Start with basic emotions and gradually expand the vocabulary. Keep it low-pressure: "It''s time for our feelings check. Can you show me which face matches how you feel today?"', 2),
(20, 'Use Indirect Communication Approaches', 'Engage with emotions through third-party scenarios rather than direct questioning.', 'Use stuffed animals or characters to model emotional expression: "Bear looks sad today. I wonder what happened?" This creates emotional distance that can feel safer for children who struggle with direct emotional communication.', 3),
(20, 'Read Stories Featuring Emotions', 'Use stories to introduce emotional vocabulary and connect with your child''s own feelings in a non-threatening way.', 'Choose children''s books where characters face different feelings. After reading, gently ask, "Have you ever felt like the character?" without pressuring an immediate answer.', 4),
(20, 'Allow Processing Time', 'Give your child ample time to process and respond to emotional questions or situations.', 'If your child pauses for a long time after you ask, "How are you feeling today?" simply wait without repeating the question. Let silence be part of the conversation.', 5);

INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(21, 'Provide Sensory Protection Tools', 'Offer tools that allow your child to moderate sensory input in overwhelming environments.', 'Provide noise-canceling headphones for loud environments like grocery stores, sunglasses for bright places, or earplugs for events with unpredictable sounds. Teach your child how to use these as "sensory superpowers" rather than as indicators of weakness.', 1),
(21, 'Create Environmental Previews', 'Prepare your child for sensory-rich environments before entering them.', 'Before going to a busy store, show pictures or videos of the location, discuss the sounds and sights they might experience, and create a plan together for how to handle overwhelming moments, such as identifying a quiet corner for breaks or using a special signal to indicate sensory distress.', 2),
(21, 'Plan Strategic Timing', 'Visit potentially overwhelming environments during their least stimulating times.', 'Schedule grocery shopping during early morning or late evening hours when stores are quieter and less crowded. Visit playgrounds during off-peak hours for reduced noise and activity levels. This gradual exposure helps build sensory tolerance while reducing the risk of overload.', 3);


INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(22, 'Break Down Tactile Tasks', 'Divide touch-sensitive activities into smaller, more manageable steps.', 'For haircuts, establish a gradual process: first just holding scissors near hair without cutting, then snipping one small piece, gradually building up tolerance. For bathing, try breaking the routine into separate components done on different days (hair washing separate from body washing) until tolerance increases.', 1),
(22, 'Modify Sensory Elements', 'Adjust the sensory qualities of caregiving activities to make them more tolerable.', 'For hair washing, try dry shampoo sometimes, use a visor to keep water off the face, or let your child hold a washcloth over their eyes. For nail trimming, try cutting after a bath when nails are softer, use clippers with less vibration, or try filing instead of cutting.', 2),
(22, 'Provide Sensory Preparation', 'Use deep pressure or proprioceptive input before tactile tasks to help regulate the nervous system.', 'Before difficult touch activities, offer deep pressure through firm shoulder squeezes, a tight hug, or weighted blanket time. This type of input has a calming effect on the nervous system and can make light or unexpected touch more tolerable afterward.', 3);

INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(23, 'Modify Lighting Environments', 'Adjust lighting to reduce visual stress in key environments like home and school.', 'Replace fluorescent bulbs with full-spectrum or LED lighting. Use dimmer switches in rooms where your child spends significant time. Consider light filtering solutions like window tints or curtains to control natural light intensity throughout the day.', 1),
(23, 'Create Visual Rest Zones', 'Designate spaces with reduced visual input where your child can recover from visual overload.', 'Set up a corner of your child''s room or a specific area of your home with minimal visual stimulation - neutral colors, reduced patterns, and limited decorations. Keep this area organized and clutter-free as a retreat space when visual processing becomes overwhelming.', 2),
(23, 'Offer Visual Filtering Tools', 'Provide your child with tools to selectively filter visual input in environments they cannot control.', 'For children sensitive to bright light, offer sunglasses, caps with brims, or tinted overlays for reading. For those overwhelmed by visual complexity, provide tools to help focus attention, such as reading windows that highlight only one line of text, or workspace dividers in busy classrooms.', 3);

INSERT INTO recommendations (option_id, title, content, example, display_order) VALUES
(24, 'Schedule Regular Movement Breaks', 'Incorporate planned physical activity throughout your child''s day rather than viewing movement as disruptive.', 'Create a visual schedule that alternates seated activities with movement breaks every 20-30 minutes. These breaks might include wall push-ups, animal walks (bear crawls, crab walks), jumping jacks, or running in place - activities that can be done in small spaces while providing necessary sensory input.', 1),
(24, 'Create a Home Sensory Space', 'Designate an area in your home where sensory-seeking behavior is not only allowed but encouraged.', 'Set up a corner with a mini-trampoline, therapy swing, crash pad (large cushions), or climbing area. Include a variety of sensory materials like putty, weighted items, and textured objects. Make this space available for both scheduled sensory breaks and as-needed regulation.', 2),
(24, 'Incorporate Heavy Work Activities', 'Include activities that provide resistance and deep pressure throughout your child''s routine.', 'Assign household chores that involve pushing, pulling, or carrying heavy objects (appropriate for your child''s size and strength). Examples include carrying groceries, pushing a loaded laundry basket, gardening activities involving digging, or helping to move furniture during cleaning.', 3);



CREATE TABLE articles (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  view_count INTEGER DEFAULT 0
);

-- Article 1
INSERT INTO articles (title, content) VALUES (
  'Can training parents improve autism communication?',
  'Parents play a powerful role in helping autistic children develop communication skills. But just how effective are parent-led interventions when it comes to real-world improvements? This article summarizes findings from a large meta-analysis of 30 randomized controlled trials involving over 1,900 children. It explores how parent training programs impact children’s social communication and overall development.

The reviewed studies included a variety of parent-mediated interventions, most targeting social engagement, language, and behavior regulation. On average, programs lasted from 8 to 20 weeks, and were typically delivered in home or community settings. The researchers found that parent-led interventions resulted in small but meaningful improvements in children’s adaptive functioning and communication skills. These gains were especially strong in younger children who were still developing basic social skills, such as joint attention or imitation.

Beyond improving the child’s outcomes, many programs also helped reduce disruptive behaviors and improved the quality of parent-child interactions. However, the study noted that while improvements in social engagement were clear, changes to core autism symptoms (like repetitive behavior) were more modest. The variability in training methods also meant that some approaches were more effective than others—those that used active coaching and video feedback had particularly strong outcomes.

This review confirms that parents can be trained to become effective communication partners for their children. While the improvements may be gradual, they are real and impactful—particularly when interventions start early. For families looking to get involved in their child’s development, this article provides strong evidence that structured training can make a positive difference in how children with autism connect, respond, and express themselves.'
);

-- Article 2
INSERT INTO articles (title, content) VALUES (
  'What do we know about different parent training styles?',
  'There are many different ways to train parents of autistic children—but which ones work best? This article reviews 53 studies covering various parent training programs across different cultures and formats. It looks at what kinds of improvements these programs bring, particularly in children’s social and communication development.

The reviewed programs ranged from structured clinical sessions to flexible community workshops. Most aimed to help parents support their child’s language, social interaction, and behavior. The article found that around two-thirds of the studies reported noticeable improvements in communication or language use, while 21 studies saw clear gains in social interaction. A smaller number of studies found no significant language improvements, suggesting that not every method works equally well.

The most effective programs shared a few common features: they taught parents how to follow the child’s lead, how to respond to different communication attempts, and how to embed learning into everyday routines. Formats also mattered—programs with active participation and follow-up (like home visits or coaching) tended to outperform one-time workshops. Cultural adaptability was another key factor, especially in low-resource settings where flexible delivery proved crucial.

This wide-ranging review shows that most parent training programs can lead to meaningful gains in children’s communication and social skills, but the degree of success depends on how the program is delivered. For practitioners and parents alike, the article underscores the importance of consistent engagement and practical coaching. When parents are equipped with the right tools and supported along the way, they can play a transformative role in their child’s development.'
);

INSERT INTO articles (title, content) VALUES ('Can a short program help both kids and their parents?', 'Parents of young children with autism often experience high levels of stress and uncertainty. Can a brief training program make a measurable difference—for both children and their caregivers? This article explores the ‘Blue Hope’ parent education program, an eight-session course tested in Tunisia with families of preschool-aged children with autism spectrum disorder.

The study was a randomized controlled trial, meaning families were divided into two groups—one that received the training and one that did not. The program focused on helping parents understand autism, learn positive communication strategies, and manage behavior in constructive ways. It also included emotional support and education about child development.

At the end of the program, children in the intervention group showed significant improvements in their ability to communicate. Parents also reported fewer behavior problems at home. But one of the most powerful outcomes was the impact on the parents themselves. Many caregivers experienced reduced levels of anxiety and depression—benefits that lasted for at least six months after the training ended.

The researchers noted that this low-cost, time-efficient intervention was particularly valuable in a setting where long-term professional therapy might not be accessible to all families. By focusing on parent empowerment and communication basics, the program delivered measurable results that benefited the entire family system.

This study shows that even a short intervention—when well-designed—can produce meaningful outcomes for both autistic children and their caregivers. By supporting parents with education, emotional resources, and communication tools, programs like Blue Hope provide a practical and effective way to promote early development and family well-being, particularly in communities with limited clinical resources.');

INSERT INTO articles (title, content) VALUES ('How new parent coaching tools like Project ImPACT work', 'When it comes to helping autistic children communicate, parents are often their child’s first and most important teachers. This article reviews recent advances in parent coaching programs, particularly those grounded in Naturalistic Developmental Behavioral Interventions (NDBIs), which focus on supporting development during everyday activities. It highlights how programs like Project ImPACT and JASPER train parents to use responsive, play-based strategies at home.

Unlike more clinical interventions, these programs help parents embed learning into real-life situations like mealtime, play, or bath time. Project ImPACT, for example, includes 24 coaching sessions where parents are taught to follow their child’s lead, model new words, and reinforce communication through shared routines. JASPER focuses on joint attention and symbolic play, encouraging children to initiate interactions.

Preliminary results from both programs show promising improvements in children’s social communication, such as increased eye contact, turn-taking, and expressive language. Parents also report reduced stress and improved confidence in their ability to support their child. Many programs use video modeling and feedback to help parents reflect and refine their strategies over time.

These advances also prioritize accessibility. Some programs are offered via telehealth or in group settings, making them available to more families. By shifting the focus from professional-only settings to everyday parenting moments, these interventions help build lasting, sustainable communication routines at home.

This article underscores the importance of coaching parents not only to interact with their child, but to do so in a way that promotes development naturally. By supporting families to become confident communication partners, programs like Project ImPACT and JASPER help children thrive in the moments that matter most—daily life.');

INSERT INTO articles (title, content) VALUES ('How ''More Than Words'' helps everyday conversations', 'How can parents turn ordinary daily routines into meaningful learning moments for their autistic child? The Hanen Centre’s ''More Than Words'' program aims to do just that. This article reviews how the program helps parents support communication development during everyday activities, especially for children with limited language skills.

''More Than Words'' is a group-based training that teaches parents practical, easy-to-use strategies to improve their child’s communication. The sessions focus on increasing parental responsiveness, following the child’s interests, and creating natural opportunities for language. For example, parents are taught how to pause at the right moment to give a child a chance to respond or how to turn simple routines like dressing or snack time into interactive learning moments.

The research found that children whose parents completed the program showed clear improvements in communication skills. These were especially noticeable in children who started with very limited language. Parents themselves gained confidence, emotional support, and a sense of community by participating in the group. Importantly, the intervention worked not just in clinical settings but also when applied at home, making it both scalable and sustainable.

''More Than Words'' demonstrates that parents don’t need to be therapists to make a big impact. With the right training, they can become powerful partners in their child’s communication journey. This article reinforces that with just a few adjustments to everyday routines, parents can help unlock language and connection in ways that are natural, enjoyable, and long-lasting.');

INSERT INTO articles (title, content) VALUES ('Can AAC (Augmentative and Alternative Communication) tools help autistic children speak more?', 'Imagine a child who has difficulty speaking. When handed a picture board or a speech device, many parents wonder—will this help them talk more? These tools, known as AAC (Augmentative and Alternative Communication), are designed to support children with limited or no verbal language. This article reviews 28 research studies to explore whether AAC helps or hinders language development in children with autism.

AAC includes a wide range of communication aids, from simple picture boards to high-tech speech-generating devices. Across the studies analyzed, researchers found that AAC use not only helped children express themselves, but also often led to improvements in spoken language. Many children began using single words after consistent exposure to AAC, while others gained confidence in social situations. The act of having a reliable way to communicate reduced frustration and opened the door to more verbal attempts.

Importantly, the review emphasized that AAC does not prevent speech development. On the contrary, it can serve as a bridge to language. Children didn’t replace speech with AAC—they often used both. Some children continued relying on AAC devices while slowly expanding their verbal vocabulary, showing that the two forms of communication can complement each other. The earlier AAC is introduced, the better, especially during the preschool years when children are more flexible and eager to learn new systems.

AAC should not be viewed as a last resort. Instead, it can be a critical first step in helping nonverbal or minimally verbal children connect with the world. This article shows that AAC provides children with autism a voice—literally and figuratively. By supporting expression through tools that meet their current needs, families and professionals create a foundation for future language growth. AAC empowers children to express their wants, needs, and feelings, which in turn encourages more natural speech over time.');

INSERT INTO articles (title, content) VALUES ('Blended therapy boosts joint attention and speech', 'Preschoolers with autism often need support from multiple directions to develop communication. What if we could blend speech therapy, parent coaching, and assistive technology into a single, short-term program? This article shares the results of a study involving 68 minimally verbal children with autism, aiming to find out how effective this combination can be in improving early communication.

The multi-component program included clinician-led therapy sessions that focused on helping children engage with others and practice communication. In parallel, parents received training so they could use the same techniques at home. The third element was a speech-generating device that gave children a consistent way to express themselves, especially if they weren’t using many spoken words yet.

After the initial intervention, children showed clear progress in joint attention skills—the ability to share focus with another person, such as following a point or gaze. Over the following months, those in the treatment group also improved in spontaneous communication. They were more likely to start interactions or respond to social cues than children who did not receive the intervention. Notably, fewer children in the treatment group remained nonverbal by the end of the study.

The results suggest that combining multiple methods—therapist-led support, at-home parent involvement, and accessible technology—creates a strong foundation for communication growth. This approach not only builds children’s ability to communicate, but also boosts the confidence of caregivers who are directly involved in the learning process. It highlights the power of early, integrated intervention for young children with autism.');

INSERT INTO articles (title, content) VALUES ('Why Picture Exchange Communication System (PECS) helps with basic but not advanced talking', 'The Picture Exchange Communication System (PECS) is widely used to help nonverbal children with autism communicate using images. It’s often the first tool introduced to teach basic communication like making requests. But how far can children go using PECS? This article reviews several studies to understand how well children master the different PECS phases, and why some progress more than others.

PECS is structured into six teaching phases. The first stages are designed to help children make simple requests—for example, handing over a picture of juice to ask for a drink. Most children successfully complete these early steps. However, the review found that only a few advanced to more complex communication, such as building full sentences or commenting on things around them.

The reasons are varied. Later PECS phases require more cognitive and motor skills, such as selecting from multiple symbols or combining them into structured sentences. Some children found these tasks difficult, requiring extensive repetition and support. As a result, many plateaued at the basic level of requesting needs, without using PECS to communicate thoughts, feelings, or observations.

This article emphasizes that PECS is an effective starting point for communication, especially for children who are just beginning to express themselves. However, to help children move beyond basic requests, PECS should be paired with other strategies or supports. With the right approach, children can continue building on their foundational skills and eventually reach more advanced communication levels, allowing for richer interaction with others in daily life.');

INSERT INTO articles (title, content) VALUES ('Can the SCERTS model improve social skills in school?', 'Many autistic children benefit from structured classroom support that helps them develop social and communication skills. The SCERTS model—standing for Social Communication, Emotional Regulation, and Transactional Support—is an educational approach designed to do just that. This article reviews how well SCERTS-based programs help children in school settings improve in social communication and related areas.

The SCERTS model takes a holistic approach, involving teachers, therapists, and families to help autistic children build everyday communication skills. It embeds goals into normal classroom routines, so learning happens naturally during play, group work, and interaction. Across six different studies covering over 450 children, the review found that most students improved in social behaviors such as making eye contact, initiating conversations, and staying engaged with others.

However, not all outcomes were equally strong. While social communication improved reliably, results related to emotional self-regulation or reduction in repetitive behaviors were mixed. Some students made progress in these areas, while others did not. Still, what made SCERTS stand out was its integration into real classrooms rather than clinical settings. Educators were trained to implement SCERTS with good consistency, showing that it can work well in inclusive school environments.

This review suggests that the SCERTS model is a promising option for schools aiming to support autistic children’s social communication. By weaving goals into daily activities and involving a team of adults, it provides a structure that helps children learn without pulling them out of their natural learning environment. While more research is needed to confirm its benefits in areas like emotion regulation, SCERTS is already showing strong potential to improve how children connect and communicate in school life.');

INSERT INTO articles (title, content) VALUES ('Group therapy helps preschoolers build social language', 'Can group therapy in a regular kindergarten help young autistic children communicate better? That’s the question this study set out to answer. Using a program called PICP (Pragmatic Intervention Communication Program), researchers in Portugal tested how effective a 24-session small group therapy was for improving preschoolers’ social language.

The PICP sessions focused on pragmatic language—skills like taking turns in conversation, using the right tone of voice, or understanding when to speak. Twenty children with autism or language delays participated, while another group was placed on a waitlist. The sessions were delivered in familiar classroom settings and guided by trained therapists.

By the end of the program, children in the intervention group had made clear progress. Their scores on standardized language assessments improved significantly, and both parents and teachers noticed better communication in daily life. These included things like more back-and-forth conversations, more appropriate responses to questions, and more attempts to engage peers.

The use of group settings also gave children a chance to practice with peers in real social scenarios. That meant they weren’t just learning language—they were learning how to use it naturally. While the study wasn’t randomized, the positive outcomes offer compelling early evidence that school-based group therapy can support key communication milestones in autistic preschoolers.

This article shows how therapy doesn’t have to happen outside the classroom—it can be part of it. By using small group sessions in everyday learning environments, programs like PICP help children build social language that sticks. For schools looking to support communication growth early on, this approach may offer a practical, effective model that strengthens both learning and connection.');




ALTER TABLE articles ADD COLUMN image_path VARCHAR(255);
ALTER TABLE articles ADD COLUMN source_link TEXT;

UPDATE articles
SET
  content = 'Parents play a powerful role in helping autistic children develop communication skills. But just how effective are parent-led interventions when it comes to real-world improvements? This article summarizes findings from a large meta-analysis of 30 randomized controlled trials involving over 1,900 children. It explores how parent training programs impact children’s social communication and overall development.\n\nThe reviewed studies included a variety of parent-mediated interventions, most targeting social engagement, language, and behavior regulation. On average, programs lasted from 8 to 20 weeks, and were typically delivered in home or community settings. The researchers found that parent-led interventions resulted in small but meaningful improvements in children’s adaptive functioning and communication skills. These gains were especially strong in younger children who were still developing basic social skills, such as joint attention or imitation.\n\nBeyond improving the child’s outcomes, many programs also helped reduce disruptive behaviors and improved the quality of parent-child interactions. However, the study noted that while improvements in social engagement were clear, changes to core autism symptoms (like repetitive behavior) were more modest. The variability in training methods also meant that some approaches were more effective than others—those that used active coaching and video feedback had particularly strong outcomes.\n\nThis review confirms that parents can be trained to become effective communication partners for their children. While the improvements may be gradual, they are real and impactful—particularly when interventions start early. For families looking to get involved in their child’s development, this article provides strong evidence that structured training can make a positive difference in how children with autism connect, respond, and express themselves.',
  source_link = 'https://www.frontiersin.org/articles/10.3389/fpsyt.2021.773604/full'
WHERE title = 'Can training parents improve autism communication?';

UPDATE articles
SET
  content = 'There are many different ways to train parents of autistic children—but which ones work best? This article reviews 53 studies covering various parent training programs across different cultures and formats. It looks at what kinds of improvements these programs bring, particularly in children’s social and communication development.\n\nThe reviewed programs ranged from structured clinical sessions to flexible community workshops. Most aimed to help parents support their child’s language, social interaction, and behavior. The article found that around two-thirds of the studies reported noticeable improvements in communication or language use, while 21 studies saw clear gains in social interaction. A smaller number of studies found no significant language improvements, suggesting that not every method works equally well.\n\nThe most effective programs shared a few common features: they taught parents how to follow the child’s lead, how to respond to different communication attempts, and how to embed learning into everyday routines. Formats also mattered—programs with active participation and follow-up (like home visits or coaching) tended to outperform one-time workshops. Cultural adaptability was another key factor, especially in low-resource settings where flexible delivery proved crucial.\n\nThis wide-ranging review shows that most parent training programs can lead to meaningful gains in children’s communication and social skills, but the degree of success depends on how the program is delivered. For practitioners and parents alike, the article underscores the importance of consistent engagement and practical coaching. When parents are equipped with the right tools and supported along the way, they can play a transformative role in their child’s development.',
  source_link = 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10028377/'
WHERE title = 'What do we know about different parent training styles?';

UPDATE articles
SET
  content = 'Parents of young children with autism often experience high levels of stress and uncertainty. Can a brief training program make a measurable difference—for both children and their caregivers? This article explores the ‘Blue Hope’ parent education program, an eight-session course tested in Tunisia with families of preschool-aged children with autism spectrum disorder.\n\nThe study was a randomized controlled trial, meaning families were divided into two groups—one that received the training and one that did not. The program focused on helping parents understand autism, learn positive communication strategies, and manage behavior in constructive ways. It also included emotional support and education about child development.\n\nAt the end of the program, children in the intervention group showed significant improvements in their ability to communicate. Parents also reported fewer behavior problems at home. But one of the most powerful outcomes was the impact on the parents themselves. Many caregivers experienced reduced levels of anxiety and depression—benefits that lasted for at least six months after the training ended.\n\nThe researchers noted that this low-cost, time-efficient intervention was particularly valuable in a setting where long-term professional therapy might not be accessible to all families. By focusing on parent empowerment and communication basics, the program delivered measurable results that benefited the entire family system.\n\nThis study shows that even a short intervention—when well-designed—can produce meaningful outcomes for both autistic children and their caregivers. By supporting parents with education, emotional resources, and communication tools, programs like Blue Hope provide a practical and effective way to promote early development and family well-being, particularly in communities with limited clinical resources.',
  source_link = 'https://www.nature.com/articles/s41599-024-03099-2'
WHERE title = 'Can a short program help both kids and their parents?';

UPDATE articles
SET
  content = 'When it comes to helping autistic children communicate, parents are often their child’s first and most important teachers. This article reviews recent advances in parent coaching programs, particularly those grounded in Naturalistic Developmental Behavioral Interventions (NDBIs), which focus on supporting development during everyday activities. It highlights how programs like Project ImPACT and JASPER train parents to use responsive, play-based strategies at home.\n\nUnlike more clinical interventions, these programs help parents embed learning into real-life situations like mealtime, play, or bath time. Project ImPACT, for example, includes 24 coaching sessions where parents are taught to follow their child’s lead, model new words, and reinforce communication through shared routines. JASPER focuses on joint attention and symbolic play, encouraging children to initiate interactions.\n\nPreliminary results from both programs show promising improvements in children’s social communication, such as increased eye contact, turn-taking, and expressive language. Parents also report reduced stress and improved confidence in their ability to support their child. Many programs use video modeling and feedback to help parents reflect and refine their strategies over time.\n\nThese advances also prioritize accessibility. Some programs are offered via telehealth or in group settings, making them available to more families. By shifting the focus from professional-only settings to everyday parenting moments, these interventions help build lasting, sustainable communication routines at home.\n\nThis article underscores the importance of coaching parents not only to interact with their child, but to do so in a way that promotes development naturally. By supporting families to become confident communication partners, programs like Project ImPACT and JASPER help children thrive in the moments that matter most—daily life.',
  source_link = 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9607214/'
WHERE title = 'How new parent coaching tools like Project ImPACT work';

UPDATE articles
SET
  content = 'How can parents turn ordinary daily routines into meaningful learning moments for their autistic child? The Hanen Centre’s ''More Than Words'' program aims to do just that. This article reviews how the program helps parents support communication development during everyday activities, especially for children with limited language skills.\n\n''More Than Words'' is a group-based training that teaches parents practical, easy-to-use strategies to improve their child’s communication. The sessions focus on increasing parental responsiveness, following the child’s interests, and creating natural opportunities for language. For example, parents are taught how to pause at the right moment to give a child a chance to respond or how to turn simple routines like dressing or snack time into interactive learning moments.\n\nThe research found that children whose parents completed the program showed clear improvements in communication skills. These were especially noticeable in children who started with very limited language. Parents themselves gained confidence, emotional support, and a sense of community by participating in the group. Importantly, the intervention worked not just in clinical settings but also when applied at home, making it both scalable and sustainable.\n\n''More Than Words'' demonstrates that parents don’t need to be therapists to make a big impact. With the right training, they can become powerful partners in their child’s communication journey. This article reinforces that with just a few adjustments to everyday routines, parents can help unlock language and connection in ways that are natural, enjoyable, and long-lasting.',
  source_link = 'https://pubmed.ncbi.nlm.nih.gov/32079487/'
WHERE title = 'How ''More Than Words'' helps everyday conversations';

UPDATE articles
SET
  content = 'Imagine a child who has difficulty speaking. When handed a picture board or a speech device, many parents wonder—will this help them talk more? These tools, known as AAC (Augmentative and Alternative Communication), are designed to support children with limited or no verbal language. This article reviews 28 research studies to explore whether AAC helps or hinders language development in children with autism.\n\nAAC includes a wide range of communication aids, from simple picture boards to high-tech speech-generating devices. Across the studies analyzed, researchers found that AAC use not only helped children express themselves, but also often led to improvements in spoken language. Many children began using single words after consistent exposure to AAC, while others gained confidence in social situations. The act of having a reliable way to communicate reduced frustration and opened the door to more verbal attempts.\n\nImportantly, the review emphasized that AAC does not prevent speech development. On the contrary, it can serve as a bridge to language. Children didn’t replace speech with AAC—they often used both. Some children continued relying on AAC devices while slowly expanding their verbal vocabulary, showing that the two forms of communication can complement each other. The earlier AAC is introduced, the better, especially during the preschool years when children are more flexible and eager to learn new systems.\n\nAAC should not be viewed as a last resort. Instead, it can be a critical first step in helping nonverbal or minimally verbal children connect with the world. This article shows that AAC provides children with autism a voice—literally and figuratively. By supporting expression through tools that meet their current needs, families and professionals create a foundation for future language growth. AAC empowers children to express their wants, needs, and feelings, which in turn encourages more natural speech over time.',
  source_link = 'https://pubmed.ncbi.nlm.nih.gov/32816121/'
WHERE title = 'Can AAC (Augmentative and Alternative Communication) tools help autistic children speak more?';

UPDATE articles
SET
  content = 'Preschoolers with autism often need support from multiple directions to develop communication. What if we could blend speech therapy, parent coaching, and assistive technology into a single, short-term program? This article shares the results of a study involving 68 minimally verbal children with autism, aiming to find out how effective this combination can be in improving early communication.\n\nThe multi-component program included clinician-led therapy sessions that focused on helping children engage with others and practice communication. In parallel, parents received training so they could use the same techniques at home. The third element was a speech-generating device that gave children a consistent way to express themselves, especially if they weren’t using many spoken words yet.\n\nAfter the initial intervention, children showed clear progress in joint attention skills—the ability to share focus with another person, such as following a point or gaze. Over the following months, those in the treatment group also improved in spontaneous communication. They were more likely to start interactions or respond to social cues than children who did not receive the intervention. Notably, fewer children in the treatment group remained nonverbal by the end of the study.\n\nThe results suggest that combining multiple methods—therapist-led support, at-home parent involvement, and accessible technology—creates a strong foundation for communication growth. This approach not only builds children’s ability to communicate, but also boosts the confidence of caregivers who are directly involved in the learning process. It highlights the power of early, integrated intervention for young children with autism.',
  source_link = 'https://pubmed.ncbi.nlm.nih.gov/32476526/'
WHERE title = 'Blended therapy boosts joint attention and speech';

UPDATE articles
SET
  content = 'The Picture Exchange Communication System (PECS) is widely used to help nonverbal children with autism communicate using images. It’s often the first tool introduced to teach basic communication like making requests. But how far can children go using PECS? This article reviews several studies to understand how well children master the different PECS phases, and why some progress more than others.\n\nPECS is structured into six teaching phases. The first stages are designed to help children make simple requests—for example, handing over a picture of juice to ask for a drink. Most children successfully complete these early steps. However, the review found that only a few advanced to more complex communication, such as building full sentences or commenting on things around them.\n\nThe reasons are varied. Later PECS phases require more cognitive and motor skills, such as selecting from multiple symbols or combining them into structured sentences. Some children found these tasks difficult, requiring extensive repetition and support. As a result, many plateaued at the basic level of requesting needs, without using PECS to communicate thoughts, feelings, or observations.\n\nThis article emphasizes that PECS is an effective starting point for communication, especially for children who are just beginning to express themselves. However, to help children move beyond basic requests, PECS should be paired with other strategies or supports. With the right approach, children can continue building on their foundational skills and eventually reach more advanced communication levels, allowing for richer interaction with others in daily life.',
  source_link = 'https://pubmed.ncbi.nlm.nih.gov/38471680/'
WHERE title = 'Why Picture Exchange Communication System (PECS) helps with basic but not advanced talking';

UPDATE articles
SET
  content = 'Many autistic children benefit from structured classroom support that helps them develop social and communication skills. The SCERTS model—standing for Social Communication, Emotional Regulation, and Transactional Support—is an educational approach designed to do just that. This article reviews how well SCERTS-based programs help children in school settings improve in social communication and related areas.\n\nThe SCERTS model takes a holistic approach, involving teachers, therapists, and families to help autistic children build everyday communication skills. It embeds goals into normal classroom routines, so learning happens naturally during play, group work, and interaction. Across six different studies covering over 450 children, the review found that most students improved in social behaviors such as making eye contact, initiating conversations, and staying engaged with others.\n\nHowever, not all outcomes were equally strong. While social communication improved reliably, results related to emotional self-regulation or reduction in repetitive behaviors were mixed. Some students made progress in these areas, while others did not. Still, what made SCERTS stand out was its integration into real classrooms rather than clinical settings. Educators were trained to implement SCERTS with good consistency, showing that it can work well in inclusive school environments.\n\nThis review suggests that the SCERTS model is a promising option for schools aiming to support autistic children’s social communication. By weaving goals into daily activities and involving a team of adults, it provides a structure that helps children learn without pulling them out of their natural learning environment. While more research is needed to confirm its benefits in areas like emotion regulation, SCERTS is already showing strong potential to improve how children connect and communicate in school life.',
  source_link = 'https://pubs.asha.org/doi/10.1044/2022_JSLHR-22-00089'
WHERE title = 'Can the SCERTS model improve social skills in school?';

UPDATE articles
SET
  content = 'Can group therapy in a regular kindergarten help young autistic children communicate better? That’s the question this study set out to answer. Using a program called PICP (Pragmatic Intervention Communication Program), researchers in Portugal tested how effective a 24-session small group therapy was for improving preschoolers’ social language.\n\nThe PICP sessions focused on pragmatic language—skills like taking turns in conversation, using the right tone of voice, or understanding when to speak. Twenty children with autism or language delays participated, while another group was placed on a waitlist. The sessions were delivered in familiar classroom settings and guided by trained therapists.\n\nBy the end of the program, children in the intervention group had made clear progress. Their scores on standardized language assessments improved significantly, and both parents and teachers noticed better communication in daily life. These included things like more back-and-forth conversations, more appropriate responses to questions, and more attempts to engage peers.\n\nThe use of group settings also gave children a chance to practice with peers in real social scenarios. That meant they weren’t just learning language—they were learning how to use it naturally. While the study wasn’t randomized, the positive outcomes offer compelling early evidence that school-based group therapy can support key communication milestones in autistic preschoolers.\n\nThis article shows how therapy doesn’t have to happen outside the classroom—it can be part of it. By using small group sessions in everyday learning environments, programs like PICP help children build social language that sticks. For schools looking to support communication growth early on, this approach may offer a practical, effective model that strengthens both learning and connection.',
  source_link = 'https://www.mdpi.com/2076-3425/12/12/1747'
WHERE title = 'Group therapy helps preschoolers build social language';








