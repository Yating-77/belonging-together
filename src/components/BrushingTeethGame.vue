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
          
          <div v-if="shouldShowItem('toothbrush')" 
               class="item-container"
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'toothbrush' }">
            <img :src="itemImages.toothbrush"
                alt="Toothbrush"
                class="draggable-item"
                draggable="true"
                @dragstart="handleDragStart(items.toothbrush, $event)" />
            <span class="item-label">Toothbrush</span>
          </div>
  
          <div v-if="shouldShowItem('toothpaste')" 
               class="item-container" 
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'toothpaste' }">
            <img :src="itemImages.toothpaste"
                 alt="Toothpaste"
                 class="draggable-item"
                 draggable="true"
                 @dragstart="handleDragStart(items.toothpaste, $event)" />
            <span class="item-label">Toothpaste</span>
          </div>
  
          <div v-if="shouldShowItem('toothbrush_paste')" 
               class="item-container"
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'toothbrush_paste' }">
            <img :src="itemImages.toothbrush_paste"
                 alt="Toothbrush with paste"
                 class="draggable-item"
                 draggable="true"
                 @dragstart="handleDragStart(items.toothbrush_paste, $event)" />
            <span class="item-label">Toothbrush with paste</span>
          </div>
          
          <div v-if="shouldShowItem('toothbrush_foaming')" 
               class="item-container"
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'toothbrush_foaming' }">
            <img :src="itemImages.toothbrush_foaming"
                 alt="Foaming toothbrush"
                 class="draggable-item"
                 draggable="true"
                 @dragstart="handleDragStart(items.toothbrush_foaming, $event)" />
            <span class="item-label">Foaming toothbrush</span>
          </div>
          
          <div v-if="shouldShowItem('cup')" 
               class="item-container"
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'cup' }">
            <img :src="itemImages.cup"
                 alt="Cup"
                 class="draggable-item"
                 draggable="true"
                 @dragstart="handleDragStart(items.cup, $event)" />
            <span class="item-label">Cup</span>
          </div>
  
          <div v-if="shouldShowItem('cup_water')" 
               class="item-container"
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'cup_water' }">
            <img :src="itemImages.cup_water"
                 alt="Cup with water"
                 class="draggable-item"
                 draggable="true"
                 @dragstart="handleDragStart(items.cup_water, $event)" />
            <span class="item-label">Cup with water</span>
          </div>
  
          <div v-if="shouldShowItem('hand_tap')" 
               class="item-container"
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'hand_tap' }">
            <img :src="itemImages.hand"
                 alt="Hand"
                 class="draggable-item"
                 draggable="true"
                 @dragstart="handleDragStart(items.hand_tap, $event)" />
            <span class="item-label">Hand</span>
          </div>
  
          <div v-if="shouldShowItem('mouth_water')" 
               class="item-container"
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'mouth_water' }">
            <img :src="itemImages.mouth_water"
                 alt="Mouth with water"
                 class="draggable-item"
                 draggable="true"
                 @dragstart="handleDragStart(items.mouth_water, $event)" />
            <span class="item-label">Mouth with water</span>
          </div>
  
          <div v-if="shouldShowItem('mouth')" 
               class="item-container"
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'mouth' }">
            <img :src="itemImages.mouth"
                 alt="Mouth"
                 class="draggable-item"
                 draggable="true"
                 @dragstart="handleDragStart(items.mouth, $event)" />
            <span class="item-label">Mouth</span>
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
  
          <div v-if="shouldShowItem('lip')" 
               class="item-container"
               :class="{ 'highlight-item': currentStep.draggableItemRequired === 'lip' }">
            <img :src="itemImages.lip"
                 alt="Lips"
                 class="draggable-item"
                 draggable="true"
                 @dragstart="handleDragStart(items.lip, $event)" />
            <span class="item-label">Mouth</span>
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
            <span v-if="currentStep.id === 'get_toothbrush'">Click on the toothbrush to start</span>
            <span v-if="currentStep.id === 'apply_toothpaste'">Drag the toothpaste onto the toothbrush</span>
            <span v-if="currentStep.id === 'open_tap'">Use your hand to turn on the tap</span>
            <span v-if="currentStep.id === 'wet_toothbrush'">Place the toothbrush under running water</span>
            <span v-if="currentStep.id === 'brush_left_top'">Brush the upper left teeth</span>
            <span v-if="currentStep.id === 'brush_left_bottom'">Brush the lower left teeth</span>
            <span v-if="currentStep.id === 'brush_right_top'">Brush the upper right teeth</span>
            <span v-if="currentStep.id === 'brush_right_bottom'">Brush the lower right teeth</span>
            <span v-if="currentStep.id === 'brush_front_top'">Brush the upper front teeth</span>
            <span v-if="currentStep.id === 'brush_front_bottom'">Brush the lower front teeth</span>
            <span v-if="currentStep.id === 'fill_cup'">Fill the cup with water</span>
            <span v-if="currentStep.id === 'rinse_mouth' && currentStepIndex < 13">Rinse your mouth with water</span>
            <span v-if="currentStep.id === 'spit_water'">Spit the water into the sink</span>
            <span v-if="currentStep.id === 'rinse_toothbrush'">Rinse the foaming toothbrush</span>
            <span v-if="currentStep.id === 'rinse_mouth' && currentStepIndex > 13">Rinse your mouth under running water</span>
            <span v-if="currentStep.id === 'wipe_mouth'">Wipe your lips with the towel</span>
          </div>
        </div>
  
        <div class="scene-area"
             :style="{ backgroundImage: `url(${currentStep.sceneImage})` }"
             @dragover.prevent="handleDragOver"
             @drop="handleDropOnScene"
             ref="sceneArea">
  
          <!-- Toothbrush target area -->
          <div v-if="currentStep.dropTarget === 'toothbrush_area'"
               class="drop-zone toothbrush-zone"
               :style="getToothbrushAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverToothbrush, 
                 'highlight-zone': true,
                 'clickable-zone': currentStep.isClickable
               }"
               @click="currentStep.isClickable && handleClickToothbrush()"
               @dragover.prevent="!currentStep.isClickable && handleDragOverToothbrush"
               @dragleave="!currentStep.isClickable && handleDragLeaveToothbrush"
               @drop.stop="!currentStep.isClickable && handleDropOnTarget('toothbrush_area')">
          </div>
          
          <!-- Mouth target area -->
          <div v-if="currentStep.dropTarget === 'mouth'"
               class="drop-zone mouth-zone"
               :style="getMouthAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverMouth, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverMouth"
               @dragleave="handleDragLeaveMouth"
               @drop.stop="handleDropOnTarget('mouth')">
          </div>
  
          <!-- Upper front teeth area -->
          <div v-if="currentStep.dropTarget === 'front_top_teeth'"
               class="drop-zone teeth-zone"
               :style="getFrontTopTeethAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverFrontTopTeeth, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverFrontTopTeeth"
               @dragleave="handleDragLeaveFrontTopTeeth"
               @drop.stop="handleDropOnTarget('front_top_teeth')">
          </div>
  
          <!-- Lower front teeth area -->
          <div v-if="currentStep.dropTarget === 'front_bottom_teeth'"
               class="drop-zone teeth-zone"
               :style="getFrontBottomTeethAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverFrontBottomTeeth, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverFrontBottomTeeth"
               @dragleave="handleDragLeaveFrontBottomTeeth"
               @drop.stop="handleDropOnTarget('front_bottom_teeth')">
          </div>
  
          <!-- Upper left teeth area -->
          <div v-if="currentStep.dropTarget === 'left_top_teeth'"
               class="drop-zone teeth-zone"
               :style="getLeftTopTeethAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverLeftTopTeeth, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverLeftTopTeeth"
               @dragleave="handleDragLeaveLeftTopTeeth"
               @drop.stop="handleDropOnTarget('left_top_teeth')">
          </div>
  
          <!-- Lower left teeth area -->
          <div v-if="currentStep.dropTarget === 'left_bottom_teeth'"
               class="drop-zone teeth-zone"
               :style="getLeftBottomTeethAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverLeftBottomTeeth, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverLeftBottomTeeth"
               @dragleave="handleDragLeaveLeftBottomTeeth"
               @drop.stop="handleDropOnTarget('left_bottom_teeth')">
          </div>
  
          <!-- Upper right teeth area -->
          <div v-if="currentStep.dropTarget === 'right_top_teeth'"
               class="drop-zone teeth-zone"
               :style="getRightTopTeethAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverRightTopTeeth, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverRightTopTeeth"
               @dragleave="handleDragLeaveRightTopTeeth"
               @drop.stop="handleDropOnTarget('right_top_teeth')">
          </div>
  
          <!-- Lower right teeth area -->
          <div v-if="currentStep.dropTarget === 'right_bottom_teeth'"
               class="drop-zone teeth-zone"
               :style="getRightBottomTeethAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverRightBottomTeeth, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverRightBottomTeeth"
               @dragleave="handleDragLeaveRightBottomTeeth"
               @drop.stop="handleDropOnTarget('right_bottom_teeth')">
          </div>
  
          <!-- Tap area -->
          <div v-if="currentStep.dropTarget === 'tap_area'"
               class="drop-zone tap-zone"
               :style="getTapAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverTap, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverTap"
               @dragleave="handleDragLeaveTap"
               @drop.stop="handleDropOnTarget('tap_area')">
          </div>
  
          <!-- Water flow area -->
          <div v-if="currentStep.dropTarget === 'water_area'"
               class="drop-zone water-zone"
               :style="getWaterAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverWater, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverWater"
               @dragleave="handleDragLeaveWater"
               @drop.stop="handleDropOnTarget('water_area')">
          </div>
  
          <!-- Sink area -->
          <div v-if="currentStep.dropTarget === 'sink_area'"
               class="drop-zone sink-zone"
               :style="getSinkAreaStyle()"
               :class="{ 
                 'droppable-active': isDragOverSink, 
                 'highlight-zone': true
               }"
               @dragover.prevent="handleDragOverSink"
               @dragleave="handleDragLeaveSink"
               @drop.stop="handleDropOnTarget('sink_area')">
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
  
      <!-- Teeth brushing process summary card -->
      <div v-if="showSummaryCard" class="summary-card">
        <div class="summary-popup">
          <div class="summary-header">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="summary-icon">
              <path d="M20.24 12.24a6 6 0 0 0-8.49-8.49L5 10.5V19h8.5l6.74-6.76z"></path>
              <line x1="16" y1="8" x2="2" y2="22"></line>
              <line x1="17.5" y1="15" x2="9" y2="15"></line>
            </svg>
            <span>Toothbrushing Process</span>
            <button @click="closeSummary" class="close-summary-icon">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
              </svg>
            </button>
          </div>
          <div class="summary-content">
            <div class="summary-intro">
              <p>Congratulations on mastering proper tooth brushing! Following these steps can help children with autism maintain good oral hygiene:</p>
            </div>
            <div class="summary-flow-grid">
              <!-- First row - Steps 1, 2, 3 -->
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>1</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="itemImages.toothbrush" alt="Pick up toothbrush" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Pick up toothbrush</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Pick up toothbrush
                </div>
              </div>
              
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>2</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="itemImages.toothpaste" alt="Apply toothpaste" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Apply toothpaste</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Apply toothpaste
                </div>
              </div>
              
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>3</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="sceneImages.water_on" alt="Turn on water" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Turn on water</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Turn on water
                </div>
              </div>
              
              <!-- Row 2 - Steps 4, 5, 6 -->
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>4</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="itemImages.toothbrush_paste" alt="Wet toothbrush" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Wet toothbrush</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Wet toothbrush
                </div>
              </div>
              
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>5</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="itemImages.brush_teeth" alt="Brush upper left teeth" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Brush upper left teeth</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Brush upper left teeth
                </div>
              </div>
              
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>6</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="itemImages.brush_teeth" alt="Brush lower left teeth" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Brush lower left teeth</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Brush lower left teeth
                </div>
              </div>
              
              <!-- Row 3 - Steps 7, 8, 9 -->
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>7</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="itemImages.brush_teeth" alt="Brush upper right teeth" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Brush upper right teeth</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Brush upper right teeth
                </div>
              </div>
  
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>8</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="itemImages.brush_teeth" alt="Brush lower right teeth" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Brush lower right teeth</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Brush lower right teeth
                </div>
              </div>
  
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>9</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="itemImages.brush_teeth" alt="Brush front teeth top" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Brush upper front teeth</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Brush upper front teeth
                </div>
              </div>
              
              <!-- Row 4 - Steps 10, 11, 12 -->
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>10</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="itemImages.brush_teeth" alt="Brush front teeth bottom" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Brush lower front teeth</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Brush lower front teeth
                </div>
              </div>
              
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>11</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="itemImages.cup_water" alt="Rinse mouth" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Fill cup with water</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Fill cup with water
                </div>
              </div>
              
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>12</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="itemImages.mouth_water" alt="Rinse mouth" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Rinse mouth</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Rinse mouth
                </div>
              </div>
              
              <!-- Row 5 - Steps 13, 14, 15 -->
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>13</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="itemImages.spit_water" alt="Spit water" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Spit water</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Spit water
                </div>
              </div>
  
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>14</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="itemImages.toothbrush_foaming" alt="Rinse toothbrush" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Rinse toothbrush</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Rinse toothbrush
                </div>
              </div>
  
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>15</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="itemImages.lip" alt="Rinse mouth again" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Rinse mouth again</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Rinse mouth again
                </div>
              </div>
              
              <!-- Row 6 - Step 16 -->
              <div class="flow-step-card">
                <div class="flow-step-circle">
                  <span>16</span>
                </div>
                <div class="flow-step-image-container">
                  <img :src="itemImages.face" alt="Wipe mouth" class="step-image" />
                  <div class="step-overlay">
                    <div class="step-tooltip">Wipe mouth dry</div>
                  </div>
                </div>
                <div class="flow-step-title">
                  Wipe mouth dry
                </div>
              </div>
            </div>
            <div class="summary-footer">
              <p>Regular tooth brushing helps prevent cavities and creates consistent daily routines for children with autism!</p>
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
  
  // --- Resource paths ---
  const sceneImages = {
    start: new URL('@/assets/brushing/scene_start.png', import.meta.url).href,
    with_toothbrush: new URL('@/assets/brushing/toothbrush.png', import.meta.url).href,
    with_paste: new URL('@/assets/brushing/toothpaste_toothbrush.png', import.meta.url).href,
    brushing: new URL('@/assets/brushing/mouth_foaming.png', import.meta.url).href,
    foaming: new URL('@/assets/brushing/mouth_foaming.png', import.meta.url).href,
    rinsing: new URL('@/assets/brushing/mouth.png', import.meta.url).href,
    water_on: new URL('@/assets/brushing/scene_water_on.png', import.meta.url).href,
  };
  
  const mouthImages = {
    neutral: new URL('@/assets/brushing/mouth.png', import.meta.url).href,
    foaming: new URL('@/assets/brushing/mouth_foaming.png', import.meta.url).href,
    rinsed: new URL('@/assets/brushing/mouth.png', import.meta.url).href,
  };
  
  const itemImages = {
    toothbrush: new URL('@/assets/brushing/toothbrush.png', import.meta.url).href,
    toothpaste: new URL('@/assets/brushing/toothpaste.png', import.meta.url).href,
    toothbrush_paste: new URL('@/assets/brushing/toothpaste_toothbrush.png', import.meta.url).href,
    toothbrush_foaming: new URL('@/assets/brushing/toothbrush_foaming.png', import.meta.url).href,
    cup: new URL('@/assets/brushing/cup.png', import.meta.url).href,
    cup_water: new URL('@/assets/brushing/cup_water.png', import.meta.url).href,
    towel: new URL('@/assets/brushing/towel.png', import.meta.url).href,
    hand: new URL('@/assets/brushing/hand_tap.png', import.meta.url).href,
    head: new URL('@/assets/brushing/head.png', import.meta.url).href,
    mouth_water: new URL('@/assets/brushing/mouth_water.png', import.meta.url).href,
    mouth: new URL('@/assets/brushing/mouth.png', import.meta.url).href,
    lip: new URL('@/assets/brushing/lip.png', import.meta.url).href,
    face: new URL('@/assets/brushing/face.png', import.meta.url).href,
    brush_teeth: new URL('@/assets/brushing/brush_teeth.png', import.meta.url).href,
    spit_water: new URL('@/assets/brushing/spit_water.png', import.meta.url).href,
  };
  
  // --- Game state definition ---
  const gameSteps = ref([
    {
      id: 'get_toothbrush',
      instruction: 'Step 1: Click on the toothbrush to start',
      sceneImage: sceneImages.start,
      draggableItemRequired: null,
      dropTarget: 'toothbrush_area', 
      nextMouthImage: mouthImages.neutral,
      nextSceneImage: sceneImages.with_toothbrush,
      successMessage: 'Great! You got the toothbrush!',
      completed: false,
      isClickable: true,
    },
    {
      id: 'apply_toothpaste',
      instruction: 'Step 2: Apply toothpaste to the toothbrush',
      sceneImage: sceneImages.with_toothbrush,
      draggableItemRequired: 'toothpaste',
      dropTarget: 'toothbrush_area',
      nextMouthImage: mouthImages.neutral,
      nextSceneImage: sceneImages.with_paste,
      successMessage: 'Well done! The toothpaste is on the toothbrush.',
      completed: false,
    },
    {
      id: 'open_tap',
      instruction: 'Step 3: Use your hand to turn on the tap',
      sceneImage: sceneImages.start,
      draggableItemRequired: 'hand_tap',
      dropTarget: 'tap_area',
      nextMouthImage: mouthImages.neutral,
      nextSceneImage: sceneImages.water_on,
      successMessage: 'Great! The water is now running.',
      completed: false,
    },
    {
      id: 'wet_toothbrush',
      instruction: 'Step 4: Place the toothbrush under running water',
      sceneImage: sceneImages.water_on,
      draggableItemRequired: 'toothbrush_paste',
      dropTarget: 'water_area',
      nextMouthImage: mouthImages.neutral,
      nextSceneImage: mouthImages.neutral,
      successMessage: 'Good job! The toothbrush is now wet.',
      completed: false,
    },
    {
      id: 'brush_left_top',
      instruction: 'Step 5: Brush the upper left teeth',
      sceneImage: mouthImages.neutral,
      draggableItemRequired: 'toothbrush_paste',
      dropTarget: 'left_top_teeth',
      nextMouthImage: mouthImages.foaming,
      nextSceneImage: sceneImages.brushing,
      successMessage: 'Excellent! The upper left teeth are clean.',
      completed: false,
      showMouthImage: true,
    },
    {
      id: 'brush_left_bottom',
      instruction: 'Step 6: Brush the lower left teeth',
      sceneImage: sceneImages.brushing,
      draggableItemRequired: 'toothbrush_foaming',
      dropTarget: 'left_bottom_teeth',
      nextMouthImage: mouthImages.foaming,
      nextSceneImage: sceneImages.brushing,
      successMessage: 'Well done! The lower left teeth are clean too.',
      completed: false,
      showMouthImage: true,
    },
    {
      id: 'brush_right_top',
      instruction: 'Step 7: Brush the upper right teeth',
      sceneImage: sceneImages.brushing,
      draggableItemRequired: 'toothbrush_foaming',
      dropTarget: 'right_top_teeth',
      nextMouthImage: mouthImages.foaming,
      nextSceneImage: sceneImages.brushing,
      successMessage: 'Great! The upper right teeth are clean.',
      completed: false,
      showMouthImage: true,
    },
    {
      id: 'brush_right_bottom',
      instruction: 'Step 8: Brush the lower right teeth',
      sceneImage: sceneImages.brushing,
      draggableItemRequired: 'toothbrush_foaming',
      dropTarget: 'right_bottom_teeth',
      nextMouthImage: mouthImages.foaming,
      nextSceneImage: sceneImages.foaming,
      successMessage: 'Good job! All the back teeth are clean now.',
      completed: false,
      showMouthImage: true,
    },
    {
      id: 'brush_front_top',
      instruction: 'Step 9: Brush the upper front teeth',
      sceneImage: sceneImages.foaming,
      draggableItemRequired: 'toothbrush_foaming',
      dropTarget: 'front_top_teeth',
      nextMouthImage: mouthImages.foaming,
      nextSceneImage: sceneImages.brushing,
      successMessage: 'Great! Keep brushing.',
      completed: false,
      showMouthImage: true,
    },
    {
      id: 'brush_front_bottom',
      instruction: 'Step 10: Brush the lower front teeth',
      sceneImage: sceneImages.brushing,
      draggableItemRequired: 'toothbrush_foaming',
      dropTarget: 'front_bottom_teeth',
      nextMouthImage: mouthImages.foaming,
      nextSceneImage: sceneImages.brushing,
      successMessage: 'Well done! The front teeth are clean too.',
      completed: false,
      showMouthImage: true,
    },
    {
      id: 'fill_cup',
      instruction: 'Step 11: Fill the cup with water',
      sceneImage: sceneImages.water_on,
      draggableItemRequired: 'cup',
      dropTarget: 'water_area',
      nextMouthImage: mouthImages.foaming,
      nextSceneImage: sceneImages.water_on,
      successMessage: 'Great! The cup is filled with water. Now rinse your mouth.',
      completed: false,
    },
    {
      id: 'rinse_mouth',
      instruction: 'Step 12: Rinse your mouth with water',
      sceneImage: mouthImages.foaming,
      draggableItemRequired: 'cup_water',
      dropTarget: 'mouth',
      nextMouthImage: mouthImages.rinsed,
      nextSceneImage: mouthImages.rinsed,
      successMessage: 'Good rinsing! Your mouth is cleaner now.',
      completed: false,
      showMouthImage: true,
    },
    {
      id: 'spit_water',
      instruction: 'Step 13: Spit the water into the sink',
      sceneImage: sceneImages.start,
      draggableItemRequired: 'mouth_water',
      dropTarget: 'sink_area',
      nextMouthImage: mouthImages.neutral,
      nextSceneImage: sceneImages.start,
      successMessage: 'Well done!',
      completed: false,
    },
    {
      id: 'rinse_toothbrush',
      instruction: 'Step 14: Rinse the foamy toothbrush',
      sceneImage: sceneImages.water_on,
      draggableItemRequired: 'toothbrush_foaming',
      dropTarget: 'water_area',
      nextMouthImage: mouthImages.neutral,
      nextSceneImage: sceneImages.water_on,
      successMessage: 'Great! The toothbrush is clean now.',
      completed: false,
    },
    {
      id: 'rinse_mouth',
      instruction: 'Step 15: Rinse your mouth under running water',
      sceneImage: sceneImages.water_on,
      draggableItemRequired: 'lip',
      dropTarget: 'water_area',
      nextMouthImage: mouthImages.neutral,
      nextSceneImage: itemImages.lip,
      successMessage: 'Good job! Your mouth is rinsed clean.',
      completed: false,
    },
    {
      id: 'wipe_mouth',
      instruction: 'Step 16: Wipe your lips with a towel',
      sceneImage: itemImages.face, // Using the new face image
      draggableItemRequired: 'towel',
      dropTarget: 'mouth',
      nextMouthImage: mouthImages.neutral,
      nextSceneImage: mouthImages.neutral,
      successMessage: 'All done! Your teeth and lips are clean now!',
      completed: false,
      showMouthImage: true,
    },
  ]);
  
  const items = ref({
    toothbrush: { id: 'toothbrush', image: itemImages.toothbrush, used: false, name: 'Toothbrush' },
    toothpaste: { id: 'toothpaste', image: itemImages.toothpaste, used: false, name: 'Toothpaste' },
    toothbrush_paste: { id: 'toothbrush_paste', image: itemImages.toothbrush_paste, used: false, name: 'Toothbrush with paste' },
    toothbrush_foaming: { id: 'toothbrush_foaming', image: itemImages.toothbrush_foaming, used: false, name: 'Foaming toothbrush' },
    cup: { id: 'cup', image: itemImages.cup, used: false, name: 'Cup' },
    cup_water: { id: 'cup_water', image: itemImages.cup_water, used: false, name: 'Cup with water' },
    towel: { id: 'towel', image: itemImages.towel, used: false, name: 'Towel' },
    hand_tap: { id: 'hand_tap', image: itemImages.hand, used: false, name: 'Hand' },
    head: { id: 'head', image: itemImages.head, used: false, name: 'Head' },
    mouth_water: { id: 'mouth_water', image: itemImages.mouth_water, used: false, name: 'Mouth with water' },
    mouth: { id: 'mouth', image: itemImages.mouth, used: false, name: 'Mouth' },
    lip: { id: 'lip', image: itemImages.lip, used: false, name: 'Mouth' }
  });
  
  // --- Reactive states ---
  const currentStepIndex = ref(0);
  const mouthImage = ref(mouthImages.neutral);
  const feedbackMessage = ref('');
  const isSuccess = ref(false);
  const draggedItem = ref(null);
  const sceneArea = ref(null); // Scene area reference
  
  // Scene scaling response
  const sceneScale = ref(1);
  const sceneWidth = ref(0);
  const sceneHeight = ref(0);
  
  const isDragOverToothbrush = ref(false);
  const isDragOverMouth = ref(false);
  const isDragOverFrontTopTeeth = ref(false);
  const isDragOverFrontBottomTeeth = ref(false);
  const isDragOverLeftTopTeeth = ref(false);
  const isDragOverLeftBottomTeeth = ref(false);
  const isDragOverRightTopTeeth = ref(false);
  const isDragOverRightBottomTeeth = ref(false);
  const isDragOverTap = ref(false);
  const isDragOverWater = ref(false);
  const isDragOverSink = ref(false);
  const showGuidance = ref(true);
  const showSummaryCard = ref(false);
  
  // Monitor window size changes
  function updateSceneDimensions() {
    if (sceneArea.value) {
      const rect = sceneArea.value.getBoundingClientRect();
      sceneWidth.value = rect.width;
      sceneHeight.value = rect.height;
      // Calculate scene scaling ratio (relative to max width 800px)
      sceneScale.value = rect.width / 800;
      console.log(`Scene scale: ${sceneScale.value}, width: ${sceneWidth.value}, height: ${sceneHeight.value}`);
    }
  }
  
  // --- Computed properties ---
  const currentStep = computed(() => gameSteps.value[currentStepIndex.value] || gameSteps.value[gameSteps.value.length-1]);
  const allStepsCompleted = computed(() => gameSteps.value.every(step => step.completed));
  
  // --- Lifecycle hooks ---
  onMounted(() => {
    if (gameSteps.value.length > 0) {
      mouthImage.value = mouthImages.neutral;
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
  
  // --- Methods ---
  function shouldShowItem(itemId) {
    const item = items.value[itemId];
    if (!item) return false;
  
    // Show specific items based on current step
    const currentStepId = currentStep.value.id;
    
    // step 1: show the toothbrush and the interference items
    if (currentStepId === 'get_toothbrush') {
      return itemId === 'toothbrush' || itemId === 'cup' || itemId === 'towel';
    }
    
    // step 2: apply the toothpaste, show the correct item(toothpaste) and the interference items(cup and hand)
    if (currentStepId === 'apply_toothpaste') {
      return itemId === 'toothpaste' || itemId === 'cup' || itemId === 'hand_tap';
    }
    
    // step 3: open the tap, show the correct item(hand) and the interference items(toothpaste and cup)
    if (currentStepId === 'open_tap') {
      return itemId === 'hand_tap' || itemId === 'toothpaste' || itemId === 'cup' || itemId === 'toothbrush_paste';
    }
    
    // step 4: wet the toothbrush, show the correct item(toothbrush_paste) and the interference items(hand and cup)
    if (currentStepId === 'wet_toothbrush') {
      return itemId === 'toothbrush_paste' || itemId === 'hand_tap' || itemId === 'cup';
    }
    
    // step 5: brush the left top teeth, show the correct item(toothbrush_paste) and the interference items(cup and towel)
    if (currentStepId === 'brush_left_top') {
      return itemId === 'toothbrush_paste' || itemId === 'cup' || itemId === 'towel';
    }
    
    // step 6-10: brush the left bottom, right top, right bottom, front top and front bottom teeth, show the correct item(toothbrush_foaming) and the interference items(cup and towel)
    if (['brush_left_bottom', 'brush_right_top', 'brush_right_bottom', 
         'brush_front_top', 'brush_front_bottom'].includes(currentStepId)) {
      return itemId === 'toothbrush_foaming' || itemId === 'cup' || itemId === 'towel';
    }
    
    // step 11: fill the cup with water, show the correct item(cup) and the interference items(toothbrush_foaming and mouth)
    if (currentStepId === 'fill_cup') {
      return itemId === 'cup' || itemId === 'toothbrush_foaming' || itemId === 'mouth';
    }
    
    // step 12 and 15: rinse the mouth, show the correct item and the interference items
    if (currentStepId === 'rinse_mouth') {
      // step 12 - rinse the mouth with the cup
      if (currentStepIndex.value === 11) {
        return itemId === 'cup_water' || itemId === 'towel' || itemId === 'lip';
      }
      // step 15 - rinse the mouth with the water
      if (currentStepIndex.value === 14) {
        return itemId === 'lip' || itemId === 'cup' || itemId === 'toothbrush_foaming';
      }
    }
    
    // step 13: spit the water, show the correct item(mouth_water) and the interference items(hand and cup)
    if (currentStepId === 'spit_water') {
      return itemId === 'mouth_water' || itemId === 'hand_tap' || itemId === 'cup_water';
    }
    
    // step 14: rinse the toothbrush, show the correct item(toothbrush_foaming) and the interference items(cup and hand)
    if (currentStepId === 'rinse_toothbrush') {
      return itemId === 'toothbrush_foaming' || itemId === 'cup' || itemId === 'hand_tap';
    }
    
    // step 16: wipe the mouth, show the correct item(towel) and the interference items(toothbrush and hand)
    if (currentStepId === 'wipe_mouth') {
      return itemId === 'towel' || itemId === 'toothbrush' || itemId === 'hand_tap';
    }
    
    // ensure the item required for the current step is displayed (in case the above conditions are not covered)
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
  
  function handleDragOverToothbrush(event) {
    if (currentStep.value.dropTarget === 'toothbrush_area' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverToothbrush.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveToothbrush() {
    isDragOverToothbrush.value = false;
  }
  
  function handleDragOverMouth(event) {
    if (currentStep.value.dropTarget === 'mouth' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverMouth.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveMouth() {
    isDragOverMouth.value = false;
  }
  
  function handleDropOnTarget(targetId) {
    // Reset all drag states
    isDragOverToothbrush.value = false;
    isDragOverMouth.value = false;
    isDragOverFrontTopTeeth.value = false;
    isDragOverFrontBottomTeeth.value = false;
    isDragOverLeftTopTeeth.value = false;
    isDragOverLeftBottomTeeth.value = false;
    isDragOverRightTopTeeth.value = false;
    isDragOverRightBottomTeeth.value = false;
    isDragOverTap.value = false;
    isDragOverWater.value = false;
    isDragOverSink.value = false;
  
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
    
    // Update mouth image
    mouthImage.value = step.nextMouthImage;
  
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
        feedbackMessage.value = 'Congratulations! You completed all the tooth brushing steps! Your teeth are very clean!';
        isSuccess.value = true;
      }
    }, 1500);
  }
  
  // Add success animation effect
  function addSuccessAnimation(targetId) {
    // Add different animation effects based on target area
    if (targetId === 'toothbrush_area') {
      // Toothbrush area animation effect - flashing effect
      const toothbrushZone = document.querySelector('.toothbrush-zone');
      if (toothbrushZone) {
        toothbrushZone.classList.add('success-animation');
        setTimeout(() => {
          toothbrushZone.classList.remove('success-animation');
        }, 1000);
      }
    } else if (targetId === 'mouth') {
      // Mouth area - ripple effect
      const mouthZone = document.querySelector('.mouth-zone');
      
      if (mouthZone) {
        mouthZone.classList.add('success-animation');
        setTimeout(() => {
          mouthZone.classList.remove('success-animation');
        }, 1000);
      }
    }
  }
  
  // If dropped on empty scene area
  function handleDropOnScene() {
    isDragOverToothbrush.value = false;
    isDragOverMouth.value = false;
    if (draggedItem.value) {
      feedbackMessage.value = 'Please drag the item to the correct position.';
      isSuccess.value = false;
      setTimeout(() => { feedbackMessage.value = ''; }, 2000);
    }
    draggedItem.value = null;
  }
  
  function resetGame() {
    currentStepIndex.value = 0;
    mouthImage.value = mouthImages.neutral;
    feedbackMessage.value = '';
    isSuccess.value = false;
    gameSteps.value.forEach(step => step.completed = false);
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
      // Update mouth image
      mouthImage.value = gameSteps.value[index].nextMouthImage || mouthImages.neutral;
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
      // Update mouth image
      if (gameSteps.value[currentStepIndex.value].completed) {
        mouthImage.value = gameSteps.value[currentStepIndex.value].nextMouthImage || mouthImages.neutral;
      } else {
        // If step is not completed, use default or previous step image
        mouthImage.value = currentStepIndex.value > 0 && gameSteps.value[currentStepIndex.value - 1].completed ? 
          gameSteps.value[currentStepIndex.value - 1].nextMouthImage : mouthImages.neutral;
      }
      
      // Show feedback message indicating current step
      feedbackMessage.value = `Please ${gameSteps.value[currentStepIndex.value].instruction.toLowerCase().replace('step ' + (currentStepIndex.value+1) + ': ', '')}`;
      isSuccess.value = true;
      // Clear feedback message after 2 seconds
      setTimeout(() => {
        feedbackMessage.value = '';
      }, 2000);
    }
  }
  
  // Calculate toothbrush area position style
  function getToothbrushAreaStyle() {
    // Return different toothbrush area positions based on current step
    if (currentStep.value.id === 'get_toothbrush') {
      // Step 1: Click toothbrush area
      return {
        position: 'absolute',
        bottom: '48%',
        left: '52%',
        width: '15%',
        height: '30%',
        zIndex: 2
      };
    } else if (currentStep.value.id === 'apply_toothpaste') {
      // Step 2: Drag toothpaste onto toothbrush area
      return {
        position: 'absolute',
        top: '45%',
        left: '30%',
        width: '15%',
        height: '20%',
        zIndex: 2
      };
    } else {
      // Default position for other steps
      return {
        position: 'absolute',
        bottom: '48%',
        left: '52%',
        width: '15%',
        height: '30%',
        zIndex: 2
      };
    }
  }
  
  // Calculate mouth area position style
  function getMouthAreaStyle() {
    // set a different position for the last wipe mouth step
    if (currentStep.value.id === 'wipe_mouth') {
      return {
        position: 'absolute',
        top: '60%',
        left: '50%',
        transform: 'translateX(-50%)',
        width: '30%',
        height: '25%',
        zIndex: 2
      };
    }
    
    // other steps use the original position
    return {
      position: 'absolute',
      top: '45%',
      left: '50%',
      transform: 'translateX(-50%)',
      width: '20%',
      height: '20%',
      zIndex: 2
    };
  }
  
  // Calculate upper front teeth area style
  function getFrontTopTeethAreaStyle() {
    return {
      position: 'absolute',
      top: '30%',
      left: '50%',
      transform: 'translateX(-50%)',
      width: '15%',
      height: '10%',
      zIndex: 2
    };
  }
  
  // Calculate lower front teeth area style
  function getFrontBottomTeethAreaStyle() {
    return {
      position: 'absolute',
      top: '60%',
      left: '50%',
      transform: 'translateX(-50%)',
      width: '15%',
      height: '10%',
      zIndex: 2
    };
  }
  
  // Calculate upper left teeth area style
  function getLeftTopTeethAreaStyle() {
    return {
      position: 'absolute',
      top: '30%',
      left: '30%',
      width: '15%',
      height: '10%',
      zIndex: 2
    };
  }
  
  // Calculate lower left teeth area style
  function getLeftBottomTeethAreaStyle() {
    return {
      position: 'absolute',
      top: '50%',
      left: '30%',
      width: '15%',
      height: '10%',
      zIndex: 2
    };
  }
  
  // Calculate upper right teeth area style
  function getRightTopTeethAreaStyle() {
    return {
      position: 'absolute',
      top: '30%',
      left: '60%',
      width: '15%',
      height: '10%',
      zIndex: 2
    };
  }
  
  // Calculate lower right teeth area style
  function getRightBottomTeethAreaStyle() {
    return {
      position: 'absolute',
      top: '50%',
      left: '60%',
      width: '15%',
      height: '10%',
      zIndex: 2
    };
  }
  
  // Calculate tap area style
  function getTapAreaStyle() {
    return {
      position: 'absolute',
      top: '25%',
      right: '45%',
      width: '15%',
      height: '15%',
      zIndex: 2
    };
  }
  
  // Calculate water flow area style
  function getWaterAreaStyle() {
    return {
      position: 'absolute',
      top: '30%',
      right: '60%',
      width: '15%',
      height: '20%',
      zIndex: 2
    };
  }
  
  // Calculate sink area style
  function getSinkAreaStyle() {
    return {
      position: 'absolute',
      bottom: '30%',
      left: '40%',
      transform: 'translateX(-50%)',
      width: '20%',
      height: '20%',
      zIndex: 2
    };
  }
  
  // Get image for each step
  function getStepImage(step) {
    switch(step.id) {
      case 'get_toothbrush':
        return itemImages.toothbrush;
      case 'apply_toothpaste':
        return itemImages.toothpaste;
      case 'open_tap':
        return sceneImages.water_on;
      case 'wet_toothbrush':
        return itemImages.toothbrush_paste;
      case 'brush_left_top':
      case 'brush_left_bottom':
      case 'brush_right_top':
      case 'brush_right_bottom':
      case 'brush_front_top':
      case 'brush_front_bottom':
        return itemImages.brush_teeth;
      case 'fill_cup':
        return itemImages.cup;
      case 'rinse_mouth':
        return itemImages.mouth_water;
      case 'spit_water':
        return itemImages.spit_water;
      case 'rinse_toothbrush':
        return itemImages.toothbrush_foaming;
      case 'wipe_mouth':
        return itemImages.towel;
      default:
        return '';
    }
  }
  
  // Show tooth brushing process summary
  function showSummary() {
    showSummaryCard.value = true;
  }
  
  // Close summary card
  function closeSummary() {
    showSummaryCard.value = false;
  }
  
  // Upper front teeth drag handling
  function handleDragOverFrontTopTeeth(event) {
    if (currentStep.value.dropTarget === 'front_top_teeth' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverFrontTopTeeth.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveFrontTopTeeth() {
    isDragOverFrontTopTeeth.value = false;
  }
  
  // Lower front teeth drag handling
  function handleDragOverFrontBottomTeeth(event) {
    if (currentStep.value.dropTarget === 'front_bottom_teeth' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverFrontBottomTeeth.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveFrontBottomTeeth() {
    isDragOverFrontBottomTeeth.value = false;
  }
  
  // Upper left teeth drag handling
  function handleDragOverLeftTopTeeth(event) {
    if (currentStep.value.dropTarget === 'left_top_teeth' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverLeftTopTeeth.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveLeftTopTeeth() {
    isDragOverLeftTopTeeth.value = false;
  }
  
  // Lower left teeth drag handling
  function handleDragOverLeftBottomTeeth(event) {
    if (currentStep.value.dropTarget === 'left_bottom_teeth' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverLeftBottomTeeth.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveLeftBottomTeeth() {
    isDragOverLeftBottomTeeth.value = false;
  }
  
  // Upper right teeth drag handling
  function handleDragOverRightTopTeeth(event) {
    if (currentStep.value.dropTarget === 'right_top_teeth' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverRightTopTeeth.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveRightTopTeeth() {
    isDragOverRightTopTeeth.value = false;
  }
  
  // Lower right teeth drag handling
  function handleDragOverRightBottomTeeth(event) {
    if (currentStep.value.dropTarget === 'right_bottom_teeth' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverRightBottomTeeth.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveRightBottomTeeth() {
    isDragOverRightBottomTeeth.value = false;
  }
  
  // Tap area drag handling
  function handleDragOverTap(event) {
    if (currentStep.value.dropTarget === 'tap_area' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverTap.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveTap() {
    isDragOverTap.value = false;
  }
  
  // Water flow area drag handling
  function handleDragOverWater(event) {
    if (currentStep.value.dropTarget === 'water_area' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverWater.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveWater() {
    isDragOverWater.value = false;
  }
  
  // Sink area drag handling
  function handleDragOverSink(event) {
    if (currentStep.value.dropTarget === 'sink_area' && draggedItem.value?.id === currentStep.value.draggableItemRequired) {
      isDragOverSink.value = true;
      event.dataTransfer.dropEffect = 'move';
    } else {
      event.dataTransfer.dropEffect = 'none';
    }
  }
  
  function handleDragLeaveSink() {
    isDragOverSink.value = false;
  }
  
  function handleClickToothbrush() {
    // Handle clicking on toothbrush logic
    if (currentStep.value.id === 'get_toothbrush' && currentStep.value.isClickable) {
      completeStep('toothbrush_area');
    }
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
  
  /* Step indicator */
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
  
  /* Responsive design enhancements */
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
  
  /* Ripple effect */
  .mouth-zone.success-animation::after,
  .toothbrush-zone.success-animation::after {
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
  
  /* Confetti animation effect */
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
  
  /* Highlight items */
  .highlight-item {
    animation: highlight 2s infinite;
  }
  
  @keyframes highlight {
    0% { transform: scale(1); }
    50% { transform: scale(1.05); }
    100% { transform: scale(1); }
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
  
  .scene-area {
    min-height: 240px;
  }
  
  .toothbrush-zone, .mouth-zone {
    position: absolute;
    min-height: 40px;
    min-width: 40px;
  }
  
  .drop-zone.clickable-zone {
    cursor: pointer;
    animation: pulse-zone 2s infinite;
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
  
  .step-image {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
    display: block;
    z-index: 1;
  }
  </style>
  