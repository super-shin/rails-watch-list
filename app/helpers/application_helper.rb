module ApplicationHelper
    def render_stars(rating)
    # Convert the rating to a 5-star scale
    adjusted_rating = (rating / 2.0).round(1)
    full_stars = adjusted_rating.floor
    half_star = (adjusted_rating % 1 >= 0.5) ? 1 : 0
    empty_stars = 5 - full_stars - half_star

    stars = ''
    
    # Render full stars with solid yellow color
    full_stars.times do
        stars += '<i class="fas fa-star" style="color: gold;"></i>'
    end

    # Render half star if applicable
    if half_star == 1
        stars += '<i class="fas fa-star-half-alt" style="color: gold;"></i>'
    end

    # Render remaining stars with outline
    empty_stars.times do
        stars += '<i class="far fa-star" style="color: gold;"></i>'
    end

    stars.html_safe
    end
end
