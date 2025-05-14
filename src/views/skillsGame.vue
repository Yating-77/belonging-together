<template>
  <div class="skills-game-container">
    <MyNavBar />
    
    <main>
      <div v-if="!currentGame">
        <div class="hero-banner">
          <div class="hero-content">
            <h1 class="hero-title">Learn Life Skills Through Play</h1>
            <p class="hero-subtitle">An engaging drag-and-drop game for kids and parents to explore everyday routines—together.</p>
          </div>
        </div>
  
        <div class="game-selection">
          <div class="intro-section">
            <div class="container">
              <h2 class="section-title">How to Play</h2>
              <div class="intro-content">
                <div class="intro-image">
                  <img src="/game.png" alt="Life Skills Game" class="game-preview">
                </div>
                <div class="intro-text">
                  <p>Our interactive life skills games help children learn everyday routines through fun, engaging activities:</p>
                  <ul>
                    <li>Click to pick up items in the first step</li>
                    <li>Drag and drop items in the correct sequence</li>
                    <li>Learn step-by-step processes through play</li>
                    <li>Receive positive reinforcement and celebration</li>
                    <li>Practice essential daily routines in a stress-free environment</li>
                  </ul>
                  <p>Select any game below to begin. Play together with your child for the best experience!</p>
                </div>
              </div>
            </div>
          </div>
  
          <div class="skills-grid-container">
            <h2 class="section-title">Available Skills Games</h2>
            <div class="skills-grid">
              <div class="skill-card" @click="currentGame = 'handwashing'">
                <div class="skill-icon">
                  <span class="icon-animation">🧼</span>
                  <div class="pulse-effect"></div>
                </div>
                <h3>Wash Hands</h3>
                <p>Learn proper hand washing steps</p>
                <button class="play-now-btn" @click.stop="startGame('handwashing')">Play Now</button>
              </div>
  
              <div class="skill-card" @click="currentGame = 'brushing'">
                <div class="skill-icon">
                  <span class="icon-animation">🪥</span>
                  <div class="pulse-effect"></div>
                </div>
                <h3>Brush Teeth</h3>
                <p>Master tooth brushing routine</p>
                <button class="play-now-btn" @click.stop="startGame('brushing')">Play Now</button>
              </div>
  
              <div class="skill-card" @click="currentGame = 'dressing'">
                <div class="skill-icon">
                  <span class="icon-animation">👕</span>
                  <div class="pulse-effect"></div>
                </div>
                <h3>Get Dressed</h3>
                <p>Learn dressing skills step by step</p>
                <button class="play-now-btn" @click.stop="startGame('dressing')">Play Now</button>
              </div>
            </div>
          </div>
        </div>
      </div>
  
      <!-- switch game -->
      <div v-if="currentGame" class="game-component-container">
        <HandWashingGame v-if="currentGame === 'handwashing'" @back="returnToSelection" />
        <BrushingTeethGame v-if="currentGame === 'brushing'" @back="returnToSelection" />
        <DressingGame v-if="currentGame === 'dressing'" @back="returnToSelection" />
      </div>
    </main>
    
    <MyFooter />
  </div>
</template>

<script>
import MyNavBar from '../components/test/MyNavBar.vue';
import MyFooter from '../components/test/MyFooter.vue';
import HandWashingGame from '../components/HandWashingGame.vue';
import BrushingTeethGame from '../components/BrushingTeethGame.vue';
import DressingGame from '../components/DressingGame.vue';
export default {
  name: 'SkillsGame',
  components: {
    MyNavBar,
    MyFooter,
    HandWashingGame,
    BrushingTeethGame,
    DressingGame
  },
  data() {
    return {
      currentGame: null
    }
  },
  methods: {
    returnToSelection() {
      this.currentGame = null;
      this.$nextTick(() => {
        window.scrollTo({ top: 0, behavior: 'smooth' });
      });
    },
    startGame(game) {
      event.stopPropagation();
      this.currentGame = game;
      this.$nextTick(() => {
        window.scrollTo({ top: 0, behavior: 'smooth' });
      });
    }
  }
}
</script>

<style scoped>
.skills-game-container {
  min-height: 100vh;
  background-color: #F8EFED;
  padding-bottom: 0;
  display: flex;
  flex-direction: column;
  margin: 0;
  overflow: visible;
  position: relative;
}

main {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  margin-top: 0;
  position: relative;
  z-index: 1;
}

