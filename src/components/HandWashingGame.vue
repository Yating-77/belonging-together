<template>
    <div class="game-container">
      <!-- left panel -->
      <div class="left-panel">
        <div class="exit-button-wrapper">
          <button @click="backToCardSelection" class="exit-button">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
              <polyline points="16 17 21 12 16 7"></polyline>
              <line x1="21" y1="12" x2="9" y2="12"></line>
            </svg>
            <span>Exit Game</span>
          </button>
        </div>
  
        <h2 class="instruction">{{ currentStep.instruction }}</h2>
  
        <!-- Step indicator -->
        <div class="step-indicator">
          <div v-for="(step, index) in gameSteps" :key="step.id" 
               class="step-dot" 
               :class="{ 
                 'current': index === currentStepIndex,
                 'completed': step.completed
               }"
               @click="goToStep(index)">
            {{ index + 1 }}
          </div>
          </div>
  
        <!-- Items palette -->
        <div class="items-palette">
          <div class="palette-title">Available Items</div>
          
          <div v-if="shouldShowItem('hand_action')" 
               class="item-container"
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'hand_action' }">
            <img :src="currentStep.id === 'rinse_hands' ? handsImages.soapy : 
                      (currentStep.id === 'wet_hands' || currentStep.id === 'apply_soap') ? handsImages.neutral : 
                      (currentStep.id === 'turn_on_tap' || currentStep.id === 'turn_off_tap') ? itemImages.hand_action :
                      itemImages.hand_action"
                alt="Hand"
                class="draggable-item"
                draggable="true"
                @dragstart="handleDragStart(items.hand_action, $event)" />
            <span class="item-label">{{ currentStep.id === 'rinse_hands' ? 'Soapy Hands' : 'Hand' }}</span>
        </div>
  
          <div v-if="shouldShowItem('soap')" 
               class="item-container" 
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'soap' }">
            <img :src="itemImages.soap"
                 alt="Soap"
                 class="draggable-item"
                 draggable="true"
                 @dragstart="handleDragStart(items.soap, $event)" />
            <span class="item-label">Soap</span>
          </div>
  
          <div v-if="shouldShowItem('towel')" 
               class="item-container"
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'towel' }">
            <img :src="itemImages.towel"
                 alt="Towel"
                 class="draggable-item"
                 draggable="true"
                 @dragstart="handleDragStart(items.towel, $event)" />
            <span class="item-label">Towel</span>
          </div>
        </div>
          </div>
  
      <!-- Right scene area -->
      <div class="right-panel">
        <!-- Task hint - moved above the scene image -->
        <div class="task-hint">
          <div class="hint-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="12" r="10"></circle>
              <line x1="12" y1="16" x2="12" y2="12"></line>
              <line x1="12" y1="8" x2="12.01" y2="8"></line>
            </svg>
          </div>
          <div class="hint-text">
            <span v-if="currentStep.id === 'turn_on_tap'">Drag "Hand" to the tap to turn on the water</span>
            <span v-if="currentStep.id === 'wet_hands'">Drag "Hand" under the water</span>
            <span v-if="currentStep.id === 'apply_soap'">Drag "Soap" to your hands</span>
            <span v-if="currentStep.id === 'rinse_hands'">Drag "Soapy Hands" under the water stream</span>
            <span v-if="currentStep.id === 'turn_off_tap'">Drag "Hand" to the tap to turn off the water</span>
            <span v-if="currentStep.id === 'dry_hands'">Drag "Towel" to your hands to dry</span>
          </div>
        </div>
  
        <div class="scene-area"
             :style="{ backgroundImage: `url(${currentStep.sceneImage})` }"
             @dragover.prevent="handleDragOver"
             @drop="handleDropOnScene">
  
          <!-- Tap target area -->
          <div v-if="currentStep.dropTarget === 'tap'"
               class="drop-zone tap-zone"
               :style="getTapPositionStyle()"
               :class="{ 
                 'droppable-active': isDragOverTap, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverTap"
               @dragleave="handleDragLeaveTap"
               @drop.stop="handleDropOnTarget('tap')">
          </div>
          
          <!-- Sink basin target area -->
          <div v-if="currentStep.id === 'wet_hands' || currentStep.id === 'rinse_hands'"
               :id="currentStep.id === 'wet_hands' ? 'wet_hands_zone' : 'rinse_hands_zone'"
               class="drop-zone sink-zone"
               :class="{ 
                 'droppable-active': isDragOverHands, 
                 'highlight-zone': (currentStep.id === 'wet_hands' || currentStep.id === 'rinse_hands') && currentStep.dropTarget === 'hands',
                 'soapy-sink': currentStep.id === 'rinse_hands'
               }"
               @dragover.prevent="handleDragOverHands"
               @dragleave="handleDragLeaveHands"
               @drop.stop="handleDropOnTarget('hands')">
        </div>
  
          <!-- Hands area -->
          <div class="hands-area-container" 
               :style="getHandsPositionStyle()"
               :class="{ 
                 'droppable-active': isDragOverHands && currentStep.dropTarget === 'hands' && currentStep.id !== 'wet_hands' && currentStep.id !== 'rinse_hands',
                 'highlight-zone': currentStep.dropTarget === 'hands' && (currentStep.id === 'apply_soap' || currentStep.id === 'dry_hands') && currentStep.id !== 'wet_hands' && currentStep.id !== 'rinse_hands'
               }"
               >
            <img v-if="currentStep.id !== 'turn_on_tap' && currentStep.id !== 'wet_hands' && currentStep.id !== 'rinse_hands' && (currentStep.showHandsImage || currentStep.id === 'dry_hands')" 
                 :src="currentStep.id === 'dry_hands' && !currentStep.completed ? handsImages.wet : handsImage" alt="Hands" class="hands-display"
                 :class="{ 
                   'droppable-active': isDragOverHands && currentStep.dropTarget === 'hands',
                   'wiggle-animation': currentStep.id === 'rinse_hands' && !currentStep.completed,
                   'hands-under-water': (currentStep.id === 'rinse_hands' || (gameSteps[0].completed && !gameSteps[3].completed)) && currentStep.id !== 'dry_hands',
                   'hands-forward': currentStep.id === 'rinse_hands'
                 }"
                 @dragover.prevent="handleDragOverHands"
                 @dragleave="handleDragLeaveHands"
                 @drop.stop="handleDropOnTarget('hands')"
                 @click="handleHandsClick"
            />
            
            <!-- Soap bubbles -->
            <div v-if="currentStep.id === 'apply_soap' && currentStep.completed" class="soap-bubbles"></div>
      </div>
  
          <!-- Success message -->
      <div v-if="feedbackMessage" class="feedback-message" :class="{ 'success': isSuccess }">
        {{ feedbackMessage }}
          </div>
      </div>
  
        <!-- Confetti animation effect -->
        <div v-if="allStepsCompleted" class="confetti-container">
          <div v-for="n in 50" :key="n" class="confetti" :style="getConfettiStyle(n)"></div>
        </div>
  
        <!-- Bottom controls area -->
        <div class="bottom-controls">
          <button v-if="currentStepIndex > 0" @click="goToPreviousStep" class="previous-button">
            Previous
          </button>
      <button v-if="allStepsCompleted" @click="resetGame" class="reset-button">
            Try Again
          </button>
          <button @click="showSummary" class="summary-button">
            See Summary
      </button>
        </div>
      </div>
  
      <!-- Hand washing process summary card -->
      <div v-if="showSummaryCard" class="summary-card">
        <div class="summary-popup">
          <div class="summary-header">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="summary-icon">
              <path d="M20.24 12.24a6 6 0 0 0-8.49-8.49L5 10.5V19h8.5l6.74-6.76z"></path>
              <line x1="16" y1="8" x2="2" y2="22"></line>
              <line x1="17.5" y1="15" x2="9" y2="15"></line>
            </svg>
            <span>Hand Washing Process</span>
            <button @click="closeSummary" class="close-summary-icon">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
              </svg>
            </button>
          </div>
          <div class="summary-content">
            <div class="summary-intro">
              <p>Congratulations on mastering proper hand washing! Follow these steps to help children with autism maintain good hygiene:</p>
            </div>
            <div class="summary-flow-grid">
              <!-- First row - step 1, 2, 3 -->
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>1</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="getStepImage(gameSteps[0])" alt="Turn on the tap" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Turn on the tap</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Turn on the tap
                </div>
              </div>
              
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>2</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="getStepImage(gameSteps[1])" alt="Wet your hands" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Wet your hands</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Place hands under water
                </div>
              </div>
              
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>3</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="getStepImage(gameSteps[2])" alt="Apply soap" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Apply soap</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Apply soap
                </div>
              </div>
              
              <!-- Second row - step 4, 5, 6 -->
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>4</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="getStepImage(gameSteps[3])" alt="Rinse your hands" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Rinse your hands</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Rinse off the soap
                </div>
              </div>
              
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>5</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="getStepImage(gameSteps[4])" alt="Turn off the tap" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Turn off the tap</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Turn off the tap
                </div>
              </div>
              
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>6</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="getStepImage(gameSteps[5])" alt="Dry your hands" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Dry your hands</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Dry your hands
                </div>
              </div>
            </div>
            <div class="summary-footer">
              <p>Regular hand washing helps prevent the spread of germs and creates a consistent routine for children with autism!</p>
              <div class="summary-buttons">
                <button @click="closeSummary" class="close-summary-button">Close</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed, onMounted, watch } from 'vue';
  
  // --- image path ---
  const sceneImages = {
    start: new URL('@/assets/washing/scene_start.png', import.meta.url).href, 
    water_on: new URL('@/assets/washing/scene_water_on.png', import.meta.url).href,
    water_soapy: new URL('@/assets/washing/scene_water_soapy.png', import.meta.url).href,
    water_off: new URL('@/assets/washing/scene_start.png', import.meta.url).href,
  };
  
  const handsImages = {
    neutral: new URL('@/assets/washing/hands_neutral.png', import.meta.url).href,
    wet: new URL('@/assets/washing/hands_wet.png', import.meta.url).href,
    soapy: new URL('@/assets/washing/hands_soapy.png', import.meta.url).href,
    rinsed: new URL('@/assets/washing/hands_clean.png', import.meta.url).href,
    clean_dry: new URL('@/assets/washing/hands_clean.png', import.meta.url).href,
  };
  
  // add water stream image
  const waterStreamImage = new URL('@/assets/washing/water_stream.png', import.meta.url).href;
  
  const itemImages = {
    soap: new URL('@/assets/washing/soap.png', import.meta.url).href,
    towel: new URL('@/assets/washing/towel.png', import.meta.url).href,
    hand_action: new URL('@/assets/washing/hand_tap.png', import.meta.url).href
  };
  
  // --- game state definition ---
  const gameSteps = ref([
    {
      id: 'turn_on_tap',
      instruction: 'Step 1: Turn on the tap',
      sceneImage: sceneImages.start,
      draggableItemRequired: 'hand_action',
      dropTarget: 'tap', 
      nextHandsImage: handsImages.neutral,
      nextSceneImage: sceneImages.water_on,
      successMessage: 'You turned on the water!',
      completed: false,
    },
    {
      id: 'wet_hands',
      instruction: 'Step 2: Place hands under water',
      sceneImage: sceneImages.water_on,
      draggableItemRequired: 'hand_action',
      dropTarget: 'hands',
      nextHandsImage: handsImages.wet,
      nextSceneImage: sceneImages.water_on,
      successMessage: 'Your hands are wet!',
      completed: false,
    },
    {
      id: 'apply_soap',
      instruction: 'Step 3: Apply soap',
      sceneImage: sceneImages.water_on,
      draggableItemRequired: 'soap',
      dropTarget: 'hands',
      nextHandsImage: handsImages.soapy,
      nextSceneImage: sceneImages.water_soapy,
      successMessage: 'Great! Lots of bubbles to clean your hands!',
      completed: false,
      showHandsImage: true,
    },
    {
      id: 'rinse_hands',
      instruction: 'Step 4: Rinse off the soap',
      sceneImage: sceneImages.water_soapy,
      draggableItemRequired: 'hand_action',
      dropTarget: 'hands',
      nextHandsImage: handsImages.rinsed,
      nextSceneImage: sceneImages.water_on,
      successMessage: 'Your hands are clean!',
      completed: false,
      showHandsImage: true,
    },
    {
      id: 'turn_off_tap',
      instruction: 'Step 5: Turn off the tap',
      sceneImage: sceneImages.water_on,
      draggableItemRequired: 'hand_action',
      dropTarget: 'tap',
      nextHandsImage: handsImages.rinsed,
      nextSceneImage: sceneImages.water_off,
      successMessage: 'You turned off the water!',
      completed: false,
    },
    {
      id: 'dry_hands',
      instruction: 'Step 6: Dry your hands',
      sceneImage: sceneImages.water_off,
      draggableItemRequired: 'towel',
      dropTarget: 'hands',
      nextHandsImage: handsImages.neutral, // 将下一步手部图片改为干燥的手
      nextSceneImage: sceneImages.water_off,
      successMessage: 'All done!',
      completed: false,
      showHandsImage: true, // 确保显示手部图片
    },
  ]);
  
  const items = ref({
    soap: { id: 'soap', image: itemImages.soap, used: false, name: 'Soap' },
    towel: { id: 'towel', image: itemImages.towel, used: false, name: 'Towel' },
    hand_action: { id: 'hand_action', image: itemImages.hand_action, used: false, name: 'Hand' }
  });
  
  // --- reactive state ---
  const currentStepIndex = ref(0);
  const handsImage = ref(handsImages.neutral);
  const feedbackMessage = ref('');
  const isSuccess = ref(false);
  const draggedItem = ref(null);
  
  const isDragOverTap = ref(false);
  const isDragOverHands = ref(false);
  const showGuidance = ref(true);
  const showSummaryCard = ref(false);
  
  // periodically show guidance
  onMounted(() => {
    setInterval(() => {
      if (!allStepsCompleted.value) {
        showGuidance.value = true;
        setTimeout(() => {
          showGuidance.value = false;
        }, 2000);
      }
    }, 5000);
  });
  
  // --- computed properties ---
  const currentStep = computed(() => gameSteps.value[currentStepIndex.value] || gameSteps.value[gameSteps.value.length-1]);
  const allStepsCompleted = computed(() => gameSteps.value.every(step => step.completed));
  
  // --- lifecycle hooks ---
  onMounted(() => {
    if (gameSteps.value.length > 0) {
      handsImage.value = handsImages.neutral;
    }
  });
  
  // watch current step change, add guidance animation
  watch(currentStepIndex, () => {
    showGuidance.value = true;
    setTimeout(() => {
      showGuidance.value = false;
    }, 3000);
  });
  
  // --- methods ---
  function shouldShowItem(itemId) {
    const item = items.value[itemId];
    if (!item) return false;
  
    // only show specific items in specific steps
    if (currentStep.value.id === 'turn_on_tap' && itemId !== 'hand_action') {
      return false;
    }
    
    // step 2 needs hand, but step 1 must be completed first
    if (currentStep.value.id === 'wet_hands' && itemId === 'hand_action' && !gameSteps.value[0].completed) {
      return false;
    }
    
    // step 4 needs hand, but step 3 must be completed first
    if (currentStep.value.id === 'rinse_hands' && itemId === 'hand_action' && !gameSteps.value[2].completed) {
      return false;
    }
    
    // step 5 needs hand, but step 4 must be completed first
    if (currentStep.value.id === 'turn_off_tap' && itemId === 'hand_action' && !gameSteps.value[3].completed) {
      return false;
    }
    
    // always show all available items
    return true;
  }
  
  function handleDragStart(item, event) {
    draggedItem.value = item;
    event.dataTransfer.effectAllowed = 'move';
    event.dataTransfer.setData('text/plain', item.id);
    feedbackMessage.value = '';
  }
  
  function handleDragOver(event) {
    // allow drag and drop
  }
  
  function handleDragOverTap(event) {
    if (currentStep.value.dropTarget === 'tap' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverTap.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveTap() {
    isDragOverTap.value = false;
  }
  
  function handleDragOverHands(event) {
    if (currentStep.value.dropTarget === 'hands' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverHands.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveHands() {
    isDragOverHands.value = false;
  }
  
  // add click hand processing method
  function handleHandsClick() {
    // only allow click on hand in step 4
    if (currentStep.value.id === 'rinse_hands' && !currentStep.value.completed) {
      completeStep('hands');
    }
  }
  
  function handleDropOnTarget(targetId) {
    isDragOverTap.value = false;
    isDragOverHands.value = false;
  
    if (!draggedItem.value) return;
  
    const step = currentStep.value;
    if (draggedItem.value.id === step.draggableItemRequired && targetId === step.dropTarget) {
      completeStep(targetId);
    } else {
      // wrong action
      feedbackMessage.value = 'Please try another action. Check the instructions for hints.';
      isSuccess.value = false;
      setTimeout(() => { feedbackMessage.value = ''; }, 2000);
    }
    draggedItem.value = null;
  }
  
  function completeStep(targetId) {
    const step = currentStep.value;
    
    // mark step as completed
    step.completed = true;
    
    // update hand image, special handle step 6
    if (step.id === 'dry_hands') {
      handsImage.value = handsImages.neutral; // dry hand
    } else {
      handsImage.value = step.nextHandsImage;
    }
  
    // show success message
    feedbackMessage.value = step.successMessage;
    isSuccess.value = true;
  
    // add success animation
    addSuccessAnimation(targetId);
  
    // delay to next step
    setTimeout(() => {
      if (currentStepIndex.value < gameSteps.value.length - 1) {
        currentStepIndex.value++;
        feedbackMessage.value = '';
      } else if (allStepsCompleted.value) {
        feedbackMessage.value = 'Congratulations! You completed all the hand washing steps! Your hands are very clean!';
        isSuccess.value = true;
      }
    }, 1500);
  }
  
  // add success animation
  function addSuccessAnimation(targetId) {
    // based on target area, add different animation effects
    if (targetId === 'tap') {
      // tap animation effect - flash effect
      const tapZone = document.querySelector('.tap-zone');
      if (tapZone) {
        tapZone.classList.add('success-animation');
        setTimeout(() => {
          tapZone.classList.remove('success-animation');
        }, 1000);
      }
    } else if (targetId === 'hands') {
      // sink area or hands area - ripple effect
      let targetElement;
      
      if (currentStep.value.id === 'wet_hands') {
        targetElement = document.querySelector('#wet_hands_zone');
      } else if (currentStep.value.id === 'rinse_hands') {
        targetElement = document.querySelector('#rinse_hands_zone');
      } else {
        targetElement = document.querySelector('.hands-area-container');
      }
      
      if (targetElement) {
        targetElement.classList.add('success-animation');
        setTimeout(() => {
          targetElement.classList.remove('success-animation');
        }, 1000);
      }
    }
  }
  
  // if drag to scene blank area
  function handleDropOnScene() {
    isDragOverTap.value = false;
    isDragOverHands.value = false;
    if (draggedItem.value) {
      feedbackMessage.value = 'Please drag the item to the correct position.';
      isSuccess.value = false;
      setTimeout(() => { feedbackMessage.value = ''; }, 2000);
    }
    draggedItem.value = null;
  }
  
  function resetGame() {
    currentStepIndex.value = 0;
    handsImage.value = handsImages.neutral;
    feedbackMessage.value = '';
    isSuccess.value = false;
    gameSteps.value.forEach(step => step.completed = false);
  }
  
  // confetti style generation function
  function getConfettiStyle(n) {
    const randomColor = ['#ff0000', '#00ff00', '#0000ff', '#ffff00', '#ff00ff', '#00ffff'];
    const color = randomColor[Math.floor(Math.random() * randomColor.length)];
    const left = `${Math.random() * 100}%`;
    const animationDelay = `${Math.random() * 5}s`;
    const animationDuration = `${Math.random() * 3 + 2}s`;
    
    return {
      backgroundColor: color,
      left: left,
      animationDelay: animationDelay,
      animationDuration: animationDuration
    };
  }
  
  function backToCardSelection() {
    // directly notify parent component to return skill game selection through emit event
    emit('back');
  }
  
  // ensure emit event is declared
  const emit = defineEmits(['back']);
  
  // add step jump function
  function goToStep(index) {
    // only jump to completed steps or previous steps
    if (gameSteps.value[index].completed || index <= currentStepIndex.value) {
      currentStepIndex.value = index;
      // update hand image
      handsImage.value = gameSteps.value[index].nextHandsImage || handsImages.neutral;
      // show feedback info indicating current step
      feedbackMessage.value = `Please ${gameSteps.value[index].instruction.toLowerCase().replace('step ' + (index+1) + ': ', '')}`;
      isSuccess.value = true;
      // 2秒后清除反馈信息
      setTimeout(() => {
        feedbackMessage.value = '';
      }, 2000);
    }
  }
  
  // add previous step jump function
  function goToPreviousStep() {
    if (currentStepIndex.value > 0) {
      currentStepIndex.value--;
      // update hand image
      if (gameSteps.value[currentStepIndex.value].completed) {
        handsImage.value = gameSteps.value[currentStepIndex.value].nextHandsImage || handsImages.neutral;
      } else {
        // if step not completed, use default or previous step image
        handsImage.value = currentStepIndex.value > 0 && gameSteps.value[currentStepIndex.value - 1].completed ? 
          gameSteps.value[currentStepIndex.value - 1].nextHandsImage : handsImages.neutral;
      }
      
      // show feedback info indicating current step (pure English)
      feedbackMessage.value = `Please ${gameSteps.value[currentStepIndex.value].instruction.toLowerCase().replace('step ' + (currentStepIndex.value+1) + ': ', '')}`;
      isSuccess.value = true;
      // 2秒后清除反馈信息
      setTimeout(() => {
        feedbackMessage.value = '';
      }, 2000);
    }
  }
  
  // calculate sink position style - use relative percentage coordinates
  function getSinkPositionStyle() {
    return {
      position: 'absolute',
      bottom: '35%', 
      left: '20%',
      width: '22.5%',
      height: '22%',
      zIndex: 2
    };
  }
  
  // calculate tap position style - use relative percentage coordinates
  function getTapPositionStyle() {
    return {
      position: 'absolute',
      top: '25%',    
      left: '45%',
      width: '10%',
      height: '16%',
      zIndex: 2
    };
  }
  
  // calculate hands area position style - use relative percentage coordinates
  function getHandsPositionStyle() {
    return {
      position: 'absolute',
      bottom: '20%', 
      left: '50%',    
      transform: 'translateX(-50%)',  
      width: '18.75%', 
      height: '24%',   
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
      borderRadius: '15px',
      zIndex: 3
    };
  }
  
  // get corresponding image based on step
  function getStepImage(step) {
    switch(step.id) {
      case 'turn_on_tap':
        return new URL('@/assets/washing/hand_turning_on.png', import.meta.url).href;
      case 'wet_hands':
      return new URL('@/assets/washing/hand_step2.png', import.meta.url).href;
      case 'apply_soap':
        return handsImages.soapy;
      case 'rinse_hands':
        return handsImages.wet;
      case 'turn_off_tap':
        return new URL('@/assets/washing/hand_turning_off.png', import.meta.url).href;
      case 'dry_hands':
        return handsImages.neutral;
      default:
        return '';
    }
  }
  
  // show hand washing process summary
  function showSummary() {
    showSummaryCard.value = true;
  }
  
  // close summary card
  function closeSummary() {
    showSummaryCard.value = false;
  }
  </script>
  
  <style scoped>
  .game-container {
    display: flex;
    flex-direction: row;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
    width: 98%;
    max-width: 1400px;
    margin: 10px auto;
    background-color: #f8f9fa;
    box-shadow: 0 12px 30px rgba(0,0,0,0.12);
    border-radius: 16px;
    overflow: hidden;
    border: 1px solid #e0e0e0;
    position: relative;
    height: auto;
  }
  
  .exit-button-wrapper {
    width: 100%;
    margin-bottom: 15px;
  }
  
  .exit-button {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px 16px;
    background-color: #3E5C2B;
    color: white;
    border: none;
    border-radius: 8px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    font-size: 0.9em;
    position: relative;
    z-index: 2; 
  }
  
  .exit-button:hover {
    background-color: #324a23;
    transform: translateY(-2px);
    box-shadow: 0 6px 12px rgba(0,0,0,0.25);
  }
  
  .exit-button svg {
    stroke: white;
  }
  
  /* Left information panel */
  .left-panel {
    width: 25%;
    padding: 20px 24px 30px; 
    display: flex;
    flex-direction: column;
    background-color: #fff;
    border-right: 1px solid #e0e0e0;
    height: auto;
    min-height: 580px;
    overflow-y: auto;
    transition: all 0.3s ease;
  }
  
  /* Right scene area */
  .right-panel {
    width: 75%;
    padding: 30px;
    display: flex;
    flex-direction: column;
    background-color: #f8f9fa;
    height: auto;
    min-height: 580px;
    position: relative;
  }
  
  /* Task hint - moved above the scene image */
  .task-hint {
    position: relative;
    display: flex;
    align-items: center;
    background-color: #f1f8e9;
    padding: 12px 16px;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    border: 1px solid #c5e1a5;
    margin-bottom: 16px;
    z-index: 5;
    animation: pulse-hint 2s infinite;
  }
  
  @keyframes pulse-hint {
    0% {
      box-shadow: 0 6px 16px rgba(0,0,0,0.08);
    }
    50% {
      box-shadow: 0 6px 16px rgba(62, 92, 43, 0.3);
    }
    100% {
      box-shadow: 0 6px 16px rgba(0,0,0,0.08);
    }
  }
  
  .hint-icon {
    color: #3E5C2B;
    margin-right: 16px;
    flex-shrink: 0;
    font-size: 1.2em;
  }
  
  .hint-text {
    font-size: 1.05em;
    color: #333;
    line-height: 1.5;
  }
  
  /* Bottom controls area */
  .bottom-controls {
    position: relative;
    margin-top: 10px;
    width: 100%;
    display: flex;
    justify-content: center;
    gap: 24px;
    padding: 0;
    z-index: 10; 
  }
  
  .instruction {
    font-size: 1.4em;
    color: #333;
    margin-bottom: 16px;
    text-align: left;
    padding-bottom: 12px;
    border-bottom: 1px solid #eaeaea;
    font-weight: 600;
  }
  
  .scene-area {
    width: 100%;
    max-width: 800px;
    height: 0;
    padding-bottom: 56%; 
    background-size: contain;
    background-repeat: no-repeat;
    background-position: center;
    position: relative;
    border: 1px solid #e0e0e0;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: inset 0 0 12px rgba(0,0,0,0.06);
    margin: 0 auto 10px auto; 
  }
  
  .step-indicator {
    display: flex;
    gap: 6px;
    background: #fff;
    padding: 10px 12px;
    border-radius: 10px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    border: 1px solid #e0e0e0;
    margin-bottom: 16px;
    justify-content: center;
    flex-wrap: wrap;
  }
  
  .step-dot {
    width: 28px;
    height: 28px;
    border-radius: 50%;
    background-color: #f0f0f0;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 500;
    color: #666;
    transition: all 0.25s ease;
    font-size: 0.85em;
    cursor: pointer;
    margin: 3px;
  }
  
  .step-dot:hover {
    transform: scale(1.05);
    background-color: #e0e0e0;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  }
  
  .step-dot.current {
    background-color: #3E5C2B;
    color: white;
    transform: scale(1.1);
    box-shadow: 0 0 8px rgba(62, 92, 43, 0.4);
  }
  
  .step-dot.completed {
    background-color: #8bc34a;
    color: white;
  }
  
  /* Items palette */
  .items-palette {
    background-color: rgba(255, 255, 255, 0.98);
    padding: 12px;
    border-radius: 12px;
    box-shadow: 0 6px 16px rgba(0,0,0,0.1);
    border: 1px solid #e0e0e0;
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: space-around;
    gap: 10px;
    margin-bottom: 15px;
    flex-grow: 1;
    max-height: 500px;
    overflow-y: auto;
  }
  
  .palette-title {
    width: 100%;
    font-weight: 600;
    color: #3E5C2B;
    text-align: center;
    padding-bottom: 6px;
    margin-bottom: 10px;
    border-bottom: 1px solid #eaeaea;
    font-size: 1.1em;
  }
  
  .item-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    transition: all 0.3s ease;
    margin-bottom: 5px;
    position: relative;
    padding: 8px;
    border-radius: 12px;
    cursor: grab;
    width: 30%;
    min-width: 80px;
  }
  
  .item-container:hover {
    background-color: #f1f8e9;
    transform: translateY(-3px);
  }
  
  .draggable-item {
    width: 65px;
    height: 65px;
    cursor: grab;
    border: 1px solid #e0e0e0;
    border-radius: 10px;
    transition: all 0.3s ease;
    background-color: white;
    padding: 5px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
  }
  
  .item-label {
    margin-top: 6px;
    font-size: 0.9em;
    font-weight: 500;
    color: #333;
    text-align: center;
  }
  
  .reset-button, .previous-button, .summary-button, .close-summary-button {
    padding: 14px 24px;
    font-size: 1.1em;
    font-weight: 600;
    background-color: #3E5C2B;
    color: white;
    border: none;
    border-radius: 12px;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 6px 15px rgba(62, 92, 43, 0.25);
  }
  
  .reset-button:hover, .previous-button:hover, .summary-button:hover, .close-summary-button:hover {
    background-color: #324a23;
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(62, 92, 43, 0.35);
  }
  
  @media (max-width: 1200px) {
    .game-container {
      width: 98%;
    }
    
    .left-panel {
      width: 30%;
    }
    
    .right-panel {
      width: 70%;
    }
    
    .scene-area {
      height: 450px;
    }
  }
  
  @media (max-width: 992px) {
    .left-panel {
      width: 35%;
    }
    
    .right-panel {
      width: 65%;
    }
    
    .instruction {
      font-size: 1.2em;
  }
  
    .scene-area {
      height: 400px;
    }
    
    .draggable-item {
      width: 60px;
      height: 60px;
    }
  }
  
  @media (max-width: 768px) {
    .game-container {
      flex-direction: column;
      width: 98%;
      height: auto;
      min-height: 100vh;
      padding: 0; 
    }
    
    .left-panel, .right-panel {
      width: 100%;
      height: auto;
      min-height: auto;
    }
    
    .left-panel {
      padding: 15px 15px 15px; 
      order: 1;
    }
    
    .right-panel {
      padding: 10px 15px 60px; 
      order: 2; 
      overflow-x: visible; 
      position: relative;
      padding-bottom: 80px; 
    }
    
    .exit-button-wrapper {
      margin-bottom: 10px;
    }
    
    .exit-button {
      padding: 8px 12px;
      font-size: 0.9em;
      z-index: 2; 
    }
    
    .instruction {
      font-size: 1.2em;
      text-align: center;
      margin-top: 10px; 
    }
    
    .scene-area {
      width: 100%;
      padding-bottom: 56%; 
      margin-bottom: 20px; 
    }
    
    .step-indicator {
      margin-bottom: 12px;
      margin-top: 10px;
      gap: 4px;
    }
    
    .items-palette {
      flex-direction: row;
      flex-wrap: wrap;
      justify-content: space-around;
      align-items: center;
    }
    
    .palette-title {
      width: 100%;
      margin-bottom: 15px;
    }
    
    .item-container {
      width: auto;
      margin: 0 10px 10px;
    }
    
    .bottom-controls {
      position: absolute; 
      bottom: 10px;
      left: 0;
      width: 100%;
      display: flex;
      justify-content: center;
      gap: 10px;
      margin-top: 15px;
      flex-wrap: wrap;
    }
    
    .reset-button, .previous-button, .summary-button {
      padding: 10px 16px;
      font-size: 0.95em;
      margin: 5px;
    }
  
    .task-hint {
      padding: 8px 12px;
      margin-bottom: 10px;
    }
    
    .hint-text {
      font-size: 0.95em;
    }
    
    .water-stream-animation {
      top: 35%;
      left: 42%;
      width: 45px;
      height: 90px;
    }
    
    .tap-zone.highlight-zone::after,
    .sink-zone.highlight-zone::after {
      font-size: 0.75em;
      padding: 3px 6px;
    }
    
    .flow-arrow-to-step5, .flow-arrow-to-step6, .flow-arrow-horizontal, 
    .flow-arrow-down, .flow-arrow-horizontal-reverse {
      display: none !important;
    }
  }
  
  @media (max-width: 576px) {
    .scene-area {
      padding-bottom: 60%; 
      margin-bottom: 15px;
    }
    
    .exit-button {
      padding: 6px 10px;
      font-size: 0.85em;
      z-index: 2; 
    }
    
    .exit-button span {
      font-size: 0.9em;
    }
    
    .exit-button svg {
      width: 16px;
      height: 16px;
    }
    
    .step-dot {
      width: 24px;
      height: 24px;
      font-size: 0.8em;
      margin: 2px;
    }
    
    .items-palette {
      padding: 10px;
      gap: 8px;
    }
    
    .draggable-item {
      width: 50px;
      height: 50px;
    }
    
    .item-label {
      margin-top: 5px;
      font-size: 0.85em;
    }
    
    .instruction {
      font-size: 0.95em;
      margin-bottom: 10px;
      padding-bottom: 8px;
    }
  
    .bottom-controls {
      bottom: 5px;
      gap: 5px;
    }
    
    .reset-button, .previous-button, .summary-button {
      padding: 8px 12px;
      font-size: 0.85em;
      margin: 2px;
    }
  
  }
  
  @media (max-width: 900px) {
    .scene-area {
      width: 100%;
      max-width: 800px;
      margin: 0 auto 40px auto; 
    }
  }
  
  @media (max-height: 700px) {
    .game-container {
      margin: 5px auto;
    }
    
    .left-panel {
      min-height: auto;
      padding: 10px;
    }
    
    .scene-area {
      padding-bottom: 50% !important; 
      margin-bottom: 10px;
    }
    
    .instruction {
      margin-bottom: 8px;
      padding-bottom: 5px;
    }
    
    .step-indicator {
      margin-bottom: 8px;
      margin-top: 5px;
      padding: 5px;
    }
    
    .items-palette {
      padding: 8px;
      gap: 5px;
    }
    
    .item-container {
      padding: 5px;
    }
    
    .bottom-controls {
      bottom: 0px;
    }
    
    .feedback-message {
      padding: 8px 12px;
      font-size: 1em;
    }
  }
  
  .summary-flow-grid .flow-step-card:nth-child(1)::after,
  .summary-flow-grid .flow-step-card:nth-child(2)::after,
  .summary-flow-grid .flow-step-card:nth-child(3)::after,
  .summary-flow-grid .flow-step-card:nth-child(4)::after,
  .summary-flow-grid .flow-step-card:nth-child(5)::after,
  .summary-flow-grid .flow-step-card:not(:last-child)::after {
    display: none !important; 
    content: none !important;
  }
  
  .flow-arrow-horizontal, .flow-arrow-down, 
  .flow-arrow-to-step5, .flow-arrow-to-step6, 
  .flow-arrow-horizontal-reverse {
    display: none !important;
  }
  
  .flow-step-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.12);
    background-color: #f1f8e9;
  }
  
  .flow-step-circle {
    width: 48px;
    height: 48px;
    background-color: #3E5C2B;
    color: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.2em;
    font-weight: 600;
    flex-shrink: 0;
    box-shadow: 0 4px 10px rgba(62, 92, 43, 0.3);
    z-index: 2;
  }
  
  .flow-step-image-container {
    width: 120px;
    height: 120px;
    background-color: white;
    border-radius: 10px;
    padding: 8px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    margin: 15px 0;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 1px solid #eaeaea;
    overflow: hidden;
    transition: all 0.3s ease;
    position: relative;
  }
  
  .step-image {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
    display: block;
    z-index: 1;
  }
  
  .step-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(62, 92, 43, 0.8);
    display: flex;
    justify-content: center;
    align-items: center;
    opacity: 0;
    transition: all 0.3s ease;
    border-radius: 8px;
    z-index: 2;
  }
  
  .flow-step-image-container:hover .step-overlay {
    opacity: 1;
  }
  
  .step-tooltip {
    color: white;
    font-weight: 500;
    font-size: 0.9em;
    text-align: center;
    padding: 5px 10px;
    background-color: rgba(0, 0, 0, 0.2);
    border-radius: 6px;
    max-width: 90%;
    pointer-events: none;
  }
  
  .flow-step-title {
    font-size: 1em;
    font-weight: 500;
    color: #333;
    line-height: 1.4;
  }
  
  .flow-arrow-horizontal {
    position: absolute;
    top: 50%;
    right: -22px;
    transform: translateY(-50%);
    z-index: 10;
    color: #3E5C2B;
  }
  
  .flow-arrow-down {
    position: absolute;
    bottom: -22px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 10;
    color: #3E5C2B;
  }
  
  .flow-arrow-horizontal-reverse {
    position: absolute;
    top: 50%;
    right: -22px;
    transform: translateY(-50%);
    z-index: 10;
    color: #3E5C2B;
  }
  
  .flow-arrow-to-step5 {
    position: absolute;
    top: 50%;
    left: -22px;
    transform: translateY(-50%);
    z-index: 10;
    color: #3E5C2B;
    animation: arrow-horizontal-reverse-pulse 1.5s infinite ease-in-out;
  }
  
  @keyframes arrow-horizontal-reverse-pulse {
    0%, 100% { transform: translateY(-50%) translateX(0); }
    50% { transform: translateY(-50%) translateX(-3px); }
  }
  
  .flow-arrow-to-step6 {
    position: absolute;
    top: 50%;
    left: -22px;
    transform: translateY(-50%) rotate(180deg);
    z-index: 10;
    color: #3E5C2B;
  }
  
  .summary-footer {
    text-align: center;
    margin-top: 20px;
    padding-top: 20px;
    border-top: 1px solid #eaeaea;
  }
  
  .summary-buttons {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-top: 20px;
  }
  
  .close-summary-button {
    padding: 12px 24px;
    font-size: 1em;
    font-weight: 600;
    background-color: #3E5C2B;
    color: white;
    border: none;
    border-radius: 12px;
    cursor: pointer;
    transition: all 0.3s ease;
    min-width: 120px;
  }
  
  .close-summary-button:hover {
    background-color: #324a23;
    transform: translateY(-3px);
    box-shadow: 0 6px 15px rgba(62, 92, 43, 0.3);
  }
  
  .feedback-message {
    position: absolute;
    top: 35%; 
    left: 50%;
    transform: translate(-50%, -50%);
    background-color: rgba(255, 255, 255, 0.95);
    padding: 12px 20px; 
    border-radius: 12px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.2);
    color: #e53935;
    font-weight: 500;
    font-size: 1.1em; 
    max-width: 80%;
    text-align: center;
    z-index: 20;
    border-left: 4px solid #e53935;
    transition: all 0.3s ease;
    animation: message-appear 0.5s ease-out forwards;
  }
  
  @keyframes message-appear {
    0% {
      opacity: 0;
      transform: translate(-50%, -40%);
    }
    100% {
      opacity: 1;
      transform: translate(-50%, -50%);
    }
  }
  
  .feedback-message.success {
    color: #3E5C2B;
    border-left: 4px solid #3E5C2B;
    background-color: rgba(241, 248, 233, 0.95);
  }
  
  /* Hands area decorators */
  .hands-display {
    width: 100%;
    height: 100%;
    object-fit: contain;
    transition: all 0.3s ease;
    cursor: pointer;
  }
  
  /* Areas that need emphasis */
  .highlight-zone {
    animation: none;
    border: 2px dashed rgba(62, 92, 43, 0.7);
    background-color: transparent;
    position: relative;
  }
  
  /* Interactive drop areas */
  .drop-zone {
    cursor: pointer;
    border: 2px dashed transparent;
    transition: all 0.3s ease;
    background-color: transparent;
  }
  
  .drop-zone.highlight-zone {
    border: 2px dashed rgba(62, 92, 43, 0.7);
    background-color: transparent;
  }
  
  .drop-zone.droppable-active {
    border-color: #3E5C2B;
    background-color: rgba(62, 92, 43, 0.2);
    box-shadow: 0 0 15px rgba(62, 92, 43, 0.6);
    transform: scale(1.05);
    transition: all 0.2s ease;
  }
  
  /* Water stream and hand washing special styles */
  .hands-under-water::before {
    content: '';
    position: absolute;
    top: -40px;
    left: 50%;
    transform: translateX(-50%);
    width: 80px;
    height: 80px;
    background-image: url('@/assets/washing/water_stream.png');
    background-size: contain;
    background-repeat: no-repeat;
    background-position: center;
    z-index: 1;
    opacity: 0.9;
  }
  
  .soapy-sink {
    position: relative;
  }
  
  .hands-forward {
    transform: translateY(-10px);
    z-index: 5;
  }
  
  .tap-zone {
    border-radius: 12px;
  }
  
  .hands-area-container.highlight-zone {
    border: 2px dashed rgba(62, 92, 43, 0.7);
    background-color: transparent;
    border-radius: 12px;
  }
  
  #wet_hands_zone, #rinse_hands_zone {
    width: 25%; 
    height: 25%; 
    position: absolute;
    bottom: 35%; 
    left: 25%;   
    border-radius: 12px;
    border: 2px dashed rgba(62, 92, 43, 0.7);
    background-color: rgba(62, 92, 43, 0.05); 
    z-index: 5;
  }
  
  @media (max-width: 900px) {
    .scene-area {
      width: 100%;
      max-width: 800px;
      margin: 0 auto 40px auto; 
    }
    
    .right-panel {
      overflow-x: visible; 
    }
    
    .task-hint {
      width: 90%;
      max-width: 700px;
      margin: 0 auto 16px auto;
    }
    
    .summary-flow-grid {
      grid-template-columns: repeat(2, 1fr);
      gap: 25px;
    }
    
    .summary-flow-grid .flow-step-card::after {
      display: none; 
    }
    
    .summary-flow-grid .flow-step-card:nth-child(1)::after,
    .summary-flow-grid .flow-step-card:nth-child(2)::after,
    .summary-flow-grid .flow-step-card:nth-child(3)::after,
    .summary-flow-grid .flow-step-card:nth-child(4)::after,
    .summary-flow-grid .flow-step-card:nth-child(5)::after,
    .summary-flow-grid .flow-step-card:not(:last-child)::after {
      display: none;
      content: none;
    }
    
    .flow-arrow-horizontal, .flow-arrow-down, .flow-arrow-to-step5, .flow-arrow-to-step6, .flow-arrow-horizontal-reverse {
      display: none;
    }
  }
  
  @media (max-width: 600px) {
    .summary-flow-grid {
      grid-template-columns: 1fr;
      gap: 20px; 
    }
    
    .summary-flow-grid .flow-step-card::after,
    .summary-flow-grid .flow-step-card:nth-child(1)::after,
    .summary-flow-grid .flow-step-card:nth-child(2)::after,
    .summary-flow-grid .flow-step-card:nth-child(3)::after,
    .summary-flow-grid .flow-step-card:nth-child(4)::after,
    .summary-flow-grid .flow-step-card:nth-child(5)::after,
    .summary-flow-grid .flow-step-card:not(:last-child)::after {
      display: none !important;
      content: none !important;
    }
    
    .flow-step-card {
      padding: 15px 8px;
      width: 100%;
      max-width: 250px; 
      height: 220px; 
      margin: 0 auto;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
    }
    
    .summary-popup {
      width: 95%;
    }
    
    .summary-header {
      padding: 16px;
      font-size: 1.3em;
    }
    
    .summary-content {
      padding: 20px;
    }
    
    .flow-step-image-container {
      width: 100px;
      height: 100px;
      margin: 10px auto; 
    }
    
    .flow-step-title {
      font-size: 0.9em;
      margin-top: 8px;
      height: 40px; 
      display: flex;
      align-items: center;
      justify-content: center;
    }
    
    .summary-intro p, .summary-footer p {
      font-size: 0.9em;
    }
  }
  
  .success-animation {
    animation: success-pulse 1s ease-in-out;
  }
  
  @keyframes success-pulse {
    0% {
      box-shadow: 0 0 0 0 rgba(62, 92, 43, 0.7);
      transform: scale(1);
    }
    50% {
      box-shadow: 0 0 20px 10px rgba(62, 92, 43, 0.4);
      transform: scale(1.05);
    }
    100% {
      box-shadow: 0 0 0 0 rgba(62, 92, 43, 0);
      transform: scale(1);
    }
  }
  
  .sink-zone.success-animation::after,
  .hands-area-container.success-animation::after {
    content: '';
    position: absolute;
    top: 50%;
    left: 50%;
    width: 5px;
    height: 5px;
    background: rgba(62, 92, 43, 0.7);
    opacity: 0;
    border-radius: 100%;
    transform: scale(1);
    animation: ripple 1s ease-out;
  }
  
  @keyframes ripple {
    0% {
      transform: scale(0);
      opacity: 1;
    }
    100% {
      transform: scale(40);
      opacity: 0;
    }
  }
  
  @keyframes arrow-pulse {
    0% { opacity: 0.6; transform: translateY(-50%) translateX(-3px); }
    50% { opacity: 1; transform: translateY(-50%) translateX(0); }
    100% { opacity: 0.6; transform: translateY(-50%) translateX(-3px); }
  }
  
  @media (hover: none) {
    .item-container:hover {
      transform: none;
      background-color: transparent;
    }
    
    .draggable-item {
      padding: 10px;
    }
    
    .drop-zone {
      border: 2px dashed rgba(62, 92, 43, 0.3);
    }
    
    .highlight-zone {
      border: 2px dashed #3E5C2B;
      background-color: transparent;
    }
  }
  
  .confetti-container {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    pointer-events: none;
    z-index: 100;
  }
  
  .confetti {
    position: absolute;
    width: 8px;
    height: 16px;
    top: -16px;
    animation: confetti-fall 3s linear forwards;
  }
  
  @keyframes confetti-fall {
    0% { 
      transform: translateY(0) rotate(0deg);
      opacity: 1;
    }
    100% { 
      transform: translateY(400px) rotate(720deg);
      opacity: 0;
    }
  }
  
  @keyframes pulse {
    0% { 
      box-shadow: 0 0 0 0 rgba(62, 92, 43, 0.4);
      border-color: rgba(62, 92, 43, 0.7);
    }
    70% { 
      box-shadow: 0 0 0 8px rgba(62, 92, 43, 0);
      border-color: rgba(62, 92, 43, 1);
    }
    100% { 
      box-shadow: 0 0 0 0 rgba(62, 92, 43, 0);
      border-color: rgba(62, 92, 43, 0.7);
    }
  }
  
  @keyframes highlight {
    0% { transform: scale(1); }
    50% { transform: scale(1.05); }
    100% { transform: scale(1); }
  }
  
  @keyframes wiggle {
    0%, 100% { transform: rotate(0deg); }
    25% { transform: rotate(-5deg); }
    75% { transform: rotate(5deg); }
  }
  
  @keyframes bubble-float {
    0%, 100% { transform: translateY(0) scale(1); opacity: 0.7; }
    50% { transform: translateY(-15px) scale(1.2); opacity: 1; }
  }
  
  .highlight-item {
    animation: highlight 2s infinite;
  }
  
  .highlight-item:after {
    content: "";
    display: none;
  }
  
  .pulse-animation {
    animation: pulse 2.5s infinite;
  }
  
  .hands-display.droppable-active {
    border-color: #3E5C2B;
    box-shadow: 0 0 15px #3E5C2B;
    transform: scale(1.05);
  }
  
  .wiggle-animation {
    animation: wiggle 1s ease-in-out infinite;
  }
  
  /* Soap bubbles animation */
  .soap-bubbles {
    position: absolute;
    width: 100%;
    height: 100%;
    pointer-events: none;
  }
  
  .soap-bubbles::before,
  .soap-bubbles::after {
    content: '';
    position: absolute;
    background-color: rgba(255, 255, 255, 0.7);
    border-radius: 50%;
    animation: bubble-float 3s infinite ease-in-out;
  }
  
  .soap-bubbles::before {
    width: 20px;
    height: 20px;
    top: 20%;
    left: 20%;
    animation-delay: 0.5s;
  }
  
  .soap-bubbles::after {
    width: 15px;
    height: 15px;
    top: 30%;
    right: 25%;
    animation-delay: 1s;
  }
  
  /* Summary card styles */
  .summary-card {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 2000;
    background-color: rgba(0, 0, 0, 0.75);
    backdrop-filter: blur(4px);
    transition: all 0.3s ease;
  }
  
  .summary-popup {
    width: 90%;
    max-width: 900px;
    max-height: 90vh;
    background-color: white;
    border-radius: 16px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
    display: flex;
    flex-direction: column;
    overflow: hidden;
    animation: popup-appear 0.4s ease-out forwards;
  }
  
  @keyframes popup-appear {
    0% {
      opacity: 0;
      transform: scale(0.95);
    }
    100% {
      opacity: 1;
      transform: scale(1);
    }
  }
  
  .summary-header {
    display: flex;
    align-items: center;
    padding: 24px;
    background-color: #3E5C2B;
    color: white;
    position: relative;
    font-size: 1.6em;
    font-weight: 600;
  }
  
  .summary-icon {
    margin-right: 15px;
  }
  
  .close-summary-icon {
    position: absolute;
    right: 20px;
    top: 50%;
    transform: translateY(-50%);
    background: none;
    border: none;
    color: white;
    cursor: pointer;
    padding: 5px;
    border-radius: 50%;
    transition: all 0.2s ease;
  }
  
  .close-summary-icon:hover {
    background-color: rgba(255, 255, 255, 0.2);
    transform: translateY(-50%) scale(1.1);
  }
  
  .summary-content {
    padding: 30px;
    overflow-y: auto;
  }
  
  .summary-intro {
    text-align: center;
    margin-bottom: 30px;
    font-size: 1.1em;
    color: #333;
  }
  
  .summary-flow-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    margin: 20px 0 40px;
    position: relative;
  }
  
  .flow-step-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    position: relative;
    background-color: #f9f9f9;
    border-radius: 12px;
    padding: 20px 10px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    border: 1px solid #e0e0e0;
    transition: all 0.3s ease;
    overflow: visible; 
  }
  
  .highlight-zone {
    animation: none;
    border: 2px dashed rgba(62, 92, 43, 0.7);
    background-color: transparent;
    position: relative;
  }
  
  @media (max-width: 400px), (max-height: 600px) {
    .scene-area {
      padding-bottom: 45% !important; 
    }
    
    .task-hint {
      padding: 5px 8px;
      margin-bottom: 5px;
      font-size: 0.9em;
    }
    
    .hint-text {
      font-size: 0.85em;
    }
    
    .hint-icon {
      display: none; 
    }
    
    .draggable-item {
      width: 45px; 
      height: 45px;
      padding: 4px;
    }
    
    .bottom-controls {
      position: relative; 
      bottom: auto;
      margin-top: 5px;
    }
    
    .right-panel {
      padding-bottom: 10px; 
    }
    
    .game-container {
      border-radius: 8px;
    }
    
    @media (orientation: portrait) {
      .game-container {
        flex-direction: column;
      }
      
      .left-panel {
        width: 100%;
        padding: 8px;
      }
      
      .right-panel {
        width: 100%;
        padding: 5px 10px 10px;
      }
    }
  }
  
  .scene-area {
    min-height: 240px; 
  }
  
  .hands-area-container, #wet_hands_zone, #rinse_hands_zone {
    position: absolute;
    min-height: 40px;
    min-width: 40px;
  }
  
  .hands-area-container.droppable-active {
    border-color: #3E5C2B;
    background-color: rgba(62, 92, 43, 0.15);
    box-shadow: 0 0 15px rgba(62, 92, 43, 0.5);
    transform: scale(1.05);
    transition: all 0.2s ease;
  }
  </style>