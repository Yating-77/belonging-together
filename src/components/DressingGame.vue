<template>
    <div class="game-container">
      <!-- Left information panel -->
      <div class="left-panel">
        <!-- Exit button container -->
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
          
          <div v-if="shouldShowItem('shirt')" 
               class="item-container"
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'shirt' }">
            <img :src="itemImages.shirt"
                alt="Shirt"
                class="draggable-item"
                draggable="true"
                @dragstart="handleDragStart(items.shirt, $event)" />
            <span class="item-label">Shirt</span>
          </div>
  
          <div v-if="shouldShowItem('pants')" 
               class="item-container" 
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'pants' }">
            <img :src="itemImages.pants"
                 alt="Pants"
                 class="draggable-item"
                 draggable="true"
                 @dragstart="handleDragStart(items.pants, $event)" />
            <span class="item-label">Pants</span>
          </div>
  
          <div v-if="shouldShowItem('sock')" 
               class="item-container"
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'sock' }">
            <img :src="itemImages.sock"
                 alt="Socks"
                 class="draggable-item"
                 draggable="true"
                 @dragstart="handleDragStart(items.sock, $event)" />
            <span class="item-label">Socks</span>
          </div>
          
          <div v-if="shouldShowItem('shoes')" 
               class="item-container"
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'shoes' }">
            <img :src="itemImages.shoes"
                 alt="Shoes"
                 class="draggable-item"
                 draggable="true"
                 @dragstart="handleDragStart(items.shoes, $event)" />
            <span class="item-label">Shoes</span>
          </div>
        </div>
      </div>
  
      <!-- Right scene area -->
      <div class="right-panel">
        <!-- Task hint -->
        <div class="task-hint">
          <div class="hint-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="12" r="10"></circle>
              <line x1="12" y1="16" x2="12" y2="12"></line>
              <line x1="12" y1="8" x2="12.01" y2="8"></line>
            </svg>
          </div>
          <div class="hint-text">
            <span v-if="currentStep.id === 'get_shirt'">Click on the shirt to start</span>
            <span v-if="currentStep.id === 'put_on_shirt'">Drag the shirt to dress the child: first over the head, then left arm, then right arm</span>
            <span v-if="currentStep.id === 'put_on_pants'">Drag the pants to dress the child: first left leg, then right leg</span>
            <span v-if="currentStep.id === 'put_on_left_sock'">Drag a sock onto the left foot</span>
            <span v-if="currentStep.id === 'put_on_right_sock'">Drag a sock onto the right foot</span>
            <span v-if="currentStep.id === 'put_on_left_shoe'">Drag a shoe onto the left foot</span>
            <span v-if="currentStep.id === 'put_on_right_shoe'">Drag a shoe onto the right foot</span>
          </div>
        </div>
  
        <div class="scene-area"
             :style="{ backgroundImage: `url(${currentStep.sceneImage})` }"
             @dragover.prevent="handleDragOver"
             @drop="handleDropOnScene"
             ref="sceneArea">
          
          <!-- Shirt target area -->
          <div v-if="currentStep.dropTarget === 'shirt_area'"
               class="drop-zone shirt-zone"
               :style="getShirtAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverShirt, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverShirt"
               @dragleave="handleDragLeaveShirt"
               @drop.stop="handleDropOnTarget('shirt_area')">
          </div>
          
          <!-- Clothing target area -->
          <div v-if="currentStep.dropTarget === 'clothing_area'"
               class="drop-zone clothing-zone"
               :style="getClothingAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverClothing, 
                 'highlight-zone': true,
                 'clickable-zone': currentStep.isClickable
               }"
               @click="currentStep.isClickable && handleClickClothing()"
               @dragover.prevent="!currentStep.isClickable && handleDragOverClothing"
               @dragleave="!currentStep.isClickable && handleDragLeaveClothing"
               @drop.stop="!currentStep.isClickable && handleDropOnTarget('clothing_area')">
          </div>
          
          <!-- Pants target area -->
          <div v-if="currentStep.dropTarget === 'pants_area'"
               class="drop-zone pants-zone"
               :style="getPantsAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverPants, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverPants"
               @dragleave="handleDragLeavePants"
               @drop.stop="handleDropOnTarget('pants_area')">
          </div>
  
          <!-- Left sock target area -->
          <div v-if="currentStep.dropTarget === 'left_sock_area'"
               class="drop-zone sock-zone"
               :style="getLeftSockAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverLeftSock, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverLeftSock"
               @dragleave="handleDragLeaveLeftSock"
               @drop.stop="handleDropOnTarget('left_sock_area')">
          </div>
  
          <!-- Right sock target area -->
          <div v-if="currentStep.dropTarget === 'right_sock_area'"
               class="drop-zone sock-zone"
               :style="getRightSockAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverRightSock, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverRightSock"
               @dragleave="handleDragLeaveRightSock"
               @drop.stop="handleDropOnTarget('right_sock_area')">
          </div>
  
          <!-- Left shoe target area -->
          <div v-if="currentStep.dropTarget === 'left_shoe_area'"
               class="drop-zone shoe-zone"
               :style="getLeftShoeAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverLeftShoe, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverLeftShoe"
               @dragleave="handleDragLeaveLeftShoe"
               @drop.stop="handleDropOnTarget('left_shoe_area')">
          </div>
  
          <!-- Right shoe target area -->
          <div v-if="currentStep.dropTarget === 'right_shoe_area'"
               class="drop-zone shoe-zone"
               :style="getRightShoeAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverRightShoe, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverRightShoe"
               @dragleave="handleDragLeaveRightShoe"
               @drop.stop="handleDropOnTarget('right_shoe_area')">
          </div>
        </div>
  
        <!-- Success message display -->
        <div v-if="feedbackMessage" 
             class="feedback-message" 
             :class="{ 'success': isSuccess }">
          {{ feedbackMessage }}
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
            Start Over
          </button>
          <button @click="showSummary" class="summary-button">
            View Summary
          </button>
        </div>
      </div>
  
      <!-- Summary card -->
      <div v-if="showSummaryCard" class="summary-card">
        <div class="summary-popup">
          <div class="summary-header">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="summary-icon">
              <path d="M20.24 12.24a6 6 0 0 0-8.49-8.49L5 10.5V19h8.5l6.74-6.76z"></path>
              <line x1="16" y1="8" x2="2" y2="22"></line>
              <line x1="17.5" y1="15" x2="9" y2="15"></line>
            </svg>
            <span>Dressing Process</span>
            <button @click="closeSummary" class="close-summary-icon">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
              </svg>
            </button>
          </div>
          <div class="summary-content">
            <div class="summary-intro">
              <p>Congratulations on mastering dressing skills! Following these steps can help children with autism develop independence:</p>
            </div>
            <div class="summary-flow-grid">
              <!-- First row - Steps 1, 2, 3 -->
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>1</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="itemImages.shirt" alt="Get shirt" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Pick up shirt</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Pick up shirt
                </div>
              </div>
              
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>2</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="sceneImages.with_shirt" alt="Put on shirt" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Put on shirt: first over the head, then left arm, then right arm</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Put on shirt: head → left arm → right arm
                </div>
              </div>
              
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>3</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="sceneImages.with_pants" alt="Put on pants" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Put on pants: first left leg, then right leg</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Put on pants: left leg → right leg
                </div>
              </div>
              
              <!-- Row 2 - Steps 4, 5, 6, 7 -->
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>4</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="sceneImages.with_left_sock" alt="Put on left sock" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Put on left sock</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Put on left sock
                </div>
              </div>
              
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>5</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="sceneImages.with_socks" alt="Put on right sock" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Put on right sock</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Put on right sock
                </div>
              </div>
              
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>6</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="sceneImages.with_left_shoe" alt="Put on left shoe" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Put on left shoe</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Put on left shoe
                </div>
              </div>
              
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>7</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="sceneImages.with_shoes" alt="Put on right shoe" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Put on right shoe</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Put on right shoe
                </div>
              </div>
            </div>
            <div class="summary-footer">
              <p>Learning to get dressed independently helps build confidence and daily life skills for children with autism!</p>
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
  import { ref, computed, onMounted, watch, onUnmounted } from 'vue';
  
  // Resource paths
  const sceneImages = {
    start: new URL('@/assets/dressing/scene_start.png', import.meta.url).href,
    start_child: new URL('@/assets/dressing/scene_start_child.png', import.meta.url).href,
    with_shirt: new URL('@/assets/dressing/child_with_shirt.png', import.meta.url).href,
    with_pants: new URL('@/assets/dressing/child_with_pants.png', import.meta.url).href,
    with_left_sock: new URL('@/assets/dressing/child_with_left_sock.png', import.meta.url).href,
    with_socks: new URL('@/assets/dressing/child_with_socks.png', import.meta.url).href,
    with_left_shoe: new URL('@/assets/dressing/child_with_left_shoe.png', import.meta.url).href,
    with_shoes: new URL('@/assets/dressing/child_with_shoes.png', import.meta.url).href,
  };
  
  const itemImages = {
    shirt: new URL('@/assets/dressing/shirt.png', import.meta.url).href,
    pants: new URL('@/assets/dressing/pants.png', import.meta.url).href,
    sock: new URL('@/assets/dressing/sock.png', import.meta.url).href,
    shoes: new URL('@/assets/dressing/shoes.png', import.meta.url).href,
  };
  
  // Game state definition
  const gameSteps = ref([
    {
      id: 'get_shirt',
      instruction: 'Step 1: Click on the shirt to start dressing',
      sceneImage: sceneImages.start,
      draggableItemRequired: null,
      dropTarget: 'clothing_area', 
      nextSceneImage: sceneImages.start_child,
      successMessage: 'Great! You got the shirt!',
      completed: false,
      isClickable: true,
    },
    {
      id: 'put_on_shirt',
      instruction: 'Step 2: Put the shirt on the child',
      sceneImage: sceneImages.start_child,
      draggableItemRequired: 'shirt',
      dropTarget: 'shirt_area',
      nextSceneImage: sceneImages.with_shirt,
      successMessage: 'Well done! The shirt is on - head, left arm, and right arm!',
      completed: false,
    },
    {
      id: 'put_on_pants',
      instruction: 'Step 3: Put on pants: first left leg, then right leg',
      sceneImage: sceneImages.with_shirt,
      draggableItemRequired: 'pants',
      dropTarget: 'pants_area',
      nextSceneImage: sceneImages.with_pants,
      successMessage: 'Great! The pants are on - left leg, then right leg!',
      completed: false,
    },
    {
      id: 'put_on_left_sock',
      instruction: 'Step 4: Put a sock on the left foot',
      sceneImage: sceneImages.with_pants,
      draggableItemRequired: 'sock',
      dropTarget: 'left_sock_area',
      nextSceneImage: sceneImages.with_left_sock,
      successMessage: 'Good job! Left sock is on.',
      completed: false,
    },
    {
      id: 'put_on_right_sock',
      instruction: 'Step 5: Put a sock on the right foot',
      sceneImage: sceneImages.with_left_sock,
      draggableItemRequired: 'sock',
      dropTarget: 'right_sock_area',
      nextSceneImage: sceneImages.with_socks,
      successMessage: 'Excellent! Both socks are on.',
      completed: false,
    },
    {
      id: 'put_on_left_shoe',
      instruction: 'Step 6: Put a shoe on the left foot',
      sceneImage: sceneImages.with_socks,
      draggableItemRequired: 'shoes',
      dropTarget: 'left_shoe_area',
      nextSceneImage: sceneImages.with_left_shoe,
      successMessage: 'Well done! Left shoe is on.',
      completed: false,
    },
    {
      id: 'put_on_right_shoe',
      instruction: 'Step 7: Put a shoe on the right foot',
      sceneImage: sceneImages.with_left_shoe,
      draggableItemRequired: 'shoes',
      dropTarget: 'right_shoe_area',
      nextSceneImage: sceneImages.with_shoes,
      successMessage: 'All done! The child is fully dressed now!',
      completed: false,
    },
  ]);
  
  const items = ref({
    shirt: { id: 'shirt', image: itemImages.shirt, used: false, name: 'Shirt' },
    pants: { id: 'pants', image: itemImages.pants, used: false, name: 'Pants' },
    sock: { id: 'sock', image: itemImages.sock, used: false, name: 'Sock' },
    shoes: { id: 'shoes', image: itemImages.shoes, used: false, name: 'Shoes' }
  });
  
  // Reactive states
  const currentStepIndex = ref(0);
  const feedbackMessage = ref('');
  const isSuccess = ref(false);
  const draggedItem = ref(null);
  const sceneArea = ref(null);
  
  // Drop zone states
  const isDragOverClothing = ref(false);
  const isDragOverShirt = ref(false);
  const isDragOverPants = ref(false);
  const isDragOverLeftSock = ref(false);
  const isDragOverRightSock = ref(false);
  const isDragOverLeftShoe = ref(false);
  const isDragOverRightShoe = ref(false);
  const showGuidance = ref(true);
  const showSummaryCard = ref(false);
  
  // Scene scaling
  const sceneScale = ref(1);
  const sceneWidth = ref(0);
  const sceneHeight = ref(0);
  
  // Monitor window size changes
  function updateSceneDimensions() {
    if (sceneArea.value) {
      const rect = sceneArea.value.getBoundingClientRect();
      sceneWidth.value = rect.width;
      sceneHeight.value = rect.height;
      sceneScale.value = rect.width / 800;
    }
  }
  
  // Computed properties
  const currentStep = computed(() => gameSteps.value[currentStepIndex.value] || gameSteps.value[0]);
  const allStepsCompleted = computed(() => gameSteps.value.every(step => step.completed));
  
  // Lifecycle hooks
  onMounted(() => {
    if (gameSteps.value.length > 0) {
      // Initialize
    }
    
    // Initialize scene dimensions
    setTimeout(updateSceneDimensions, 100);
    
    // Monitor window size changes
    window.addEventListener('resize', updateSceneDimensions);
    
    // Periodically show guidance
    setInterval(() => {
      if (!allStepsCompleted.value) {
        showGuidance.value = true;
        setTimeout(() => {
          showGuidance.value = false;
        }, 2000);
      }
    }, 5000);
  });
  
  // Clean up listeners
  onUnmounted(() => {
    window.removeEventListener('resize', updateSceneDimensions);
  });
  
  // Monitor current step changes, add guidance animation
  watch(currentStepIndex, () => {
    showGuidance.value = true;
    setTimeout(() => {
      showGuidance.value = false;
    }, 3000);
  });
  
  // Methods
  function shouldShowItem(itemId) {
    const item = items.value[itemId];
    if (!item) return false;
  
    // Show specific items based on current step
    const currentStepId = currentStep.value.id;
    
    // Step 1: Show shirt
    if (currentStepId === 'get_shirt') {
      return itemId === 'shirt';
    }
    
    // Step 2: Put on shirt
    if (currentStepId === 'put_on_shirt') {
      return itemId === 'shirt';
    }
    
    // Step 3: Put on pants
    if (currentStepId === 'put_on_pants') {
      return itemId === 'pants' || itemId === 'sock';
    }
    
    // Step 4-5: Put on socks
    if (currentStepId === 'put_on_left_sock' || currentStepId === 'put_on_right_sock') {
      return itemId === 'sock' || itemId === 'shoes';
    }
    
    // Step 6-7: Put on shoes
    if (currentStepId === 'put_on_left_shoe' || currentStepId === 'put_on_right_shoe') {
      return itemId === 'shoes';
    }
    
    // Ensure the required item for the current step is shown
    if (itemId === currentStep.value.draggableItemRequired) {
      return true;
    }
    
    return false;
  }
  
  function handleDragStart(item, event) {
    draggedItem.value = item;
    event.dataTransfer.effectAllowed = 'move';
    event.dataTransfer.setData('text/plain', item.id);
    feedbackMessage.value = '';
  }
  
  function handleDragOver(event) {
    // Allow dropping
  }
  
  function handleDragOverClothing(event) {
    if (currentStep.value.dropTarget === 'clothing_area' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverClothing.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveClothing() {
    isDragOverClothing.value = false;
  }
  
  function handleDragOverShirt(event) {
    if (currentStep.value.dropTarget === 'shirt_area' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverShirt.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveShirt() {
    isDragOverShirt.value = false;
  }
  
  function handleDragOverPants(event) {
    if (currentStep.value.dropTarget === 'pants_area' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverPants.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeavePants() {
    isDragOverPants.value = false;
  }
  
  function handleDragOverLeftSock(event) {
    if (currentStep.value.dropTarget === 'left_sock_area' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverLeftSock.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveLeftSock() {
    isDragOverLeftSock.value = false;
  }
  
  function handleDragOverRightSock(event) {
    if (currentStep.value.dropTarget === 'right_sock_area' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverRightSock.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveRightSock() {
    isDragOverRightSock.value = false;
  }
  
  function handleDragOverLeftShoe(event) {
    if (currentStep.value.dropTarget === 'left_shoe_area' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverLeftShoe.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveLeftShoe() {
    isDragOverLeftShoe.value = false;
  }
  
  function handleDragOverRightShoe(event) {
    if (currentStep.value.dropTarget === 'right_shoe_area' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverRightShoe.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveRightShoe() {
    isDragOverRightShoe.value = false;
  }
  
  function handleClickClothing() {
    // Handle clicking on clothing logic
    if (currentStep.value.id === 'get_shirt' && currentStep.value.isClickable) {
      completeStep('clothing_area');
    }
  }
  
  function handleDropOnTarget(targetId) {
    // Reset all drag states
    isDragOverClothing.value = false;
    isDragOverPants.value = false;
    isDragOverLeftSock.value = false;
    isDragOverRightSock.value = false;
    isDragOverLeftShoe.value = false;
    isDragOverRightShoe.value = false;
  
    if (!draggedItem.value) return;
  
    const step = currentStep.value;
    if (draggedItem.value.id === step.draggableItemRequired && targetId === step.dropTarget) {
      completeStep(targetId);
    } else {
      // Incorrect action
      feedbackMessage.value = 'Try a different action. Check the hint for help.';
      isSuccess.value = false;
      setTimeout(() => { feedbackMessage.value = ''; }, 2000);
    }
    draggedItem.value = null;
  }
  
  function completeStep(targetId) {
    const step = currentStep.value;
    
    // Mark step as completed
    step.completed = true;
  
    // Show success message
    feedbackMessage.value = step.successMessage;
    isSuccess.value = true;
  
    // Add success animation effect
    addSuccessAnimation(targetId);
  
    // Delay moving to next step
    setTimeout(() => {
      if (currentStepIndex.value < gameSteps.value.length - 1) {
        currentStepIndex.value++;
        feedbackMessage.value = '';
      } else if (allStepsCompleted.value) {
        // update the scene image to the fully dressed image
        step.sceneImage = sceneImages.with_shoes;
        feedbackMessage.value = 'Congratulations! The child is fully dressed!';
        isSuccess.value = true;
      }
    }, 1500);
  }
  
  // Add success animation effect
  function addSuccessAnimation(targetId) {
    // Add different animation effects based on target area
    if (targetId === 'clothing_area') {
      // Clothing area animation effect
      const clothingZone = document.querySelector('.clothing-zone');
      if (clothingZone) {
        clothingZone.classList.add('success-animation');
        setTimeout(() => {
          clothingZone.classList.remove('success-animation');
        }, 1000);
      }
    } else if (targetId === 'pants_area') {
      // Pants area animation effect
      const pantsZone = document.querySelector('.pants-zone');
      if (pantsZone) {
        pantsZone.classList.add('success-animation');
        setTimeout(() => {
          pantsZone.classList.remove('success-animation');
        }, 1000);
      }
    }
  }
  
  // If dropped on empty scene area
  function handleDropOnScene() {
    isDragOverClothing.value = false;
    isDragOverShirt.value = false;
    isDragOverPants.value = false;
    if (draggedItem.value) {
      feedbackMessage.value = 'Please drag the item to the correct position.';
      isSuccess.value = false;
      setTimeout(() => { feedbackMessage.value = ''; }, 2000);
    }
    draggedItem.value = null;
  }
  
  function resetGame() {
    currentStepIndex.value = 0;
    feedbackMessage.value = '';
    isSuccess.value = false;
    gameSteps.value.forEach(step => {
      step.completed = false;
      // reset the scene image for the last step
      if (step.id === 'put_on_right_shoe') {
        step.sceneImage = sceneImages.with_socks;
      }
    });
  }
  
  // Confetti style generation function
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
    // Directly notify parent component to return to skill game selection
    emit('back');
  }
  
  // Ensure emit event is declared
  const emit = defineEmits(['back']);
  
  // Step navigation function
  function goToStep(index) {
    // Can only navigate to completed steps or steps before current step
    if (gameSteps.value[index].completed || index <= currentStepIndex.value) {
      currentStepIndex.value = index;
      // Show feedback message indicating current step
      feedbackMessage.value = `Please ${gameSteps.value[index].instruction.toLowerCase().replace('step ' + (index+1) + ': ', '')}`;
      isSuccess.value = true;
      // Clear feedback message after 2 seconds
      setTimeout(() => {
        feedbackMessage.value = '';
      }, 2000);
    }
  }
  
  // Previous step function
  function goToPreviousStep() {
    if (currentStepIndex.value > 0) {
      currentStepIndex.value--;
      // Show feedback message indicating current step
      feedbackMessage.value = `Please ${gameSteps.value[currentStepIndex.value].instruction.toLowerCase().replace('step ' + (currentStepIndex.value+1) + ': ', '')}`;
      isSuccess.value = true;
      // Clear feedback message after 2 seconds
      setTimeout(() => {
        feedbackMessage.value = '';
      }, 2000);
    }
  }
  
  // Show dressing process summary
  function showSummary() {
    showSummaryCard.value = true;
  }
  
  // Calculate clothing area position style
  function getClothingAreaStyle() {
    return {
      position: 'absolute',
      top: '40%',
      left: '42%',
      transform: 'translateX(-50%)',
      width: '20%',
      height: '20%',
      zIndex: 2
    };
  }
  
  // Calculate shirt area position style 
  function getShirtAreaStyle() {
    return {
      position: 'absolute',
      top: '40%',
      left: '50%',
      transform: 'translateX(-50%)',
      width: '25%',
      height: '25%',
      zIndex: 2
    };
  }
  
  // Calculate pants area position style
  function getPantsAreaStyle() {
    return {
      position: 'absolute',
      top: '50%',
      left: '50%',
      transform: 'translateX(-50%)',
      width: '30%',
      height: '30%',
      zIndex: 2
    };
  }
  
  // Calculate left sock area position style
  function getLeftSockAreaStyle() {
    return {
      position: 'absolute',
      bottom: '13%',
      left: '40%',
      width: '10%',
      height: '15%',
      zIndex: 2
    };
  }
  
  // Calculate right sock area position style
  function getRightSockAreaStyle() {
    return {
      position: 'absolute',
      bottom: '9%',
      right: '42%',
      width: '10%',
      height: '15%',
      zIndex: 2
    };
  }
  
  // Calculate left shoe area position style
  function getLeftShoeAreaStyle() {
    return {
      position: 'absolute',
      bottom: '10%',
      left: '40%',
      width: '10%',
      height: '15%',
      zIndex: 2
    };
  }
  
  // Calculate right shoe area position style
  function getRightShoeAreaStyle() {
    return {
      position: 'absolute',
      bottom: '9%',
      right: '40%',
      width: '10%',
      height: '15%',
      zIndex: 2
    };
  }
  
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
  
  /* Exit button container */
  .exit-button-wrapper {
    width: 100%;
    margin-bottom: 15px;
  }
  
  /* Exit button style */
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
    z-index: 2; /* Ensure z-index is lower than nav bar */
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
    padding: 15px;
    display: flex;
    flex-direction: column;
    background-color: #fff;
    border-right: 1px solid #e0e0e0;
    height: auto;
    min-height: 650px; /* Increase minimum height */
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
  
  /* Success message styling */
  .feedback-message {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background-color: rgba(255, 255, 255, 0.95);
    padding: 15px 25px;
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
  
  .feedback-message.success {
    color: #3E5C2B;
    border-left: 4px solid #3E5C2B;
    background-color: rgba(241, 248, 233, 0.95);
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
    font-size: 1.2em;
    color: #333;
    margin-bottom: 10px;
    text-align: left;
    padding-bottom: 8px;
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
    transform-origin: top left;
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
    max-height: 500px;
    overflow-y: auto;
  }
  
  .palette-title {
    width: 100%;
    font-weight: 600;
    color: #3E5C2B;
    text-align: center;
    padding-bottom: 6px;
    margin-bottom: 6px;
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
    padding: 6px;
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
    width: 60px;
    height: 60px;
    cursor: grab;
    border: 1px solid #e0e0e0;
    border-radius: 10px;
    transition: all 0.3s ease;
    background-color: white;
    padding: 4px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
  }
  
  .item-label {
    margin-top: 4px;
    font-size: 0.8em;
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
      flex-direction: row;
      width: 98%;
      height: auto;
      min-height: 100vh;
      padding: 0;
    }
    
    .left-panel {
      width: 35%;
      height: auto;
      min-height: auto;
      padding: 10px;
      order: 0;
    }
    
    .right-panel {
      width: 65%;
      height: auto;
      min-height: auto;
      padding: 10px;
      order: 1;
      position: relative;
    }
    
    .items-palette {
      padding: 8px;
      gap: 5px;
      max-height: none;
    }
    
    .item-container {
      width: 30%;
      padding: 4px;
      margin: 2px;
    }
    
    .draggable-item {
      width: 50px;
      height: 50px;
    }
    
    .scene-area {
      padding-bottom: 75%;
    }
  }
  
  @media (max-width: 576px) {
    .game-container {
      flex-direction: column;
    }
    
    .left-panel, .right-panel {
      width: 100%;
    }
    
    .items-palette {
      max-height: 200px;
    }
    
    .item-container {
      width: 30%;
    }
    
    .draggable-item {
      width: 45px;
      height: 45px;
    }
  }
  
  .highlight-zone {
    animation: none;
    border: 2px dashed rgba(62, 92, 43, 0.7);
    background-color: transparent;
    position: absolute;
  }
  
  .drop-zone {
    position: absolute;
    border: 2px dashed transparent;
    border-radius: 12px;
    transition: all 0.3s ease;
    box-sizing: border-box;
    cursor: pointer;
  }
  
  .highlight-zone {
    border: 2px dashed rgba(113, 179, 60, 0.4);
    animation: pulse-zone 2s infinite;
  }
  
  @keyframes pulse-zone {
    0% {
      border-color: rgba(113, 179, 60, 0.2);
      box-shadow: 0 0 0 1px rgba(113, 179, 60, 0.1);
    }
    50% {
      border-color: rgba(113, 179, 60, 0.6);
      box-shadow: 0 0 0 3px rgba(113, 179, 60, 0.3);
    }
    100% {
      border-color: rgba(113, 179, 60, 0.2);
      box-shadow: 0 0 0 1px rgba(113, 179, 60, 0.1);
    }
  }
  
  .scene-area .drop-zone {
    transform-origin: top left;
    will-change: transform, width, height;
    pointer-events: auto;
  }
  
  .clickable-zone:hover {
    background-color: rgba(113, 179, 60, 0.1);
    border-color: rgba(113, 179, 60, 0.8);
    cursor: pointer;
  }
  
  .droppable-active {
    background-color: rgba(113, 179, 60, 0.1);
    border-color: rgba(113, 179, 60, 0.8) !important;
    box-shadow: 0 0 10px rgba(113, 179, 60, 0.3);
  }
  
  .success-animation {
    animation: success-pulse 1s;
  }
  
  @keyframes success-pulse {
    0% {
      box-shadow: 0 0 0 0 rgba(113, 179, 60, 0.7);
    }
    70% {
      box-shadow: 0 0 0 20px rgba(113, 179, 60, 0);
    }
    100% {
      box-shadow: 0 0 0 0 rgba(113, 179, 60, 0);
    }
  }
  
  .clothing-zone.success-animation::after,
  .pants-zone.success-animation::after {
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
  
  .highlight-item {
    animation: highlight 2s infinite;
  }
  
  @keyframes highlight {
    0% { transform: scale(1); }
    50% { transform: scale(1.05); }
    100% { transform: scale(1); }
  }
  
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
  
  @media (max-width: 768px) {
    .summary-flow-grid {
      grid-template-columns: repeat(2, 1fr);
    }
  }
  
  @media (max-width: 480px) {
    .summary-flow-grid {
      grid-template-columns: 1fr;
    }
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
  
  .flow-step-title {
    font-size: 1em;
    font-weight: 500;
    color: #333;
    line-height: 1.4;
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
    font-size: 1em;
    font-weight: 500;
    text-align: center;
    padding: 0 10px;
    max-width: 100%;
  }
  
  .step-image {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
    display: block;
    z-index: 1;
  }
  </style>
  