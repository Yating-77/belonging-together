<template>
  <div class="location-search">
    <div class="search-title">Want to see resources near you?</div>
    <div v-if="searchOutOfVicError" class="search-warning out-of-vic-error">
      {{ searchOutOfVicError }}
    </div>
    <div v-if="inputValidationError" class="search-warning input-validation-error">
      {{ inputValidationError }}
    </div>
    <div class="search-input-group">
      <div class="autocomplete-wrapper">
        <input
          type="text"
          v-model="searchLocation"
          placeholder="Enter your address or suburb name to zoom in on your local area"
          @input="handleInput"
          @keyup.enter="handleEnterKey"
          @blur="hideSuggestions"
        >
        <ul v-if="showSuggestions && suggestions.length > 0" class="suggestions-list">
          <li
            v-for="(suggestion, index) in suggestions"
            :key="index"
            @mousedown.prevent="selectSuggestion(suggestion)"
            class="suggestion-item"
            :class="{ 'non-vic-suggestion': !suggestion.isVic }"
          >
            {{ suggestion.displayName }}
            <span v-if="!suggestion.isVic" class="suggestion-state-warning"> (Non-VIC)</span>
          </li>
        </ul>
         <div v-if="showSuggestions && suggestions.length === 0 && searchLocation.length >= 2 && !isLoadingSuggestions" class="suggestions-list no-suggestions">
          No suggestions found in VIC.
        </div>
        <div v-if="isLoadingSuggestions" class="suggestions-list loading-suggestions">
          Loading...
        </div>
      </div>
      <button
        class="search-button"
        @click="validateAndSearch"
      >
        <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="11" cy="11" r="8"></circle>
          <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
        </svg>
      </button>
    </div>

    <!-- add clear search results button -->
    <div v-if="densityResult" class="search-results-tabs">
      <div class="tabs-container">
        <div 
          class="tab-item" 
          :class="{ 'active': activeTab === 'meter' }"
          @click="switchTab('meter', true)"
        >
          <span class="tab-icon">📊</span>
          Resource Meter
        </div>
        <div 
          class="tab-item" 
          :class="{ 'active': activeTab === 'map' }"
          @click="switchTab('map', true)"
        >
          <span class="tab-icon">🗺️</span>
          Resource Heatmap
        </div>
      </div>
      
      <button class="clear-results-button" @click="clearResults">
        <svg class="clear-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <line x1="18" y1="6" x2="6" y2="18"></line>
          <line x1="6" y1="6" x2="18" y2="18"></line>
        </svg>
        Clear search results
      </button>
    </div>
    
    <div v-if="densityResult" class="density-gauge-container">
 
      <div class="location-header">
        <div class="location-icon">📍</div>
        <div class="location-name">{{ searchedAddress }}</div>
      </div>
      
      
      <div class="density-info-display">
        <div class="density-level" :class="densityResultClass">
          {{ densityLevelText }}
        </div>
        <div class="density-detail">
          {{ densityData?.pointsCount || 0 }} resources in 3km
        </div>
      </div>
      
      
      <div class="density-gauge-wrapper">
        <v-chart class="chart" :option="echartsOption" autoresize />
      </div>
      
      <!-- resource density indicator reference -->
      <div class="density-levels-reference">
        <div class="reference-header">
          <h4>Resource Density Level Reference</h4>
          <div class="reference-desc">Density levels are based on the number of accessible support resources within 3km</div>
        </div>
        
        <div class="density-level-cards">
          <div class="density-level-card" :class="{'active': densityResultClass === 'very-low'}">
            <div class="level-color very-low"></div>
            <div class="level-content">
              <div class="level-title">Very Low</div>
              <div class="level-range">0-5 resources</div>
              <div class="level-description">Very limited resources, consider online support</div>
            </div>
          </div>
          
          <div class="density-level-card" :class="{'active': densityResultClass === 'low'}">
            <div class="level-color low"></div>
            <div class="level-content">
              <div class="level-title">Low</div>
              <div class="level-range">6-10 resources</div>
              <div class="level-description">Limited resources, advance planning recommended</div>
            </div>
          </div>
          
          <div class="density-level-card" :class="{'active': densityResultClass === 'medium'}">
            <div class="level-color medium"></div>
            <div class="level-content">
              <div class="level-title">Medium</div>
              <div class="level-range">11-15 resources</div>
              <div class="level-description">Adequate resources for basic needs</div>
            </div>
          </div>
          
          <div class="density-level-card" :class="{'active': densityResultClass === 'high'}">
            <div class="level-color high"></div>
            <div class="level-content">
              <div class="level-title">High</div>
              <div class="level-range">16-20 resources</div>
              <div class="level-description">Abundant resource options available</div>
            </div>
          </div>
          
          <div class="density-level-card" :class="{'active': densityResultClass === 'very-high'}">
            <div class="level-color very-high"></div>
            <div class="level-content">
              <div class="level-title">Very High</div>
              <div class="level-range">20+ resources</div>
              <div class="level-description">Diverse professional support services</div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Online Resources for Low Resource Areas -->
      <div v-if="densityResultClass === 'very-low'" class="online-resources">
        <h3 class="online-resources-title">Limited physical resources in this area. Consider these online support options:</h3>
        
        <div class="resource-cards">
          <div class="resource-card">
            <h4>Positive Partnerships</h4>
            <ul>
              <li><strong>Service Type:</strong> Early Intervention (Online Available)</li>
              <li><strong>Description:</strong> Offers evidence-based online workshops and learning modules for parents to support early intervention and school collaboration.</li>
              <li><strong>Website:</strong> <a href="https://positivepartnerships.com.au" target="_blank">positivepartnerships.com.au</a></li>
              <li><strong>Phone:</strong> 1300 881 971</li>
            </ul>
          </div>
          
          <div class="resource-card">
            <h4>Amaze (Autism Victoria)</h4>
            <ul>
              <li><strong>Service Type:</strong> Early Intervention (Online Available); Daily Living Support (Online Available)</li>
              <li><strong>Description:</strong> Provides online tools and information via Autism Connect and TherapyConnect to help families understand therapies, coordinate NDIS support, and manage daily challenges.</li>
              <li><strong>Website:</strong> <a href="https://amaze.org.au" target="_blank">amaze.org.au</a></li>
              <li><strong>Phone:</strong> 03 9657 1600 / 1300 308 699 (Autism Connect Helpline)</li>
              <li><strong>Email:</strong> info@amaze.org.au</li>
            </ul>
          </div>
          
          <div class="resource-card">
            <h4>ParentZone – Anglicare Victoria</h4>
            <ul>
              <li><strong>Service Type:</strong> Daily Living Support (Online Available)</li>
              <li><strong>Description:</strong> Delivers free online parenting programs and support groups for families of children with autism, focused on daily routines, emotional regulation, and behaviour strategies.</li>
              <li><strong>Website:</strong> <a href="https://anglicarevic.org.au" target="_blank">anglicarevic.org.au</a></li>
              <li><strong>Phone:</strong> 1800 809 722</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>

  
  <div v-if="nearbyResourcesList.length > 0" class="resources-list-container">
    <div class="resources-header">
      <h3>Nearby Resources</h3>
      <span class="total-resources">{{ nearbyResourcesList.length }} total</span>
    </div>
    
    <div class="resources-grid">
      <div v-for="(group, typeKey) in groupedNearbyResources" :key="typeKey" 
           class="resource-category" :data-type="typeKey">
        <div class="category-header">
          <div class="category-title">{{ formatTypeName(typeKey) }}</div>
          <div class="category-count">{{ group.length }}</div>
        </div>
        
        <div class="resource-items-grid">
          <div v-for="resource in group" :key="resource.id || resource.name" class="resource-card">
            <div class="resource-name">{{ resource.name || 'Unnamed Resource' }}</div>
            <div v-if="resource.address" class="resource-address">{{ resource.address }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, watch, onMounted, computed } from 'vue';
