class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.ratings
    
    ratings = (params[:ratings]) ? params[:ratings] : session[:ratings]
    if ratings != nil and !ratings.empty? 
      session[:ratings] = ratings
      ratings = ratings.keys
      @movies.delete_if { |m| !ratings.include? m.rating }
    end
    
    order = (params[:order]) ? params[:order] : session[:order]
    if order
      @movies.sort! { |m1, m2| m1.send(order) <=> m2.send(order) }
      params[:highlight] = order
      session[:order] = order
    end
    
    flash.keep
    if session[:order] != params[:order] or session[:ratings] != params[:ratings]
      redirect_to movies_path :order => session[:order], :ratings => session[:ratings]
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.new(params[:movie])
    if @movie.save
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    else
      render 'new'
    end
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end