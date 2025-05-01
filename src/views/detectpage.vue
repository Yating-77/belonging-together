<template>
  <!-- Main container with THEMED background -->
  <div class="outside-scene-page">

    <MyNavBar />

    <!-- ===== NEW: Intro Section ===== -->
    <div class="hero-banner">
      <div class="hero-image-container">
        <img
          src="/detect-image.png"
          alt="Illustration for preparing for outings"
          class="hero-image"
        />
      </div>
      <div class="hero-text-overlay">
        <div class="container text-center">
          <h1 class="main-title">Prepare for a Successful Outing</h1>
          <p class="main-subtitle">
            Help your child feel confident and calm before exploring outdoor places and activities.
            Discover different environments and what you can bring to support them.
          </p>
        </div>
      </div>
    </div>
    <!-- ===== End Intro Section ===== -->


    <!-- ===== 改为左右布局的场景选择部分 ===== -->
    <div class="scene-selection-section">
      <div class="container">
        <div class="row">
          <!-- 左侧文字说明 -->
          <div class="col-md-5" data-aos="fade-right" data-aos-duration="800">
            <div class="intro-text-container">
              <h2 class="intro-title">Prepare for a Successful Outing</h2>
              <p class="intro-description">
                We've created guides for several common scenarios that might be challenging for children with sensory sensitivities. Choose a scene to get tailored tips and sensory-friendly checklists.
              </p>
            </div>
          </div>
          
          <!-- 右侧场景卡片 -->
          <div class="col-md-7" data-aos="fade-left" data-aos-duration="800">
            <h3 class="scene-selection-heading">Choose a Scene:</h3>
            <div class="scene-cards-grid">
              <div 
                v-for="scene in frontendScenes" 
                :key="scene.id" 
                class="scene-card" 
                :class="{ 'active': selectedSceneId === scene.id }"
                @click="selectScene(scene.id)"
              >
                <div class="scene-card-icon">
                  <img 
                    :src="getSceneIcon(scene.id)" 
                    :alt="scene.name + ' icon'"
                    class="scene-icon-image"
                  >
                </div>
                <div class="scene-card-content">
                  <h4 class="scene-card-title">{{ scene.name }}</h4>
                  <p class="scene-card-description">{{ scene.subtitle }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
          </div>

    <!-- ===== Sensory Expectations Section ===== -->
    <div v-if="selectedSceneId && !isLoading && sensoryExpectations.length > 0" class="sensory-expectations-section">
      <div class="container">
        <div class="expectations-header text-center">
          <h3>What Your Child Might Sense in {{ selectedSceneDetails?.name || 'this Environment' }}</h3>
          <p class="expectations-subtitle">{{ selectedSceneDetails?.subtitle }}</p>
        </div>
        
        <!-- 左右布局容器 -->
        <div class="sensory-content-container">
          <!-- 左侧图片 -->
          <div class="sensory-image-container" :class="'scene-bg-' + selectedSceneId">
            <!-- 这里可以添加特定的场景图片 -->
          </div>
          
          <!-- 右侧卡片列表 -->
          <div class="sensory-cards-container">
            <div 
              v-for="(item, index) in sensoryExpectations" 
              :key="item.id"
              class="sensory-card"
            >
              <div class="sensory-card-icon">
                <span class="sensory-icon">{{ getIconForCategory(item.category) }}</span>
        </div>
              <div class="sensory-card-content">
                <h4 class="sensory-category text-capitalize">{{ item.category }}</h4>
                <p class="sensory-description">{{ item.description }}</p>
                
                <!-- 添加声音播放按钮,只在听觉卡片中显示，并根据场景ID显示不同的音频 -->
                <div v-if="item.category.toLowerCase() === 'hearing'" class="audio-controls mt-3">
                  <!-- 医疗场景音频 -->
                  <template v-if="selectedSceneId === 1">
                    <!-- 蜂鸣声播放器 -->
                    <div class="audio-player-container">
                      <div class="audio-player">
                        <button 
                          class="audio-play-button"
                          :class="{ 'playing': activeSoundId === 'buzzing' }"
                          @click="playSound('buzzing')"
                          aria-label="Play or pause buzzing sounds"
                        >
                          <span class="play-icon" v-if="activeSoundId !== 'buzzing'"></span>
                          <span class="pause-icon" v-else></span>
                        </button>
                        
                        <div class="audio-info">
                          <div class="audio-title">Buzzing Sounds</div>
                          <div class="audio-timeline">
                            <span class="current-time">{{ formatTime(audioCurrentTimes.buzzing || 0) }}</span>
                            <div class="progress-bar-container" @click="setAudioProgress('buzzing', $event)">
                              <div class="progress-bar-bg"></div>
                              <div class="progress-bar" :style="{ width: `${audioProgress.buzzing || 0}%` }"></div>
                            </div>
                            <span class="duration">{{ formatTime(audioDurations.buzzing || 0) }}</span>
                          </div>
                        </div>
                      </div>
        </div>
        
                    <!-- 人声播放器 -->
                    <div class="audio-player-container">
                      <div class="audio-player">
                        <button 
                          class="audio-play-button"
                          :class="{ 'playing': activeSoundId === 'people-talking' }"
                          @click="playSound('people-talking')"
                          aria-label="Play or pause people talking sounds"
                        >
                          <span class="play-icon" v-if="activeSoundId !== 'people-talking'"></span>
                          <span class="pause-icon" v-else></span>
                        </button>
                        
                        <div class="audio-info">
                          <div class="audio-title">People Talking</div>
                          <div class="audio-timeline">
                            <span class="current-time">{{ formatTime(audioCurrentTimes['people-talking'] || 0) }}</span>
                            <div class="progress-bar-container" @click="setAudioProgress('people-talking', $event)">
                              <div class="progress-bar-bg"></div>
                              <div class="progress-bar" :style="{ width: `${audioProgress['people-talking'] || 0}%` }"></div>
        </div>
                            <span class="duration">{{ formatTime(audioDurations['people-talking'] || 0) }}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </template>
                  
                  <!-- 机场场景音频 -->
                  <template v-if="selectedSceneId === 2">
                    <!-- 机场广播播放器 -->
                    <div class="audio-player-container">
                      <div class="audio-player">
                        <button 
                          class="audio-play-button"
                          :class="{ 'playing': activeSoundId === 'airport-announcement' }"
                          @click="playSound('airport-announcement')"
                          aria-label="Play or pause airport announcement sounds"
                        >
                          <span class="play-icon" v-if="activeSoundId !== 'airport-announcement'"></span>
                          <span class="pause-icon" v-else></span>
                        </button>
                        
                        <div class="audio-info">
                          <div class="audio-title">Airport Announcements</div>
                          <div class="audio-timeline">
                            <span class="current-time">{{ formatTime(audioCurrentTimes['airport-announcement'] || 0) }}</span>
                            <div class="progress-bar-container" @click="setAudioProgress('airport-announcement', $event)">
                              <div class="progress-bar-bg"></div>
                              <div class="progress-bar" :style="{ width: `${audioProgress['airport-announcement'] || 0}%` }"></div>
                            </div>
                            <span class="duration">{{ formatTime(audioDurations['airport-announcement'] || 0) }}</span>
                       </div>
                     </div>
                </div>
        </div>
        
                    <!-- 登机呼叫播放器 -->
                    <div class="audio-player-container">
                      <div class="audio-player">
                        <button 
                          class="audio-play-button"
                          :class="{ 'playing': activeSoundId === 'airport-call' }"
                          @click="playSound('airport-call')"
                          aria-label="Play or pause boarding call sounds"
                        >
                          <span class="play-icon" v-if="activeSoundId !== 'airport-call'"></span>
                          <span class="pause-icon" v-else></span>
              </button>
                        
                        <div class="audio-info">
                          <div class="audio-title">Boarding Call</div>
                          <div class="audio-timeline">
                            <span class="current-time">{{ formatTime(audioCurrentTimes['airport-call'] || 0) }}</span>
                            <div class="progress-bar-container" @click="setAudioProgress('airport-call', $event)">
                              <div class="progress-bar-bg"></div>
                              <div class="progress-bar" :style="{ width: `${audioProgress['airport-call'] || 0}%` }"></div>
        </div>
                            <span class="duration">{{ formatTime(audioDurations['airport-call'] || 0) }}</span>
      </div>
                        </div>
                      </div>
                    </div>
                  </template>

                  <!-- 休闲娱乐场景音频 -->
                  <template v-if="selectedSceneId === 3">
                    <!-- 孩子们玩耍的声音播放器 -->
                    <div class="audio-player-container">
                      <div class="audio-player">
                        <button 
                          class="audio-play-button"
                          :class="{ 'playing': activeSoundId === 'kids-playing' }"
                          @click="playSound('kids-playing')"
                          aria-label="Play or pause children playing sounds"
                        >
                          <span class="play-icon" v-if="activeSoundId !== 'kids-playing'"></span>
                          <span class="pause-icon" v-else></span>
                        </button>
                        
                        <div class="audio-info">
                          <div class="audio-title">Children Playing</div>
                          <div class="audio-timeline">
                            <span class="current-time">{{ formatTime(audioCurrentTimes['kids-playing'] || 0) }}</span>
                            <div class="progress-bar-container" @click="setAudioProgress('kids-playing', $event)">
                              <div class="progress-bar-bg"></div>
                              <div class="progress-bar" :style="{ width: `${audioProgress['kids-playing'] || 0}%` }"></div>
      </div>
                            <span class="duration">{{ formatTime(audioDurations['kids-playing'] || 0) }}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                    
                    <!-- 电影声音播放器 -->
                    <div class="audio-player-container">
                      <div class="audio-player">
                        <button 
                          class="audio-play-button"
                          :class="{ 'playing': activeSoundId === 'movie' }"
                          @click="playSound('movie')"
                          aria-label="Play or pause movie theater sounds"
                        >
                          <span class="play-icon" v-if="activeSoundId !== 'movie'"></span>
                          <span class="pause-icon" v-else></span>
                        </button>
                        
                        <div class="audio-info">
                          <div class="audio-title">Movie Theater Sounds</div>
                          <div class="audio-timeline">
                            <span class="current-time">{{ formatTime(audioCurrentTimes['movie'] || 0) }}</span>
                            <div class="progress-bar-container" @click="setAudioProgress('movie', $event)">
                              <div class="progress-bar-bg"></div>
                              <div class="progress-bar" :style="{ width: `${audioProgress['movie'] || 0}%` }"></div>
                            </div>
                            <span class="duration">{{ formatTime(audioDurations['movie'] || 0) }}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </template>

                  <!-- 学校场景音频 -->
                  <template v-if="selectedSceneId === 4">
                    <!-- 学校铃声播放器 -->
                    <div class="audio-player-container">
                      <div class="audio-player">
                        <button 
                          class="audio-play-button"
                          :class="{ 'playing': activeSoundId === 'school-bell' }"
                          @click="playSound('school-bell')"
                          aria-label="Play or pause school bell sounds"
                        >
                          <span class="play-icon" v-if="activeSoundId !== 'school-bell'"></span>
                          <span class="pause-icon" v-else></span>
                        </button>
                        
                        <div class="audio-info">
                          <div class="audio-title">School Bell</div>
                          <div class="audio-timeline">
                            <span class="current-time">{{ formatTime(audioCurrentTimes['school-bell'] || 0) }}</span>
                            <div class="progress-bar-container" @click="setAudioProgress('school-bell', $event)">
                              <div class="progress-bar-bg"></div>
                              <div class="progress-bar" :style="{ width: `${audioProgress['school-bell'] || 0}%` }"></div>
                            </div>
                            <span class="duration">{{ formatTime(audioDurations['school-bell'] || 0) }}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                    
                    <!-- 孩子们交谈声音播放器 -->
                    <div class="audio-player-container">
                      <div class="audio-player">
                        <button 
                          class="audio-play-button"
                          :class="{ 'playing': activeSoundId === 'children-chatting' }"
                          @click="playSound('children-chatting')"
                          aria-label="Play or pause children chatting sounds"
                        >
                          <span class="play-icon" v-if="activeSoundId !== 'children-chatting'"></span>
                          <span class="pause-icon" v-else></span>
                        </button>
                        
                        <div class="audio-info">
                          <div class="audio-title">Children Chatting</div>
                          <div class="audio-timeline">
                            <span class="current-time">{{ formatTime(audioCurrentTimes['children-chatting'] || 0) }}</span>
                            <div class="progress-bar-container" @click="setAudioProgress('children-chatting', $event)">
                              <div class="progress-bar-bg"></div>
                              <div class="progress-bar" :style="{ width: `${audioProgress['children-chatting'] || 0}%` }"></div>
                            </div>
                            <span class="duration">{{ formatTime(audioDurations['children-chatting'] || 0) }}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </template>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 按钮部分 -->
        <div class="text-center mt-5">
          <button class="btn btn-action btn-lg" @click="goToNext">
            {{ getButtonText(selectedSceneId) }} →
          </button>
        </div>
      </div>
    </div>
    
    <!-- Loading Indicator -->
    <div v-if="isLoading" class="container text-center my-5">
      <div class="spinner-border spinner-border-lg text-primary-custom" role="status"> 
        <span class="visually-hidden">Loading...</span> 
      </div>
      <p class="loading-text mt-3">Loading sensory details...</p>
    </div>
    
    <!-- Display Backend Error -->
    <div v-if="error" class="container my-4">
      <div class="alert alert-danger error-box" role="alert">
        <strong>Error:</strong> {{ error }}
        <p class="mb-0 mt-1"><small>Could not load details for the selected scene. Please check the backend or try again later.</small></p>
      </div>
    </div>

    <MyFooter />
    </div>
  </template>
  
<script setup>
// Script content remains IDENTICAL
import { ref, onMounted, watch, computed } from 'vue';
  import axios from 'axios';
import AOS from 'aos';
import 'aos/dist/aos.css';
import MyNavBar from '../components/test/MyNavBar.vue';
import MyFooter from '../components/test/MyFooter.vue';
import { useRouter } from 'vue-router';

// 导入图标
import medicalIcon from '../components/icons/medical.png';
import airportIcon from '../components/icons/airport.png';
import outingIcon from '../components/icons/outing.png';
import schoolIcon from '../components/icons/school.png';

const frontendScenes = ref([ { id: 1, name: 'Medical Visit', title: 'Going to the Doctor/Dentist', subtitle: 'Preparing for a check-up or appointment.' }, { id: 2, name: 'Airport Travel', title: 'Traveling by Plane', subtitle: 'Navigating the airport environment.' }, { id: 3, name: 'Leisure Outing', title: 'Visiting a Park or Cinema', subtitle: 'Enjoying community spaces and events.' }, { id: 4, name: 'School Visit', title: 'Going to School', subtitle: 'Getting ready for the classroom setting.' } ]);
const selectedSceneId = ref(null); const sensoryExpectations = ref([]); const isLoading = ref(false); const error = ref(null);
const API_BASE_URL = 'http://localhost:3000/api';
const router = useRouter();

const selectedSceneDetails = computed(() => { if (!selectedSceneId.value) return null; return frontendScenes.value.find(scene => scene.id === selectedSceneId.value) || null; });

const fetchSensoryExpectations = async (sceneId) => { if (!sceneId) { sensoryExpectations.value = []; return; } isLoading.value = true; error.value = null; sensoryExpectations.value = []; console.log("Fetching expectations for scene ID:", sceneId); try { const response = await axios.get(`${API_BASE_URL}/scenes/${sceneId}/sensory-expectations`); console.log("Fetch expectations response:", response); if (response.data.success && Array.isArray(response.data.data)) { sensoryExpectations.value = response.data.data; console.log("Expectations loaded:", sensoryExpectations.value.length); } else { throw new Error(response.data.error || 'Invalid data format received for expectations'); } } catch (err) { console.error(`Error fetching sensory expectations for scene ${sceneId}:`, err); let message = `Could not load sensory details for "${selectedSceneDetails.value?.name || 'this scene'}". `; if (err.response) { message += `Server responded with status ${err.response.status}.`; if (err.response.data?.details) { message += ` Details: ${err.response.data.details}`; } else if (err.response.data?.error) { message += ` Message: ${err.response.data.error}`; } } else if (err.request) { message += ' No response from server.'; } else { message += ` Error: ${err.message}`; } error.value = message; sensoryExpectations.value = []; } finally { isLoading.value = false; } };
const getIconForCategory = (category) => { switch (category?.toLowerCase()) { case 'hearing': return '👂'; case 'sight': return '💡'; case 'smell': return '👃'; case 'touch': return '🖐️'; default: return '🧠'; } };
const goToNext = () => {
  if (!selectedSceneId.value) return;
  console.log('Navigating to next step for scene ID:', selectedSceneId.value);
  router.push({
    path: '/detectImage',
    query: { sceneId: selectedSceneId.value }
  });
};
const selectScene = async (sceneId) => {
  // 更新选中的场景ID
  selectedSceneId.value = sceneId;
  console.log(`已选择场景ID: ${sceneId}`);
  
  // 先手动调用API获取数据（而不是通过watch触发）
  isLoading.value = true;
  error.value = null;
  sensoryExpectations.value = [];
  
  try {
    // 直接调用API获取数据
    const response = await axios.get(`${API_BASE_URL}/scenes/${sceneId}/sensory-expectations`);
    console.log("获取到数据:", response);
    
    if (response.data.success && Array.isArray(response.data.data)) {
      sensoryExpectations.value = response.data.data;
      console.log("加载了期望数据，共", sensoryExpectations.value.length, "条");
      
      // 等待Vue更新DOM
      setTimeout(() => {
        console.log("正在尝试滚动到内容区域");
        const expectationsSection = document.querySelector('.sensory-expectations-section');
        if (expectationsSection) {
          console.log("找到目标区域，开始滚动");
          expectationsSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
        } else {
          console.log("未找到目标区域，可能尚未渲染");
        }
      }, 200); // 给DOM更新留出足够时间
    }
  } catch (err) {
    console.error("获取数据时出错:", err);
    let message = `加载场景"${selectedSceneDetails.value?.name || '此场景'}"的数据失败。`;
    error.value = message;
  } finally {
    isLoading.value = false;
  }
};

// 为每个场景提供对应的emoji图标
const getSceneIcon = (sceneId) => {
  switch(sceneId) {
    case 1: return medicalIcon; // 医疗访问
    case 2: return airportIcon; // 机场旅行
    case 3: return outingIcon;  // 休闲活动
    case 4: return schoolIcon;  // 学校参观
    default: return medicalIcon;
  }
};

// 添加获取按钮文本的方法
const getButtonText = (sceneId) => {
  if (!sceneId) return 'Continue to Checklist';
  
  switch(sceneId) {
    case 1: return 'See What to Pack for Medical Visit';
    case 2: return 'See What to Pack for Airport Travel';
    case 3: return 'See What to Pack for Leisure Outing';
    case 4: return 'See What to Pack for School Visit';
    default: return 'Continue to Checklist';
  }
};

// 添加音频播放状态和方法
const activeSoundId = ref(null);
const audioElements = ref({});
const audioDurations = ref({});
const audioCurrentTimes = ref({});
const audioProgress = ref({});
const audioInterval = ref(null);

// 音频播放方法
const playSound = (soundId) => {
  // 如果当前有播放中的音频，先停止
  if (activeSoundId.value && activeSoundId.value !== soundId) {
    audioElements.value[activeSoundId.value].pause();
    clearInterval(audioInterval.value);
    audioInterval.value = null;
  }
  
  // 检查音频元素是否已经创建
  if (!audioElements.value[soundId]) {
    const audio = new Audio();
    
    if (soundId === 'buzzing') {
      audio.src = '/audio/buzzing.mp3';
    } else if (soundId === 'people-talking') {
      audio.src = '/audio/people-talking.mp3';
    } else if (soundId === 'airport-announcement') {
      audio.src = '/audio/airport-announcements.mp3';
    } else if (soundId === 'airport-call') {
      audio.src = '/audio/airport-call.mp3';
    } else if (soundId === 'kids-playing') {
      audio.src = '/audio/kids-playing.mp3';
    } else if (soundId === 'movie') {
      audio.src = '/audio/movie.mp3';
    } else if (soundId === 'school-bell') {
      audio.src = '/audio/school-bell.mp3';
    } else if (soundId === 'children-chatting') {
      audio.src = '/audio/children-chatting.mp3';
    }
    
    audio.addEventListener('loadedmetadata', () => {
      audioDurations.value[soundId] = audio.duration;
    });
    
    audio.addEventListener('ended', () => {
      activeSoundId.value = null;
      audioCurrentTimes.value[soundId] = 0;
      audioProgress.value[soundId] = 0;
      clearInterval(audioInterval.value);
      audioInterval.value = null;
    });
    
    audioDurations.value[soundId] = 0;
    audioCurrentTimes.value[soundId] = 0;
    audioProgress.value[soundId] = 0;
    audioElements.value[soundId] = audio;
  }
  
  // 播放或暂停
  const audio = audioElements.value[soundId];
  if (activeSoundId.value === soundId) {
    audio.pause();
    activeSoundId.value = null;
    clearInterval(audioInterval.value);
    audioInterval.value = null;
  } else {
    audio.play();
    activeSoundId.value = soundId;
    
    // 设置定时器更新进度
    if (audioInterval.value) clearInterval(audioInterval.value);
    audioInterval.value = setInterval(() => {
      audioCurrentTimes.value[soundId] = audio.currentTime;
      audioProgress.value[soundId] = (audio.currentTime / audio.duration) * 100;
    }, 100);
  }
};

// 设置音频进度
const setAudioProgress = (soundId, event) => {
  if (!audioElements.value[soundId]) return;
  
  const audio = audioElements.value[soundId];
  const progressBar = event.currentTarget;
  const rect = progressBar.getBoundingClientRect();
  const clickPositionRatio = (event.clientX - rect.left) / rect.width;
  
  const newTime = audioDurations.value[soundId] * clickPositionRatio;
  audio.currentTime = newTime;
  audioCurrentTimes.value[soundId] = newTime;
  audioProgress.value[soundId] = clickPositionRatio * 100;
};

// 格式化时间为 mm:ss 格式
const formatTime = (seconds) => {
  if (isNaN(seconds) || seconds === Infinity) return '0:00';
  const mins = Math.floor(seconds / 60);
  const secs = Math.floor(seconds % 60).toString().padStart(2, '0');
  return `${mins}:${secs}`;
};

onMounted(() => { AOS.init({ duration: 600, once: false, offset: 50 }); });
watch(selectedSceneId, (newId) => { 
  console.log(`选中场景ID变为 ${newId}`); 
  if (newId === null) {
    sensoryExpectations.value = []; 
    error.value = null; 
    isLoading.value = false;
  }
  // 移除对fetchSensoryExpectations的调用，因为在selectScene中已经处理
});
  </script>
  
  <style scoped>
/* Core theme colors */
:root {
  --background-main: #F8EFED;
  --text-brown: #4d2f20;
  --primary-green: #3E5C2B;
  --card-bg: #FFFFFF;
  --border-color: #e0e0e0;
}

/* global page background */
.outside-scene-page {
  background-color: #F8EFED !important;
  min-height: 100vh;
  width: 100%;
  display: flex;
  flex-direction: column;
}

/* Hero Banner style */
.hero-banner {
  position: relative;
  width: 100%;
  height: 500px;
  overflow: hidden;
  margin-bottom: 0;
}

.hero-image-container {
  width: 100%;
  height: 100%;
}

.hero-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center 30%;
}

