//import axios from 'axios';
//let axios = require('axios');
let result;
            
let getSearchMovie = async () => {
  const ID_KEY = 'MPF85hV_M_MgoJFe46Ms';
  const SECRET_KEY = 'uSvgQms2A1';

  try { 
               const {data: { 
                  items 
//                }} = await axios.get('https://openapi.naver.com/v1/search/movie.json',{ 
                  }} = await axios.get('/api/v1/search/movie.json',{ 
                    params:{ 
                    query: "히어로", 
                    display: 10 
                  }, 
                  headers: { 
                    'X-Naver-Client-Id': ID_KEY, 
                    'X-Naver-Client-Secret': SECRET_KEY 
                  } 
                }); 
                console.log("items: ", items);
                result = items;
                let x = document.getElementsByTagName('body');
                x[0].innerHTML += JSON.stringify(items);

  } catch (error) { 
      console.log(error); 
  } 
}; 

getSearchMovie();
console.log("result: ", result);
    