import React from "react";
import PropTypes from "prop-types";
import "./Movie.css";
function Movie({id, year, title, poster, rating, director, actor}) {
  return (
    <div className="movie">
    <a href={id} target="_blank">
      <img src={poster} alt={title} titlt={title}></img>
    <div className="movie__data">
      <h3 className="movie__title">{
          title.replace(/<b>/gi,"").replace(/<\/b>/gi,"")
        }</h3>
      <p className="movie__rating">
        <span>평점</span> {rating}/10
      </p>
      <p className="movie__year">
        <span>개봉일</span> {year}
      </p>
    <p className="movie__director">
      <span>감독</span> {director}
    </p>
    <p className="movie__actor">
      <span>배우</span> {actor}
    </p>
    </div>
  </a>
  </div>
  )
};
Movie.propTypes = {
  id: PropTypes.string.isRequired,
  year: PropTypes.string.isRequired,
  title: PropTypes.string.isRequired,
  poster: PropTypes.string.isRequired,
  rating: PropTypes.string.isRequired,
  director: PropTypes.string.isRequired,
  actor: PropTypes.string.isRequired
};
export default Movie;
