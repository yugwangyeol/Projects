//import axios from 'axios';
//let axios = require('axios');
let result;
            
let getSearchMovie = async () => {
 const ID_KEY = 'MPF85hV_M_MgoJFe46Ms';
  const SECRET_KEY = 'uSvgQms2A1';

  try { 
        result = await axios.get('https://movie-app-2021.herokuapp.com/yts/api/v2/list_movies.json?sort_by=like_count&order_by=desc&limit=5');
        result=result.data.data.movies;
        console.log("result1: ", result);
        for(let i=0; i<result.length; i++) {
          let t = `<img src='https://movie-app-2021.herokuapp.com/yts/${result[i].medium_cover_image.match(/assets.*/)}' alt='yts movie snapshot'>`;
          document.body.innerHTML += t;
        }
      } catch (error) { 
        console.log(error); 
      } 
}; 

getSearchMovie();
console.log("result2: ", result);
    