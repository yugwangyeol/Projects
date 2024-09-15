import React from 'react';
import Movie from './Movie';
import { MdAdd } from 'react-icons/md';
import "./Search.css";
import {naverMoviesApi} from '../api';

class Search extends React.Component {
  state = {
    isLoading: false,
    movies: [],
    value: "",
    name: "영화 검색",
    info: {},
  };

  getSearchMovie = async () => {
    console.log('search Movie');
    const search = this.state.value;

    try {
      if (search === "") {
        this.setState({movies: [], isLoading: false})
      } else {
        this.setState({movies: [], isLoading: true})
        const {data: {
            items
          }} = await naverMoviesApi.search(search);
        //alert("(Loading 메시지 확인중...)");
        this.setState({movies: items, isLoading: false});
      }
    } catch (error) {
      console.log(error);
    }
  };

  componentDidMount() {
    this.getSearchMovie();
  };

  handleChange = (e : any) => {
    this.setState({value: e.target.value});
  };

  handleSubmit = (e : any) => {
    e.preventDefault();
    this.getSearchMovie();
  };

  handler = (movie) => {
    this.setState({
      info : movie
    });
  };

  render() {
    const {movies, isLoading, name, info, value} = this.state;

    return (<section className="container">
      {
        isLoading
          ? (<div className="loader">
            <span className="loader__text">({this.state.name}) Loading... {this.state.value}</span>
          </div>)
          : (<form onSubmit={this.handleSubmit}>
            <div>
              <div className="input_div">
                <h1>영화 검색 서비스</h1>
              </div>
              <div className="input_search">
                <input type="text" value={this.state.value} onChange={this.handleChange} placeholder="영화 이름을 입력하세요"/>
                <button type="submit">
                  <MdAdd />
                </button>
              </div>
              <div className = 'movie_buttons'>
                {movies.map((movie, index) => (<button className = "movie_button" key={movie.id} onClick={() => this.setState({ info: movie })}>{index+1}
                </button>))}
              </div>
              <div className="movies">
              {(Object.keys(info).length != 0 ? <Movie 
                key={info.link} 
                id={info.link} 
                year={info.pubDate} 
                title={info.title} 
                poster={info.image} 
                rating={info.userRating} 
                director={info.director} 
                actor={info.actor}/> : <div />)}
              </div>
              
            </div>
          </form>)
      }
    </section>);
  }
}

export default Search;