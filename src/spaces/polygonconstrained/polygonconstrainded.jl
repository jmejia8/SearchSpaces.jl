struct PolygonConstrainedSpace
    vertices::Matrix{<:Real}  # Matrix representing polygon/hyperpolygon vertices
    dim::Int                  # Dimensionality of the space
    rigid::Bool               # Whether the space is rigidly constrained
end
# Checking Polygon Validity (No Self-Intersecting Edges)
function _valid_bounds(polygon::Matrix{<:Real})
    n = size(polygon, 1)  # Number of vertices

    for i in 1:n
        A, B = polygon[i, :], polygon[mod1(i+1, n), :]  # Edge AB
        for j in i+2:n
            if (i == 1 && j == n)  # Ignore first and last vertices (they are connected)
                continue
            end
            C, D = polygon[j, :], polygon[mod1(j+1, n), :]  # Edge CD
            if segments_intersect(A, B, C, D)
                return false  # Intersection detected
            end
        end
    end
    return true
end
# Checking if Two Segments Intersect
function segments_intersect(A, B, C, D)
    function cross_product(v1, v2)
        return v1[1] * v2[2] - v1[2] * v2[1]
    end
    return ((cross_product(B - A, C - A) * cross_product(B - A, D - A)) ≤ 0) &&
           ((cross_product(D - C, A - C) * cross_product(D - C, B - C)) ≤ 0)
end

function cardinality(searchspace::PolygonConstrainedSpace)
    Inf
end

isinspace(x, searchspace::PolygonConstrainedSpace) = inpolygon(x,sesarchspace.vertices)