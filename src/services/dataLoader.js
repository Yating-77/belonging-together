// dataLoader.js
import Papa from 'papaparse';

// Common CSV loading function
const loadCSVData = async (url, transformFn, errorMessage) => {
  try {
    const response = await fetch(url);
    
    if (!response.ok) {
      throw new Error(`HTTP error: ${response.status}`);
    }
    
    const csvData = await response.text();
    
   
    const parsedData = Papa.parse(csvData, {
      header: true,
      dynamicTyping: true,
      skipEmptyLines: true
    });
    
    
    const transformedData = parsedData.data
      .map(transformFn)
      .filter(item => typeof item.lat === 'number' && typeof item.lng === 'number' && !isNaN(item.lat) && !isNaN(item.lng))
;
    
    
    
    return {
      data: transformedData,
      success: true
    };
  } catch (error) {
   
    return {
      data: [],
      success: false,
      error: `${errorMessage}: ${error.message}`
    };
  }
};

// School data transformation function
const transformSchoolData = (item) => {
  const district = item.LGA_Name ? item.LGA_Name.replace(/\s*\([^)]*\)/g, '') : item.Address_Town;
  
  return {
    lat: parseFloat(item.Y),
    lng: parseFloat(item.X),
    district: district,
    name: item.School_Name,
    address: `${item.Address_Line}, ${item.Address_Town}, ${item.Address_State} ${item.Address_Postcode}`,
    phone: item.Full_Phone_No,
    type: item.Education_Sector
  };
};

// Hospital data transformation function
const transformHospitalData = (item) => {
  return {
    lat: parseFloat(item.Y),
    lng: parseFloat(item.X),
    district: item.Address_Town || '',
    name: item["Hospital name"] || item.Hospital_name,
    address: `${item.Address_Line || ''}, ${item.Address_Town || ''}, ${item.Address_State || ''} ${item.Address_Postcode || ''}`,
    phone: item.Full_Phone_No || '',
    type: 'Public'
  };
};

// NDIS Early Intervention provider data transformation function
const transformNdisProviderData = (item) => {
  const addressParts = (item.Address || '').split(',');
  const district = addressParts.length > 2 ? addressParts[2].trim() : '';
  
  return {
    lat: parseFloat(item.Y),
    lng: parseFloat(item.X),
    district: district,
    name: item['Registered Provider Name'] || '', 
    outletName: item['Outlet Name'] || '',
    address: item.Address || '',
    phone: item.Phone || '',
    email: item.Email || '',
    website: item.Website || '',
    openHours: item['Open Hours'] || '',
    type: item['NDIS Category'] || 'Early Intervention'
  };
};


const transformNdisDailyLivingData = (item) => {
  const addressParts = (item.Address || '').split(',');
  const district = addressParts.length > 2 ? addressParts[2].trim() : '';
  
  return {
    lat: parseFloat(item.Y),
    lng: parseFloat(item.X),
    district: district,
    name: item['Registered Provider Name'] || '', 
    outletName: item['Outlet Name'] || '',
    address: item.Address || '',
    phone: item.Phone || '',
    email: item.Email || '',
    website: item.Website || '',
    openHours: item['Open Hours'] || '',
    type: item['NDIS Category'] || 'Daily Living Support'
  };
};


const transformNdisTherapyData = (item) => {
  const addressParts = (item.Address || '').split(',');
  const district = addressParts.length > 2 ? addressParts[2].trim() : '';
  

  const primaryName = item['Outlet Name'] || item['Registered Provider Name'] || ''; 

  return {
    lat: parseFloat(item.Y),
    lng: parseFloat(item.X),
    district: district,
    name: primaryName, 
   
    address: item.Address || '',
    phone: item.Phone || '',
    email: item.Email || '',
    website: item.Website || '',
    openHours: item['Open Hours'] || '',
    type: item['NDIS Category'] || 'Professional Therapy'
  };
};

// Load all data
const loadAllData = async () => {
  const results = await Promise.all([
    loadCSVData(
      '/data/special_school.csv', 
      transformSchoolData, 
      'Failed to load school data'
    ),
    loadCSVData(
      '/data/public_hospital.csv', 
      transformHospitalData, 
      'Failed to load hospital data'
    ),
    loadCSVData(
      '/data/NDIS_Early_Intervention.csv', 
      transformNdisProviderData, 
      'Failed to load NDIS Early Intervention provider data'
    ),
    loadCSVData(
      '/data/NDIS_Daily_Living_Support_FinalReviewed.csv', 
      transformNdisDailyLivingData, 
      'Failed to load NDIS Daily Living Support provider data'
    ),
    loadCSVData(
      '/data/NDIS_Professional_Therapy.csv', 
      transformNdisTherapyData, 
      'Failed to load NDIS Professional Therapy provider data'
    )
  ]);
  
  // Collect all errors
  const errors = results
    .filter(result => !result.success)
    .map(result => result.error)
    .join('; ');
  
  return {
    schoolsData: results[0].data,
    hospitalsData: results[1].data,
    ndisProvidersData: results[2].data,
    ndisDailyLivingData: results[3].data,
    ndisTherapyData: results[4].data, 
    success: !errors,
    error: errors || null
  };
};

export { loadAllData };