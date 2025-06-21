import axios from 'axios'
import router from '../router'

axios.defaults.baseURL = import.meta.env.VITE_API_URL

axios.interceptors.request.use(
  function (config) {
    // const token = localStorage.getItem('token')
    // if (token) {
    //   config.withCredentials = true
    //   config.headers = { 'Authorization': 'Bearer ' + token }
    // }
    const method = config.method.toUpperCase()
    if (method !== 'OPTIONS' && method !== 'GET') {
      // config.headers = { 'Content-Type': 'application/x-www-form-urlencoded' }
      // config.headers = { 'Accept': '*/*', 'Accept-Encoding': 'gzip, deflate, br' }
      // config.headers = {
      //   ...config.headers
      // }
    }
    return config
  },
  function (error) {
    // Do something with request error
    return Promise.reject(error)
  },
)

axios.interceptors.response.use(
  function (response) {
    // Any status code that lie within the range of 2xx cause this function to trigger
    // Do something with response data
    return response
  },
  function (error) {
    if (error.config.ignoreGlobalCatch) {
      return Promise.reject(error)
    }
    // Any status codes that falls outside the range of 2xx cause this function to trigger
    // Do something with response error
    if (error.response.status === 401) {
      router.push({ name: 'login' })
    }
    // location.reload()
    return Promise.reject(error)
  },
)