.hero-text-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.5);
}

.main-title {
  color: #4d2f20 !important;
  font-size: 2.7rem;
  font-weight: 700;
  margin-bottom: 1rem;
  text-shadow: 1px 1px 2px rgba(255, 255, 255, 0.8);
}

.main-subtitle {
  color: #4d2f20 !important;
  font-size: 1.3rem;
  margin-bottom: 0;
  line-height: 1.6;
  max-width: 800px;
  margin-left: auto;
  margin-right: auto;
  text-shadow: 1px 1px 2px rgba(255, 255, 255, 0.8);
}

/* ===== Interactive Section Styling ===== */
.interactive-section-container {
  flex-grow: 1;
  padding-bottom: 3rem;
  background-color: #F8EFED;
}

.interactive-content {
  max-width: 700px;
  width: 100%;
}

/* Label and Dropdown */
.label-text { 
  color: #4d2f20 !important; 
  font-size: 1.1rem; 
  margin-bottom: 0.5rem; 
  font-weight: 600;
  text-align: left;
}

.dropdown-select {
  border: 2px solid #3E5C2B !important;
  border-radius: 8px;
  padding: 0.75rem 1.25rem;
  font-size: 1.1rem;
  background-color: white;
  color: #4d2f20 !important;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    cursor: pointer;
  }
  