import L from 'leaflet';

// ECharts imports
import { use } from 'echarts/core';
import { CanvasRenderer } from 'echarts/renderers';
import { GaugeChart } from 'echarts/charts';
import { TitleComponent, TooltipComponent, LegendComponent } from 'echarts/components';
import VChart from 'vue-echarts';


use([
  CanvasRenderer,
  GaugeChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent
]);


function debounce(func, delay) {
  let timeout;
  return function(...args) {
    const context = this;
    clearTimeout(timeout);
    timeout = setTimeout(() => func.apply(context, args), delay);
  };
}

export default {
  name: 'LocationDensitySearch',
  components: {
    VChart
  },
  props: {
    map: {
      type: Object,
      required: true
    },
    allTypesSelected: {
      type: Boolean,
      default: false
    },
    resourceData: {
      type: Object,
      required: true,
    },
    loading: {
      type: Boolean,
      default: false
    },
    selectedTypes: {
      type: Object,
      required: true
    }
  },
  emits: ['update:loading', 'scroll-to-map'],
  setup(props, { emit }) {
    const searchLocation = ref('');
    const searchedAddress = ref('');
    const densityResult = ref('');
    const densityResultClass = ref('');
    const locationMarker = ref(null);
    const nearbyResourcesList = ref([]);
    const densityData = ref(null);
    const inputValidationError = ref('');
    const activeTab = ref('meter');

    const suggestions = ref([]);
    const showSuggestions = ref(false);
    const isLoadingSuggestions = ref(false);
    const searchOutOfVicError = ref('');
    let debouncedFetchSuggestions;
    
    const GEOAPIFY_API_KEY = '7cdc3f23f1334a329855300d3ec01b74';

    const VIC_VIEWBOX_STRING = '140.9,-39.2,149.9,-33.9'; 
    const VIC_NOMINATIM_VIEWBOX = VIC_VIEWBOX_STRING;
    const VIC_GEOAPIFY_BIAS_PROXIMITY = '144.9631,-37.8136';

    const formatTypeName = (typeKey) => {
      switch (typeKey) {
        case 'schools': return 'Schools';
        case 'hospitals': return 'Hospitals';
        case 'ndisProviders': return 'NDIS Early Childhood';
        case 'ndisDailyLiving': return 'NDIS Daily Living';
        case 'ndisTherapy': return 'NDIS Therapy';
        default: return typeKey;
      }
    };

    const groupedNearbyResources = computed(() => {
      if (!nearbyResourcesList.value.length) return {};
      const groups = { schools: [], hospitals: [], ndisProviders: [], ndisDailyLiving: [], ndisTherapy: [] };
      nearbyResourcesList.value.forEach(item => {
        if (item.type && groups[item.type]) groups[item.type].push(item);
      });
      return Object.fromEntries(Object.entries(groups).filter(([_, value]) => value.length > 0));
    });

    const densityLevelText = computed(() => {
      const texts = {
        'very-low': 'Very Low',
        'low': 'Low',
        'medium': 'Medium',
        'high': 'High',
        'very-high': 'Very High',
        'error': 'Error'
      };
      return texts[densityResultClass.value] || '';
    });
    
    const densityDetailsText = computed(() => {
      if (densityResultClass.value === 'error' || !densityData.value?.typeCount) return '';
      const total = Object.values(densityData.value.typeCount).reduce((sum, count) => sum + count, 0);
      return `${total} resources in 3km`;
    });

    const echartsGaugeValue = computed(() => {
      
      const actual = densityData.value?.pointsCount || 0;
      
     
      if (actual <= 5) return actual;        
      if (actual <= 10) return actual;     
      if (actual <= 15) return actual;       
      if (actual <= 20) return actual;       
      return Math.min(actual, 40);           
    });

    const echartsOption = computed(() => {
      const levelText = densityLevelText.value;
      const detailsText = densityDetailsText.value;

      return {
        series: [
          {
            type: 'gauge',
            startAngle: 180,
            endAngle: 0,
            min: 0,
            max: 40, 
            splitNumber: 5,
            radius: '150%',  
            center: ['50%', '75%'],  
            axisLine: {
              lineStyle: {
                width: 40,  
                color: [
                  [0.125, '#FF4444'],  
                  [0.25, '#FFAA00'],    
                  [0.375, '#FFFF00'],   
                  [0.5, '#00C851'],   
                  [1, '#0099CC']       
                ]
              }
            },
            pointer: {
              itemStyle: {
                color: 'auto'
              },
              length: '60%',
              width: 10, 
              offsetCenter: [0, '-10%']
            },
            axisTick: {
              distance: -35, 
              length: 10,    
              lineStyle: {
                color: '#fff',
                width: 3      
              }
            },
            splitLine: {
              distance: -35,  
              length: 35,     
              lineStyle: {
                color: '#fff',
                width: 5      
              }
            },
            axisLabel: {
              show: false 
            },
            detail: {
              show: false 
            },
            data: [
              {
                value: echartsGaugeValue.value,
              }
            ],
          }
        ]
      };
    });
    
    onMounted(() => {
      const link = document.createElement('link');
      link.rel = 'stylesheet';
      link.href = 'https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined';
      const existingLink = document.querySelector(`link[href="${link.href}"]`);
      if (!existingLink) document.head.appendChild(link);
      debouncedFetchSuggestions = debounce(fetchAddressSuggestions, 350);
    });
    
    const cleanAddressText = (text) => {
      if (!text) return '';
      const parts = text.split(',').map(part => part.trim());
      const cleanParts = parts.filter(part => !/[\u4e00-\u9fa5]/.test(part));
      const finalParts = cleanParts.map(part => {
        part = part.replace(/\([^)]*\)/g, '').trim();
        part = part.replace(/^\d+[-\d]*$/, '').trim();
        return part;
      }).filter(part => part.length > 0);
      const relevantParts = finalParts.slice(0, 3);
      return relevantParts.join(', ');
    };

    const isAddressInVicNominatim = (addressObject) => {
        if (!addressObject) return false;
        const state = addressObject.state;
        return state && (state.toLowerCase() === 'victoria' || state.toLowerCase() === 'vic');
    };

    const isSuggestionInVicGeoapify = (properties) => {
        if (!properties) return false;
        const state = properties.state;
        return state && (state.toLowerCase() === 'victoria' || state.toLowerCase() === 'vic.');
    };
    
    const geocodeAddress = async (addressText) => {
      try {
        const url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(addressText)}&viewbox=${VIC_NOMINATIM_VIEWBOX}&bounded=1&limit=1&countrycodes=au&accept-language=en&addressdetails=1`;
        
        const response = await fetch(url, {
          headers: { 'User-Agent': 'Melbourne Resources Map Application - Geocoding', 'Accept-Language': 'en' }
        });
        
        if (!response.ok) throw new Error(`Nominatim Geocoding request failed: ${response.status}`);
        const data = await response.json();

        if (!data || data.length === 0) {
            return { error: 'NOT_FOUND_IN_VIC_VIEWBOX', isVic: false };
        }
        
        const firstResult = data[0];
        const isInVic = isAddressInVicNominatim(firstResult.address);

        if (!isInVic) {
            return { error: 'FOUND_OUTSIDE_VIC', result: firstResult, isVic: false };
        }
        
        const cleanDisplayName = cleanAddressText(firstResult.display_name);
        return {
          lat: parseFloat(firstResult.lat),
          lng: parseFloat(firstResult.lon),
          displayName: cleanDisplayName || 'Victoria, Australia',
          isVic: true
        };
      } catch (error) {
        console.error('Geocoding error with Nominatim:', error);
        return { error: 'GEOCODING_EXCEPTION', message: error.message, isVic: false };
      }
    };

    const fetchAddressSuggestions = async (query) => {
      if (!query || query.length < 2) {
        suggestions.value = []; showSuggestions.value = false; isLoadingSuggestions.value = false;
        return;
      }
      
      isLoadingSuggestions.value = true;
      suggestions.value = [];

      const encodedQuery = encodeURIComponent(query);
      const geoapifyUrl = `https://api.geoapify.com/v1/geocode/autocomplete?text=${encodedQuery}&apiKey=${GEOAPIFY_API_KEY}&limit=7&filter=countrycode:au&bias=proximity:${VIC_GEOAPIFY_BIAS_PROXIMITY}`;

      try {
        const response = await fetch(geoapifyUrl);
        if (!response.ok) {
          const errorData = await response.json().catch(() => ({ message: response.statusText }));
          throw new Error(`Geoapify Autocomplete request failed: ${response.status} - ${errorData.message || 'Unknown error'}`);
        }
        const data = await response.json();

        if (data.features && data.features.length > 0) {
          suggestions.value = data.features.map(feature => ({
            displayName: feature.properties.formatted,
            lat: feature.properties.lat, 
            lng: feature.properties.lon,
            isVic: isSuggestionInVicGeoapify(feature.properties),
          }));
        } else {
          suggestions.value = [];
        }
      } catch (error) {
        console.error('Error fetching Geoapify suggestions:', error);
        suggestions.value = [];
      } finally {
        isLoadingSuggestions.value = false;
        showSuggestions.value = searchLocation.value.length >= 2;
      }
    };

    const handleInput = () => {
      inputValidationError.value = '';
      searchOutOfVicError.value = '';
      
      if (searchLocation.value.trim() !== '') {
        validateInput(searchLocation.value);
        showSuggestions.value = true;
        debouncedFetchSuggestions(searchLocation.value);
      } else {
        suggestions.value = []; 
        showSuggestions.value = false; 
        isLoadingSuggestions.value = false;
      }
    };

    const selectSuggestion = (suggestion) => {
      searchLocation.value = suggestion.displayName; 
      suggestions.value = [];                      
      showSuggestions.value = false;                 
      isLoadingSuggestions.value = false;            
      searchOutOfVicError.value = '';
      inputValidationError.value = '';
    };

    const hideSuggestions = () => {
        setTimeout(() => {
            if (document.activeElement !== document.querySelector('.autocomplete-wrapper input')) {
                 showSuggestions.value = false;
                 isLoadingSuggestions.value = false;
            }
        }, 200);
    };
    
    const searchLocationDensity = async () => {
      nearbyResourcesList.value = []; 
      searchOutOfVicError.value = ''; 
      
      if (!searchLocation.value || !props.map) return;
      
      emit('update:loading', true);
      densityResult.value = '';
      densityResultClass.value = '';
      
      try {
        clearMarker(); 
        let lat, lng;
        let geocodedAddressName = searchLocation.value;
        let isVicLocation = true;

        const coordsRegex = /^(-?\d+(\.\d+)?),\s*(-?\d+(\.\d+)?)$/;
        const coordsMatch = searchLocation.value.match(coordsRegex);
        
        if (coordsMatch) {
          lat = parseFloat(coordsMatch[1]);
          lng = parseFloat(coordsMatch[3]);
          geocodedAddressName = `${lat.toFixed(6)}, ${lng.toFixed(6)}`;
        } else {
          const geocodeResult = await geocodeAddress(searchLocation.value);

          if (geocodeResult.error || !geocodeResult.isVic) {
            isVicLocation = false;
            if (geocodeResult.error === 'NOT_FOUND_IN_VIC_VIEWBOX') {
              searchOutOfVicError.value = `Address not found within Victoria. Please try a different address.`;
            } else if (geocodeResult.error === 'FOUND_OUTSIDE_VIC') {
              searchOutOfVicError.value = `The address "${cleanAddressText(geocodeResult.result.display_name)}" is outside Victoria. Please search for an address within VIC.`;
            } else if (!geocodeResult.isVic && !geocodeResult.error) {
              searchOutOfVicError.value = `The address "${geocodeResult.displayName}" is outside Victoria. Please search for an address within VIC.`;
            } else {
              searchOutOfVicError.value = `Could not process the address. Please try again. (${geocodeResult.message || ''})`;
            }
          } else {
            lat = geocodeResult.lat;
            lng = geocodeResult.lng;
            geocodedAddressName = geocodeResult.displayName;
          }
        }
        
        if (!isVicLocation) {
          densityResultClass.value = 'error';
          densityResult.value = "trigger";
          emit('update:loading', false);
          return; 
        }

        searchedAddress.value = geocodedAddressName;

        if (!isValidCoordinate(lat, lng)) {
          densityResultClass.value = 'error';
          densityResult.value = "trigger";
          emit('update:loading', false);
          return;
        }
        
        locationMarker.value = L.marker([lat, lng], {
          icon: L.divIcon({ className: 'custom-search-marker', html: `<div class="search-location-pin"><span class="location-icon">📍</span></div>`, iconSize: [40, 40], iconAnchor: [20, 40], popupAnchor: [0, -40] })
        });
        
        locationMarker.value.bindTooltip(`
          <div class="tooltip-content">
            <div class="tooltip-title">Search Location</div>
            <div class="tooltip-details">
              <div class="tooltip-row"><span class="tooltip-label">Address:</span><span class="tooltip-value">${searchedAddress.value}</span></div>
              <div class="tooltip-row"><span class="tooltip-label">Coordinates:</span><span class="tooltip-value">[${lat.toFixed(6)}, ${lng.toFixed(6)}]</span></div>
            </div>
          </div>
        `, { direction: 'auto', permanent: false, className: 'custom-tooltip search-tooltip horizontal-tooltip', offset: [0, -10], opacity: 0.9 });
        
        locationMarker.value.addTo(props.map);
        
        const density = calculateProximityDensity(lat, lng);
        densityData.value = density; 
        
        const radius = density.radius || 3;
        const zoomLevel = radius <= 1 ? 16 : radius <= 3 ? 14 : radius <= 5 ? 12 : 10;
        
        props.map.flyTo([lat, lng], zoomLevel, {
          duration: 1.5,
          easeLinearity: 0.25
        });
        
        evaluateDensity(density);

      } catch (error) {
        console.error('Error during searchLocationDensity:', error);
        densityResultClass.value = 'error';
        densityResult.value = "trigger";
      } finally {
        emit('update:loading', false);
      }
    };
    
    const isValidCoordinate = (lat, lng) => {
      return lat !== undefined && lng !== undefined && !isNaN(lat) && !isNaN(lng) && Math.abs(lat) <= 90 && Math.abs(lng) <= 180;
    };
    
    const calculateProximityDensity = (lat, lng, radius = 3) => {
      const radiusKm = radius;
      const allPoints = [];
      try {
        if (props.selectedTypes.schools && props.resourceData.schools) allPoints.push(...props.resourceData.schools.map(point => ({...point, type: 'schools'})));
        if (props.selectedTypes.hospitals && props.resourceData.hospitals) allPoints.push(...props.resourceData.hospitals.map(point => ({...point, type: 'hospitals'})));
        if (props.selectedTypes.ndisProviders && props.resourceData.ndisProviders) allPoints.push(...props.resourceData.ndisProviders.map(point => ({...point, type: 'ndisProviders'})));
        if (props.selectedTypes.ndisDailyLiving && props.resourceData.ndisDailyLiving) allPoints.push(...props.resourceData.ndisDailyLiving.map(point => ({...point, type: 'ndisDailyLiving'})));
        if (props.selectedTypes.ndisTherapy && props.resourceData.ndisTherapy) allPoints.push(...props.resourceData.ndisTherapy.map(point => ({...point, type: 'ndisTherapy'})));
      } catch (e) { /* silent */ }
      
      const pointsInRadius = allPoints.filter(point => {
        if (!isValidCoordinate(point.lat, point.lng)) return false;
        return calculateDistance(lat, lng, point.lat, point.lng) <= radiusKm;
      });
      
      const typeCount = { schools: 0, hospitals: 0, ndisProviders: 0, ndisDailyLiving: 0, ndisTherapy: 0 };
      pointsInRadius.forEach(point => { if (point.type && typeCount[point.type] !== undefined) typeCount[point.type]++; });
      
      return { pointsCount: pointsInRadius.length, radius: radiusKm, totalPoints: allPoints.length, typeCount: typeCount, nearbyRawResources: pointsInRadius };
    };
    
    const calculateDistance = (lat1, lon1, lat2, lon2) => {
      const R = 6371; 
      const dLat = (lat2 - lat1) * Math.PI / 180; const dLon = (lon2 - lon1) * Math.PI / 180;
      const a = Math.sin(dLat/2)**2 + Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * Math.sin(dLon/2)**2;
      const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
      return R * c;
    };
    
    const evaluateDensity = (densityVal) => {
      const { pointsCount, radius, totalPoints, nearbyRawResources } = densityVal;
      nearbyResourcesList.value = nearbyRawResources || [];
      densityResultClass.value = "";

      
      if (pointsCount <= 5) {
        densityResultClass.value = 'very-low';  // 0-5
      } else if (pointsCount <= 10) {
        densityResultClass.value = 'low';       // 6-10
      } else if (pointsCount <= 15) {
        densityResultClass.value = 'medium';    // 11-15
      } else if (pointsCount <= 20) {
        densityResultClass.value = 'high';      // 16-20
      } else {
        densityResultClass.value = 'very-high'; 
      }
      
      if (densityResultClass.value) {
        densityResult.value = "evaluated";
      } else {
        densityResult.value = "";
      }
    };
    
    const clearMarker = () => {
      if (locationMarker.value && props.map && props.map.hasLayer(locationMarker.value)) {
        props.map.removeLayer(locationMarker.value);
        locationMarker.value = null;
      }
      densityResult.value = '';
      densityResultClass.value = '';
      nearbyResourcesList.value = [];
      densityData.value = null;
    };
    
    watch(() => props.map, (newMap, oldMap) => {
      if (!newMap && oldMap && locationMarker.value) clearMarker();
    });
    
    // check if the input is a valid address or coordinates
    const validateInput = (input) => {
      if (!input || input.trim() === '') {
        return { valid: false, error: 'Please enter a search address or coordinates' };
      }
      
      // check if the input is a valid coordinate
      const coordsRegex = /^(-?\d+(\.\d+)?),\s*(-?\d+(\.\d+)?)$/;
      const isCoords = coordsRegex.test(input);
      
      // if the input is a valid coordinate, validate the coordinate values
      if (isCoords) {
        const parts = input.split(',');
        const lat = parseFloat(parts[0]);
        const lng = parseFloat(parts[1]);
        
        if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
          return { valid: false, error: 'Coordinate values out of range. Latitude should be between -90 and 90, longitude between -180 and 180' };
        }
        
        // coordinate validation passed
        return { valid: true, error: '' };
      }
      
      // non-coordinate format validation
      // check if the input is only numbers
      const isOnlyDigits = /^\d+$/.test(input);
      if (isOnlyDigits) {
        return { valid: false, error: 'Please enter a valid address name, not just numbers' };
      }
      
      // check if the input contains invalid characters (but allow common address characters)
      const hasInvalidChars = /[^\w\s.,\-/'&()]+/.test(input);
      if (hasInvalidChars) {
        return { valid: false, error: 'Address contains invalid characters. Please use letters, numbers, and common punctuation' };
      }
      
      // check if the input is too short
      if (input.length < 3) {
        return { valid: false, error: 'Address is too short. Please provide more detailed information' };
      }
      
      return { valid: true, error: '' };
    };
    
    // validate the input and search
    const validateAndSearch = () => {
      inputValidationError.value = '';
      searchOutOfVicError.value = '';
      
      const validation = validateInput(searchLocation.value);
      if (!validation.valid) {
        inputValidationError.value = validation.error;
        return;
      }

      searchLocationDensity();
    };
    
    const handleEnterKey = () => {
      // when the user presses the enter key, do not perform any action
      // just keep the input box focused, allowing the user to continue typing
    };
    
    const clearResults = () => {
      searchLocation.value = '';
      clearMarker();
      
      // reset the map view to Melbourne center
      if (props.map) {
        props.map.setView([-37.815, 144.963], 8);
      }
      
      // clear the search related states
      searchedAddress.value = '';
      searchOutOfVicError.value = '';
      inputValidationError.value = '';
    };
    
    // switch tab function
    const switchTab = (tab, fromUserClick = true) => {
      activeTab.value = tab;
      
      // only trigger scroll behavior when fromUserClick is true
      if (fromUserClick) {
        // scroll to the corresponding position based on the selected tab
        if (tab === 'map') {
          // trigger event, notify parent component to scroll to map position
          emit('scroll-to-map');
        } else {
          // scroll to density-gauge-container element position
          const meterElement = document.querySelector('.density-gauge-container');
          if (meterElement) {
            meterElement.scrollIntoView({ behavior: 'smooth', block: 'start' });
          }
        }
      }
    };

    return {
      searchLocation, handleInput, selectSuggestion, hideSuggestions, suggestions, showSuggestions, isLoadingSuggestions,
      searchLocationDensity, searchedAddress, 
      densityResult, 
      clearMarker, clearResults, nearbyResourcesList, groupedNearbyResources, formatTypeName, searchOutOfVicError,
      echartsOption,
      densityLevelText,
      densityResultClass,
      densityData,
      validateAndSearch,
      handleEnterKey,
      inputValidationError,
      activeTab,
      switchTab
    };
  }
};
</script>
<style scoped>
.location-search { 
  margin-top: 15px; 
  padding-top: 10px; 
}

