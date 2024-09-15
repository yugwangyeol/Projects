import axios from 'axios';

const ID_KEY = 'JiQYIxJLyld893HC29gG';
const SECRET_KEY = 'q9p2M1mMbb';

const api = axios.create({
  baseURL: '/api',
  headers: {
    'X-Naver-Client-Id': ID_KEY,
    'X-Naver-Client-Secret': SECRET_KEY,
  }
});

export const naverMoviesApi = {
  search: word => api.get('/v1/search/movie.json', {
    params: {
      query: word,
      display: 10
    }
  })
};
