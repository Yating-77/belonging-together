import { createApp } from 'vue'
import App from './App.vue' 
import ElementPlus from 'element-plus' 
import 'element-plus/dist/index.css' 
import router from './router' 
import AOS from 'aos'
import 'aos/dist/aos.css'


import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

import { faBalanceScale, faLink, faClock, faAppleAlt } from '@fortawesome/free-solid-svg-icons'

import scrollSlideDirective from './directives/scrollSlide'

const app = createApp(App)


library.add(faBalanceScale, faLink, faClock, faAppleAlt) 

app.component('font-awesome-icon', FontAwesomeIcon)

app.directive('scroll-slide', scrollSlideDirective)

app.use(ElementPlus)
app.use(router)

app.mount('#app')

AOS.init()