.search-title { 
  font-weight: bold; 
  margin-bottom: 8px; 
  font-size: 13px; 
  color: #4d2f20; 
}

.search-warning { 
  background-color: #fff8e1; 
  border-left: 3px solid #ffc107; 
  padding: 8px 12px; 
  margin-bottom: 12px; 
  font-size: 12px; 
  color: #856404; 
  border-radius: 4px; 
  display: flex;
  align-items: center;
  transition: all 0.3s ease;
}

.search-warning::before {
  content: "⚠️";
  margin-right: 8px;
  font-size: 14px;
}

.search-warning.out-of-vic-error { 
  background-color: #f8d7da; 
  border-left-color: #f5c6cb; 
  color: #721c24; 
  margin-bottom: 10px; 
}

.search-warning.input-validation-error { 
  background-color: rgba(62, 92, 43, 0.1); 
  border-left: 3px solid #3E5C2B; 
  color: #4d2f20; 
  margin-bottom: 10px; 
  animation: fadeIn 0.3s ease;
}

.search-warning.input-validation-error::before {
  content: "⚠️";
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-5px); }
  to { opacity: 1; transform: translateY(0); }
}

.search-input-group {
  display: flex;
  margin-bottom: 10px;
  width: 100%;
}

.search-input-group.disabled { 
  opacity: 0.6; 
}

