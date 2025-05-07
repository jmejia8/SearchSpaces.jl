# using LatinHypercubeSampling

# Vérifie si un point est dans un polygone (format 2*n)
function inpolygon(point::Vector{<:Real}, vertices::Matrix{<:Real})
    n = size(vertices, 2)  # Nombre de sommets (colonnes)
    etat = false
    last_vertex = vertices[:, end]

    for i in 1:n
        vertex = vertices[:, i]
        if ((vertex[2] < point[2] && last_vertex[2] ≥ point[2]) || 
            (last_vertex[2] < point[2] && vertex[2] ≥ point[2])) &&
           (vertex[1] + (point[2] - vertex[2]) / (last_vertex[2] - vertex[2]) * (last_vertex[1] - vertex[1]) < point[1])
            etat = !etat
        end
        last_vertex = vertex
    end
    return etat
end

# Vérifie si tous les points d'une matrice (2*m) sont dans un polygone (2*n)
function inpolygon(surface::Matrix{<:Real}, vertices::Matrix{<:Real})
    return all(i -> inpolygon(surface[:,i], vertices), axes(surface, 2))
end

# Calcul de l'aire d'un polygone avec la formule du "Shoelace" (2*n)
function polygon_area(vertices::Matrix{<:Real})
    n = size(vertices, 2)  # n est le nombre de sommets
    area = 0.0
    for i in 1:n
        j = mod1(i+1, n)  # j = i+1 (et 1 pour i = n)
        area += vertices[1, i] * vertices[2, j] - vertices[1, j] * vertices[2, i]
    end
    return abs(area) / 2
end
# # Latin Hypercube Sampling dans un polygone (format 2*n)
# function latinHyperPolygone(vertices::Matrix{<:Real}, n_points::Int)
#     # Compute bounding box of the polygon

#     xmin, xmax = minimum(vertices[1, :]), maximum(vertices[1, :])
#     ymin, ymax = minimum(vertices[2, :]), maximum(vertices[2, :])
#     # Compute polygon area and bounding box area
#     poly_area = polygon_area(vertices)
#     bbox_area = (xmax - xmin) * (ymax - ymin)

#     # Density ratio
#     ratio = poly_area / bbox_area

#     # Estimate the number of points needed
#     estimated_n = ceil(Int, n_points / ratio * 1.2)  # 1.2 to ensure sufficient coverage

#     points_inside = []
#     filtered_indices = Int[]
#     while length(filtered_indices) < n_points
#         # Generate points in Latin Hypercube Sampling within the bounding box
#         scaled_plan = scaleLHC(LHCoptim(estimated_n, 2, 1)[1], [(xmin, xmax), (ymin, ymax)])
#         filtered_indices = [i for i in 1:size(scaled_plan, 1) if inpolygon(scaled_plan[i,:], vertices)] # 
#         points_inside = collect(scaled_plan[filtered_indices[1:min(n_points,length(filtered_indices))],:]')
#     end
    
#     # Return the points inside the polygon as a matrix of size 2 x n_points
#     return points_inside 
# end
function random_remove_rows(mat::Matrix{<:Real}, n::Int)
    m= size(mat,1)  # Dimensions de la matrice d'entrée
    # Vérification que n est plus petit que m
    if n < m
        throw(ArgumentError("n doit être plus petit que m"))
    else n=m 
        return mat
    end
    # Générer une permutation aléatoire des indices de lignes
    indices = randperm(m)

    # Sélectionner les indices des lignes à garder (les n premiers indices après permutation)
    rows_to_keep = indices[1:n]

    # Extraire les lignes correspondantes pour créer la nouvelle matrice
    return mat[sort(rows_to_keep), :]
end
function grid_random_polygon(vertices::Matrix{<:Real}, n_points::Int)
    # Déterminer la boîte englobante du polygone
    xmin, ymin = minimum(vertices, dims=2)
    xmax, ymax = maximum(vertices, dims=2)

    # Déterminer la densité des points en fonction de la surface du polygone
    poly_area = polygon_area(vertices)
    bbox_area = (xmax - xmin) * (ymax - ymin)
    ratio = poly_area / bbox_area
    estimated_n = ceil(Int, n_points / ratio * 1.2)  # Facteur de marge 1.2 pour garantir une bonne couverture

    # Générer une grille régulière aléatoire
    X = range(xmin, xmax; length=ceil(Int, sqrt(estimated_n)))
    Y = range(ymin, ymax; length=ceil(Int, sqrt(estimated_n)))

    nX, nY = length(X) - 1, length(Y) - 1  # Nombre d'intervalles sur X et Y
    points = Matrix{Float64}(undef, 2, Int(round(n_points*1.2)))  # Préallouer une matrice 2×n
    index = 1
    for indexX in 1:nX,indexY in 1:nY
        point = [rand() * (X[indexX+1] - X[indexX]) + X[indexX],rand() * (Y[indexY+1] - Y[indexY]) + Y[indexY]]
        if inpolygon(point,vertices)
            points[:,index] = point
            index += 1
            if index>n_points*1.2
                break
            end
        end
    end
    points = random_remove_rows(points[:,1:index-1],n_points)
    return points
end

# Génère un point aléatoire à l'intérieur d'un polygone
function _get_random(polygon::PolygonConstrainedSpace, rng::Int)
    return grid_random_polygon(polygon.vertices, rng)
end
