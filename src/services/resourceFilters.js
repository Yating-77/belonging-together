// Resource type configuration
export const RESOURCE_TYPES = {
  schools: {
    key: 'schools',
    label: 'Special Schools',
    color: '#3388ff',
    icon: '🏫',
    dataKey: 'schoolsData'
  },
  hospitals: {
    key: 'hospitals',
    label: 'Hospitals',
    color: '#ff3333',
    icon: '🏥',
    dataKey: 'hospitalsData'
  },
  ndisProviders: {
    key: 'ndisProviders',
    label: 'NDIS Early Intervention',
    color: '#33cc33',
    icon: '👶',
    dataKey: 'ndisProvidersData'
  },
  ndisDailyLiving: {
    key: 'ndisDailyLiving',
    label: 'NDIS Daily Living Support',
    color: '#9933cc',
    icon: '🏠',
    dataKey: 'ndisDailyLivingData'
  },
  ndisTherapy: {
    key: 'ndisTherapy',
    label: 'NDIS Therapy Services',
    color: '#ff9900',
    icon: '⚕️',
    dataKey: 'ndisTherapyData'
  }
};

// Create reactive filter state
export const createFilterState = () => {
  return {
    schools: false,
    hospitals: false,
    ndisProviders: false,
    ndisDailyLiving: false,
    ndisTherapy: false
  };
};

// Check if any type is selected
export const hasSelectedAnyType = (filterState) => {
  return Object.values(filterState).some(value => value === true);
};

// Check if all types are selected
export const isAllTypesSelected = (filterState) => {
  return Object.values(filterState).every(value => value === true);
};

// Select all types
export const selectAllTypes = (filterState) => {
  const newState = { ...filterState };
  Object.keys(newState).forEach(key => {
    newState[key] = true;
  });
  return newState;
};

// Clear all selections
export const selectNoneTypes = (filterState) => {
  const newState = { ...filterState };
  Object.keys(newState).forEach(key => {
    newState[key] = false;
  });
  return newState;
};

// Toggle selection state of individual type
export const toggleResourceType = (filterState, type) => {
  return {
    ...filterState,
    [type]: !filterState[type]
  };
};

// Copy filter state
export const copyFilterState = (sourceState, targetState) => {
  const newState = { ...targetState };
  Object.keys(sourceState).forEach(key => {
    newState[key] = sourceState[key];
  });
  return newState;
};

// Get list of selected resource types
export const getSelectedTypes = (filterState) => {
  return Object.entries(filterState)
    .filter(([_, selected]) => selected)
    .map(([type, _]) => type);
};

// Get configuration info for selected types
export const getSelectedTypeConfigs = (filterState) => {
  return getSelectedTypes(filterState).map(type => RESOURCE_TYPES[type]);
};

// Get data based on filter state
export const getDataByFilters = (filterState, allData) => {
  const result = {};
  const selectedTypes = getSelectedTypes(filterState);
  
  selectedTypes.forEach(type => {
    const config = RESOURCE_TYPES[type];
    if (config && allData[config.dataKey]) {
      result[type] = allData[config.dataKey];
    }
  });
  
  return result;
};

// Create filter statistics
export const getFilterStatistics = (filterState, allData) => {
  const stats = {};
  let totalCount = 0;
  
  Object.entries(RESOURCE_TYPES).forEach(([type, config]) => {
    const count = allData[config.dataKey]?.length || 0;
    stats[type] = {
      label: config.label,
      count: count,
      selected: filterState[type],
      selectedCount: filterState[type] ? count : 0
    };
    
    if (filterState[type]) {
      totalCount += count;
    }
  });
  
  stats.total = {
    label: 'Total',
    count: totalCount,
    selected: hasSelectedAnyType(filterState)
  };
  
  return stats;
};

// Validate filter state
export const validateFilterState = (filterState) => {
  const validKeys = Object.keys(RESOURCE_TYPES);
  const invalidKeys = Object.keys(filterState).filter(key => !validKeys.includes(key));
  
  if (invalidKeys.length > 0) {
    console.warn('Invalid filter types found:', invalidKeys);
  }
  
  // Create normalized filter state
  const normalizedState = {};
  validKeys.forEach(key => {
    normalizedState[key] = filterState[key] !== undefined ? Boolean(filterState[key]) : true;
  });
  
  return normalizedState;
};

// Save filter state to local storage
export const saveFilterState = (filterState, key = 'melbourne_resource_filters') => {
  try {
    localStorage.setItem(key, JSON.stringify(filterState));
    return true;
  } catch (error) {
    console.error('Failed to save filter state:', error);
    return false;
  }
};

// Load filter state from local storage
export const loadFilterState = (key = 'melbourne_resource_filters') => {
  try {
    const saved = localStorage.getItem(key);
    if (saved) {
      const parsedState = JSON.parse(saved);
      return validateFilterState(parsedState);
    }
  } catch (error) {
    console.error('Failed to load filter state:', error);
  }
  
  // Return default state
  return createFilterState();
};

// Export commonly used composite functions
export const useResourceFilters = () => {
  return {
    RESOURCE_TYPES,
    createFilterState,
    hasSelectedAnyType,
    isAllTypesSelected,
    selectAllTypes,
    selectNoneTypes,
    toggleResourceType,
    copyFilterState,
    getSelectedTypes,
    getSelectedTypeConfigs,
    getDataByFilters,
    getFilterStatistics,
    validateFilterState,
    saveFilterState,
    loadFilterState
  };
};