.hero-banner {
  background-image: url('/000.png');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  height: 400px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  padding: 0;
}

.hero-banner::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
}

.hero-content {
  z-index: 1;
  position: relative;
  text-align: center;
  padding: 20px;
  max-width: 800px;
  margin: 0 auto;
}

.hero-title {
  font-size: 3rem;
  font-weight: bold;
  color: white;
  text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.7);
  margin: 0 0 15px 0;
}

.hero-subtitle {
  font-size: 1.2rem;
  line-height: 1.5;
  color: white;
  text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.5);
  max-width: 700px;
  margin: 0 auto;
}

.game-selection {
  display: flex;
  flex-direction: column;
  flex: 1;
}

.intro-section {
  background-color: white;
  padding: 50px 20px;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
}

.section-title {
  text-align: center;
  margin-bottom: 40px;
  font-size: 2rem;
  color: #4d2f20;
}

.intro-content {
  display: flex;
  gap: 40px;
  align-items: center;
}

.intro-image {
  flex: 1;
  border-radius: 15px;
  overflow: hidden;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

.game-preview {
  width: 100%;
  display: block;
  transition: transform 0.5s;
}

.intro-image:hover .game-preview {
  transform: scale(1.03);
}

.intro-text {
  flex: 1;
  font-size: 1.1rem;
  line-height: 1.7;
  color: #4d2f20;
}

.intro-text ul {
  margin: 20px 0;
  padding-left: 20px;
}

.intro-text li {
  margin-bottom: 10px;
}

.skills-grid-container {
  background-color: #F8EFED;
  padding: 50px 20px;
  margin-top: 30px;
}

.skills-grid {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px 20px;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 30px;
}

.skill-card {
  background: white;
  border-radius: 15px;
  padding: 40px 30px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(0,0,0,0.1);
  position: relative;
  overflow: hidden;
  height: 100%;
  min-height: 280px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.skill-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 12px 25px rgba(0,0,0,0.15);
  background-color: #f0f8ea;
}

.skill-icon {
  font-size: 3rem;
  margin-bottom: 20px;
  position: relative;
  display: inline-block;
}

.icon-animation {
  display: inline-block;
  transition: all 0.3s ease;
}

.skill-card:hover .icon-animation {
  transform: scale(1.2) rotate(5deg);
}

.pulse-effect {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background-color: rgba(62, 92, 43, 0.1);
  z-index: -1;
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0% {
    transform: translate(-50%, -50%) scale(0.8);
    opacity: 0.8;
  }
  70% {
    transform: translate(-50%, -50%) scale(1.5);
    opacity: 0;
  }
  100% {
    transform: translate(-50%, -50%) scale(0.8);
    opacity: 0;
  }
}

.skill-card h3 {
  color: #3E5C2B;
  font-size: 1.5rem;
  margin-bottom: 10px;
  transition: color 0.3s ease;
}

.skill-card p {
  color: #666;
  font-size: 1rem;
  margin-bottom: 20px;
}

.play-now-btn {
  background-color: #3E5C2B;
  color: white;
  border: none;
  padding: 10px 24px;
  font-size: 1rem;
  font-weight: 600;
  border-radius: 30px;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 10px rgba(62, 92, 43, 0.3);
}

.play-now-btn:hover {
  background-color: #4a6e34;
  transform: translateY(-2px);
  box-shadow: 0 6px 15px rgba(62, 92, 43, 0.4);
}

@media (max-width: 768px) {
  .hero-title {
    font-size: 2rem;
  }
  
  .hero-subtitle {
    font-size: 1rem;
  }
  
  .section-title {
    font-size: 1.5rem;
  }
  
  .intro-content {
    flex-direction: column;
  }
  
  .intro-image, .intro-text {
    width: 100%;
  }
  
  .skills-grid {
    grid-template-columns: 1fr;
    padding: 0 15px;
  }
  
  .skill-card {
    padding: 20px;
  }
}

.game-component-container {
  flex: 1;
  min-height: calc(100vh - 120px);
  padding: 20px;
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
}

:deep(footer) {
  margin-top: auto;
  margin-bottom: 0;
  position: relative;
  width: 100%;
  bottom: 0;
}

:deep(.my-navbar) {
  z-index: 9999 !important;
}

:deep(.dropdown-menu) {
  z-index: 9999 !important;
  overflow: visible !important;
}
</style>