.dropdown-select:focus { 
  border-color: #3E5C2B !important; 
  box-shadow: 0 0 0 0.25rem rgba(62, 92, 43, 0.25);
}

/* custom dropdown arrow and background */
select.dropdown-select {
  background-image: linear-gradient(45deg, transparent 50%, #3E5C2B 50%), 
                    linear-gradient(135deg, #3E5C2B 50%, transparent 50%);
  background-position: calc(100% - 20px) center, calc(100% - 15px) center;
  background-size: 5px 5px, 5px 5px;
  background-repeat: no-repeat;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
}

/* cover dropdown option style */
select option {
  background-color: #F8EFED !important;
  color: #4d2f20 !important;
  padding: 12px !important;
}

/* choose option style */
select option:checked {
  background-color: #3E5C2B !important;
  color: white !important;
  box-shadow: 0 0 10px 100px #3E5C2B inset !important;
  -webkit-text-fill-color: white !important;
}

/* Dynamic Area below dropdown */
.dynamic-content-area { 
  min-height: 200px;
  margin-top: 2rem;
}

.scene-content-title {
  color: #4d2f20 !important;
  font-size: 1.6rem;
  font-weight: 600;
}

.scene-content-subtitle {
  color: #4d2f20 !important;
  font-size: 1.0rem;
  opacity: 0.9;
  line-height: 1.5;
}

/* Loading and Error styling */
.text-primary-custom { color: #3E5C2B !important; }
.loading-text { color: #4d2f20 !important; opacity: 0.8; }
.error-box { 
  border-radius: 8px; 
  padding: 0.8rem 1.25rem; 
  background-color: #f8d7da; 
  border-color: #f5c6cb; 
  color: #721c24; 
  margin-top: 1rem;
}
.error-box strong { color: #721c24; }
.info-box { 
  border-radius: 8px; 
  padding: 1rem 1.25rem; 
  background-color: #e2f3fd; 
  border-color: #b8e7fb; 
  color: #0c5464; 
  margin-top: 1rem;
}

/* Expectations section styling */
.expectations-section { margin-top: 2rem; }

/* wide screen card container */
.expectations-container-wide {
  width: 100%;
  min-height: 400px;
  margin-bottom: 2rem;
  margin-top: 2rem;
  background-color: rgba(248, 249, 250, 0.4);
  background-size: cover;
  background-position: center;
  position: relative;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  overflow: hidden;
  padding: 1.5rem;
}

.expectations-list {
  padding: 1rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.expectation-item.card {
  background-color: rgba(255, 255, 255, 0.95);
  border: none;
  border-left: 4px solid #3E5C2B;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  transition: all 0.3s ease;
  margin-bottom: 1rem;
  max-width: 600px;
}

.expectation-item.card:hover { 
  transform: translateY(-3px); 
  box-shadow: 0 6px 16px rgba(0,0,0,0.12);
}

.expectation-icon { 
  color: #3E5C2B !important; 
  font-size: 1.8rem;
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 40px;
}

.expectation-category { 
  color: #3E5C2B !important; 
  font-weight: 600; 
  font-size: 1.2rem;
  margin-bottom: 0.5rem;
}

.expectation-description { 
  color: #4d2f20 !important; 
  font-size: 1rem; 
  line-height: 1.5;
}

/* Button styling */
.btn-action {
  background-color: #3E5C2B !important; 
  color: white !important;
  font-size: 1.1rem;
  border-radius: 8px;
  transition: all 0.3s ease;
  border: 2px solid #3E5C2B !important;
  padding: 0.75rem 1.5rem;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.btn-action:hover:not(:disabled) { 
  background-color: #314a22 !important; 
  border-color: #314a22 !important;
  box-shadow: 0 4px 10px rgba(77, 47, 32, 0.2);
  transform: translateY(-2px);
}

.btn-action:disabled { 
  background-color: #3E5C2B !important;
  border-color: #3E5C2B !important;
  opacity: 0.7;
  cursor: not-allowed;
  color: white !important;
}

/* Transitions */
.fade-enter-active, .fade-leave-active { transition: opacity 0.3s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

/* Responsive adjustments */
@media (max-width: 991px) {
  .interactive-content {
    max-width: 95%;
  }
  
  .hero-banner {
    height: 400px;
  }
  
  .hero-image {
    height: 100%;
  }
  
  .main-title {
    font-size: 2.2rem;
  }
  
  .main-subtitle {
    font-size: 1.1rem;
  }
}

@media (max-width: 767px) {
  .hero-banner {
    height: 300px;
  }
  
  .main-title {
    font-size: 1.8rem;
    padding: 0 1rem;
  }
  
  .main-subtitle {
    font-size: 1rem;
    padding: 0 1rem;
  }
  
  .expectations-container-wide {
    min-height: auto;
    padding: 1rem;
  }
  
  .expectation-item.card {
    margin-bottom: 0.8rem;
  }
  
  .expectation-category {
    font-size: 1.1rem;
  }
  
  .expectation-description {
    font-size: 0.95rem;
  }
  
  .expectation-icon {
    font-size: 1.5rem;
    min-width: 30px;
  }
}

@media (max-width: 575px) {
  .scene-intro-card .card-body {
    padding: 1.2rem;
  }
  
  .expectation-icon {
    margin-right: 0.5rem !important;
  }
  
  .label-text {
    font-size: 1rem;
  }
  
  .scene-content-title {
    font-size: 1.4rem;
  }
  
  .expectation-item.card .card-body {
    padding: 0.8rem;
  }
}

/* introduction card style */
.scene-intro-card {
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  margin-bottom: 2rem;
  border: 1px solid #e0e0e0;
}

.scene-intro-card .card-body {
  padding: 1.5rem;
}

.scene-intro-card h4 {
  color: #4d2f20;
}

.scene-intro-card p, .scene-intro-card ul {
  color: #4d2f20;
  font-size: 1rem;
  line-height: 1.5;
}

.scene-intro-card ul {
  margin-bottom: 1.5rem;
  padding-left: 1.5rem;
}

.scene-intro-card li {
  margin-bottom: 0.5rem;
}

  /* sensory card container style */
.expectations-container {
  background-color: #f8f9fa;
  border-radius: 10px;
  padding: 1.5rem;
  margin-bottom: 2rem;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  border: 1px solid #e0e0e0;
}

/* scene background style */
.scene-bg-1 {
  background-image: url('/scenes/medical-bg.png');
}

.scene-bg-2 {
  background-image: url('/scenes/airplane-bg.png');
}

.scene-bg-3 {
  background-image: url('/scenes/park-bg.png');
}

.scene-bg-4 {
  background-image: url('/scenes/school-bg.png');
}

/* ===== 新添加的场景选择部分样式 ===== */
.scene-selection-section {
  padding: 4rem 0;
  background-color: #F8EFED;
}

/* left text container */
.intro-text-container {
  padding: 1.5rem;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.intro-title {
  color: #4d2f20;
  font-size: 2rem;
  font-weight: 700;
  margin-bottom: 1.5rem;
}

.intro-description {
  color: #4d2f20;
  font-size: 1.1rem;
  line-height: 1.6;
  margin-bottom: 2rem;
}

.selected-scene-info {
  margin-top: 1.5rem;
  padding: 1rem;
  background-color: rgba(255, 255, 255, 0.7);
  border-radius: 10px;
  border-left: 4px solid #3E5C2B;
}

.selected-scene-text {
  color: #4d2f20;
  margin-bottom: 1rem;
  font-size: 1.1rem;
}

.scene-label {
  font-weight: 600;
  color: #3E5C2B;
}

.scene-name {
  font-weight: 700;
  color: #4d2f20;
}

/* right scene card */
.scene-selection-heading {
  color: #4d2f20;
  font-size: 1.3rem;
  font-weight: 600;
  margin-bottom: 1.5rem;
}

.scene-cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 1.5rem;
}

.scene-card {
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  transition: all 0.3s ease;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  height: 100%;
  border: 2px solid transparent;
}

.scene-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.12);
}

.scene-card.active {
  border-color: #3E5C2B;
  box-shadow: 0 10px 25px rgba(62, 92, 43, 0.2);
}

.scene-card-icon {
  padding: 1.5rem;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #f8f9fa;
}

.scene-icon-image {
  height: 50px;
  width: auto;
  object-fit: contain;
}

.scene-card-content {
  padding: 1.5rem;
  flex-grow: 1;
  display: flex;
  flex-direction: column;
}

.scene-card-title {
  color: #3E5C2B;
  font-size: 1.2rem;
  font-weight: 600;
  margin-bottom: 0.75rem;
}

.scene-card-description {
  color: #6c757d;
  font-size: 0.95rem;
  margin-bottom: 0;
  line-height: 1.5;
}

/* 感官期望部分样式 */
.sensory-expectations-section {
  padding: 3rem 0 5rem;
  background-color: #f8f9fa;
}

.expectations-header {
  margin-bottom: 2.5rem;
}

.expectations-header h3 {
  color: #4d2f20;
  font-size: 1.8rem;
  font-weight: 700;
  margin-bottom: 0.75rem;
}

.expectations-subtitle {
  color: #6c757d;
  font-size: 1.1rem;
}

.sensory-content-container {
  display: flex;
  gap: 2rem;
  margin: 2rem 0;
  min-height: 450px;
}

/* left image container */
.sensory-image-container {
  flex: 1;
  border-radius: 16px;
  overflow: hidden;
  background-size: cover;
  background-position: center;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
  position: relative;
}

/* right card container */
.sensory-cards-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.sensory-card {
  display: flex;
  align-items: flex-start;
  background-color: white;
  border-radius: 12px;
  padding: 1.25rem;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
  border-left: 4px solid #3E5C2B;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.sensory-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
}

.sensory-card-icon {
  margin-right: 1rem;
  font-size: 1.75rem;
  color: #3E5C2B;
  width: 40px;
  display: flex;
  justify-content: center;
}

.sensory-card-content {
  flex: 1;
}

.sensory-category {
  font-size: 1.15rem;
  font-weight: 600;
  color: #4d2f20;
  margin-bottom: 0.5rem;
}

.sensory-description {
  font-size: 1rem;
  color: #6c757d;
  margin-bottom: 0;
  line-height: 1.5;
}

/* responsive design */
@media (max-width: 991px) {
  .sensory-content-container {
    flex-direction: column;
    gap: 2rem;
  }
  
  .sensory-image-container {
    height: 350px;
  }
}

@media (max-width: 768px) {
  .sensory-expectations-section {
    padding: 2rem 0 3rem;
  }
  
  .expectations-header h3 {
    font-size: 1.5rem;
  }
  
  .sensory-image-container {
    height: 280px;
  }
  
  .sensory-card {
    padding: 1rem;
  }
  
  .sensory-category {
    font-size: 1.1rem;
  }
  
  .sensory-card-icon {
    font-size: 1.5rem;
    margin-right: 0.75rem;
  }
}

/* audio player style */
.audio-controls {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-top: 1rem;
}

.audio-player-container {
  background-color: #f8f9fa;
  border-radius: 8px;
  padding: 0.75rem;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
  width: 100%;
}

.audio-player {
  display: flex;
  align-items: center;
}

.audio-play-button {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background-color: #3E5C2B;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  padding: 0;
  margin-right: 0.75rem;
  transition: all 0.2s ease;
  box-shadow: 0 2px 4px rgba(62, 92, 43, 0.3);
  flex-shrink: 0;
}

.audio-play-button:hover {
  background-color: #345124;
  transform: scale(1.05);
}

/* play icon - triangle */
.play-icon {
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 8px 0 8px 12px;
  border-color: transparent transparent transparent #ffffff;
  margin-left: 2px; /* adjust to center the triangle visually */
}

/* pause icon - two vertical bars */
.pause-icon {
  width: 12px;
  height: 14px;
  position: relative;
  display: flex;
  justify-content: space-between;
}

.pause-icon::before,
.pause-icon::after {
  content: "";
  width: 4px;
  height: 14px;
  background-color: #ffffff;
  border-radius: 1px;
}

.audio-info {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.audio-title {
  font-size: 0.9rem;
  font-weight: 500;
  color: #4d2f20;
}

.audio-timeline {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.75rem;
  color: #6c757d;
}

.current-time, .duration {
  min-width: 35px;
}

.progress-bar-container {
  flex-grow: 1;
  height: 4px;
  background-color: #e0e0e0;
  border-radius: 2px;
  overflow: hidden;
  position: relative;
  cursor: pointer;
}

.progress-bar-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: #e0e0e0;
}

.progress-bar {
  position: absolute;
  top: 0;
  left: 0;
  height: 100%;
  background-color: #3E5C2B;
  width: 0%;
  transition: width 0.1s linear;
}

@media (max-width: 576px) {
  .audio-controls {
    width: 100%;
  }
  
  .audio-timeline {
    gap: 0.25rem;
  }
  
  .current-time, .duration {
    min-width: 30px;
    font-size: 0.7rem;
  }
  }
  </style>