.autocomplete-wrapper {
  position: relative;
  flex: 1;
  width: 100%;
}

.autocomplete-wrapper input {
  width: 100%;
  padding: 10px 14px;
  border: 1px solid #ddd;
  border-radius: 6px 0 0 6px;
  font-size: 15px;
  box-sizing: border-box;
}

.autocomplete-wrapper input:focus {
  border-color: #3E5C2B;
  outline: none;
  box-shadow: 0 0 0 2px rgba(62, 92, 43, 0.1);
}

.search-button { 
  width: 45px; 
  background-color: #3E5C2B; 
  color: white; 
  border: none; 
  border-radius: 0 6px 6px 0; 
  cursor: pointer; 
  display: flex; 
  align-items: center; 
  justify-content: center; 
  flex-shrink: 0; 
  transition: all 0.2s ease;
}

.search-button:hover { 
  background-color: #517A39; 
}

.search-icon {
  stroke: white;
  width: 20px;
  height: 20px;
}

.suggestions-list {
  position: absolute;
  top: 100%; 
  left: 0;
  right: 0;
  background-color: white;
  border: 1px solid #ddd;
  border-top: none;
  list-style: none;
  padding: 0;
  margin: 0;
  max-height: 200px; 
  overflow-y: auto;
  z-index: 1000; 
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.suggestion-item { 
  padding: 8px 12px; 
  cursor: pointer; 
  font-size: 13px; 
}

.suggestion-item:hover { 
  background-color: #f0f0f0; 
}

.suggestion-item.non-vic-suggestion { 
  color: #777; 
}

.suggestion-state-warning { 
  font-size: 0.8em; 
  margin-left: 5px; 
  color: #dc3545; 
  font-style: italic; 
}

.no-suggestions, .loading-suggestions { 
  padding: 8px 12px; 
  font-size: 13px; 
  color: #777; 
  text-align: center; 
}


.density-gauge-container {
  background: white;
  border-radius: 8px;
  padding: 15px;
  margin-top: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.location-header {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
  gap: 10px;
}

.location-name {
  font-weight: bold;
  color: #333;
  flex: 1;
}


.density-info-display {
  text-align: center;
  margin-bottom: 20px;
}

.density-level {
  font-size: 24px;
  font-weight: bold;
  padding: 8px 16px;
  border-radius: 8px;
  display: inline-block;
  transition: all 0.3s ease;
  margin-bottom: 8px;
}

.density-detail {
  font-size: 16px;
  color: #666;
  margin-top: 5px;
}

.density-level.very-low {
  color: #FF4444;
  background-color: rgba(255, 68, 68, 0.1);
  border: 1px solid rgba(255, 68, 68, 0.3);
}

.density-level.low {
  color: #FFAA00;
  background-color: rgba(255, 170, 0, 0.1);
  border: 1px solid rgba(255, 170, 0, 0.3);
}

.density-level.medium {
  color: #CCAA00;
  background-color: rgba(255, 255, 0, 0.1);
  border: 1px solid rgba(204, 170, 0, 0.3);
}

.density-level.high {
  color: #00C851;
  background-color: rgba(0, 200, 81, 0.1);
  border: 1px solid rgba(0, 200, 81, 0.3);
}

.density-level.very-high {
  color: #0099CC;
  background-color: rgba(0, 153, 204, 0.1);
  border: 1px solid rgba(0, 153, 204, 0.3);
}

.density-level.error {
  color: #dc3545;
  background-color: rgba(220, 53, 69, 0.1);
  border: 1px solid rgba(220, 53, 69, 0.3);
}


.density-gauge-wrapper {
  width: 100%;
  max-width: 100%;
  height: 300px;
  margin: 0 auto 10px auto;
}

.density-gauge-wrapper .chart {
  width: 100%;
  height: 100%;
}


.density-levels-reference {
  margin-top: 20px;
  padding: 15px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  border: 1px solid #f0f0f0;
}

.reference-header {
  margin-bottom: 15px;
  text-align: center;
}

.reference-header h4 {
  margin: 0 0 5px 0;
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.reference-desc {
  font-size: 14px;
  color: #666;
}

.density-level-cards {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  justify-content: space-between;
}

.density-level-card {
  flex: 1;
  min-width: 150px;
  max-width: 190px;
  background: #f9f9f9;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12);
  transition: all 0.3s ease;
  display: flex;
  flex-direction: column;
  border: 1px solid #eaeaea;
}

.density-level-card.active {
  transform: translateY(-3px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
  border-color: #3E5C2B;
}

.level-color {
  height: 6px;
  width: 100%;
}

.level-color.very-low { background-color: #FF4444; }
.level-color.low { background-color: #FFAA00; }
.level-color.medium { background-color: #FFFF00; }
.level-color.high { background-color: #00C851; }
.level-color.very-high { background-color: #0099CC; }

.level-content {
  padding: 8px;
}

.level-title {
  font-weight: bold;
  font-size: 14px;
  margin-bottom: 2px;
  color: #333;
}

.level-range {
  font-size: 12px;
  color: #666;
  font-weight: 500;
  margin-bottom: 2px;
}

.level-description {
  font-size: 11px;
  color: #777;
  line-height: 1.2;
  white-space: normal;
}

.density-level-card.active .level-title {
  color: #3E5C2B;
}

.density-level-card.active .level-range {
  color: #3E5C2B;
}

.density-level-card.active .level-description {
  color: #4c6d35;
}

/* 响应式调整 */
@media (max-width: 768px) {
  .density-level-cards {
    flex-wrap: wrap;
  }
  
  .density-level-card {
    min-width: 120px;
    max-width: 30%;
  }
  
  .level-title {
    font-size: 13px;
  }
  
  .level-range {
    font-size: 11px;
  }
  
  .level-description {
    font-size: 10px;
  }
  
  .resource-cards {
    grid-template-columns: 1fr;
  }
  
  .online-resources-title {
    font-size: 16px;
  }
  
  .online-resources .resource-card h4 {
    font-size: 16px;
  }
  
  .online-resources .resource-card li {
    font-size: 13px;
  }
}

@media (max-width: 576px) {
  .density-level-card {
    min-width: 100px;
    max-width: 48%;
    margin-bottom: 8px;
  }
  
  .density-levels-reference {
    padding: 12px;
  }
  
  .reference-header h4 {
    font-size: 16px;
  }
}

@media (max-width: 480px) {
  .density-level-cards {
    justify-content: center;
  }
  
  .density-level-card {
    min-width: 140px;
    max-width: 45%;
  }
}

.online-resources {
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px dashed #ddd;
}

.online-resources-title {
  color: #4d2f20;
  font-size: 18px;
  margin-bottom: 20px;
  text-align: center;
  position: relative;
}

.online-resources-title:after {
  content: '';
  position: absolute;
  bottom: -8px;
  left: 50%;
  transform: translateX(-50%);
  width: 80px;
  height: 3px;
  background-color: #3E5C2B;
  border-radius: 3px;
  display: none;
}

.resource-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 20px;
  margin-top: 25px;
}

.online-resources .resource-card {
  background-color: #f8f9fa;
  border-radius: 8px;
  border: 1px solid #e9ecef;
  padding: 15px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  transition: all 0.3s ease;
  display: flex;
  flex-direction: column;
}

.online-resources .resource-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 15px rgba(62, 92, 43, 0.15);
  border-color: #3E5C2B;
}

.online-resources .resource-card h4 {
  color: #3E5C2B;
  font-size: 17px;
  border-bottom: 1px solid #e9ecef;
  padding-bottom: 8px;
  margin-top: 0;
  margin-bottom: 12px;
}

.online-resources .resource-card ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.online-resources .resource-card li {
  margin-bottom: 8px;
  font-size: 14px;
  color: #4d2f20;
  line-height: 1.5;
}

.online-resources .resource-card strong {
  color: #4d2f20;
  font-weight: 600;
}

.online-resources .resource-card a {
  color: #3E5C2B;
  text-decoration: none;
  transition: all 0.2s ease;
}

.online-resources .resource-card a:hover {
  color: #517A39;
  text-decoration: underline;
}

.resources-list-container {
  margin-top: 20px;
  background-color: #f5f5f5;
  border-radius: 8px;
  padding: 15px 10px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  width: 100%;
  box-sizing: border-box;
}

.resources-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.resources-header h3 {
  margin: 0;
  font-size: 18px;
  color: #333;
  font-weight: 600;
}

.total-resources {
  background-color: #3E5C2B;
  color: white;
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 13px;
  font-weight: 500;
}

.resources-grid {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.resource-category {
  width: 100%;
  overflow: hidden;
}

.category-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  border-radius: 8px 8px 0 0;
  font-weight: 600;
}

.resource-category[data-type="schools"] .category-header {
  background-color: #2196F3;
  color: white;
}

.resource-category[data-type="hospitals"] .category-header {
  background-color: #F44336;
  color: white;
}

.resource-category[data-type="ndisProviders"] .category-header {
  background-color: #4CAF50;
  color: white;
}

.resource-category[data-type="ndisDailyLiving"] .category-header {
  background-color: #9C27B0;
  color: white;
}

.resource-category[data-type="ndisTherapy"] .category-header {
  background-color: #FF9800;
  color: white;
}

.category-title {
  color: white;
  font-size: 16px;
}

.category-count {
  background-color: rgba(255, 255, 255, 0.3);
  color: white;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
}

.resource-items-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 8px;
  padding: 10px;
}

.resource-items-grid .resource-card {
  width: 100%;
  padding: 15px;
  background-color: white;
  border-radius: 4px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
  border-left: 4px solid transparent;
  display: flex;
  flex-direction: column;
}

.resource-category[data-type="schools"] .resource-card {
  border-left-color: #2196F3;
}

.resource-category[data-type="hospitals"] .resource-card {
  border-left-color: #F44336;
}

.resource-category[data-type="ndisProviders"] .resource-card {
  border-left-color: #4CAF50;
}

.resource-category[data-type="ndisDailyLiving"] .resource-card {
  border-left-color: #9C27B0;
}

.resource-category[data-type="ndisTherapy"] .resource-card {
  border-left-color: #FF9800;
}

.resource-name {
  font-weight: 600;
  margin-bottom: 5px;
  font-size: 15px;
  color: #333;
}

.resource-address {
  color: #666;
  font-size: 14px;
}

@media (min-width: 768px) {
  .resource-items-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .density-gauge-wrapper {
    height: 380px;
  }
}

@media (max-width: 767px) {
  .resource-items-grid {
    grid-template-columns: 1fr;
    padding: 8px;
  }
  
  .resources-list-container {
    padding: 10px;
  }
  
  .resources-header h3 {
    font-size: 16px;
  }
  
  .category-header {
    padding: 8px 12px;
  }
  
  .category-title {
    font-size: 15px;
  }
  
  .resource-items-grid .resource-card {
    padding: 12px;
  }
  
  .density-level-cards {
    grid-template-columns: 1fr;
  }
  
  .density-gauge-wrapper {
    height: 250px;
  }
}

@media (max-width: 480px) {
  .search-input-group {
    flex-direction: column;
  }
  
  .autocomplete-wrapper input {
    border-radius: 6px;
    margin-bottom: 8px;
  }
  
  .search-button {
    width: 100%;
    border-radius: 6px;
    height: 40px;
  }
  
  .resources-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }
  
  .total-resources {
    align-self: flex-start;
  }
  
  .density-gauge-wrapper {
    height: 200px;
  }
}

.search-results-tabs {
  display: flex;
  flex-direction: column;
  gap: 15px;
  margin: 15px 0;
}

.tabs-container {
  display: flex;
  background-color: #f5f5f5;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.tab-item {
  flex: 1;
  padding: 12px 15px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  color: #6c757d;
  font-weight: 500;
  border-bottom: 3px solid transparent;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.tab-item.active {
  background-color: rgba(62, 92, 43, 0.1);
  color: #3E5C2B;
  font-weight: 600;
  border-bottom-color: #3E5C2B;
}

.tab-item:hover:not(.active) {
  background-color: rgba(0, 0, 0, 0.03);
}

.tab-icon {
  font-size: 16px;
}

.clear-results-button {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 8px 16px;
  background-color: #f5f5f5;
  border: 1px solid #ddd;
  border-radius: 4px;
  color: #666;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
  margin: 0 auto;
}

.clear-results-button:hover {
  background-color: #e5e5e5;
  color: #333;
}

.clear-icon {
  flex-shrink: 0;
}

@media (max-width: 480px) {
  .tabs-container {
    flex-direction: column;
  }
  
  .tab-item {
    border-bottom: none;
    border-left: 3px solid transparent;
  }
  
  .tab-item.active {
    border-bottom: none;
    border-left-color: #3E5C2B;
  }
}
</style>
