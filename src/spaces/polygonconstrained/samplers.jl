using LatinHypercubeSampling

# Ray-Casting Algorithm to check if a point is inside a polygon
function inpolygon(point::Vector{<:Real}, vertices::Matrix{<:Real})
    etat = false
    last_vertex = vertices[end, :]
    
    for vertex in eachrow(vertices)
        if ((vertex[2] < point[2] && last_vertex[2] ≥ point[2]) || 
            (last_vertex[2] < point[2] && vertex[2] ≥ point[2])) &&
           (vertex[1] + (point[2] - vertex[2]) / (last_vertex[2] - vertex[2]) * (last_vertex[1] - vertex[1]) < point[1])
            etat = !etat
        end
        last_vertex = vertex
    end
    return etat
end

# Check if all points in a surface are inside a polygon
function inpolygon(surface::Vector{Vector{<:Real}}, vertices::Matrix{<:Real})
    return all(point -> inpolygon(point, vertices), surface)
end
# Computing the Area of a Polygon (Shoelace Formula)
function polygon_area(vertices::Matrix{<:Real})
    n = size(vertices, 1)
    area = 0.0

    for i in 1:n
        j = mod1(i+1, n)  # Wrap-around index
        area += vertices[i, 1] * vertices[j, 2] - vertices[j, 1] * vertices[i, 2]
    end

    return abs(area) / 2
end

# Latin Hypercube Sampling for Polygonal Search Spaces

function latinhyperpolygone(vertices::Matrix{<:Real}, n_points::Int)
    # Compute bounding box of the polygon
    xmin, ymin = minimum(vertices, dims=1)[1, :]
    xmax, ymax = maximum(vertices, dims=1)[1, :]

    # Compute polygon area and bounding box area
    poly_area = polygon_area(vertices)
    bbox_area = (xmax - xmin) * (ymax - ymin)

    # Density ratio
    ratio = poly_area / bbox_area

    # Estimate the number of points needed
    estimated_n = ceil(Int, n_points / ratio * 1.2)  # 1.2 to ensure sufficient coverage

    points_inside = []

    while length(points_inside) < n_points
        # Generate points in Latin Hypercube Sampling within the bounding box
        scaled_plan = scaleLHC(LHCoptim(estimated_n, 2, 1)[1], [(xmin, xmax), (ymin, ymax)])

        # Filter points inside the polygon
        new_points = [scaled_plan[i, :] for i in axes(scaled_plan, 1) if inpolygon(scaled_plan[i, :], vertices)]

        # Add new points without exceeding n_points
        points_inside = vcat(points_inside, new_points)[1:min(n_points, end)]
    end

    return hcat([collect(p) for p in points_inside]...)'  # Return as (n_points × 2) matrix
end
# Random Point Generation in a Polygon-Constrained Space
function _get_random(bounds, rng) #::PolygonConstrainedSpace{<:Real}
    return latinhyperpolygone(bounds.vertices, rng)
end

